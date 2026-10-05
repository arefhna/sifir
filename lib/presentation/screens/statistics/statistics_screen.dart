import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../providers/game_providers.dart';
import '../../providers/player_notifier.dart';
import '../../widgets/empty_state.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

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

    final successfulInvestments = playerState.activeInvestments
        .where((i) => i.status.name == 'success')
        .length;
    final failedInvestments = playerState.activeInvestments
        .where((i) => i.status.name == 'failed')
        .length;
    final totalInvestment = successfulInvestments + failedInvestments;
    final successRate = totalInvestment == 0
        ? 0
        : (successfulInvestments / totalInvestment * 100).round();

    final activeLoans = playerState.activeLoans.length;
    final totalBusinesses = playerState.ownedBusinesses.length;
    final totalRelationships = playerState.relationships.length;
    final avgTrust = playerState.relationships.isEmpty
        ? 0
        : (playerState.relationships.values
                    .fold<int>(0, (sum, r) => sum + r.trust) /
                playerState.relationships.length)
            .round();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Statistika'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: playerState.day == 0
            ? const EmptyState(
                icon: Icons.bar_chart,
                title: 'Statistika yoxdur',
                description: 'Bir az oyna, sonra burada statistikalar görünəcək.',
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _BigStatCard(
                      label: 'Cari kapital',
                      value: Formatters.money(playerState.capital),
                      icon: Icons.account_balance_wallet,
                      color: AppColors.capital,
                    ),
                    const SizedBox(height: 12),
                    _GridStats(state: playerState),
                    const SizedBox(height: 20),
                    const _SectionHeader(title: 'İnvestisiyalar'),
                    _StatRow(
                      label: 'Uğurlu',
                      value: '$successfulInvestments',
                      valueColor: AppColors.success,
                    ),
                    _StatRow(
                      label: 'Uğursuz',
                      value: '$failedInvestments',
                      valueColor: AppColors.danger,
                    ),
                    _StatRow(
                      label: 'Aktiv',
                      value: '${playerState.activeInvestments.where((i) => i.status.name == 'active').length}',
                      valueColor: AppColors.info,
                    ),
                    _StatRow(
                      label: 'Uğur nisbəti',
                      value: '$successRate%',
                      valueColor: AppColors.gold,
                    ),
                    const SizedBox(height: 20),
                    const _SectionHeader(title: 'Bizneslər'),
                    _StatRow(
                      label: 'Sahib olduğun',
                      value: '$totalBusinesses',
                      valueColor: AppColors.accent,
                    ),
                    _StatRow(
                      label: 'Gündəlik gəlir',
                      value: Formatters.money(playerState.dailyIncome),
                      valueColor: AppColors.capital,
                    ),
                    const SizedBox(height: 20),
                    const _SectionHeader(title: 'Əlaqələr'),
                    _StatRow(
                      label: 'NPC sayı',
                      value: '$totalRelationships',
                      valueColor: AppColors.reputation,
                    ),
                    _StatRow(
                      label: 'Orta etibar',
                      value: '$avgTrust/100',
                      valueColor: AppColors.info,
                    ),
                    const SizedBox(height: 20),
                    const _SectionHeader(title: 'Maliyyə'),
                    _StatRow(
                      label: 'Borc',
                      value: Formatters.money(playerState.debt),
                      valueColor: AppColors.debt,
                    ),
                    _StatRow(
                      label: 'Aktiv kreditlər',
                      value: '$activeLoans',
                      valueColor: AppColors.warning,
                    ),
                    _StatRow(
                      label: 'Reputasiya',
                      value: '${playerState.reputation}/100',
                      valueColor: AppColors.reputation,
                    ),
                    _StatRow(
                      label: 'Risk',
                      value: '${playerState.risk}%',
                      valueColor: AppColors.risk,
                    ),
                    const SizedBox(height: 20),
                    const _SectionHeader(title: 'Oyun'),
                    _StatRow(
                      label: 'Oynanılan gün',
                      value: '${playerState.day}',
                      valueColor: AppColors.textPrimary,
                    ),
                    _StatRow(
                      label: 'Achievements',
                      value: '${playerState.achievements.length}',
                      valueColor: AppColors.gold,
                    ),
                    _StatRow(
                      label: 'Challenge-lər',
                      value: '${playerState.completedChallenges.length}',
                      valueColor: AppColors.gold,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _BigStatCard extends StatelessWidget {
  const _BigStatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

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
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTypography.bodySecondary),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTypography.statValue.copyWith(color: color),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GridStats extends StatelessWidget {
  const _GridStats({required this.state});

  final dynamic state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MiniCard(
            label: 'GÜN',
            value: '${state.day}',
            color: AppColors.info,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MiniCard(
            label: 'REP',
            value: '${state.reputation}',
            color: AppColors.reputation,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MiniCard(
            label: 'RİSK',
            value: '${state.risk}%',
            color: AppColors.risk,
          ),
        ),
      ],
    );
  }
}

class _MiniCard extends StatelessWidget {
  const _MiniCard({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.statLabel),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.statValue.copyWith(color: color, fontSize: 18),
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

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySecondary),
          Text(
            value,
            style: AppTypography.body.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
