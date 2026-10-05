import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/business_model.dart';

class BusinessCard extends StatelessWidget {
  const BusinessCard({
    required this.business,
    required this.canPurchase,
    required this.isOwned,
    required this.owned,
    required this.onTap,
    super.key,
  });

  final Business business;
  final bool canPurchase;
  final bool isOwned;
  final OwnedBusiness? owned;
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
            border: Border.all(
              color: isOwned
                  ? AppColors.accent.withOpacity(0.5)
                  : AppColors.border,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isOwned
                          ? AppColors.accent.withOpacity(0.15)
                          : AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _iconFromName(business.icon),
                      color: isOwned ? AppColors.accent : AppColors.textSecondary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                business.name,
                                style: AppTypography.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isOwned)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.accent.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'SAHİB',
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          business.category,
                          style: AppTypography.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                business.description,
                style: AppTypography.bodySecondary,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _MiniColumn(
                    label: 'XƏRC',
                    value: Formatters.moneyShort(business.initialCost),
                    color: AppColors.danger,
                  ),
                  _MiniColumn(
                    label: 'GÜNLÜK',
                    value: '+${Formatters.moneyShort(business.dailyIncome)}',
                    color: AppColors.capital,
                  ),
                  _MiniColumn(
                    label: 'XİDMƏT',
                    value: Formatters.moneyShort(business.maintenance),
                    color: AppColors.warning,
                  ),
                  _MiniColumn(
                    label: 'REP',
                    value: '${business.reputationRequirement}+',
                    color: AppColors.reputation,
                  ),
                ],
              ),
              if (isOwned && owned != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Səviyyə: ${owned!.level}',
                        style: AppTypography.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Toplam: ${Formatters.moneyShort(owned!.accumulatedIncome)}',
                        style: AppTypography.body.copyWith(
                          color: AppColors.capital,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconFromName(String name) {
    switch (name) {
      case 'storefront':
        return Icons.storefront;
      case 'shopping_cart':
        return Icons.shopping_cart;
      case 'build':
        return Icons.build;
      case 'local_cafe':
        return Icons.local_cafe;
      case 'devices':
        return Icons.devices;
      case 'local_shipping':
        return Icons.local_shipping;
      case 'memory':
        return Icons.memory;
      case 'apartment':
        return Icons.apartment;
      default:
        return Icons.business;
    }
  }
}

class _MiniColumn extends StatelessWidget {
  const _MiniColumn({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

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
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
