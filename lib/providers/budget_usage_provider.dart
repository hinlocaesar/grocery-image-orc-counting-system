import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'basket_provider.dart';
import 'budget_provider.dart';

enum BudgetStatus { ok, nearlyReached, exceeded }

class BudgetUsage {
  const BudgetUsage({
    required this.percentUsed,
    required this.remaining,
    required this.overage,
    required this.status,
    required this.totalSpent,
    required this.budgetLimit,
  });

  final double percentUsed;
  final double remaining;
  final double overage;
  final BudgetStatus status;
  final double totalSpent;
  final double budgetLimit;
}

final budgetUsageProvider = Provider<BudgetUsage>((ref) {
  final budget = ref.watch(budgetProvider);
  final totalSpent = ref.watch(basketTotalProvider);

  if (budget == null || budget <= 0) {
    return BudgetUsage(
      percentUsed: 0,
      remaining: 0,
      overage: 0,
      status: BudgetStatus.ok,
      totalSpent: totalSpent,
      budgetLimit: budget ?? 0,
    );
  }

  final percentUsed = (totalSpent / budget).clamp(0.0, double.infinity);
  final remaining = (budget - totalSpent).clamp(0.0, double.infinity);
  final overage = totalSpent > budget ? totalSpent - budget : 0.0;

  BudgetStatus status;
  if (totalSpent > budget) {
    status = BudgetStatus.exceeded;
  } else if (percentUsed >= 0.70) {
    status = BudgetStatus.nearlyReached;
  } else {
    status = BudgetStatus.ok;
  }

  return BudgetUsage(
    percentUsed: percentUsed,
    remaining: remaining,
    overage: overage,
    status: status,
    totalSpent: totalSpent,
    budgetLimit: budget,
  );
});
