import 'package:flutter/material.dart';

import '../providers/scan_provider.dart';

class ScanViewfinderOverlay extends StatelessWidget {
  const ScanViewfinderOverlay({
    super.key,
    required this.status,
    required this.formattedPrice,
    this.statusMessage,
  });

  final ScanStatus status;
  final String? formattedPrice;
  final String? statusMessage;

  @override
  Widget build(BuildContext context) {
    final displayPrice = formattedPrice ?? '---';

    return Stack(
      fit: StackFit.expand,
      children: [
        Center(
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              border: Border.all(
                color: status == ScanStatus.found ? Colors.greenAccent : Colors.white,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  displayPrice,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 120,
          left: 0,
          right: 0,
          child: Text(
            statusMessage ?? _defaultStatusMessage(status),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ),
      ],
    );
  }

  String _defaultStatusMessage(ScanStatus status) {
    switch (status) {
      case ScanStatus.initializing:
        return 'Starting camera...';
      case ScanStatus.scanning:
        return 'Scanning Price...';
      case ScanStatus.found:
        return 'Price Found!';
      case ScanStatus.notFound:
        return 'Point camera at a price tag...';
      case ScanStatus.error:
        return 'Camera error';
      case ScanStatus.unsupported:
        return 'OCR not supported on this platform';
    }
  }
}
