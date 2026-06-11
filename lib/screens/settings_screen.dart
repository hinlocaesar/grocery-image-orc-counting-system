import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/currency_config.dart';
import '../providers/currency_formatter_provider.dart';
import '../providers/currency_provider.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(currencyProvider);
    final formatter = ref.watch(currencyFormatterProvider);

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
                  const SizedBox(height: 12),
                  DropdownButtonFormField<CurrencyConfig>(
                    initialValue: CurrencyConfig.presets.firstWhere(
                      (preset) => preset.code == current.code,
                      orElse: () => current,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Select currency',
                    ),
                    items: CurrencyConfig.presets
                        .map(
                          (preset) => DropdownMenuItem(
                            value: preset,
                            child: Text(
                              '${preset.symbol} ${preset.code} (${preset.locale})',
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (preset) {
                      if (preset != null) {
                        ref
                            .read(currencyProvider.notifier)
                            .setCurrency(preset);
                      }
                    },
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
