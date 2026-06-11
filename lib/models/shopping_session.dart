import 'cart_item.dart';

class ShoppingSession {
  const ShoppingSession({
    required this.id,
    required this.completedAt,
    required this.budgetLimit,
    required this.totalSpent,
    required this.currencyCode,
    required this.items,
  });

  final String id;
  final DateTime completedAt;
  final double budgetLimit;
  final double totalSpent;
  final String currencyCode;
  final List<CartItem> items;

  bool get isOverBudget => totalSpent > budgetLimit;

  Map<String, dynamic> toJson() => {
        'id': id,
        'completedAt': completedAt.toIso8601String(),
        'budgetLimit': budgetLimit,
        'totalSpent': totalSpent,
        'currencyCode': currencyCode,
        'items': items.map((item) => item.toJson()).toList(),
      };

  factory ShoppingSession.fromJson(Map<String, dynamic> json) {
    return ShoppingSession(
      id: json['id'] as String,
      completedAt: DateTime.parse(json['completedAt'] as String),
      budgetLimit: (json['budgetLimit'] as num).toDouble(),
      totalSpent: (json['totalSpent'] as num).toDouble(),
      currencyCode: json['currencyCode'] as String,
      items: (json['items'] as List<dynamic>)
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
