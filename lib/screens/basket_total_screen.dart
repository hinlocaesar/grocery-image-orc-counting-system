import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/basket_provider.dart';
import '../providers/budget_provider.dart';
import '../providers/budget_usage_provider.dart';
import '../providers/currency_formatter_provider.dart';
import '../providers/history_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/basket_item_tile.dart';
import '../widgets/budget_progress_bar.dart';

class BasketTotalScreen extends ConsumerWidget {
  const BasketTotalScreen({super.key});

  Future<void> _endSession(BuildContext context, WidgetRef ref) async {
    final items = ref.read(basketProvider);
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Basket is empty. Add items first.')),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Session'),
        content: const Text(
          'Save this shopping session to history and clear the basket?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('End Session'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(historyProvider.notifier).saveCurrentSession();
      await ref.read(basketProvider.notifier).clear();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Session saved to history.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatter = ref.watch(currencyFormatterProvider);
    final usage = ref.watch(budgetUsageProvider);
    final items = ref.watch(basketProvider);
    final budget = ref.watch(budgetProvider);

    return Scaffold(
      backgroundColor: AppColors.mintLight,
      appBar: AppBar(title: const Text('Basket Total')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              color: AppColors.mintBackground,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formatter.format(usage.totalSpent),
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatter.format(budget ?? 0),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey.shade700,
                          ),
                    ),
                    const SizedBox(height: 16),
                    BudgetProgressBar(
                      percentUsed: usage.percentUsed,
                      status: usage.status,
                    ),
                    const SizedBox(height: 12),
                    if (usage.status == BudgetStatus.nearlyReached)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.warningOrange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'NEARLY REACHED',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    if (usage.status == BudgetStatus.nearlyReached)
                      const SizedBox(height: 8),
                    Text(
                      'Budget Status: ${(usage.percentUsed * 100).toStringAsFixed(0)}% Used (${formatter.format(usage.remaining)} remaining)',
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? const Center(
                    child: Text(
                      'No items yet.\nTap Scan to add groceries.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: BasketItemTile(
                          item: item,
                          onDelete: () => ref
                              .read(basketProvider.notifier)
                              .removeItem(item.id),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton(
              onPressed: () => _endSession(context, ref),
              child: const Text('END SESSION'),
            ),
          ),
        ],
      ),
    );
  }
}
