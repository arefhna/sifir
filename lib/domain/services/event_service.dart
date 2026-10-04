import '../../core/utils/random_utils.dart';
import '../../data/models/event_model.dart';
import '../../data/models/player_state_model.dart';

class EventFilterContext {
  const EventFilterContext({
    required this.day,
    required this.reputation,
    required this.capital,
  });

  final int day;
  final int reputation;
  final double capital;

  factory EventFilterContext.fromState(PlayerState state) {
    return EventFilterContext(
      day: state.day,
      reputation: state.reputation,
      capital: state.capital,
    );
  }
}

class EventService {
  const EventService();

  List<GameEvent> filterEligible(
    List<GameEvent> pool,
    EventFilterContext ctx,
  ) {
    return pool.where((e) {
      if (e.minDay > ctx.day) return false;
      if (e.minReputation > ctx.reputation) return false;
      if (e.minCapital > ctx.capital) return false;
      return true;
    }).toList();
  }

  List<GameEvent> pickDaily(
    List<GameEvent> pool,
    EventFilterContext ctx, {
    int count = 3,
  }) {
    final eligible = filterEligible(pool, ctx);
    if (eligible.isEmpty) return [];

    final weighted = <GameEvent>[];
    for (final event in eligible) {
      for (var i = 0; i < event.weight; i++) {
        weighted.add(event);
      }
    }

    final picked = <GameEvent>[];
    final seen = <String>{};
    var attempts = 0;
    while (picked.length < count && attempts < 100) {
      attempts++;
      if (weighted.isEmpty) break;
      final candidate = RandomUtils.pick(weighted);
      if (seen.contains(candidate.id)) continue;
      seen.add(candidate.id);
      picked.add(candidate);
    }

    return picked;
  }

  EventChoice? findChoice(GameEvent event, String choiceId) {
    for (final c in event.choices) {
      if (c.id == choiceId) return c;
    }
    return null;
  }

  bool canAfford(EventChoice choice, PlayerState state) =>
      state.capital >= choice.cost;
}
