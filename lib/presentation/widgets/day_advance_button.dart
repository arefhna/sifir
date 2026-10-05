import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class DayAdvanceButton extends StatefulWidget {
  const DayAdvanceButton({
    required this.onPressed,
    required this.isLoading,
    super.key,
  });

  final VoidCallback onPressed;
  final bool isLoading;

  @override
  State<DayAdvanceButton> createState() => _DayAdvanceButtonState();
}

class _DayAdvanceButtonState extends State<DayAdvanceButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: widget.isLoading ? null : widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              widget.isLoading ? AppColors.surfaceElevated : AppColors.accent,
          foregroundColor:
              widget.isLoading ? AppColors.textMuted : AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: widget.isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.accent,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.arrow_forward, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Növbəti gün',
                    style: AppTypography.button,
                  ),
                ],
              ),
      ),
    );
  }
}
