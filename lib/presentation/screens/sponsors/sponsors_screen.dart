import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../providers/sponsor_providers.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/sponsor_banner.dart';

class SponsorsScreen extends ConsumerWidget {
  const SponsorsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sponsorsAsync = ref.watch(allSponsorsProvider);
    final activeCount = ref.watch(activeSponsorCountProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Sponsorlar'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: sponsorsAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.accent),
          ),
          error: (e, _) => Center(
            child: Text('Xəta: $e', style: AppTypography.body),
          ),
          data: (sponsors) {
            if (sponsors.isEmpty) {
              return const EmptyState(
                icon: Icons.campaign_outlined,
                title: 'Hələ sponsor yoxdur',
                description:
                    'Tezliklə real Azərbaycan şirkətləri burada görünəcək.',
              );
            }

            final now = DateTime.now();
            final active = sponsors.where((s) => s.isActiveOn(now)).toList();
            final inactive = sponsors.where((s) => !s.isActiveOn(now)).toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SummaryCard(total: sponsors.length, active: activeCount),
                  const SizedBox(height: 20),
                  if (active.isNotEmpty) ...[
                    const _SectionHeader(title: 'Aktiv sponsorlar'),
                    SponsorList(sponsors: active),
                    const SizedBox(height: 16),
                  ],
                  if (inactive.isNotEmpty) ...[
                    const _SectionHeader(title: 'Keçmiş sponsorlar'),
                    ...inactive.map(
                      (s) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _InactiveSponsorTile(sponsor: s),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.gold.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: AppColors.gold,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Şirkətiniz oyunda sponsor olmaq istəyir? '
                            'Gələcəkdə bu imkan açılacaq.',
                            style: AppTypography.caption,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.total,
    required this.active,
  });

  final int total;
  final AsyncValue<int> active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.campaign,
              color: AppColors.gold,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sponsorlar', style: AppTypography.title),
                const SizedBox(height: 2),
                active.maybeWhen(
                  data: (count) => Text(
                    '$count aktiv • $total toplam',
                    style: AppTypography.bodySecondary,
                  ),
                  orElse: () => Text(
                    '$total toplam',
                    style: AppTypography.bodySecondary,
                  ),
                ),
              ],
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

class _InactiveSponsorTile extends StatelessWidget {
  const _InactiveSponsorTile({required this.sponsor});

  final dynamic sponsor;

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
                Text(
                  sponsor.name,
                  style: AppTypography.title.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  sponsor.product,
                  style: AppTypography.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'BİTDİ',
              style: AppTypography.caption.copyWith(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
