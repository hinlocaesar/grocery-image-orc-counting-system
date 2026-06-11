import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cart_item.dart';
import '../providers/basket_provider.dart';
import '../providers/currency_formatter_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/basket_item_tile.dart';
import '../widgets/primary_button.dart';

const double _mockScannedPrice = 4.99;

class ScanItemScreen extends ConsumerStatefulWidget {
  const ScanItemScreen({super.key});

  @override
  ConsumerState<ScanItemScreen> createState() => _ScanItemScreenState();
}

class _ScanItemScreenState extends ConsumerState<ScanItemScreen> {
  final _nameController = TextEditingController(text: 'Scanned Item');

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _confirmAndAdd() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an item name.')),
      );
      return;
    }

    await ref.read(basketProvider.notifier).addItem(
          name: name,
          scannedPrice: _mockScannedPrice,
        );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$name added to basket.')),
      );
      _nameController.text = 'Scanned Item';
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = ref.watch(currencyFormatterProvider);
    final items = ref.watch(basketProvider);
    final total = ref.watch(basketTotalProvider);
    final formattedPrice = formatter.format(_mockScannedPrice);
    final formattedTotal = formatter.format(total);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          _buildTopBar(context),
          Expanded(child: _buildViewfinder(formattedPrice)),
          _buildBottomCard(
            context,
            items: items,
            formattedPrice: formattedPrice,
            formattedTotal: formattedTotal,
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      color: AppColors.cardWhite,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {},
            ),
            const Expanded(
              child: Text(
                'Scan Item Price',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.camera_alt_outlined),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewfinder(String formattedPrice) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF37474F), Color(0xFF263238)],
            ),
          ),
          child: CustomPaint(painter: _ShelfPainter()),
        ),
        Center(
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 3),
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
                  formattedPrice,
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
        const Positioned(
          bottom: 120,
          left: 0,
          right: 0,
          child: Text(
            'Scanning Price...',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomCard(
    BuildContext context, {
    required List<CartItem> items,
    required String formattedPrice,
    required String formattedTotal,
  }) {
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
              'Price Found: $formattedPrice',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Item name',
                isDense: true,
              ),
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
              onPressed: _confirmAndAdd,
            ),
          ],
        ),
      ),
    );
  }
}

class _ShelfPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final shelfPaint = Paint()..color = const Color(0xFF546E7A);
    final jarPaint = Paint()..color = const Color(0xFF78909C);

    for (var row = 0; row < 3; row++) {
      final y = size.height * 0.25 + row * 80;
      canvas.drawRect(
        Rect.fromLTWH(20, y, size.width - 40, 6),
        shelfPaint,
      );
      for (var col = 0; col < 4; col++) {
        final x = 40 + col * ((size.width - 80) / 4);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(x, y - 50, 40, 50),
            const Radius.circular(6),
          ),
          jarPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
