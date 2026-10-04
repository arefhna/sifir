import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class BusinessesScreen extends StatelessWidget {
  const BusinessesScreen({super.key});

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
              Text('Biznes', style: AppTypography.headline),
              SizedBox(height: 4),
              Text('Passiv gəlir və böyümə',
                  style: AppTypography.bodySecondary),
              SizedBox(height: 24),
              Expanded(
                child: Center(
                  child: Text('Biznes sistemi Mərhələ 4-də əlavə olunacaq',
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
