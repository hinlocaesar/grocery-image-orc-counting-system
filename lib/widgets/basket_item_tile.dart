import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cart_item.dart';
import '../providers/currency_formatter_provider.dart';

class BasketItemTile extends ConsumerWidget {
  const BasketItemTile({
    super.key,
    required this.item,
    this.onDelete,
    this.compact = false,
  });

  final CartItem item;
  final VoidCallback? onDelete;
  final bool compact;

  IconData _iconForName(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('apple')) return Icons.apple;
    if (lower.contains('milk')) return Icons.local_drink;
    if (lower.contains('chip')) return Icons.fastfood;
    if (lower.contains('pumpkin')) return Icons.eco;
    return Icons.shopping_basket;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatter = ref.watch(currencyFormatterProvider);
    final unitPrice = formatter.format(item.scannedPrice);
    final lineTotal = formatter.format(item.lineTotal);

    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: compact ? 0 : 16,
        vertical: compact ? 4 : 0,
      ),
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFE8F5E9),
        child: Icon(_iconForName(item.name), color: const Color(0xFF2E7D32)),
      ),
      title: Text(
        item.quantity > 1
            ? '${item.name} - $unitPrice x${item.quantity}'
            : '${item.name} - $unitPrice',
        style: TextStyle(
          fontSize: compact ? 14 : 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            lineTotal,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: compact ? 14 : 16,
            ),
          ),
          if (onDelete != null) ...[
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: onDelete,
              visualDensity: VisualDensity.compact,
            ),
          ],
        ],
      ),
    );
  }
}
