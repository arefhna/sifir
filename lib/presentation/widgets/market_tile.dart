import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/product_model.dart';
import 'trend_badge.dart';

class MarketTile extends StatelessWidget {
  const MarketTile({
    required this.product,
    required this.changePercent,
    required this.onTap,
    super.key,
  });

  final Product product;
  final double changePercent;
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: AppTypography.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          product.category,
                          style: AppTypography.caption,
                        ),
                      ],
                    ),
                  ),
                  TrendBadge(changePercent: changePercent),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('QİYMƏT', style: AppTypography.statLabel),
                      const SizedBox(height: 2),
                      Text(
                        Formatters.money(product.currentPrice),
                        style: AppTypography.body.copyWith(
                          color: AppColors.capital,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('TƏLƏB', style: AppTypography.statLabel),
                      const SizedBox(height: 2),
                      Text(
                        '${product.demand}%',
                        style: AppTypography.body.copyWith(
                          color: AppColors.reputation,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('TƏKLİF', style: AppTypography.statLabel),
                      const SizedBox(height: 2),
                      Text(
                        '${product.supply}%',
                        style: AppTypography.body.copyWith(
                          color: AppColors.info,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('RİSK', style: AppTypography.statLabel),
                      const SizedBox(height: 2),
                      Text(
                        '${product.risk}%',
                        style: AppTypography.body.copyWith(
                          color: AppColors.risk,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
