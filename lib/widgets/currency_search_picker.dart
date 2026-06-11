import 'package:flutter/material.dart';

import '../data/currency_catalog.dart';
import '../theme/app_theme.dart';

class CurrencySearchPicker extends StatefulWidget {
  const CurrencySearchPicker({
    super.key,
    required this.selectedCode,
    required this.onSelected,
  });

  final String selectedCode;
  final ValueChanged<CurrencyOption> onSelected;

  static Future<void> show(
    BuildContext context, {
    required String selectedCode,
    required ValueChanged<CurrencyOption> onSelected,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => CurrencySearchPicker(
        selectedCode: selectedCode,
        onSelected: (option) {
          onSelected(option);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  State<CurrencySearchPicker> createState() => _CurrencySearchPickerState();
}

class _CurrencySearchPickerState extends State<CurrencySearchPicker> {
  final _searchController = TextEditingController();
  late List<CurrencyOption> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = CurrencyCatalog.all;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _filtered = CurrencyCatalog.search(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text(
                'Select Currency',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search by code, name, or symbol...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => _searchController.clear(),
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  isDense: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${_filtered.length} currencies',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ),
            ),
            Expanded(
              child: _filtered.isEmpty
                  ? const Center(child: Text('No currencies match your search.'))
                  : ListView.builder(
                      controller: scrollController,
                      itemCount: _filtered.length,
                      itemBuilder: (context, index) {
                        final option = _filtered[index];
                        final isSelected = option.code == widget.selectedCode;

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isSelected
                                ? AppColors.mintBackground
                                : Colors.grey.shade100,
                            child: Text(
                              option.symbol,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? AppColors.darkGreen
                                    : Colors.black87,
                              ),
                            ),
                          ),
                          title: Text(
                            option.code,
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(option.name),
                          trailing: isSelected
                              ? const Icon(
                                  Icons.check_circle,
                                  color: AppColors.primaryGreen,
                                )
                              : null,
                          onTap: () => widget.onSelected(option),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
