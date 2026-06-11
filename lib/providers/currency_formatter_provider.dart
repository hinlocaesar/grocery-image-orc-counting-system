import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/currency_formatter.dart';
import 'currency_provider.dart';

final currencyFormatterProvider = Provider<CurrencyFormatter>((ref) {
  final config = ref.watch(currencyProvider);
  return CurrencyFormatter(config);
});
