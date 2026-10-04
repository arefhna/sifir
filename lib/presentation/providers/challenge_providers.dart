import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/challenge_model.dart';
import 'game_providers.dart';
import 'player_notifier.dart';

final allChallengesProvider =
    FutureProvider<List<DailyChallenge>>((ref) async {
  return ref.watch(challengeRepositoryProvider).loadChallenges();
});

final activeChallengeProvider =
    StateProvider<DailyChallenge?>((ref) => null);

final challengeAvailableProvider = Provider<List<DailyChallenge>>((ref) {
  final all = ref.watch(allChallengesProvider).maybeWhen(
        data: (list) => list,
        orElse: () => const <DailyChallenge>[],
      );
  final state = ref.watch(playerStateProvider);
  if (state == null) return all;
  return all
      .where((c) => !state.completedChallenges.contains(c.id))
      .toList();
});

final completedChallengesProvider = Provider<Set<String>>((ref) {
  final state = ref.watch(playerStateProvider);
  return state?.completedChallenges ?? const {};
});
