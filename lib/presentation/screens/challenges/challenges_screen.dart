import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/challenge_model.dart';
import '../../providers/challenge_providers.dart';
import '../../providers/player_notifier.dart';
import '../../widgets/challenge_card.dart';
import '../../widgets/empty_state.dart';

class ChallengesScreen extends ConsumerStatefulWidget {
  const ChallengesScreen({super.key});

  @override
  ConsumerState<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends ConsumerState<ChallengesScreen> {
  @override
  Widget build(BuildContext context) {
    final available = ref.watch(challengeAvailableProvider);
    final active = ref.watch(activeChallengeProvider);
    final completed = ref.watch(completedChallengesProvider);
    final playerState = ref.watch(playerStateProvider);

    if (playerState == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Challenge-lər'),
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
              _SummaryCard(
                completed: completed.length,
                available: available.length + (active != null ? 1 : 0),
              ),
              const SizedBox(height: 20),
              if (active != null) ...[
                const _SectionHeader(title: 'Aktiv challenge'),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ChallengeCard(
                    challenge: active,
                    completed: completed.contains(active.id),
                    onAccept: null,
                  ),
                ),
              ],
              if (available.isNotEmpty) ...[
                const _SectionHeader(title: 'Mövcud challenge-lər'),
                ...available.map(
                  (c) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ChallengeCard(
                      challenge: c,
                      completed: false,
                      onAccept: () => _acceptChallenge(c),
                    ),
                  ),
                ),
              ] else if (active == null)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: EmptyState(
                    icon: Icons.task_alt,
                    title: 'Yeni challenge yoxdur',
                    description: 'Bütün mövcud challenge-lər tamamlanıb.',
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _acceptChallenge(DailyChallenge challenge) {
    final active = ref.read(activeChallengeProvider);
    if (active != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Əvvəlcə aktiv challenge-i bitir'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    ref.read(activeChallengeProvider.notifier).state = challenge;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Challenge qəbul edildi: ${challenge.title}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.completed,
    required this.available,
  });

  final int completed;
  final int available;

  @override
  Widget build(BuildContext context) {
    final total = completed + available;
    final ratio = total == 0 ? 0.0 : completed / total;

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
                  Icons.flag_outlined,
                  color: AppColors.gold,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Challenge-lər', style: AppTypography.title),
                    const SizedBox(height: 2),
                    Text(
                      '$completed tamamlanıb • $available mövcud',
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
          if (completed > 0) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.emoji_events_outlined,
                  color: AppColors.gold,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  'Qazandığın mükafatlar',
                  style: AppTypography.caption,
                ),
                const Spacer(),
                Text(
                  '+${Formatters.moneyShort(completed * 100)}',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.capital,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
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
