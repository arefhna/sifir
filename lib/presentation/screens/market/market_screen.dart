import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(height: 16),
              Text('Bazar', style: AppTypography.headline),
              SizedBox(height: 4),
              Text('Qiymətlər və tələb-təklif',
                  style: AppTypography.bodySecondary),
              SizedBox(height: 24),
              Expanded(
                child: Center(
                  child: Text('Bazar Mərhələ 4-də əlavə olunacaq',
                      style: AppTypography.bodySecondary,
                      textAlign: TextAlign.center),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
