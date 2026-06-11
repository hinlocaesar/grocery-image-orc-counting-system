import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/currency_config.dart';
import '../services/prefs_storage.dart';
import 'router_refresh_provider.dart';

class CurrencyNotifier extends Notifier<CurrencyConfig> {
  @override
  CurrencyConfig build() {
    return PrefsStorage.instance.loadCurrency();
  }

  Future<void> setCurrency(CurrencyConfig config) async {
    state = config;
    await PrefsStorage.instance.saveCurrency(config);
    ref.read(routerRefreshProvider).refresh();
  }
}

final currencyProvider =
    NotifierProvider<CurrencyNotifier, CurrencyConfig>(CurrencyNotifier.new);
