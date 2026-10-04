import '../../data/models/achievement_model.dart';
import '../../data/models/player_state_model.dart';

class AchievementService {
  const AchievementService();

  List<String> checkNewUnlocks({
    required List<Achievement> catalog,
    required PlayerState state,
    required int ownedBusinesses,
    required int successfulInvestments,
    required int debtFreeStreak,
  }) {
    final unlocked = <String>[];
    for (final a in catalog) {
      if (state.achievements.contains(a.id)) continue;
      if (_meets(
        achievement: a,
        state: state,
        ownedBusinesses: ownedBusinesses,
        successfulInvestments: successfulInvestments,
        debtFreeStreak: debtFreeStreak,
      )) {
        unlocked.add(a.id);
      }
    }
    return unlocked;
  }

  bool _meets({
    required Achievement achievement,
    required PlayerState state,
    required int ownedBusinesses,
    required int successfulInvestments,
    required int debtFreeStreak,
  }) {
    switch (achievement.type) {
      case AchievementType.capital:
        return state.capital >= achievement.targetValue;
      case AchievementType.reputation:
        return state.reputation >= achievement.targetValue;
      case AchievementType.businesses:
        return ownedBusinesses >= achievement.targetValue;
      case AchievementType.investments:
        return successfulInvestments >= achievement.targetValue;
      case AchievementType.debtFreeDays:
        return debtFreeStreak >= achievement.targetValue;
      case AchievementType.custom:
        return false;
    }
  }

  double progress({
    required Achievement achievement,
    required PlayerState state,
    required int ownedBusinesses,
    required int successfulInvestments,
    required int debtFreeStreak,
  }) {
    switch (achievement.type) {
      case AchievementType.capital:
        if (achievement.targetValue <= 0) return 0;
        return (state.capital / achievement.targetValue).clamp(0, 1);
      case AchievementType.reputation:
        if (achievement.targetValue <= 0) return 0;
        return (state.reputation / achievement.targetValue).clamp(0, 1);
      case AchievementType.businesses:
        if (achievement.targetValue <= 0) return 0;
        return (ownedBusinesses / achievement.targetValue).clamp(0, 1);
      case AchievementType.investments:
        if (achievement.targetValue <= 0) return 0;
        return (successfulInvestments / achievement.targetValue).clamp(0, 1);
      case AchievementType.debtFreeDays:
        if (achievement.targetValue <= 0) return 0;
        return (debtFreeStreak / achievement.targetValue).clamp(0, 1);
      case AchievementType.custom:
        return 0;
    }
  }

  int unlockedCount(List<Achievement> all, PlayerState state) {
    return all.where((a) => state.achievements.contains(a.id)).length;
  }

  double completionRatio(List<Achievement> all, PlayerState state) {
    if (all.isEmpty) return 0;
    return unlockedCount(all, state) / all.length;
  }
}
