import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../providers/player_notifier.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Parametrlər'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Oyun', style: AppTypography.title),
              const SizedBox(height: 12),
              _SettingTile(
                icon: Icons.save_outlined,
                title: 'Manual save',
                subtitle: 'Oyunu əl ilə yadda saxla',
                onTap: () async {
                  final notifier = ref.read(playerStateProvider.notifier);
                  await notifier.save();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Oyun yadda saxlanıldı'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
              _SettingTile(
                icon: Icons.refresh,
                title: 'Oyunu sıfırla',
                subtitle: 'Bütün irəliləyiş silinsin',
                color: AppColors.danger,
                onTap: () => _confirmReset(context, ref),
              ),
              const SizedBox(height: 20),
              Text('Məlumat', style: AppTypography.title),
              const SizedBox(height: 12),
              _SettingTile(
                icon: Icons.info_outline,
                title: 'Haqqında',
                subtitle: 'SIFIR oyunu haqqında',
                onTap: () => context.push(AppRouter.about),
              ),
              _SettingTile(
                icon: Icons.code,
                title: 'Versiya',
                subtitle: 'SIFIR v1.0.0 (build 1)',
                onTap: () {},
              ),
              const SizedBox(height: 20),
              Text('Gələcək', style: AppTypography.title),
              const SizedBox(height: 12),
              _SettingTile(
                icon: Icons.cloud_outlined,
                title: 'Cloud save',
                subtitle: 'Tezliklə — onlayn yadda saxlama',
                enabled: false,
                onTap: () {},
              ),
              _SettingTile(
                icon: Icons.leaderboard_outlined,
                title: 'Leaderboard',
                subtitle: 'Tezliklə — qlobal reytinq',
                enabled: false,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Oyunu sıfırla?'),
        content: const Text(
          'Bütün irəliləyiş silinəcək. Bu geri qaytarıla bilməz.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Ləğv et'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Sil',
              style: TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final notifier = ref.read(playerStateProvider.notifier);
    await notifier.reset();
    if (context.mounted) context.go(AppRouter.mainMenu);
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.color,
    this.enabled = true,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? color;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final tileColor = color ?? AppColors.accent;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: enabled
                        ? tileColor.withOpacity(0.15)
                        : AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: enabled ? tileColor : AppColors.textMuted,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.title.copyWith(
                          color: enabled
                              ? AppColors.textPrimary
                              : AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(subtitle, style: AppTypography.caption),
                    ],
                  ),
                ),
                if (enabled)
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.textMuted,
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'SOON',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
