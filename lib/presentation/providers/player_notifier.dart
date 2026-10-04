import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/business_model.dart';
import '../../data/models/challenge_model.dart';
import '../../data/models/player_state_model.dart';
import '../../data/models/product_model.dart';
import '../../domain/services/game_engine.dart';
import 'game_providers.dart';

class PlayerStateNotifier extends StateNotifier<PlayerState?> {
  PlayerStateNotifier(this._ref) : super(null);

  final Ref _ref;
  GameEngine? _engine;
  PlayerState? _state;

  PlayerState? get currentState => _state;

  Future<PlayerState?> load() async {
    final loaded = await _ref.read(saveServiceProvider).load();
    if (loaded == null) {
      return null;
    }
    _ensureEngine();
    _state = loaded;
    state = loaded;
    return loaded;
  }

  Future<PlayerState> createNew(String playerName) async {
    var initial = PlayerState.initial(playerName);

    final products = await _ref.read(productsFutureProvider.future);
    final events = await _ref.read(eventsFutureProvider.future);
    final businesses = await _ref.read(businessesFutureProvider.future);
    final npcs = await _ref.read(npcsFutureProvider.future);
    final conditions = await _ref.read(marketConditionsFutureProvider.future);
    final achievements = await _ref.read(achievementsFutureProvider.future);

    _engine = GameEngine(
      marketService: _ref.read(marketServiceProvider),
      riskService: _ref.read(riskServiceProvider),
      businessService: _ref.read(businessServiceProvider),
      loanService: _ref.read(loanServiceProvider),
      relationshipService: _ref.read(relationshipServiceProvider),
      achievementService: _ref.read(achievementServiceProvider),
      challengeService: _ref.read(challengeServiceProvider),
      eventService: _ref.read(eventServiceProvider),
      reputationService: _ref.read(reputationServiceProvider),
      random: _ref.read(randomProvider),
      products: products,
      events: events,
      businesses: businesses,
      npcs: npcs,
      conditions: conditions,
      achievementCatalog: achievements,
    );

    initial = _engine!.bootstrapRelationships(initial);
    await _ref.read(saveServiceProvider).save(initial);
    _state = initial;
    state = initial;
    return initial;
  }

  void _ensureEngine() {
    if (_engine != null) return;
    _engine = GameEngine(
      marketService: _ref.read(marketServiceProvider),
      riskService: _ref.read(riskServiceProvider),
      businessService: _ref.read(businessServiceProvider),
      loanService: _ref.read(loanServiceProvider),
      relationshipService: _ref.read(relationshipServiceProvider),
      achievementService: _ref.read(achievementServiceProvider),
      challengeService: _ref.read(challengeServiceProvider),
      eventService: _ref.read(eventServiceProvider),
      reputationService: _ref.read(reputationServiceProvider),
      random: _ref.read(randomProvider),
      products: const [],
      events: const [],
      businesses: const [],
      npcs: const [],
      conditions: const [],
      achievementCatalog: const [],
    );
  }

  Future<void> save() async {
    if (_state == null) return;
    await _ref.read(saveServiceProvider).save(_state!);
  }

  Future<void> reset() async {
    await _ref.read(saveServiceProvider).delete();
    _state = null;
    state = null;
  }

  List<Product> get products => _engine?.products ?? const [];

  Future<void> startInvestment({
    required String title,
    required double cost,
    required double expectedReward,
    required int riskPercent,
    required int durationDays,
    required int reputationDelta,
  }) async {
    if (_state == null || _engine == null) return;
    final updated = _engine!.startInvestment(
      state: _state!,
      title: title,
      cost: cost,
      expectedReward: expectedReward,
      riskPercent: riskPercent,
      durationDays: durationDays,
      reputationDelta: reputationDelta,
    );
    _state = updated;
    state = updated;
    await save();
  }

  Future<void> takeLoan(double principal) async {
    if (_state == null || _engine == null) return;
    final updated = _engine!.takeLoan(state: _state!, principal: principal);
    _state = updated;
    state = updated;
    await save();
  }

  Future<void> purchaseBusiness(Business business) async {
    if (_state == null || _engine == null) return;
    final updated =
        _engine!.purchaseBusiness(state: _state!, business: business);
    _state = updated;
    state = updated;
    await save();
  }

  Future<void> upgradeBusiness(Business business, OwnedBusiness owned) async {
    if (_state == null || _engine == null) return;
    final updated = _engine!.upgradeBusiness(
      state: _state!,
      business: business,
      owned: owned,
    );
    _state = updated;
    state = updated;
    await save();
  }

  Future<void> interactWithNpc({
    required String npcId,
    required int trustDelta,
    required int relationshipDelta,
  }) async {
    if (_state == null || _engine == null) return;
    final updated = _engine!.interactWithNpc(
      state: _state!,
      npcId: npcId,
      trustDelta: trustDelta,
      relationshipDelta: relationshipDelta,
    );
    _state = updated;
    state = updated;
    await save();
  }

  Future<DayAdvanceResult?> advanceDay({
    DailyChallenge? activeChallenge,
    bool tookLoanToday = false,
  }) async {
    if (_state == null || _engine == null) return null;

    final businesses = await _ref.read(businessesFutureProvider.future);
    final achievements = await _ref.read(achievementsFutureProvider.future);

    final stateAtStart = _state!;

    final result = _engine!.advanceDay(
      state: _state!,
      stateAtDayStart: stateAtStart,
      activeChallenge: activeChallenge,
      tookLoanToday: tookLoanToday,
      businessCatalog: businesses,
      achievements: achievements,
    );

    _state = result.newState;
    state = result.newState;
    await save();

    return result;
  }
}

final playerStateProvider =
    StateNotifierProvider<PlayerStateNotifier, PlayerState?>((ref) {
  return PlayerStateNotifier(ref);
});
