class CartItem {
  const CartItem({
    required this.id,
    required this.name,
    required this.scannedPrice,
    this.quantity = 1,
  });

  final String id;
  final String name;
  final double scannedPrice;
  final int quantity;

  double get lineTotal => scannedPrice * quantity;

  CartItem copyWith({
    String? id,
    String? name,
    double? scannedPrice,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      scannedPrice: scannedPrice ?? this.scannedPrice,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'scannedPrice': scannedPrice,
        'quantity': quantity,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as String,
      name: json['name'] as String,
      scannedPrice: (json['scannedPrice'] as num).toDouble(),
      quantity: json['quantity'] as int? ?? 1,
    );
  }
}
