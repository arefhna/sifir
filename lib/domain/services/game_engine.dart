import 'dart:math';

import '../../data/models/business_model.dart';
import '../../data/models/challenge_model.dart';
import '../../data/models/event_model.dart';
import '../../data/models/investment_model.dart';
import '../../data/models/loan_model.dart';
import '../../data/models/market_condition_model.dart';
import '../../data/models/npc_model.dart';
import '../../data/models/player_state_model.dart';
import '../../data/models/product_model.dart';
import 'achievement_service.dart';
import 'business_service.dart';
import 'challenge_service.dart';
import 'event_service.dart';
import 'loan_service.dart';
import 'market_service.dart';
import 'relationship_service.dart';
import 'reputation_service.dart';
import 'risk_service.dart';

class InvestmentOutcome {
  const InvestmentOutcome({
    required this.title,
    required this.success,
    required this.reward,
    required this.message,
  });

  final String title;
  final bool success;
  final double reward;
  final String message;
}

class DayAdvanceResult {
  const DayAdvanceResult({
    required this.newState,
    required this.newEvents,
    required this.investmentOutcomes,
    required this.loanPenalty,
    required this.unlockedAchievements,
    required this.challengeCompleted,
    required this.challengeRewardCapital,
    required this.challengeRewardReputation,
  });

  final PlayerState newState;
  final List<GameEvent> newEvents;
  final List<InvestmentOutcome> investmentOutcomes;
  final double loanPenalty;
  final List<String> unlockedAchievements;
  final bool challengeCompleted;
  final double challengeRewardCapital;
  final int challengeRewardReputation;
}

class GameEngine {
  GameEngine({
    required this.marketService,
    required this.riskService,
    required this.businessService,
    required this.loanService,
    required this.relationshipService,
    required this.achievementService,
    required this.challengeService,
    required this.eventService,
    required this.reputationService,
    required this.random,
    required this.products,
    required this.events,
    required this.businesses,
    required this.npcs,
    required this.conditions,
    required this.achievementCatalog,
  });

  final MarketService marketService;
  final RiskService riskService;
  final BusinessService businessService;
  final LoanService loanService;
  final RelationshipService relationshipService;
  final AchievementService achievementService;
  final ChallengeService challengeService;
  final EventService eventService;
  final ReputationService reputationService;
  final Random random;

  List<Product> products;
  final List<GameEvent> events;
  final List<Business> businesses;
  final List<Npc> npcs;
  final List<MarketCondition> conditions;
  final List<dynamic> achievementCatalog;

  List<MarketCondition> _activeConditions = [];
  List<MarketCondition> get activeConditions => List.unmodifiable(_activeConditions);

  PlayerState bootstrapRelationships(PlayerState state) {
    final map = relationshipService.initialize(npcs, state.day);
    return state.copyWith(relationships: map);
  }

  PlayerState startInvestment({
    required PlayerState state,
    required String title,
    required double cost,
    required double expectedReward,
    required int riskPercent,
    required int durationDays,
    required int reputationDelta,
  }) {
    if (cost > state.capital) return state;

    final effectiveRisk = riskService.effectiveRiskPercent(
      baseRisk: riskPercent,
      playerRisk: state.risk,
      reputation: state.reputation,
      debt: state.debt,
    );

    final investment = Investment(
      id: 'inv_${DateTime.now().microsecondsSinceEpoch}_${random.nextInt(9999)}',
      title: title,
      cost: cost,
      expectedReward: expectedReward,
      riskPercent: effectiveRisk,
      startDay: state.day,
      duration: durationDays,
      endDay: state.day + durationDays,
      status: InvestmentStatus.active,
      actualReward: 0,
    );

    return state.copyWith(
      capital: double.parse((state.capital - cost).toStringAsFixed(2)),
      reputation:
          reputationService.applyDelta(state.reputation, reputationDelta),
      activeInvestments: [...state.activeInvestments, investment],
    );
  }

  PlayerState takeLoan({
    required PlayerState state,
    required double principal,
  }) {
    if (principal <= 0) return state;
    final offer = loanService.generateOffer(
      principal: principal,
      reputation: state.reputation,
    );
    final loan = loanService.createLoan(
      offer: offer,
      currentDay: state.day,
    );
    return state.copyWith(
      capital: double.parse((state.capital + principal).toStringAsFixed(2)),
      debt: double.parse((state.debt + offer.totalDue).toStringAsFixed(2)),
      activeLoans: [...state.activeLoans, loan],
      risk: riskService.applyDelta(state.risk, 5),
    );
  }

