import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../providers/player_notifier.dart';

class EndgameScreen extends ConsumerWidget {
  const EndgameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerStateProvider);

    if (playerState == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
      );
    }

    final endings = _computeEndings(playerState);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Oyun sonu'),
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
              _BigCard(state: playerState),
              const SizedBox(height: 20),
              Text(
                'Sənin strategiyaların',
                style: AppTypography.headline,
              ),
              const SizedBox(height: 4),
              Text(
                'Fərqli yollarla imperiya qura bilərsən.',
                style: AppTypography.bodySecondary,
              ),
              const SizedBox(height: 16),
              ...endings.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _EndingTile(ending: e),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => context.go(AppRouter.dashboard),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text('Oyuna qayıt', style: AppTypography.button),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<_Ending> _computeEndings(dynamic state) {
    final endings = <_Ending>[];

    final totalInvestments = state.activeInvestments.length;
    final successfulInvestments = state.activeInvestments
        .where((i) => i.status.name == 'success')
        .length;
    final successRate = totalInvestments == 0
        ? 0
        : (successfulInvestments / totalInvestments * 100).round();

    if (state.capital >= 1000000) {
      endings.add(_Ending(
        title: 'Milyonçu',
        description: 'Kapitalın 1 milyon ₼-ı keçdi.',
        icon: Icons.emoji_events,
        color: AppColors.gold,
        achieved: true,
      ));
    } else {
      endings.add(_Ending(
        title: 'Milyonçu',
        description: '1 milyon ₼ kapitala çat.',
        icon: Icons.emoji_events,
        color: AppColors.gold,
        achieved: false,
        progress: state.capital / 1000000,
      ));
    }

    if (state.ownedBusinesses.length >= 5) {
      endings.add(_Ending(
        title: 'Biznes imperiyası',
        description: '5 və ya daha çox biznesə sahib ol.',
        icon: Icons.business_center,
        color: AppColors.accent,
        achieved: true,
      ));
    } else {
      endings.add(_Ending(
        title: 'Biznes imperiyası',
        description: '5 və ya daha çox biznesə sahib ol.',
        icon: Icons.business_center,
        color: AppColors.accent,
        achieved: false,
        progress: state.ownedBusinesses.length / 5,
      ));
    }

    if (successRate >= 70 && totalInvestments >= 5) {
      endings.add(_Ending(
        title: 'Ağıllı investor',
        description: '5+ investisiyada 70%+ uğur nisbəti.',
        icon: Icons.trending_up,
        color: AppColors.success,
        achieved: true,
      ));
    } else {
      endings.add(_Ending(
        title: 'Ağıllı investor',
        description: '5+ investisiyada 70%+ uğur nisbəti.',
        icon: Icons.trending_up,
        color: AppColors.success,
        achieved: false,
        progress: (successRate / 70).clamp(0.0, 1.0),
      ));
    }

    if (state.reputation >= 81) {
      endings.add(_Ending(
        title: 'Güvənilən biznes sahibi',
        description: 'Reputasiyanı 81-ə çatdır.',
        icon: Icons.verified,
        color: AppColors.reputation,
        achieved: true,
      ));
    } else {
      endings.add(_Ending(
        title: 'Güvənilən biznes sahibi',
        description: 'Reputasiyanı 81-ə çatdır.',
        icon: Icons.verified,
        color: AppColors.reputation,
        achieved: false,
        progress: state.reputation / 81,
      ));
    }

    if (state.debt <= 0 && state.day >= 30) {
      endings.add(_Ending(
        title: 'Borcsuz 30 gün',
        description: '30 gün borcsuz qal.',
        icon: Icons.shield,
        color: AppColors.info,
        achieved: true,
      ));
    } else {
      endings.add(_Ending(
        title: 'Borcsuz 30 gün',
        description: '30 gün borcsuz qal.',
        icon: Icons.shield,
        color: AppColors.info,
        achieved: false,
        progress: (state.day / 30).clamp(0.0, 1.0),
      ));
    }

    if (state.relationships.values
            .where((r) => r.trust >= 80)
            .length >=
        3) {
      endings.add(_Ending(
        title: 'Geniş şəbəkə',
        description: '3 NPC ilə 80+ etibar qur.',
        icon: Icons.people,
        color: AppColors.gold,
        achieved: true,
      ));
    } else {
      endings.add(_Ending(
        title: 'Geniş şəbəkə',
        description: '3 NPC ilə 80+ etibar qur.',
        icon: Icons.people,
        color: AppColors.gold,
        achieved: false,
        progress: state.relationships.values
                .where((r) => r.trust >= 80)
                .length /
            3,
      ));
    }

    return endings;
  }
}

class _BigCard extends StatelessWidget {
  const _BigCard({required this.state});

  final dynamic state;

  @override
  Widget build(BuildContext context) {
    final progress = (state.capital / 1000000).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surface,
            AppColors.gold.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: AppColors.gold,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'İrəliləyiş',
                      style: AppTypography.bodySecondary,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      Formatters.money(state.capital),
                      style: AppTypography.statValue.copyWith(
                        color: AppColors.gold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: AppColors.surfaceElevated,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).toStringAsFixed(1)}% milyon yolu',
            style: AppTypography.caption,
          ),
        ],
      ),
    );
  }
}

class _Ending {
  const _Ending({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.achieved,
    this.progress = 1.0,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool achieved;
  final double progress;
}

class _EndingTile extends StatelessWidget {
  const _EndingTile({required this.ending});

  final _Ending ending;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: ending.achieved
              ? ending.color.withOpacity(0.4)
              : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: ending.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              ending.icon,
              color: ending.achieved ? ending.color : AppColors.textMuted,
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
                        ending.title,
                        style: AppTypography.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (ending.achieved)
                      Icon(
                        Icons.check_circle,
                        color: ending.color,
                        size: 18,
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  ending.description,
                  style: AppTypography.caption,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (!ending.achieved) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: ending.progress.clamp(0.0, 1.0),
                      minHeight: 4,
                      backgroundColor: AppColors.surfaceElevated,
                      valueColor: AlwaysStoppedAnimation<Color>(ending.color),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
