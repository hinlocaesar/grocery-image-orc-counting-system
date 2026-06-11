import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/cart_item.dart';
import '../services/prefs_storage.dart';

const _uuid = Uuid();

class BasketNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() {
    return PrefsStorage.instance.loadBasket();
  }

  Future<void> _persist() async {
    await PrefsStorage.instance.saveBasket(state);
  }

  Future<void> addItem({
    required String name,
    required double scannedPrice,
    int quantity = 1,
  }) async {
    state = [
      ...state,
      CartItem(
        id: _uuid.v4(),
        name: name,
        scannedPrice: scannedPrice,
        quantity: quantity,
      ),
    ];
    await _persist();
  }

  Future<void> removeItem(String id) async {
    state = state.where((item) => item.id != id).toList();
    await _persist();
  }

  Future<void> updateQuantity(String id, int quantity) async {
    if (quantity < 1) return;
    state = [
      for (final item in state)
        if (item.id == id) item.copyWith(quantity: quantity) else item,
    ];
    await _persist();
  }

  Future<void> clear() async {
    state = [];
    await _persist();
  }
}

final basketProvider =
    NotifierProvider<BasketNotifier, List<CartItem>>(BasketNotifier.new);

final basketTotalProvider = Provider<double>((ref) {
  final items = ref.watch(basketProvider);
  return items.fold<double>(0, (sum, item) => sum + item.lineTotal);
});
