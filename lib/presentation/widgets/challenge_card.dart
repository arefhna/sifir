import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/challenge_model.dart';

class ChallengeCard extends StatelessWidget {
  const ChallengeCard({
    required this.challenge,
    required this.completed,
    required this.onAccept,
    super.key,
  });

  final DailyChallenge challenge;
  final bool completed;
  final VoidCallback? onAccept;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: completed
              ? AppColors.success.withOpacity(0.4)
              : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: (completed ? AppColors.success : AppColors.gold)
                      .withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  completed ? 'TAMAMLANDI' : 'GÜNDƏLİK',
                  style: AppTypography.caption.copyWith(
                    color: completed ? AppColors.success : AppColors.gold,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(challenge.title, style: AppTypography.title),
          const SizedBox(height: 4),
          Text(challenge.description, style: AppTypography.bodySecondary),
          const SizedBox(height: 10),
          Row(
            children: [
              if (challenge.rewardCapital > 0) ...[
                _Reward(
                  icon: Icons.account_balance_wallet_outlined,
                  label: Formatters.moneyShort(challenge.rewardCapital),
                  color: AppColors.capital,
                ),
                const SizedBox(width: 12),
              ],
              if (challenge.rewardReputation > 0)
                _Reward(
                  icon: Icons.verified_outlined,
                  label: '+${challenge.rewardReputation} rep',
                  color: AppColors.reputation,
                ),
            ],
          ),
          if (!completed && onAccept != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: onAccept,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: AppColors.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'QƏBUL ET',
                  style: AppTypography.button.copyWith(
                    color: AppColors.background,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Reward extends StatelessWidget {
  const _Reward({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
