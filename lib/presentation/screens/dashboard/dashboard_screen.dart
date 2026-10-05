import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/challenge_model.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/player_state_model.dart';
import '../../modals/event_modal.dart';
import '../../providers/challenge_providers.dart';
import '../../providers/event_providers.dart';
import '../../providers/player_notifier.dart';
import '../../widgets/day_advance_button.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/section_header.dart';
import '../../widgets/stat_grid.dart';
import '../../widgets/stat_bar.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  List<GameEvent> _todayEvents = [];
  bool _isAdvancing = false;
  bool _tookLoanToday = false;
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
    await _loadTodayEvents();
  }

  Future<void> _loadTodayEvents() async {
    final playerState = ref.read(playerStateProvider);
    if (playerState == null) return;

    final allEvents = await ref.read(eventsFutureProvider.future);
    final service = ref.read(eventServiceProvider);

    final ctx = EventFilterContext.fromState(playerState);
    final picked = service.pickDaily(allEvents, ctx, count: 3);

    if (!mounted) return;
    setState(() {
      _todayEvents = picked;
    });
  }

  Future<void> _onAdvanceDay() async {
    if (_isAdvancing) return;
    setState(() => _isAdvancing = true);

    try {
      final challenge = ref.read(activeChallengeProvider);
      final notifier = ref.read(playerStateProvider.notifier);
      final result = await notifier.advanceDay(
        activeChallenge: challenge,
        tookLoanToday: _tookLoanToday,
      );

      if (!mounted || result == null) return;

      _showDayResultDialog(result);

      setState(() {
        _todayEvents = result.newEvents;
        _tookLoanToday = false;
      });
    } finally {
      if (mounted) setState(() => _isAdvancing = false);
    }
  }

  void _showDayResultDialog(dynamic result) {
    final messages = <String>[];
    for (final outcome in result.investmentOutcomes) {
      messages.add('• ${outcome.message}');
    }
    if (result.loanPenalty > 0) {
      messages.add('• Kredit cəriməsi: ${Formatters.money(result.loanPenalty)}');
    }
    if (result.challengeCompleted) {
      messages.add(
        '• Gündəlik challenge tamamlandı! +${Formatters.money(result.challengeRewardCapital)}',
      );
    }
    if (messages.isEmpty) return;

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Günün nəticəsi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: messages.map((m) => Text(m)).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _openEvent(GameEvent event) async {
    final playerState = ref.read(playerStateProvider);
    if (playerState == null) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => EventModal(
        event: event,
        playerCapital: playerState.capital,
        onChoiceSelected: (choice) => _handleChoice(event, choice),
      ),
    );
  }

  Future<void> _handleChoice(GameEvent event, EventChoice choice) async {
    final notifier = ref.read(playerStateProvider.notifier);

    if (choice.cost > 0 && choice.expectedReward > 0) {
      await notifier.startInvestment(
        title: event.title,
        cost: choice.cost,
        expectedReward: choice.expectedReward,
        riskPercent: choice.riskPercent,
        durationDays: choice.duration,
        reputationDelta: choice.reputationDelta,
      );
    }

    if (!mounted) return;
    setState(() {
      _todayEvents = _todayEvents.where((e) => e.id != event.id).toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(choice.description),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(playerStateProvider);

    if (playerState == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _Header(state: playerState),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatGrid(state: playerState),
                    const SizedBox(height: 20),
                    _MetersSection(state: playerState),
                    const SizedBox(height: 8),
                    SectionHeader(
                      title: 'Bugünkü hadisələr (${_todayEvents.length})',
                    ),
                    if (_todayEvents.isEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: const EmptyState(
                          icon: Icons.event_available,
                          title: 'Bugün üçün hadisə yoxdur',
                          description:
                              'Növbəti günə keç və yeni fürsətlər gör.',
                        ),
                      )
                    else
                      ..._todayEvents.map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _EventCard(
                            event: e,
                            onTap: () => _openEvent(e),
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: DayAdvanceButton(
                onPressed: _onAdvanceDay,
                isLoading: _isAdvancing,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.state});

  final PlayerState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('SIFIR', style: AppTypography.displayLarge.copyWith(
                fontSize: 24,
                letterSpacing: 3,
              )),
              const SizedBox(height: 2),
              Text(
                '${state.playerName} • Gün ${state.day}',
                style: AppTypography.bodySecondary,
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('KAPİTAL', style: AppTypography.statLabel),
                Text(
                  Formatters.moneyShort(state.capital),
                  style: AppTypography.body.copyWith(
                    color: AppColors.capital,
                    fontWeight: FontWeight.w700,
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

class _MetersSection extends StatelessWidget {
  const _MetersSection({required this.state});

  final PlayerState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          StatBar(
            label: 'Reputasiya',
            value: state.reputation.toDouble(),
            maxValue: 100,
            color: AppColors.reputation,
            suffix: '/100',
          ),
          const SizedBox(height: 12),
          StatBar(
            label: 'Risk',
            value: state.risk.toDouble(),
            maxValue: 100,
            color: AppColors.risk,
            suffix: '%',
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event, required this.onTap});

  final GameEvent event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    late Color color;
    late IconData icon;
    switch (event.type) {
      case EventType.opportunity:
        color = AppColors.success;
        icon = Icons.trending_up;
        break;
      case EventType.threat:
        color = AppColors.danger;
        icon = Icons.warning_amber_outlined;
        break;
      case EventType.neutral:
        color = AppColors.info;
        icon = Icons.info_outline;
        break;
    }

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
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: AppTypography.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.description,
                      style: AppTypography.caption,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
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
