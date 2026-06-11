import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/currency_catalog.dart';
import '../providers/currency_formatter_provider.dart';
import '../providers/currency_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/currency_search_picker.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(currencyProvider);
    final formatter = ref.watch(currencyFormatterProvider);
    final selected = CurrencyCatalog.optionFor(current);

    return Scaffold(
      backgroundColor: AppColors.mintLight,
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Currency',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Search from ${CurrencyCatalog.all.length} world currencies',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () => CurrencySearchPicker.show(
                      context,
                      selectedCode: current.code,
                      onSelected: (option) {
                        ref
                            .read(currencyProvider.notifier)
                            .setCurrency(option.toConfig());
                      },
                    ),
                    borderRadius: BorderRadius.circular(12),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Selected currency',
                        suffixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      child: Row(
                        children: [
                          Text(
                            selected.symbol,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selected.code,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  selected.name,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Preview',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.grey.shade700,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatter.format(1234.56),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGreen,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
