import 'dart:ui';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../models/currency_config.dart';
import 'price_extractor.dart';

class _NameCandidate {
  const _NameCandidate({
    required this.name,
    required this.score,
  });

  final String name;
  final double score;
}

class ProductNameExtractor {
  static final _noisePattern = RegExp(
    r'^(sale|special|new|each|ea|lb|oz|kg|g|ml|per|price|total)$',
    caseSensitive: false,
  );

  String? extract(
    RecognizedText recognized, {
    required CurrencyConfig currency,
    Rect viewfinder = PriceExtractor.viewfinderRect,
    Size? imageSize,
  }) {
    final pricePattern = _pricePattern(currency);
    final candidates = <_NameCandidate>[];

    final expandedRegion = Rect.fromLTWH(
      viewfinder.left,
      (viewfinder.top - 0.2).clamp(0.0, 1.0),
      viewfinder.width,
      viewfinder.height + 0.2,
    );

    for (final block in recognized.blocks) {
      for (final line in block.lines) {
        final text = _cleanLine(line.text);
        if (!_looksLikeProductName(text, pricePattern)) continue;

        final viewfinderOverlap =
            _overlapScore(line.boundingBox, viewfinder, imageSize);
        final regionOverlap =
            _overlapScore(line.boundingBox, expandedRegion, imageSize);
        if (viewfinderOverlap <= 0 && regionOverlap <= 0) continue;

        final confidence = line.confidence ?? 0.5;
        final lengthScore = (text.length / 24).clamp(0.0, 1.0);
        final abovePriceBonus = _isAbovePriceLine(line, recognized, pricePattern, imageSize);

        final score = viewfinderOverlap * 3 +
            regionOverlap * 2 +
            confidence +
            lengthScore +
            abovePriceBonus;

        candidates.add(_NameCandidate(name: text, score: score));
      }
    }

    if (candidates.isEmpty) return null;

    candidates.sort((a, b) => b.score.compareTo(a.score));
    return candidates.first.name;
  }

  String? extractFromText(String text, {required CurrencyConfig currency}) {
    final pricePattern = _pricePattern(currency);
    final lines = text.split(RegExp(r'[\n\r]+'));

    String? best;
    var bestScore = 0.0;

    for (final rawLine in lines) {
      final line = _cleanLine(rawLine);
      if (!_looksLikeProductName(line, pricePattern)) continue;

      final score = line.length.toDouble();
      if (score > bestScore) {
        bestScore = score;
        best = line;
      }
    }

    return best;
  }

  String _cleanLine(String raw) {
    return raw.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  bool _looksLikeProductName(String text, RegExp pricePattern) {
    if (text.length < 2 || text.length > 50) return false;
    if (!RegExp(r'[a-zA-Z]').hasMatch(text)) return false;
    if (pricePattern.hasMatch(text) && _stripPrices(text, pricePattern).isEmpty) {
      return false;
    }
    if (_noisePattern.hasMatch(text)) return false;
    if (RegExp(r'^\d+([.,]\d+)?$').hasMatch(text)) return false;

    final letters = RegExp(r'[a-zA-Z]').allMatches(text).length;
    if (letters < 2) return false;

    return true;
  }

  String _stripPrices(String text, RegExp pricePattern) {
    return text.replaceAll(pricePattern, '').trim();
  }

  double _isAbovePriceLine(
    TextLine line,
    RecognizedText recognized,
    RegExp pricePattern,
    Size? imageSize,
  ) {
    if (imageSize == null) return 0;

    final lineCenterY = _normalizedCenterY(line.boundingBox, imageSize);
    TextLine? priceLine;

    for (final block in recognized.blocks) {
      for (final candidate in block.lines) {
        if (pricePattern.hasMatch(candidate.text)) {
          priceLine = candidate;
          break;
        }
      }
      if (priceLine != null) break;
    }

    if (priceLine == null) return 0;
    final priceCenterY = _normalizedCenterY(priceLine.boundingBox, imageSize);
    return lineCenterY < priceCenterY ? 0.5 : 0;
  }

  double _normalizedCenterY(Rect box, Size imageSize) {
    return (box.top + box.height / 2) / imageSize.height;
  }

  RegExp _pricePattern(CurrencyConfig currency) {
    final symbol = RegExp.escape(currency.symbol);
    switch (currency.code) {
      case 'EUR':
        return RegExp(r'(?:' + symbol + r')?\s*\d{1,4}[.,]\d{2}');
      case 'JPY':
        return RegExp(r'(?:' + symbol + r')?\s*\d{1,6}');
      default:
        return RegExp(r'(?:' + symbol + r'|\$|£)?\s*\d{1,4}\.\d{2}');
    }
  }

  double _overlapScore(Rect box, Rect region, Size? imageSize) {
    final normalizedBox = imageSize != null &&
            imageSize.width > 0 &&
            imageSize.height > 0
        ? Rect.fromLTWH(
            box.left / imageSize.width,
            box.top / imageSize.height,
            box.width / imageSize.width,
            box.height / imageSize.height,
          )
        : box;

    final intersection = Rect.fromLTRB(
      normalizedBox.left > region.left ? normalizedBox.left : region.left,
      normalizedBox.top > region.top ? normalizedBox.top : region.top,
      normalizedBox.right < region.right ? normalizedBox.right : region.right,
      normalizedBox.bottom < region.bottom ? normalizedBox.bottom : region.bottom,
    );

    if (intersection.width <= 0 || intersection.height <= 0) return 0;

    final intersectionArea = intersection.width * intersection.height;
    final boxArea = normalizedBox.width * normalizedBox.height;
    if (boxArea <= 0) return 0;

    return intersectionArea / boxArea;
  }
}
