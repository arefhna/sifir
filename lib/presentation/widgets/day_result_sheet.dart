import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';

class DayResultSheet extends StatelessWidget {
  const DayResultSheet({
    required this.investmentMessages,
    required this.loanPenalty,
    required this.challengeCompleted,
    required this.challengeReward,
    required this.newAchievementsCount,
    super.key,
  });

  final List<String> investmentMessages;
  final double loanPenalty;
  final bool challengeCompleted;
  final double challengeReward;
  final int newAchievementsCount;

  @override
  Widget build(BuildContext context) {
    final hasAny = investmentMessages.isNotEmpty ||
        loanPenalty > 0 ||
        challengeCompleted ||
        newAchievementsCount > 0;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Günün nəticəsi', style: AppTypography.headline),
            const SizedBox(height: 16),
            if (!hasAny)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppColors.info,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Bu gün heç bir xüsusi hadisə baş vermədi.',
                        style: AppTypography.bodySecondary,
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              if (investmentMessages.isNotEmpty) ...[
                _SectionTitle(
                  icon: Icons.trending_up,
                  title: 'İnvestisiyalar',
                  color: AppColors.accent,
                ),
                const SizedBox(height: 8),
                ...investmentMessages.map(
                  (m) => Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 6),
                    child: Text(
                      '• $m',
                      style: AppTypography.bodySecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              if (loanPenalty > 0) ...[
                _SectionTitle(
                  icon: Icons.warning_amber_outlined,
                  title: 'Kredit cəriməsi',
                  color: AppColors.danger,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    '-${Formatters.money(loanPenalty)}',
                    style: AppTypography.body.copyWith(
                      color: AppColors.danger,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              if (challengeCompleted) ...[
                _SectionTitle(
                  icon: Icons.flag,
                  title: 'Challenge tamamlandı',
                  color: AppColors.gold,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    '+${Formatters.money(challengeReward)}',
                    style: AppTypography.body.copyWith(
                      color: AppColors.capital,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              if (newAchievementsCount > 0) ...[
                _SectionTitle(
                  icon: Icons.emoji_events,
                  title: 'Yeni achievements',
                  color: AppColors.gold,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    '$newAchievementsCount yeni achievement açıldı!',
                    style: AppTypography.body.copyWith(
                      color: AppColors.gold,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text('DAVAM ET', style: AppTypography.button),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.color,
  });

  final IconData icon;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 6),
        Text(
          title,
          style: AppTypography.title.copyWith(color: color),
        ),
      ],
    );
  }
}
