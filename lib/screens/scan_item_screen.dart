import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cart_item.dart';
import '../providers/basket_provider.dart';
import '../providers/currency_formatter_provider.dart';
import '../providers/scan_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/basket_item_tile.dart';
import '../widgets/camera_permission_error.dart';
import '../widgets/primary_button.dart';
import '../widgets/scan_viewfinder_overlay.dart';

class ScanItemScreen extends ConsumerStatefulWidget {
  const ScanItemScreen({super.key});

  @override
  ConsumerState<ScanItemScreen> createState() => _ScanItemScreenState();
}

class _ScanItemScreenState extends ConsumerState<ScanItemScreen> {
  final _nameController = TextEditingController(text: 'Scanned Item');
  final _priceController = TextEditingController();
  var _priceManuallyEdited = false;
  var _nameManuallyEdited = false;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  double? _resolvePrice(ScanState scanState) {
    if (_priceManuallyEdited) {
      return double.tryParse(_priceController.text.trim());
    }
    return scanState.detectedPrice;
  }

  void _syncPriceField(ScanState scanState) {
    if (_priceManuallyEdited) return;
    if (scanState.detectedPrice != null) {
      _priceController.text = scanState.detectedPrice!.toStringAsFixed(2);
    }
  }

  void _syncNameField(ScanState scanState) {
    if (_nameManuallyEdited) return;
    final name = scanState.detectedProductName;
    if (name != null && name.isNotEmpty) {
      _nameController.text = name;
    }
  }

  Future<void> _confirmAndAdd() async {
    final scanState = ref.read(scanProvider);
    final name = _nameController.text.trim();
    final price = _resolvePrice(scanState);

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an item name.')),
      );
      return;
    }

    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No price detected. Scan a tag or enter a price.'),
        ),
      );
      return;
    }

    await ref.read(basketProvider.notifier).addItem(
          name: name,
          scannedPrice: price,
        );

    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$name added to basket.')),
      );
      _nameController.text = 'Scanned Item';
      _priceController.clear();
      _priceManuallyEdited = false;
      _nameManuallyEdited = false;
      ref.read(scanProvider.notifier).resetDetection();
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = ref.watch(currencyFormatterProvider);
    final items = ref.watch(basketProvider);
    final total = ref.watch(basketTotalProvider);
    final scanState = ref.watch(scanProvider);

    ref.listen<ScanState>(scanProvider, (previous, next) {
      _syncPriceField(next);
      _syncNameField(next);
    });

    final detectedPrice = scanState.detectedPrice;
    final formattedPrice = detectedPrice != null
        ? formatter.format(detectedPrice)
        : null;
    final formattedTotal = formatter.format(total);
    final canConfirm = _resolvePrice(scanState) != null;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          _buildTopBar(context, scanState),
          Expanded(child: _buildViewfinder(scanState, formattedPrice)),
          _buildBottomCard(
            context,
            items: items,
            formattedPrice: formattedPrice,
            formattedTotal: formattedTotal,
            canConfirm: canConfirm,
            scanState: scanState,
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, ScanState scanState) {
    return Container(
      color: AppColors.cardWhite,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            const SizedBox(width: 48),
            const Expanded(
              child: Text(
                'Scan Item Price',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            IconButton(
              icon: Icon(
                scanState.cameraController?.value.flashMode == FlashMode.torch
                    ? Icons.flash_on
                    : Icons.camera_alt_outlined,
              ),
              onPressed: scanState.status == ScanStatus.unsupported ||
                      scanState.status == ScanStatus.error
                  ? null
                  : () => ref.read(scanProvider.notifier).toggleTorch(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewfinder(ScanState scanState, String? formattedPrice) {
    if (scanState.status == ScanStatus.unsupported) {
      return const CameraPermissionError(
        message:
            'Price scanning requires an Android or iOS device with a camera.',
      );
    }

    if (scanState.status == ScanStatus.error) {
      return CameraPermissionError(
        message: scanState.errorMessage ?? 'Camera unavailable.',
      );
    }

    final controller = scanState.cameraController;
    if (scanState.status == ScanStatus.initializing || controller == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        CameraPreview(controller),
        ScanViewfinderOverlay(
          status: scanState.status,
          formattedPrice: formattedPrice,
        ),
      ],
    );
  }

  Widget _buildBottomCard(
    BuildContext context, {
    required List<CartItem> items,
    required String? formattedPrice,
    required String formattedTotal,
    required bool canConfirm,
    required ScanState scanState,
  }) {
    final priceLabel = formattedPrice ?? 'Scanning...';

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              scanState.status == ScanStatus.found
                  ? 'Price Found: $priceLabel'
                  : 'Price Found: $priceLabel',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            if (scanState.detectedProductName != null) ...[
              const SizedBox(height: 4),
              Text(
                'Product: ${scanState.detectedProductName}',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
              ),
            ],
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Item name',
                hintText: scanState.detectedProductName == null
                    ? 'Enter name if not detected'
                    : null,
                isDense: true,
              ),
              onChanged: (_) => _nameManuallyEdited = true,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _priceController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Price (override if needed)',
                isDense: true,
              ),
              onChanged: (_) => _priceManuallyEdited = true,
            ),
            const SizedBox(height: 12),
            if (items.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'No items in basket yet.',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 140),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return BasketItemTile(item: items[index], compact: true);
                  },
                ),
              ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  formattedTotal,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              label: 'CONFIRM & ADD',
              onPressed: canConfirm ? _confirmAndAdd : null,
            ),
          ],
        ),
      ),
    );
  }
}
