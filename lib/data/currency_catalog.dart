import '../models/currency_config.dart';

class CurrencyOption {
  const CurrencyOption({
    required this.code,
    required this.name,
    required this.symbol,
    required this.locale,
  });

  final String code;
  final String name;
  final String symbol;
  final String locale;

  CurrencyConfig toConfig() => CurrencyConfig(
        code: code,
        symbol: symbol,
        locale: locale,
      );

  String get displayLabel => '$symbol $code — $name';

  bool matchesQuery(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return code.toLowerCase().contains(q) ||
        name.toLowerCase().contains(q) ||
        symbol.toLowerCase().contains(q) ||
        locale.toLowerCase().contains(q);
  }
}

class CurrencyCatalog {
  static const List<CurrencyOption> all = [
    CurrencyOption(code: 'AED', name: 'UAE Dirham', symbol: 'د.إ', locale: 'ar_AE'),
    CurrencyOption(code: 'AFN', name: 'Afghan Afghani', symbol: '؋', locale: 'fa_AF'),
    CurrencyOption(code: 'ALL', name: 'Albanian Lek', symbol: 'L', locale: 'sq_AL'),
    CurrencyOption(code: 'AMD', name: 'Armenian Dram', symbol: '֏', locale: 'hy_AM'),
    CurrencyOption(code: 'ANG', name: 'Netherlands Antillean Guilder', symbol: 'ƒ', locale: 'nl_AN'),
    CurrencyOption(code: 'AOA', name: 'Angolan Kwanza', symbol: 'Kz', locale: 'pt_AO'),
    CurrencyOption(code: 'ARS', name: 'Argentine Peso', symbol: r'$', locale: 'es_AR'),
    CurrencyOption(code: 'AUD', name: 'Australian Dollar', symbol: r'A$', locale: 'en_AU'),
    CurrencyOption(code: 'AWG', name: 'Aruban Florin', symbol: 'ƒ', locale: 'nl_AW'),
    CurrencyOption(code: 'AZN', name: 'Azerbaijani Manat', symbol: '₼', locale: 'az_AZ'),
    CurrencyOption(code: 'BAM', name: 'Bosnia-Herzegovina Convertible Mark', symbol: 'KM', locale: 'bs_BA'),
    CurrencyOption(code: 'BBD', name: 'Barbadian Dollar', symbol: r'Bds$', locale: 'en_BB'),
    CurrencyOption(code: 'BDT', name: 'Bangladeshi Taka', symbol: '৳', locale: 'bn_BD'),
    CurrencyOption(code: 'BGN', name: 'Bulgarian Lev', symbol: 'лв', locale: 'bg_BG'),
    CurrencyOption(code: 'BHD', name: 'Bahraini Dinar', symbol: '.د.ب', locale: 'ar_BH'),
    CurrencyOption(code: 'BIF', name: 'Burundian Franc', symbol: 'FBu', locale: 'fr_BI'),
    CurrencyOption(code: 'BMD', name: 'Bermudian Dollar', symbol: r'$', locale: 'en_BM'),
    CurrencyOption(code: 'BND', name: 'Brunei Dollar', symbol: r'B$', locale: 'ms_BN'),
    CurrencyOption(code: 'BOB', name: 'Bolivian Boliviano', symbol: 'Bs.', locale: 'es_BO'),
    CurrencyOption(code: 'BRL', name: 'Brazilian Real', symbol: 'R\$', locale: 'pt_BR'),
    CurrencyOption(code: 'BSD', name: 'Bahamian Dollar', symbol: r'B$', locale: 'en_BS'),
    CurrencyOption(code: 'BTN', name: 'Bhutanese Ngultrum', symbol: 'Nu.', locale: 'dz_BT'),
    CurrencyOption(code: 'BWP', name: 'Botswana Pula', symbol: 'P', locale: 'en_BW'),
    CurrencyOption(code: 'BYN', name: 'Belarusian Ruble', symbol: 'Br', locale: 'be_BY'),
    CurrencyOption(code: 'BZD', name: 'Belize Dollar', symbol: r'BZ$', locale: 'en_BZ'),
    CurrencyOption(code: 'CAD', name: 'Canadian Dollar', symbol: r'C$', locale: 'en_CA'),
    CurrencyOption(code: 'CDF', name: 'Congolese Franc', symbol: 'FC', locale: 'fr_CD'),
    CurrencyOption(code: 'CHF', name: 'Swiss Franc', symbol: 'CHF', locale: 'de_CH'),
    CurrencyOption(code: 'CLP', name: 'Chilean Peso', symbol: r'$', locale: 'es_CL'),
    CurrencyOption(code: 'CNY', name: 'Chinese Yuan', symbol: '¥', locale: 'zh_CN'),
    CurrencyOption(code: 'COP', name: 'Colombian Peso', symbol: r'$', locale: 'es_CO'),
    CurrencyOption(code: 'CRC', name: 'Costa Rican Colón', symbol: '₡', locale: 'es_CR'),
    CurrencyOption(code: 'CUP', name: 'Cuban Peso', symbol: r'$', locale: 'es_CU'),
    CurrencyOption(code: 'CVE', name: 'Cape Verdean Escudo', symbol: r'$', locale: 'pt_CV'),
    CurrencyOption(code: 'CZK', name: 'Czech Koruna', symbol: 'Kč', locale: 'cs_CZ'),
    CurrencyOption(code: 'DJF', name: 'Djiboutian Franc', symbol: 'Fdj', locale: 'fr_DJ'),
    CurrencyOption(code: 'DKK', name: 'Danish Krone', symbol: 'kr', locale: 'da_DK'),
    CurrencyOption(code: 'DOP', name: 'Dominican Peso', symbol: r'RD$', locale: 'es_DO'),
    CurrencyOption(code: 'DZD', name: 'Algerian Dinar', symbol: 'د.ج', locale: 'ar_DZ'),
    CurrencyOption(code: 'EGP', name: 'Egyptian Pound', symbol: 'E£', locale: 'ar_EG'),
    CurrencyOption(code: 'ERN', name: 'Eritrean Nakfa', symbol: 'Nfk', locale: 'ti_ER'),
    CurrencyOption(code: 'ETB', name: 'Ethiopian Birr', symbol: 'Br', locale: 'am_ET'),
    CurrencyOption(code: 'EUR', name: 'Euro', symbol: '€', locale: 'de_DE'),
    CurrencyOption(code: 'FJD', name: 'Fijian Dollar', symbol: r'FJ$', locale: 'en_FJ'),
    CurrencyOption(code: 'FKP', name: 'Falkland Islands Pound', symbol: '£', locale: 'en_FK'),
    CurrencyOption(code: 'GBP', name: 'British Pound', symbol: '£', locale: 'en_GB'),
    CurrencyOption(code: 'GEL', name: 'Georgian Lari', symbol: '₾', locale: 'ka_GE'),
    CurrencyOption(code: 'GHS', name: 'Ghanaian Cedi', symbol: '₵', locale: 'en_GH'),
    CurrencyOption(code: 'GIP', name: 'Gibraltar Pound', symbol: '£', locale: 'en_GI'),
    CurrencyOption(code: 'GMD', name: 'Gambian Dalasi', symbol: 'D', locale: 'en_GM'),
    CurrencyOption(code: 'GNF', name: 'Guinean Franc', symbol: 'FG', locale: 'fr_GN'),
    CurrencyOption(code: 'GTQ', name: 'Guatemalan Quetzal', symbol: 'Q', locale: 'es_GT'),
    CurrencyOption(code: 'GYD', name: 'Guyanese Dollar', symbol: r'G$', locale: 'en_GY'),
    CurrencyOption(code: 'HKD', name: 'Hong Kong Dollar', symbol: r'HK$', locale: 'zh_HK'),
    CurrencyOption(code: 'HNL', name: 'Honduran Lempira', symbol: 'L', locale: 'es_HN'),
    CurrencyOption(code: 'HRK', name: 'Croatian Kuna', symbol: 'kn', locale: 'hr_HR'),
    CurrencyOption(code: 'HTG', name: 'Haitian Gourde', symbol: 'G', locale: 'ht_HT'),
    CurrencyOption(code: 'HUF', name: 'Hungarian Forint', symbol: 'Ft', locale: 'hu_HU'),
    CurrencyOption(code: 'IDR', name: 'Indonesian Rupiah', symbol: 'Rp', locale: 'id_ID'),
    CurrencyOption(code: 'ILS', name: 'Israeli New Shekel', symbol: '₪', locale: 'he_IL'),
    CurrencyOption(code: 'INR', name: 'Indian Rupee', symbol: '₹', locale: 'en_IN'),
    CurrencyOption(code: 'IQD', name: 'Iraqi Dinar', symbol: 'ع.د', locale: 'ar_IQ'),
    CurrencyOption(code: 'IRR', name: 'Iranian Rial', symbol: '﷼', locale: 'fa_IR'),
    CurrencyOption(code: 'ISK', name: 'Icelandic Króna', symbol: 'kr', locale: 'is_IS'),
    CurrencyOption(code: 'JMD', name: 'Jamaican Dollar', symbol: r'J$', locale: 'en_JM'),
    CurrencyOption(code: 'JOD', name: 'Jordanian Dinar', symbol: 'JD', locale: 'ar_JO'),
    CurrencyOption(code: 'JPY', name: 'Japanese Yen', symbol: '¥', locale: 'ja_JP'),
    CurrencyOption(code: 'KES', name: 'Kenyan Shilling', symbol: 'KSh', locale: 'en_KE'),
    CurrencyOption(code: 'KGS', name: 'Kyrgyzstani Som', symbol: 'с', locale: 'ky_KG'),
    CurrencyOption(code: 'KHR', name: 'Cambodian Riel', symbol: '៛', locale: 'km_KH'),
    CurrencyOption(code: 'KMF', name: 'Comorian Franc', symbol: 'CF', locale: 'fr_KM'),
    CurrencyOption(code: 'KRW', name: 'South Korean Won', symbol: '₩', locale: 'ko_KR'),
    CurrencyOption(code: 'KWD', name: 'Kuwaiti Dinar', symbol: 'د.ك', locale: 'ar_KW'),
    CurrencyOption(code: 'KYD', name: 'Cayman Islands Dollar', symbol: r'CI$', locale: 'en_KY'),
    CurrencyOption(code: 'KZT', name: 'Kazakhstani Tenge', symbol: '₸', locale: 'kk_KZ'),
    CurrencyOption(code: 'LAK', name: 'Lao Kip', symbol: '₭', locale: 'lo_LA'),
    CurrencyOption(code: 'LBP', name: 'Lebanese Pound', symbol: 'ل.ل', locale: 'ar_LB'),
    CurrencyOption(code: 'LKR', name: 'Sri Lankan Rupee', symbol: 'Rs', locale: 'si_LK'),
    CurrencyOption(code: 'LRD', name: 'Liberian Dollar', symbol: r'L$', locale: 'en_LR'),
    CurrencyOption(code: 'LSL', name: 'Lesotho Loti', symbol: 'L', locale: 'en_LS'),
    CurrencyOption(code: 'LYD', name: 'Libyan Dinar', symbol: 'ل.د', locale: 'ar_LY'),
    CurrencyOption(code: 'MAD', name: 'Moroccan Dirham', symbol: 'د.م.', locale: 'ar_MA'),
    CurrencyOption(code: 'MDL', name: 'Moldovan Leu', symbol: 'L', locale: 'ro_MD'),
    CurrencyOption(code: 'MGA', name: 'Malagasy Ariary', symbol: 'Ar', locale: 'mg_MG'),
    CurrencyOption(code: 'MKD', name: 'Macedonian Denar', symbol: 'ден', locale: 'mk_MK'),
    CurrencyOption(code: 'MMK', name: 'Myanmar Kyat', symbol: 'K', locale: 'my_MM'),
    CurrencyOption(code: 'MNT', name: 'Mongolian Tögrög', symbol: '₮', locale: 'mn_MN'),
    CurrencyOption(code: 'MOP', name: 'Macanese Pataca', symbol: 'MOP\$', locale: 'zh_MO'),
    CurrencyOption(code: 'MRU', name: 'Mauritanian Ouguiya', symbol: 'UM', locale: 'ar_MR'),
    CurrencyOption(code: 'MUR', name: 'Mauritian Rupee', symbol: '₨', locale: 'en_MU'),
    CurrencyOption(code: 'MVR', name: 'Maldivian Rufiyaa', symbol: 'Rf', locale: 'dv_MV'),
    CurrencyOption(code: 'MWK', name: 'Malawian Kwacha', symbol: 'MK', locale: 'en_MW'),
    CurrencyOption(code: 'MXN', name: 'Mexican Peso', symbol: r'$', locale: 'es_MX'),
    CurrencyOption(code: 'MYR', name: 'Malaysian Ringgit', symbol: 'RM', locale: 'ms_MY'),
    CurrencyOption(code: 'MZN', name: 'Mozambican Metical', symbol: 'MT', locale: 'pt_MZ'),
    CurrencyOption(code: 'NAD', name: 'Namibian Dollar', symbol: r'N$', locale: 'en_NA'),
    CurrencyOption(code: 'NGN', name: 'Nigerian Naira', symbol: '₦', locale: 'en_NG'),
    CurrencyOption(code: 'NIO', name: 'Nicaraguan Córdoba', symbol: 'C\$', locale: 'es_NI'),
    CurrencyOption(code: 'NOK', name: 'Norwegian Krone', symbol: 'kr', locale: 'nb_NO'),
    CurrencyOption(code: 'NPR', name: 'Nepalese Rupee', symbol: '₨', locale: 'ne_NP'),
    CurrencyOption(code: 'NZD', name: 'New Zealand Dollar', symbol: r'NZ$', locale: 'en_NZ'),
    CurrencyOption(code: 'OMR', name: 'Omani Rial', symbol: 'ر.ع.', locale: 'ar_OM'),
    CurrencyOption(code: 'PAB', name: 'Panamanian Balboa', symbol: 'B/.', locale: 'es_PA'),
    CurrencyOption(code: 'PEN', name: 'Peruvian Sol', symbol: 'S/', locale: 'es_PE'),
    CurrencyOption(code: 'PGK', name: 'Papua New Guinean Kina', symbol: 'K', locale: 'en_PG'),
    CurrencyOption(code: 'PHP', name: 'Philippine Peso', symbol: '₱', locale: 'en_PH'),
    CurrencyOption(code: 'PKR', name: 'Pakistani Rupee', symbol: '₨', locale: 'ur_PK'),
    CurrencyOption(code: 'PLN', name: 'Polish Złoty', symbol: 'zł', locale: 'pl_PL'),
    CurrencyOption(code: 'PYG', name: 'Paraguayan Guaraní', symbol: '₲', locale: 'es_PY'),
    CurrencyOption(code: 'QAR', name: 'Qatari Riyal', symbol: 'ر.ق', locale: 'ar_QA'),
    CurrencyOption(code: 'RON', name: 'Romanian Leu', symbol: 'lei', locale: 'ro_RO'),
    CurrencyOption(code: 'RSD', name: 'Serbian Dinar', symbol: 'дин.', locale: 'sr_RS'),
    CurrencyOption(code: 'RUB', name: 'Russian Ruble', symbol: '₽', locale: 'ru_RU'),
    CurrencyOption(code: 'RWF', name: 'Rwandan Franc', symbol: 'FRw', locale: 'rw_RW'),
    CurrencyOption(code: 'SAR', name: 'Saudi Riyal', symbol: 'ر.س', locale: 'ar_SA'),
    CurrencyOption(code: 'SBD', name: 'Solomon Islands Dollar', symbol: r'SI$', locale: 'en_SB'),
    CurrencyOption(code: 'SCR', name: 'Seychellois Rupee', symbol: '₨', locale: 'en_SC'),
    CurrencyOption(code: 'SDG', name: 'Sudanese Pound', symbol: 'ج.س.', locale: 'ar_SD'),
    CurrencyOption(code: 'SEK', name: 'Swedish Krona', symbol: 'kr', locale: 'sv_SE'),
    CurrencyOption(code: 'SGD', name: 'Singapore Dollar', symbol: r'S$', locale: 'en_SG'),
    CurrencyOption(code: 'SHP', name: 'Saint Helena Pound', symbol: '£', locale: 'en_SH'),
    CurrencyOption(code: 'SLE', name: 'Sierra Leonean Leone', symbol: 'Le', locale: 'en_SL'),
    CurrencyOption(code: 'SOS', name: 'Somali Shilling', symbol: 'Sh', locale: 'so_SO'),
    CurrencyOption(code: 'SRD', name: 'Surinamese Dollar', symbol: r'\$', locale: 'nl_SR'),
    CurrencyOption(code: 'SSP', name: 'South Sudanese Pound', symbol: '£', locale: 'en_SS'),
    CurrencyOption(code: 'STN', name: 'São Tomé and Príncipe Dobra', symbol: 'Db', locale: 'pt_ST'),
    CurrencyOption(code: 'SYP', name: 'Syrian Pound', symbol: '£', locale: 'ar_SY'),
    CurrencyOption(code: 'SZL', name: 'Swazi Lilangeni', symbol: 'E', locale: 'en_SZ'),
    CurrencyOption(code: 'THB', name: 'Thai Baht', symbol: '฿', locale: 'th_TH'),
    CurrencyOption(code: 'TJS', name: 'Tajikistani Somoni', symbol: 'SM', locale: 'tg_TJ'),
    CurrencyOption(code: 'TMT', name: 'Turkmenistani Manat', symbol: 'm', locale: 'tk_TM'),
    CurrencyOption(code: 'TND', name: 'Tunisian Dinar', symbol: 'د.ت', locale: 'ar_TN'),
    CurrencyOption(code: 'TOP', name: 'Tongan Paʻanga', symbol: r'T$', locale: 'to_TO'),
    CurrencyOption(code: 'TRY', name: 'Turkish Lira', symbol: '₺', locale: 'tr_TR'),
    CurrencyOption(code: 'TTD', name: 'Trinidad and Tobago Dollar', symbol: r'TT$', locale: 'en_TT'),
    CurrencyOption(code: 'TWD', name: 'New Taiwan Dollar', symbol: r'NT$', locale: 'zh_TW'),
    CurrencyOption(code: 'TZS', name: 'Tanzanian Shilling', symbol: 'TSh', locale: 'sw_TZ'),
    CurrencyOption(code: 'UAH', name: 'Ukrainian Hryvnia', symbol: '₴', locale: 'uk_UA'),
    CurrencyOption(code: 'UGX', name: 'Ugandan Shilling', symbol: 'USh', locale: 'en_UG'),
    CurrencyOption(code: 'USD', name: 'US Dollar', symbol: r'$', locale: 'en_US'),
    CurrencyOption(code: 'UYU', name: 'Uruguayan Peso', symbol: r'\$U', locale: 'es_UY'),
    CurrencyOption(code: 'UZS', name: 'Uzbekistani Som', symbol: 'soʻm', locale: 'uz_UZ'),
    CurrencyOption(code: 'VES', name: 'Venezuelan Bolívar', symbol: 'Bs.', locale: 'es_VE'),
    CurrencyOption(code: 'VND', name: 'Vietnamese Đồng', symbol: '₫', locale: 'vi_VN'),
    CurrencyOption(code: 'VUV', name: 'Vanuatu Vatu', symbol: 'VT', locale: 'en_VU'),
    CurrencyOption(code: 'WST', name: 'Samoan Tālā', symbol: r'WS$', locale: 'en_WS'),
    CurrencyOption(code: 'XAF', name: 'Central African CFA Franc', symbol: 'FCFA', locale: 'fr_CM'),
    CurrencyOption(code: 'XCD', name: 'East Caribbean Dollar', symbol: r'EC$', locale: 'en_AG'),
    CurrencyOption(code: 'XOF', name: 'West African CFA Franc', symbol: 'CFA', locale: 'fr_SN'),
    CurrencyOption(code: 'XPF', name: 'CFP Franc', symbol: '₣', locale: 'fr_PF'),
    CurrencyOption(code: 'YER', name: 'Yemeni Rial', symbol: '﷼', locale: 'ar_YE'),
    CurrencyOption(code: 'ZAR', name: 'South African Rand', symbol: 'R', locale: 'en_ZA'),
    CurrencyOption(code: 'ZMW', name: 'Zambian Kwacha', symbol: 'ZK', locale: 'en_ZM'),
    CurrencyOption(code: 'ZWL', name: 'Zimbabwean Dollar', symbol: r'Z$', locale: 'en_ZW'),
  ];

  static List<CurrencyOption> search(String query) {
    return all.where((c) => c.matchesQuery(query)).toList();
  }

  static CurrencyOption? findByCode(String code) {
    final upper = code.toUpperCase();
    for (final option in all) {
      if (option.code == upper) return option;
    }
    return null;
  }

  static CurrencyOption optionFor(CurrencyConfig config) {
    return findByCode(config.code) ??
        CurrencyOption(
          code: config.code,
          name: config.code,
          symbol: config.symbol,
          locale: config.locale,
        );
  }
}
