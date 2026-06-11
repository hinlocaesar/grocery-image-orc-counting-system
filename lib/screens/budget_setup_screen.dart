import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/budget_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/currency_text_field.dart';
import '../widgets/primary_button.dart';

class BudgetSetupScreen extends ConsumerStatefulWidget {
  const BudgetSetupScreen({super.key});

  @override
  ConsumerState<BudgetSetupScreen> createState() => _BudgetSetupScreenState();
}

class _BudgetSetupScreenState extends ConsumerState<BudgetSetupScreen> {
  late final TextEditingController _controller;
  var _prefilled = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '400.00');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveBudget() async {
    final value = double.tryParse(_controller.text.trim());
    if (value == null || value <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid budget amount.')),
      );
      return;
    }

    await ref.read(budgetProvider.notifier).setBudget(value);
    if (mounted) context.go('/scan');
  }

  @override
  Widget build(BuildContext context) {
    final existing = ref.watch(budgetProvider);
    if (!_prefilled && existing != null) {
      _controller.text = existing.toStringAsFixed(2);
      _prefilled = true;
    }

    return Scaffold(
      backgroundColor: AppColors.mintBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 48),
              Text(
                'Groceries',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Setup Your Monthly Budget',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: CurrencyTextField(controller: _controller),
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(label: 'SAVE', onPressed: _saveBudget),
              const Spacer(),
              Text(
                'Track. Scan. Save.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today_outlined, size: 48, color: Colors.grey.shade800),
                  const SizedBox(width: 64),
                  Icon(Icons.account_balance_wallet_outlined, size: 48, color: Colors.grey.shade800),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
