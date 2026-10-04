import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/achievement_model.dart';
import 'game_providers.dart';
import 'player_notifier.dart';

final allAchievementsProvider =
    FutureProvider<List<Achievement>>((ref) async {
  return ref.watch(achievementRepositoryProvider).loadAchievements();
});

final unlockedAchievementsProvider = Provider<Set<String>>((ref) {
  final state = ref.watch(playerStateProvider);
  return state?.achievements ?? const {};
});

final achievementProgressProvider =
    Provider<List<MapEntry<Achievement, double>>>((ref) {
  final all = ref.watch(allAchievementsProvider).maybeWhen(
        data: (list) => list,
        orElse: () => const <Achievement>[],
      );
  final state = ref.watch(playerStateProvider);
  if (state == null) {
    return all.map((a) => MapEntry(a, 0.0)).toList();
  }

  final service = ref.watch(achievementServiceProvider);
  return all.map((a) {
    final progress = service.progress(
      achievement: a,
      state: state,
      ownedBusinesses: state.ownedBusinesses.length,
      successfulInvestments: 0,
      debtFreeStreak: 0,
    );
    return MapEntry(a, progress);
  }).toList();
});
