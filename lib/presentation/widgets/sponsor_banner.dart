import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/sponsor_model.dart';

class SponsorBanner extends StatelessWidget {
  const SponsorBanner({required this.sponsor, super.key});

  final Sponsor sponsor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surface,
            AppColors.surfaceElevated,
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'SPONSOR',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.gold,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  sponsor.name,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            sponsor.product,
            style: AppTypography.title,
          ),
          const SizedBox(height: 4),
          Text(
            sponsor.campaignText,
            style: AppTypography.bodySecondary,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.link,
                size: 14,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  sponsor.website,
                  style: AppTypography.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SponsorBannerEmpty extends StatelessWidget {
  const SponsorBannerEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.campaign_outlined,
              color: AppColors.textMuted,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sponsor sahəsi', style: AppTypography.title),
                const SizedBox(height: 2),
                Text(
                  'Gələcəkdə real şirkətlər burada görünəcək.',
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SponsorList extends StatelessWidget {
  const SponsorList({
    required this.sponsors,
    super.key,
  });

  final List<Sponsor> sponsors;

  @override
  Widget build(BuildContext context) {
    if (sponsors.isEmpty) {
      return const SponsorBannerEmpty();
    }
    return Column(
      children: sponsors
          .map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SponsorBanner(sponsor: s),
            ),
          )
          .toList(),
    );
  }
}
