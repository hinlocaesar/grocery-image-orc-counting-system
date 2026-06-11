import 'package:intl/intl.dart';

import '../models/currency_config.dart';

class CurrencyFormatter {
  CurrencyFormatter(this.config);

  final CurrencyConfig config;

  NumberFormat get _formatter => NumberFormat.currency(
        locale: config.locale,
        symbol: config.symbol,
        name: config.code,
      );

  String format(double amount) => _formatter.format(amount);
}