  PlayerState purchaseBusiness({
    required PlayerState state,
    required Business business,
  }) {
    if (!businessService.canPurchase(
      business: business,
      capital: state.capital,
      reputation: state.reputation,
      day: state.day,
      owned: state.ownedBusinesses,
    )) {
      return state;
    }
    final owned = businessService.purchase(
      business: business,
      currentDay: state.day,
    );
    return state.copyWith(
      capital:
          double.parse((state.capital - business.initialCost).toStringAsFixed(2)),
      ownedBusinesses: [...state.ownedBusinesses, owned],
      reputation: reputationService.applyDelta(state.reputation, 3),
    );
  }

  PlayerState upgradeBusiness({
    required PlayerState state,
    required Business business,
    required OwnedBusiness owned,
  }) {
    if (!businessService.canUpgrade(
      business: business,
      owned: owned,
      capital: state.capital,
    )) {
      return state;
    }
    final cost = businessService.upgradeCost(
      business: business,
      owned: owned,
    );
    final updated = state.ownedBusinesses.map((o) {
      if (o.businessId == owned.businessId) {
        return businessService.upgrade(o);
      }
      return o;
    }).toList();

    return state.copyWith(
      capital: double.parse((state.capital - cost).toStringAsFixed(2)),
      ownedBusinesses: updated,
      reputation: reputationService.applyDelta(state.reputation, 2),
    );
  }

  PlayerState interactWithNpc({
    required PlayerState state,
    required String npcId,
    required int trustDelta,
    required int relationshipDelta,
  }) {
    final current = state.relationships[npcId];
    if (current == null) return state;

    final updated = relationshipService.interact(
      state: current,
      trustDelta: trustDelta,
      relationshipDelta: relationshipDelta,
      currentDay: state.day,
    );

    final map = Map<String, RelationshipState>.from(state.relationships);
    map[npcId] = updated;

    return state.copyWith(relationships: map);
  }

