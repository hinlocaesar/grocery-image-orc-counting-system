import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/shopping_session.dart';
import '../services/prefs_storage.dart';
import 'basket_provider.dart';
import 'budget_provider.dart';
import 'currency_provider.dart';

const _uuid = Uuid();

class HistoryNotifier extends Notifier<List<ShoppingSession>> {
  @override
  List<ShoppingSession> build() {
    return PrefsStorage.instance.loadHistory();
  }

  Future<void> saveCurrentSession() async {
    final items = ref.read(basketProvider);
    if (items.isEmpty) return;

    final budget = ref.read(budgetProvider);
    final currency = ref.read(currencyProvider);
    final total = ref.read(basketTotalProvider);

    final session = ShoppingSession(
      id: _uuid.v4(),
      completedAt: DateTime.now(),
      budgetLimit: budget ?? 0,
      totalSpent: total,
      currencyCode: currency.code,
      items: List.from(items),
    );

    state = [session, ...state];
    await PrefsStorage.instance.saveHistory(state);
  }
}

final historyProvider =
    NotifierProvider<HistoryNotifier, List<ShoppingSession>>(
  HistoryNotifier.new,
);
