class ScanExtractionResult {
  const ScanExtractionResult({
    required this.price,
    required this.rawPriceText,
    required this.confidence,
    this.productName,
  });

  final double price;
  final String rawPriceText;
  final double confidence;
  final String? productName;
}
