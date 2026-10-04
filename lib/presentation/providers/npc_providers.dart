import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/npc_model.dart';
import 'game_providers.dart';
import 'player_notifier.dart';

final allNpcsProvider = FutureProvider<List<Npc>>((ref) async {
  return ref.watch(npcRepositoryProvider).loadNpcs();
});

final relationshipStatesProvider =
    Provider<Map<String, RelationshipState>>((ref) {
  final state = ref.watch(playerStateProvider);
  return state?.relationships ?? const {};
});

final npcWithRelationshipProvider =
    Provider<List<MapEntry<Npc, RelationshipState>>>((ref) {
  final npcs = ref.watch(allNpcsProvider).maybeWhen(
        data: (list) => list,
        orElse: () => const <Npc>[],
      );
  final relations = ref.watch(relationshipStatesProvider);

  final result = <MapEntry<Npc, RelationshipState>>[];
  for (final npc in npcs) {
    final rel = relations[npc.id];
    if (rel == null) continue;
    result.add(MapEntry(npc, rel));
  }
  return result;
});

final topRelationshipsProvider =
    Provider<List<MapEntry<Npc, RelationshipState>>>((ref) {
  final list = ref.watch(npcWithRelationshipProvider).toList();
  list.sort((a, b) => b.value.trust.compareTo(a.value.trust));
  return list.take(5).toList();
});
