import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text('Ana səhifə', style: AppTypography.headline),
              const SizedBox(height: 4),
              const Text('Gün 1', style: AppTypography.bodySecondary),
              const SizedBox(height: 24),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.rocket_launch_outlined,
                          color: AppColors.accent, size: 48),
                      SizedBox(height: 12),
                      Text('Dashboard hazırdır',
                          style: AppTypography.title),
                      SizedBox(height: 6),
                      Text('Core gameplay Mərhələ 2-də əlavə olunacaq',
                          style: AppTypography.bodySecondary,
                          textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
