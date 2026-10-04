import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/local/game_storage.dart';
import '../../widgets/secondary_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _resetGame(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Oyunu sıfırla?'),
        content: const Text('Bütün irəliləyiş silinəcək.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Ləğv et'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sil', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final storage = const GameStorage();
    await storage.deleteSave();
    if (context.mounted) context.go(AppRouter.mainMenu);
  }

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
              const Text('Profil', style: AppTypography.headline),
              const SizedBox(height: 4),
              const Text('Oyunçu məlumatları',
                  style: AppTypography.bodySecondary),
              const SizedBox(height: 24),
              SecondaryButton(
                label: 'Oyunu sıfırla',
                onPressed: () => _resetGame(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
