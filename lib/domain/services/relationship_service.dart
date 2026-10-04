import '../../data/models/npc_model.dart';

class RelationshipService {
  const RelationshipService();

  Map<String, RelationshipState> initialize(List<Npc> npcs, int currentDay) {
    final map = <String, RelationshipState>{};
    for (final npc in npcs) {
      map[npc.id] = RelationshipState(
        npcId: npc.id,
        trust: npc.initialTrust,
        relationship: npc.initialRelationship,
        lastInteractionDay: currentDay,
      );
    }
    return map;
  }

  RelationshipState interact({
    required RelationshipState state,
    required int trustDelta,
    required int relationshipDelta,
    required int currentDay,
  }) {
    return state.copyWith(
      trust: (state.trust + trustDelta).clamp(0, 100),
      relationship: (state.relationship + relationshipDelta).clamp(0, 100),
      lastInteractionDay: currentDay,
    );
  }

  RelationshipState applyDecay({
    required RelationshipState state,
    required int currentDay,
  }) {
    final daysSince = currentDay - state.lastInteractionDay;
    if (daysSince < 5) return state;
    final decay = (daysSince ~/ 5).clamp(0, 5);
    return state.copyWith(
      trust: (state.trust - decay).clamp(0, 100),
      relationship: (state.relationship - decay).clamp(0, 100),
    );
  }

  int influenceScore(Npc npc, RelationshipState state) {
    return ((npc.influence + state.relationship + state.trust) / 3).round();
  }

  String statusLabel(RelationshipState state) {
    final avg = (state.trust + state.relationship) / 2;
    if (avg >= 80) return 'Yaxın tərəfdaş';
    if (avg >= 60) return 'Etibarlı';
    if (avg >= 40) return 'Neytral';
    if (avg >= 20) return 'Uzaq';
    return 'Soyuq';
  }

  bool hasGoodRelationship(RelationshipState state) =>
      state.trust >= 60 && state.relationship >= 60;

  int averageTrust(Map<String, RelationshipState> map) {
    if (map.isEmpty) return 0;
    final total = map.values.fold<int>(0, (sum, r) => sum + r.trust);
    return (total / map.length).round();
  }
}
