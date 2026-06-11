import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/basket_provider.dart';
import '../providers/budget_usage_provider.dart';
import '../providers/currency_formatter_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/basket_item_tile.dart';
import '../widgets/budget_progress_bar.dart';

class BudgetExceededScreen extends ConsumerWidget {
  const BudgetExceededScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatter = ref.watch(currencyFormatterProvider);
    final usage = ref.watch(budgetUsageProvider);
    final items = ref.watch(basketProvider);

    return Scaffold(
      backgroundColor: AppColors.alertPink,
      appBar: AppBar(
        title: const Text('Budget Exceeded!'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: AppColors.alertRed,
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: const Text(
              'ALERT: BUDGET REACHED',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 1,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    color: const Color(0xFFFCE4EC),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formatter.format(usage.totalSpent),
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Budget: ${formatter.format(usage.budgetLimit)}',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: const BoxDecoration(
                                  color: AppColors.alertRed,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.stop,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: BudgetProgressBar(
                                  percentUsed: 1.0,
                                  status: BudgetStatus.exceeded,
                                  height: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'You have exceeded your grocery budget by '
                            '${formatter.format(usage.overage)}. '
                            'Review your basket or adjust your budget.',
                            style: const TextStyle(fontSize: 14, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => context.go('/home'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.warningOrange,
                          ),
                          child: const Text('REVIEW BASKET'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => context.go('/setup?adjust=true'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 52),
                            side: const BorderSide(color: Colors.black87),
                          ),
                          child: const Text('ADJUST BUDGET'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (items.isNotEmpty) ...[
                    Text(
                      'Basket Preview',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    ...items.map(
                      (item) => Opacity(
                        opacity: 0.6,
                        child: BasketItemTile(item: item, compact: true),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