  DayAdvanceResult advanceDay({
    required PlayerState state,
    required PlayerState stateAtDayStart,
    required DailyChallenge? activeChallenge,
    required bool tookLoanToday,
    required List<Business> businessCatalog,
    required List<dynamic> achievements,
  }) {
    final outcomes = <InvestmentOutcome>[];
    final remainingInvestments = <Investment>[];
    final completedInvestments = <Investment>[];

    double capital = state.capital;
    int reputation = state.reputation;
    int risk = state.risk;
    int successfulToday = 0;
    final nextDay = state.day + 1;

    for (final inv in state.activeInvestments) {
      if (!inv.isMatured(nextDay)) {
        remainingInvestments.add(inv);
        continue;
      }

      final result = riskService.resolve(
        effectiveRiskPercent: inv.riskPercent,
        expectedReward: inv.expectedReward,
        successMessage: '${inv.title} uğurlu oldu.',
        failMessage: '${inv.title} uğursuz oldu.',
      );

      if (result.success) {
        capital += result.actualReward;
        reputation = reputationService.applyDelta(reputation, 2);
        successfulToday++;
      } else {
        reputation = reputationService.applyDelta(reputation, -1);
        risk = riskService.applyDelta(risk, 2);
      }

      outcomes.add(
        InvestmentOutcome(
          title: inv.title,
          success: result.success,
          reward: result.actualReward,
          message: result.message,
        ),
      );

      completedInvestments.add(
        inv.copyWith(
          status: result.success
              ? InvestmentStatus.success
              : InvestmentStatus.failed,
          actualReward: result.actualReward,
        ),
      );
    }

    final allInvestments = [...remainingInvestments, ...completedInvestments];

    final businessIncome = businessService.totalDailyIncome(
      catalog: businessCatalog,
      owned: state.ownedBusinesses,
    );
    capital += businessIncome;

    final updatedBusinesses = state.ownedBusinesses.map((o) {
      final match = businessCatalog.where((b) => b.id == o.businessId).toList();
      if (match.isEmpty) return o;
      final net = businessService.dailyNetIncome(
        business: match.first,
        owned: o,
      );
      return businessService.applyDailyGrowth(
        business: match.first,
        owned: o,
        netIncome: net,
      );
    }).toList();

    double loanPayment = 0;
    final updatedLoans = <Loan>[];
    double newDebt = 0;

    for (final loan in state.activeLoans) {
      final updated = loanService.applyDailyPayment(loan);
      if (loanService.isFullyPaid(updated)) continue;
      loanPayment += updated.dailyPayment;
      newDebt += updated.remaining;
      updatedLoans.add(updated);
    }

    capital -= loanPayment;

    double penalty = 0;
    for (final loan in updatedLoans) {
      penalty += loanService.overduePenalty(loan, nextDay);
    }
    if (penalty > 0) {
      capital -= penalty;
      reputation = reputationService.applyDelta(reputation, -3);
      risk = riskService.applyDelta(risk, 5);
    }

    if (capital < 0) {
      newDebt += -capital;
      capital = 0;
      reputation = reputationService.applyDelta(reputation, -5);
    }

    final updatedRelationships = <String, RelationshipState>{};
    for (final entry in state.relationships.entries) {
      updatedRelationships[entry.key] = relationshipService.applyDecay(
        state: entry.value,
        currentDay: nextDay,
      );
    }

    final condition = marketService.pickCondition(conditions);
    if (condition != null) {
      _activeConditions = [..._activeConditions, condition];
    }

    _activeConditions = _activeConditions
        .map(
          (c) => MarketCondition(
            id: c.id,
            name: c.name,
            description: c.description,
            affectedCategories: c.affectedCategories,
            demandMultiplier: c.demandMultiplier,
            priceMultiplier: c.priceMultiplier,
            durationDays: c.durationDays - 1,
          ),
        )
        .where((c) => c.durationDays > 0)
        .toList();

    products = marketService.updatePrices(products, _activeConditions);

    final riskDrift = riskService.dailyRiskDrift(
      debt: newDebt,
      activeLoans: updatedLoans.length,
      capital: capital,
    );
    risk = riskService.applyDelta(risk, riskDrift);

    var intermediate = state.copyWith(
      day: nextDay,
      capital: double.parse(capital.toStringAsFixed(2)),
      reputation: reputation,
      risk: risk,
      debt: double.parse(newDebt.toStringAsFixed(2)),
      dailyIncome: businessIncome,
      activeInvestments: allInvestments,
      ownedBusinesses: updatedBusinesses,
      activeLoans: updatedLoans,
      relationships: updatedRelationships,
      lastPlayedAt: DateTime.now(),
    );

    bool challengeDone = false;
    double challengeRewardCapital = 0;
    int challengeRewardReputation = 0;

    if (activeChallenge != null) {
      final completed = challengeService.isCompleted(
        challenge: activeChallenge,
        stateBefore: stateAtDayStart,
        stateAfter: intermediate,
        successfulInvestmentsToday: successfulToday,
        tookLoanToday: tookLoanToday,
      );

      if (completed) {
        challengeDone = true;
        challengeRewardCapital = activeChallenge.rewardCapital;
        challengeRewardReputation = activeChallenge.rewardReputation;
        intermediate = intermediate.copyWith(
          capital: double.parse(
            (intermediate.capital + activeChallenge.rewardCapital)
                .toStringAsFixed(2),
          ),
          reputation: reputationService.applyDelta(
            intermediate.reputation,
            activeChallenge.rewardReputation,
          ),
          completedChallenges: {
            ...intermediate.completedChallenges,
            activeChallenge.id,
          },
        );
      }
    }

    int debtFreeStreak = 0;
    if (intermediate.debt <= 0 && intermediate.activeLoans.isEmpty) {
      debtFreeStreak = state.day;
    }

    final unlocked = achievementService.checkNewUnlocks(
      catalog: achievements.cast(),
      state: intermediate,
      ownedBusinesses: intermediate.ownedBusinesses.length,
      successfulInvestments: successfulToday,
      debtFreeStreak: debtFreeStreak,
    );

    if (unlocked.isNotEmpty) {
      intermediate = intermediate.copyWith(
        achievements: {...intermediate.achievements, ...unlocked},
      );
    }

    final ctx = EventFilterContext.fromState(intermediate);
    final newEvents = eventService.pickDaily(events, ctx, count: 3);

    return DayAdvanceResult(
      newState: intermediate,
      newEvents: newEvents,
      investmentOutcomes: outcomes,
      loanPenalty: penalty,
      unlockedAchievements: unlocked,
      challengeCompleted: challengeDone,
      challengeRewardCapital: challengeRewardCapital,
      challengeRewardReputation: challengeRewardReputation,
    );
  }

  Product? findProduct(String id) {
    for (final p in products) {
      if (p.id == id) return p;
    }
    return null;
  }

  Business? findBusiness(String id) {
    for (final b in businesses) {
      if (b.id == id) return b;
    }
    return null;
  }

  Npc? findNpc(String id) {
    for (final n in npcs) {
      if (n.id == id) return n;
    }
    return null;
  }
}
