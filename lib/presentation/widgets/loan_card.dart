import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/loan_model.dart';

class LoanCard extends StatelessWidget {
  const LoanCard({
    required this.loan,
    required this.currentDay,
    super.key,
  });

  final Loan loan;
  final int currentDay;

  @override
  Widget build(BuildContext context) {
    final progress = loan.totalDue <= 0
        ? 0.0
        : (loan.paid / loan.totalDue).clamp(0.0, 1.0);
    final daysLeft = loan.dueDay - currentDay;
    final isOverdue = loan.isOverdue(currentDay);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isOverdue
              ? AppColors.danger.withOpacity(0.5)
              : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kredit',
                style: AppTypography.title,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: (isOverdue ? AppColors.danger : AppColors.info)
                      .withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isOverdue ? 'GECİKMİŞ' : '$daysLeft gün',
                  style: AppTypography.caption.copyWith(
                    color: isOverdue ? AppColors.danger : AppColors.info,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppColors.surfaceElevated,
              valueColor: AlwaysStoppedAnimation<Color>(
                progress >= 1 ? AppColors.success : AppColors.accent,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Col(
                label: 'MƏBLƏĞ',
                value: Formatters.moneyShort(loan.principal),
              ),
              _Col(
                label: 'FAİZ',
                value: '${(loan.interestRate * 100).toStringAsFixed(1)}%',
              ),
              _Col(
                label: 'QALIB',
                value: Formatters.moneyShort(loan.remaining),
                valueColor: AppColors.danger,
              ),
              _Col(
                label: 'GÜNLÜK',
                value: Formatters.moneyShort(loan.dailyPayment),
                valueColor: AppColors.warning,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Col extends StatelessWidget {
  const _Col({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.statLabel),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.caption.copyWith(
            color: valueColor ?? AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
