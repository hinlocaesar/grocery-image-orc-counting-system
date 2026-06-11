import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/prefs_storage.dart';
import 'router_refresh_provider.dart';

class BudgetNotifier extends Notifier<double?> {
  @override
  double? build() {
    return PrefsStorage.instance.loadBudget();
  }

  Future<void> setBudget(double budget) async {
    state = budget;
    await PrefsStorage.instance.saveBudget(budget);
    ref.read(routerRefreshProvider).refresh();
  }
}

final budgetProvider =
    NotifierProvider<BudgetNotifier, double?>(BudgetNotifier.new);
