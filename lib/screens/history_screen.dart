import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/shopping_session.dart';
import '../providers/currency_formatter_provider.dart';
import '../providers/history_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/basket_item_tile.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  void _showSessionDetail(BuildContext context, ShoppingSession session) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return _SessionDetailSheet(
            session: session,
            scrollController: scrollController,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(historyProvider);
    final formatter = ref.watch(currencyFormatterProvider);
    final dateFormat = DateFormat.yMMMd().add_jm();

    return Scaffold(
      backgroundColor: AppColors.mintLight,
      appBar: AppBar(title: const Text('History')),
      body: sessions.isEmpty
          ? const Center(
              child: Text(
                'No shopping sessions yet.\nEnd a session from Home to save one.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                final overUnder = session.isOverBudget
                    ? 'Over budget'
                    : 'Under budget';

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      dateFormat.format(session.completedAt),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('${session.items.length} items'),
                        Text(
                          '${formatter.format(session.totalSpent)} / '
                          '${formatter.format(session.budgetLimit)}',
                        ),
                      ],
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: session.isOverBudget
                            ? AppColors.alertPink
                            : const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        overUnder,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: session.isOverBudget
                              ? AppColors.alertRed
                              : AppColors.darkGreen,
                        ),
                      ),
                    ),
                    onTap: () => _showSessionDetail(context, session),
                  ),
                );
              },
            ),
    );
  }
}

class _SessionDetailSheet extends ConsumerWidget {
  const _SessionDetailSheet({
    required this.session,
    required this.scrollController,
  });

  final ShoppingSession session;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatter = ref.watch(currencyFormatterProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Session Details',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Total: ${formatter.format(session.totalSpent)} · '
            'Budget: ${formatter.format(session.budgetLimit)}',
            style: TextStyle(color: Colors.grey.shade700),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: session.items.length,
              itemBuilder: (context, index) {
                return BasketItemTile(
                  item: session.items[index],
                  compact: true,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
