class CurrencyConfig {
  const CurrencyConfig({
    required this.code,
    required this.symbol,
    required this.locale,
  });

  final String code;
  final String symbol;
  final String locale;

  static const defaults = CurrencyConfig(
    code: 'USD',
    symbol: r'$',
    locale: 'en_US',
  );

  static const presets = [
    CurrencyConfig(code: 'USD', symbol: r'$', locale: 'en_US'),
    CurrencyConfig(code: 'EUR', symbol: '€', locale: 'de_DE'),
    CurrencyConfig(code: 'GBP', symbol: '£', locale: 'en_GB'),
    CurrencyConfig(code: 'JPY', symbol: '¥', locale: 'ja_JP'),
  ];

  CurrencyConfig copyWith({
    String? code,
    String? symbol,
    String? locale,
  }) {
    return CurrencyConfig(
      code: code ?? this.code,
      symbol: symbol ?? this.symbol,
      locale: locale ?? this.locale,
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'symbol': symbol,
        'locale': locale,
      };

  factory CurrencyConfig.fromJson(Map<String, dynamic> json) {
    return CurrencyConfig(
      code: json['code'] as String,
      symbol: json['symbol'] as String,
      locale: json['locale'] as String,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrencyConfig &&
          code == other.code &&
          symbol == other.symbol &&
          locale == other.locale;

  @override
  int get hashCode => Object.hash(code, symbol, locale);
}
