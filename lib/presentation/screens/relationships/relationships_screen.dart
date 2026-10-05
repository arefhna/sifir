import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/npc_model.dart';
import '../../modals/loan_modal.dart';
import '../../providers/business_providers.dart';
import '../../providers/game_providers.dart';
import '../../providers/npc_providers.dart';
import '../../providers/player_notifier.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loan_card.dart';
import '../../widgets/npc_card.dart';
import '../../widgets/section_header.dart';

class RelationshipsScreen extends ConsumerStatefulWidget {
  const RelationshipsScreen({super.key});

  @override
  ConsumerState<RelationshipsScreen> createState() =>
      _RelationshipsScreenState();
}

class _RelationshipsScreenState extends ConsumerState<RelationshipsScreen> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureLoaded();
    });
  }

  Future<void> _ensureLoaded() async {
    if (_initialized) return;
    _initialized = true;
    final notifier = ref.read(playerStateProvider.notifier);
    if (notifier.currentState == null) {
      await notifier.load();
    }
  }

  Future<void> _openNpcInteraction(Npc npc, RelationshipState rel) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _NpcInteractionSheet(npc: npc, rel: rel),
    );

    if (action == null || !mounted) return;

    final notifier = ref.read(playerStateProvider.notifier);

    if (action == 'talk') {
      await notifier.interactWithNpc(
        npcId: npc.id,
        trustDelta: 2,
        relationshipDelta: 1,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${npc.name} ilə söhbət etdin')),
      );
    } else if (action == 'gift') {
      final playerState = ref.read(playerStateProvider);
      if (playerState == null || playerState.capital < 100) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kifayət qədər kapital yoxdur')),
        );
        return;
      }
      await notifier.interactWithNpc(
        npcId: npc.id,
        trustDelta: 5,
        relationshipDelta: 4,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${npc.name} hədiyyə aldı')),
      );
    }
  }

  Future<void> _openLoan() async {
    final playerState = ref.read(playerStateProvider);
    if (playerState == null) return;

    final amount = await showModalBottomSheet<double>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => LoanModal(
        loanService: ref.read(loanServiceProvider),
        playerCapital: playerState.capital,
        playerDailyIncome: playerState.dailyIncome,
        playerReputation: playerState.reputation,
        onConfirm: (a) => Navigator.of(ctx).pop(a),
      ),
    );

    if (amount == null || !mounted) return;

    final notifier = ref.read(playerStateProvider.notifier);
    await notifier.takeLoan(amount);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kredit alındı: ${amount.toStringAsFixed(0)} ₼'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(playerStateProvider);
    final npcList = ref.watch(npcWithRelationshipProvider);
    final dailyIncome = ref.watch(dailyBusinessIncomeProvider);

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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Əlaqələr', style: AppTypography.headline),
              const SizedBox(height: 4),
              Text(
                '${npcList.length} əlaqə • Kapital: ${playerState.capital.toStringAsFixed(0)} ₼',
                style: AppTypography.bodySecondary,
              ),
              const SizedBox(height: 20),
              if (playerState.activeLoans.isNotEmpty) ...[
                const SectionHeader(title: 'Aktiv kreditlər'),
                ...playerState.activeLoans.map(
                  (loan) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: LoanCard(
                      loan: loan,
                      currentDay: playerState.day,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              SectionHeader(
                title: 'Kredit',
                action: playerState.activeLoans.length >= 3
                    ? null
                    : 'Kredit götür',
                onActionTap: playerState.activeLoans.length >= 3
                    ? null
                    : _openLoan,
              ),
              if (playerState.activeLoans.isEmpty &&
                  playerState.debt <= 0)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: AppColors.success,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Borcsuzsan. Ehtiyac olsa kredit götürə bilərsən.',
                          style: AppTypography.bodySecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              SectionHeader(title: 'Biznes əlaqələri (${npcList.length})'),
              if (npcList.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: EmptyState(
                    icon: Icons.people_outline,
                    title: 'Hələ əlaqə yoxdur',
                  ),
                )
              else
                ...npcList.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: NpcCard(
                      npc: entry.key,
                      relationship: entry.value,
                      onTap: () => _openNpcInteraction(entry.key, entry.value),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NpcInteractionSheet extends StatelessWidget {
  const _NpcInteractionSheet({required this.npc, required this.rel});

  final Npc npc;
  final RelationshipState rel;

  @override
  Widget build(BuildContext context) {
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
            Text(npc.name, style: AppTypography.headline),
            const SizedBox(height: 4),
            Text(
              '${npc.role} • ${npc.specialty}',
              style: AppTypography.bodySecondary,
            ),
            const SizedBox(height: 12),
            Text(npc.description, style: AppTypography.bodySecondary),
            const SizedBox(height: 20),
            _ActionTile(
              icon: Icons.chat_bubble_outline,
              title: 'Söhbət et',
              subtitle: '+2 etibar, +1 münasibət',
              onTap: () => Navigator.of(context).pop('talk'),
            ),
            const SizedBox(height: 8),
            _ActionTile(
              icon: Icons.card_giftcard,
              title: 'Hədiyyə et',
              subtitle: '+5 etibar, +4 münasibət • 100 ₼',
              onTap: () => Navigator.of(context).pop('gift'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceElevated,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(icon, color: AppColors.accent, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.title),
                    const SizedBox(height: 2),
                    Text(subtitle, style: AppTypography.caption),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
