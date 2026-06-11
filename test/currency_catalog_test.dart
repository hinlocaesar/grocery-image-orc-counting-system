import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_budget_app/data/currency_catalog.dart';

void main() {
  group('CurrencyCatalog', () {
    test('contains a comprehensive currency list', () {
      expect(CurrencyCatalog.all.length, greaterThan(100));
    });

    test('search finds currency by code', () {
      final results = CurrencyCatalog.search('usd');
      expect(results.any((c) => c.code == 'USD'), isTrue);
    });

    test('search finds currency by name', () {
      final results = CurrencyCatalog.search('japanese');
      expect(results.any((c) => c.code == 'JPY'), isTrue);
    });

    test('search finds currency by symbol', () {
      final results = CurrencyCatalog.search('€');
      expect(results.any((c) => c.code == 'EUR'), isTrue);
    });

    test('findByCode returns correct option', () {
      final usd = CurrencyCatalog.findByCode('USD');
      expect(usd?.name, 'US Dollar');
      expect(usd?.symbol, r'$');
    });
  });
}
