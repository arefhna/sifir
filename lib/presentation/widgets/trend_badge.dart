import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class TrendBadge extends StatelessWidget {
  const TrendBadge({required this.changePercent, super.key});

  final double changePercent;

  @override
  Widget build(BuildContext context) {
    late Color color;
    late String label;
    late IconData icon;

    if (changePercent > 3) {
      color = AppColors.success;
      label = '+${changePercent.toStringAsFixed(1)}%';
      icon = Icons.arrow_upward;
    } else if (changePercent < -3) {
      color = AppColors.danger;
      label = '${changePercent.toStringAsFixed(1)}%';
      icon = Icons.arrow_downward;
    } else {
      color = AppColors.textMuted;
      label = '${changePercent.toStringAsFixed(1)}%';
      icon = Icons.remove;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
