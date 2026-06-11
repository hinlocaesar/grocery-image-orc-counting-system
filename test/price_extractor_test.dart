import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_budget_app/models/currency_config.dart';
import 'package:grocery_budget_app/services/price_extractor.dart';

void main() {
  final extractor = PriceExtractor();

  group('PriceExtractor.extractFromText', () {
    test('parses USD price with symbol', () {
      final result = extractor.extractFromText(
        r'Price: $4.99',
        currency: CurrencyConfig.defaults,
      );
      expect(result?.price, 4.99);
      expect(result?.rawText, r'$4.99');
    });

    test('parses price without symbol', () {
      final result = extractor.extractFromText(
        'SPECIAL 3.50',
        currency: CurrencyConfig.defaults,
      );
      expect(result?.price, 3.50);
    });

    test('parses EUR price with comma decimal', () {
      final result = extractor.extractFromText(
        '€3,99',
        currency: const CurrencyConfig(
          code: 'EUR',
          symbol: '€',
          locale: 'de_DE',
        ),
      );
      expect(result?.price, 3.99);
    });

    test('parses JPY integer price', () {
      final result = extractor.extractFromText(
        '¥350',
        currency: const CurrencyConfig(
          code: 'JPY',
          symbol: '¥',
          locale: 'ja_JP',
        ),
      );
      expect(result?.price, 350);
    });

    test('returns null when no price pattern found', () {
      final result = extractor.extractFromText(
        'Organic apples 1lb',
        currency: CurrencyConfig.defaults,
      );
      expect(result, isNull);
    });
  });
}
