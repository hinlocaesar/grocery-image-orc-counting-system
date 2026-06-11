import 'dart:ui';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../models/currency_config.dart';
import '../models/scan_extraction_result.dart';
import 'price_extractor.dart';
import 'product_name_extractor.dart';

class OcrService {
  OcrService()
      : _recognizer = TextRecognizer(script: TextRecognitionScript.latin);

  final TextRecognizer _recognizer;
  final PriceExtractor _priceExtractor = PriceExtractor();
  final ProductNameExtractor _nameExtractor = ProductNameExtractor();

  Future<ScanExtractionResult?> scanFrame(
    InputImage image, {
    required CurrencyConfig currency,
    Rect viewfinder = PriceExtractor.viewfinderRect,
  }) async {
    try {
      final recognized = await _recognizer.processImage(image);
      final imageSize = image.metadata?.size;

      final priceResult = _priceExtractor.extract(
        recognized,
        currency: currency,
        viewfinder: viewfinder,
        imageSize: imageSize,
      );

      if (priceResult == null) return null;

      final productName = _nameExtractor.extract(
        recognized,
        currency: currency,
        viewfinder: viewfinder,
        imageSize: imageSize,
      );

      return ScanExtractionResult(
        price: priceResult.price,
        rawPriceText: priceResult.rawText,
        confidence: priceResult.confidence,
        productName: productName,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> close() => _recognizer.close();
}
