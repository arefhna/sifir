import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../providers/achievement_providers.dart';
import '../../providers/challenge_providers.dart';
import '../../providers/player_notifier.dart';
import '../../widgets/achievement_tile.dart';
import '../../widgets/challenge_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/sponsor_banner.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureLoaded();
    });
  }

  Future<void> _ensureLoaded() async {
    if (_initialized) return;
    _initialized = true;
    final notifier = ref.read(playerStateProvider.notifier);
    if (notifier.currentState == null) {
      await notifier.load();
    }
  }

  Future<void> _resetGame() async {
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

    if (confirmed != true || !mounted) return;

    final notifier = ref.read(playerStateProvider.notifier);
    await notifier.reset();
    ref.read(activeChallengeProvider.notifier).state = null;

    if (mounted) context.go(AppRouter.mainMenu);
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(playerStateProvider);
    final achievements = ref.watch(achievementProgressProvider);
    final activeChallenge = ref.watch(activeChallengeProvider);

    if (playerState == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
      );
    }

    final unlockedCount = achievements.where((e) => e.value >= 1.0).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Profil', style: AppTypography.headline),
              const SizedBox(height: 4),
              Text(
                playerState.playerName,
                style: AppTypography.bodySecondary,
              ),
              const SizedBox(height: 20),
              _ProfileStats(state: playerState),
              const SizedBox(height: 20),
              if (activeChallenge != null) ...[
                const SectionHeader(title: 'Gündəlik challenge'),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ChallengeCard(
                    challenge: activeChallenge,
                    completed: playerState.completedChallenges
                        .contains(activeChallenge.id),
                    onAccept: null,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              SectionHeader(
                title: 'Achievements ($unlockedCount/${achievements.length})',
              ),
              if (achievements.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.center,
                  child: Text(
                    'Achievements yüklənir...',
                    style: AppTypography.bodySecondary,
                  ),
                )
              else
                ...achievements.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AchievementTile(
                      achievement: entry.key,
                      unlocked: entry.value >= 1.0,
                      progress: entry.value,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              const SectionHeader(title: 'Sponsor'),
              const SponsorBannerEmpty(),
              const SizedBox(height: 20),
              const SectionHeader(title: 'Oyun'),
              _MenuTile(
                icon: Icons.refresh,
                title: 'Oyunu sıfırla',
                subtitle: 'Bütün irəliləyiş silinsin',
                color: AppColors.danger,
                onTap: _resetGame,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppColors.textMuted,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Versiya', style: AppTypography.title),
                          const SizedBox(height: 2),
                          Text('SIFIR v1.0.0', style: AppTypography.caption),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileStats extends StatelessWidget {
  const _ProfileStats({required this.state});

  final dynamic state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _Row(label: 'Gün', value: '${state.day}'),
          const Divider(height: 16),
          _Row(
            label: 'Kapital',
            value: Formatters.money(state.capital),
            valueColor: AppColors.capital,
          ),
          const Divider(height: 16),
          _Row(
            label: 'Reputasiya',
            value: '${state.reputation}/100',
            valueColor: AppColors.reputation,
          ),
          const Divider(height: 16),
          _Row(
            label: 'Risk',
            value: '${state.risk}%',
            valueColor: AppColors.risk,
          ),
          const Divider(height: 16),
          _Row(
            label: 'Borc',
            value: Formatters.money(state.debt),
            valueColor: AppColors.debt,
          ),
          const Divider(height: 16),
          _Row(
            label: 'Gündəlik gəlir',
            value: Formatters.money(state.dailyIncome),
            valueColor: AppColors.success,
          ),
          const Divider(height: 16),
          _Row(
            label: 'Bizneslər',
            value: '${state.ownedBusinesses.length}',
          ),
          const Divider(height: 16),
          _Row(
            label: 'Aktiv investisiyalar',
            value: '${state.activeInvestments.length}',
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodySecondary),
        Text(
          value,
          style: AppTypography.body.copyWith(
            color: valueColor ?? AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
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
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.title),
                    const SizedBox(height: 2),
                    Text(subtitle, style: AppTypography.caption),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
