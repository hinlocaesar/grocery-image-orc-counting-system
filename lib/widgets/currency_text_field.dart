import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/currency_provider.dart';

class CurrencyTextField extends ConsumerWidget {
  const CurrencyTextField({
    super.key,
    required this.controller,
    this.hintText = 'Enter Amount',
    this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final symbol = ref.watch(currencyProvider).symbol;

    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Text(
            symbol,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
          fontWeight: FontWeight.normal,
        ),
      ),
      onChanged: onChanged,
    );
  }
}
