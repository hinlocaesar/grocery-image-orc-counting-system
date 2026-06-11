import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_item.dart';
import '../models/currency_config.dart';
import '../models/shopping_session.dart';

class PrefsStorage {
  PrefsStorage._(this._prefs);

  static PrefsStorage? _instance;

  final SharedPreferences _prefs;

  static const _budgetKey = 'monthly_budget';
  static const _currencyKey = 'currency_config';
  static const _basketKey = 'active_basket';
  static const _historyKey = 'shopping_history';

  static Future<PrefsStorage> init() async {
    final prefs = await SharedPreferences.getInstance();
    _instance = PrefsStorage._(prefs);
    return _instance!;
  }

  static PrefsStorage get instance {
    final storage = _instance;
    if (storage == null) {
      throw StateError('PrefsStorage.init() must be called before use.');
    }
    return storage;
  }

  double? loadBudget() {
    if (!_prefs.containsKey(_budgetKey)) return null;
    return _prefs.getDouble(_budgetKey);
  }

  Future<void> saveBudget(double budget) async {
    await _prefs.setDouble(_budgetKey, budget);
  }

  CurrencyConfig loadCurrency() {
    final raw = _prefs.getString(_currencyKey);
    if (raw == null) return CurrencyConfig.defaults;
    return CurrencyConfig.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );
  }

  Future<void> saveCurrency(CurrencyConfig config) async {
    await _prefs.setString(_currencyKey, jsonEncode(config.toJson()));
  }

  List<CartItem> loadBasket() {
    final raw = _prefs.getString(_basketKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveBasket(List<CartItem> items) async {
    final encoded = jsonEncode(items.map((item) => item.toJson()).toList());
    await _prefs.setString(_basketKey, encoded);
  }

  List<ShoppingSession> loadHistory() {
    final raw = _prefs.getString(_historyKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map(
          (session) =>
              ShoppingSession.fromJson(session as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> saveHistory(List<ShoppingSession> sessions) async {
    final encoded =
        jsonEncode(sessions.map((session) => session.toJson()).toList());
    await _prefs.setString(_historyKey, encoded);
  }
}
