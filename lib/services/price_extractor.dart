import 'dart:ui';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../models/currency_config.dart';

class PriceScanResult {
  const PriceScanResult({
    required this.price,
    required this.rawText,
    required this.confidence,
  });

  final double price;
  final String rawText;
  final double confidence;
}

class _PriceCandidate {
  const _PriceCandidate({
    required this.price,
    required this.rawText,
    required this.confidence,
    required this.overlapScore,
  });

  final double price;
  final String rawText;
  final double confidence;
  final double overlapScore;
}

class PriceExtractor {
  static const viewfinderRect = Rect.fromLTWH(0.25, 0.3, 0.5, 0.4);

  PriceScanResult? extract(
    RecognizedText recognized, {
    required CurrencyConfig currency,
    Rect viewfinder = viewfinderRect,
    Size? imageSize,
  }) {
    final candidates = <_PriceCandidate>[];

    for (final block in recognized.blocks) {
      for (final line in block.lines) {
        final overlap = _overlapScore(line.boundingBox, viewfinder, imageSize);
        final lineConfidence = line.confidence ?? 0.5;

        for (final match in _pricePattern(currency).allMatches(line.text)) {
          final price = _parsePrice(match.group(0)!, currency);
          if (price == null || price <= 0 || price > 99999) continue;

          candidates.add(
            _PriceCandidate(
              price: price,
              rawText: match.group(0)!,
              confidence: lineConfidence,
              overlapScore: overlap,
            ),
          );
        }
      }
    }

    if (candidates.isEmpty) return null;

    candidates.sort((a, b) {
      final overlapCompare = b.overlapScore.compareTo(a.overlapScore);
      if (overlapCompare != 0) return overlapCompare;
      return b.confidence.compareTo(a.confidence);
    });

    final best = candidates.first;
    return PriceScanResult(
      price: best.price,
      rawText: best.rawText,
      confidence: best.confidence,
    );
  }

  PriceScanResult? extractFromText(
    String text, {
    required CurrencyConfig currency,
  }) {
    final candidates = <_PriceCandidate>[];

    for (final match in _pricePattern(currency).allMatches(text)) {
      final price = _parsePrice(match.group(0)!, currency);
      if (price == null || price <= 0 || price > 99999) continue;
      candidates.add(
        _PriceCandidate(
          price: price,
          rawText: match.group(0)!,
          confidence: 1.0,
          overlapScore: 1.0,
        ),
      );
    }

    if (candidates.isEmpty) return null;
    return PriceScanResult(
      price: candidates.first.price,
      rawText: candidates.first.rawText,
      confidence: candidates.first.confidence,
    );
  }

  RegExp _pricePattern(CurrencyConfig currency) {
    final symbol = RegExp.escape(currency.symbol);
    switch (currency.code) {
      case 'EUR':
        return RegExp(
          r'(?:' + symbol + r')?\s*\d{1,4}[.,]\d{2}\b',
          caseSensitive: false,
        );
      case 'JPY':
        return RegExp(
          r'(?:' + symbol + r')?\s*\d{1,6}\b',
          caseSensitive: false,
        );
      default:
        return RegExp(
          r'(?:' + symbol + r'|\$|£)?\s*\d{1,4}\.\d{2}\b',
          caseSensitive: false,
        );
    }
  }

  double? _parsePrice(String raw, CurrencyConfig currency) {
    var cleaned = raw.trim();
    cleaned = cleaned.replaceAll(currency.symbol, '');
    cleaned = cleaned.replaceAll(r'$', '').replaceAll('£', '').replaceAll('€', '');
    cleaned = cleaned.replaceAll('¥', '').trim();

    if (currency.code == 'EUR') {
      cleaned = cleaned.replaceAll(',', '.');
    }

    return double.tryParse(cleaned);
  }

  double _overlapScore(Rect box, Rect viewfinder, Size? imageSize) {
    final normalizedBox = imageSize != null && imageSize.width > 0 && imageSize.height > 0
        ? Rect.fromLTWH(
            box.left / imageSize.width,
            box.top / imageSize.height,
            box.width / imageSize.width,
            box.height / imageSize.height,
          )
        : box;

    final intersection = Rect.fromLTRB(
      normalizedBox.left > viewfinder.left ? normalizedBox.left : viewfinder.left,
      normalizedBox.top > viewfinder.top ? normalizedBox.top : viewfinder.top,
      normalizedBox.right < viewfinder.right ? normalizedBox.right : viewfinder.right,
      normalizedBox.bottom < viewfinder.bottom ? normalizedBox.bottom : viewfinder.bottom,
    );

    if (intersection.width <= 0 || intersection.height <= 0) return 0;

    final intersectionArea = intersection.width * intersection.height;
    final boxArea = normalizedBox.width * normalizedBox.height;
    if (boxArea <= 0) return 0;

    return intersectionArea / boxArea;
  }
}
