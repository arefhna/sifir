import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../providers/achievement_providers.dart';
import '../../widgets/achievement_tile.dart';
import '../../widgets/empty_state.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressList = ref.watch(achievementProgressProvider);

    final unlocked = progressList.where((e) => e.value >= 1.0).toList();
    final locked = progressList.where((e) => e.value < 1.0).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Achievements'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: progressList.isEmpty
            ? const EmptyState(
                icon: Icons.emoji_events_outlined,
                title: 'Achievements yüklənir',
                description: 'Zəhmət olmasa bir az gözlə.',
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SummaryCard(
                      unlocked: unlocked.length,
                      total: progressList.length,
                    ),
                    const SizedBox(height: 20),
                    if (unlocked.isNotEmpty) ...[
                      const _SectionHeader(title: 'Açılmış'),
                      ...unlocked.map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: AchievementTile(
                            achievement: e.key,
                            unlocked: true,
                            progress: e.value,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (locked.isNotEmpty) ...[
                      const _SectionHeader(title: 'Açılmamış'),
                      ...locked.map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: AchievementTile(
                            achievement: e.key,
                            unlocked: false,
                            progress: e.value,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.unlocked,
    required this.total,
  });

  final int unlocked;
  final int total;

  @override
  Widget build(BuildContext context) {
    final ratio = total == 0 ? 0.0 : unlocked / total;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: AppColors.gold,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Achievements', style: AppTypography.title),
                    const SizedBox(height: 2),
                    Text(
                      '$unlocked / $total açılıb',
                      style: AppTypography.bodySecondary,
                    ),
                  ],
                ),
              ),
              Text(
                '${(ratio * 100).toStringAsFixed(0)}%',
                style: AppTypography.statValue.copyWith(
                  color: AppColors.gold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 8,
              backgroundColor: AppColors.surfaceElevated,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title, style: AppTypography.title),
    );
  }
}
