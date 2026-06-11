import 'package:flutter/material.dart';

import '../providers/budget_usage_provider.dart';
import '../theme/app_theme.dart';

class BudgetProgressBar extends StatelessWidget {
  const BudgetProgressBar({
    super.key,
    required this.percentUsed,
    required this.status,
    this.height = 12,
  });

  final double percentUsed;
  final BudgetStatus status;
  final double height;

  Color get _barColor {
    switch (status) {
      case BudgetStatus.exceeded:
        return AppColors.alertRed;
      case BudgetStatus.nearlyReached:
        return AppColors.warningOrange;
      case BudgetStatus.ok:
        return AppColors.primaryGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final clampedValue = percentUsed.clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: SizedBox(
        height: height,
        child: LinearProgressIndicator(
          value: status == BudgetStatus.exceeded ? 1.0 : clampedValue,
          backgroundColor: Colors.grey.shade200,
          color: _barColor,
          minHeight: height,
        ),
      ),
    );
  }
}
