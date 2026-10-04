import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/event_model.dart';
import '../../data/models/player_state_model.dart';
import '../../domain/services/event_service.dart';
import 'game_providers.dart';
import 'player_notifier.dart';

final allEventsProvider = FutureProvider<List<GameEvent>>((ref) async {
  return ref.watch(eventRepositoryProvider).loadEvents();
});

final eligibleEventsProvider = Provider<List<GameEvent>>((ref) {
  final playerState = ref.watch(playerStateProvider);
  if (playerState == null) return const [];

  final all = ref.watch(allEventsProvider).maybeWhen(
        data: (list) => list,
        orElse: () => const <GameEvent>[],
      );

  final service = ref.watch(eventServiceProvider);
  final ctx = EventFilterContext.fromState(playerState);
  return service.filterEligible(all, ctx);
});

final dailyEventsProvider =
    StateProvider.family<List<GameEvent>, int>((ref, day) => const []);
