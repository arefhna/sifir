import '../../core/utils/random_utils.dart';
import '../../data/models/challenge_model.dart';
import '../../data/models/player_state_model.dart';

class ChallengeService {
  const ChallengeService();

  DailyChallenge? pickDaily(List<DailyChallenge> pool, PlayerState state) {
    final eligible = pool.where((c) {
      if (state.completedChallenges.contains(c.id)) return false;
      return true;
    }).toList();

    if (eligible.isEmpty) return null;
    return RandomUtils.pick(eligible);
  }

  bool isCompleted({
    required DailyChallenge challenge,
    required PlayerState stateBefore,
    required PlayerState stateAfter,
    required int successfulInvestmentsToday,
    required bool tookLoanToday,
  }) {
    switch (challenge.type) {
      case ChallengeType.capitalTarget:
        final gained = stateAfter.capital - stateBefore.capital;
        return gained >= challenge.targetValue;
      case ChallengeType.noDebt:
        return !tookLoanToday;
      case ChallengeType.profitPercent:
        if (stateBefore.capital <= 0) {
          return stateAfter.capital >= challenge.targetValue;
        }
        final gained = stateAfter.capital - stateBefore.capital;
        final percent = (gained / stateBefore.capital) * 100;
        return percent >= challenge.targetValue;
      case ChallengeType.businessOwned:
        return stateAfter.ownedBusinesses.length >
            stateBefore.ownedBusinesses.length;
      case ChallengeType.investmentSuccess:
        return successfulInvestmentsToday >= challenge.targetValue;
    }
  }
}
