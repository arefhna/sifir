import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class RelationshipsScreen extends StatelessWidget {
  const RelationshipsScreen({super.key});

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
              Text('Əlaqələr', style: AppTypography.headline),
              SizedBox(height: 4),
              Text('NPC və biznes şəbəkəsi',
                  style: AppTypography.bodySecondary),
              SizedBox(height: 24),
              Expanded(
                child: Center(
                  child: Text('Əlaqələr Mərhələ 4-də əlavə olunacaq',
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
