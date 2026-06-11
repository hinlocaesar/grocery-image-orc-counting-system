import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_budget_app/models/currency_config.dart';
import 'package:grocery_budget_app/services/product_name_extractor.dart';

void main() {
  final extractor = ProductNameExtractor();

  group('ProductNameExtractor.extractFromText', () {
    test('extracts product name above price line', () {
      final result = extractor.extractFromText(
        'Organic Apples\n\$4.99',
        currency: CurrencyConfig.defaults,
      );
      expect(result, 'Organic Apples');
    });

    test('extracts longest meaningful name from multi-line label', () {
      final result = extractor.extractFromText(
        'Fresh Milk\nWhole Vitamin D\n\$2.99',
        currency: CurrencyConfig.defaults,
      );
      expect(result, 'Whole Vitamin D');
    });

    test('ignores price-only lines', () {
      final result = extractor.extractFromText(
        r'$4.99',
        currency: CurrencyConfig.defaults,
      );
      expect(result, isNull);
    });

    test('ignores noise keywords', () {
      final result = extractor.extractFromText(
        'SALE\nSPECIAL\n\$3.50',
        currency: CurrencyConfig.defaults,
      );
      expect(result, isNull);
    });
  });
}
