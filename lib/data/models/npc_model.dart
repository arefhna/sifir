class Npc {
  const Npc({
    required this.id,
    required this.name,
    required this.role,
    required this.specialty,
    required this.description,
    required this.initialTrust,
    required this.influence,
    required this.initialRelationship,
  });

  final String id;
  final String name;
  final String role;
  final String specialty;
  final String description;
  final int initialTrust;
  final int influence;
  final int initialRelationship;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'role': role,
        'specialty': specialty,
        'description': description,
        'initialTrust': initialTrust,
        'influence': influence,
        'initialRelationship': initialRelationship,
      };

  factory Npc.fromJson(Map<String, dynamic> json) => Npc(
        id: json['id'] as String,
        name: json['name'] as String,
        role: json['role'] as String,
        specialty: json['specialty'] as String,
        description: json['description'] as String,
        initialTrust: (json['initialTrust'] as num).toInt(),
        influence: (json['influence'] as num).toInt(),
        initialRelationship: (json['initialRelationship'] as num).toInt(),
      );
}

class RelationshipState {
  const RelationshipState({
    required this.npcId,
    required this.trust,
    required this.relationship,
    required this.lastInteractionDay,
  });

  final String npcId;
  final int trust;
  final int relationship;
  final int lastInteractionDay;

  RelationshipState copyWith({
    int? trust,
    int? relationship,
    int? lastInteractionDay,
  }) =>
      RelationshipState(
        npcId: npcId,
        trust: trust ?? this.trust,
        relationship: relationship ?? this.relationship,
        lastInteractionDay: lastInteractionDay ?? this.lastInteractionDay,
      );

  Map<String, dynamic> toJson() => {
        'npcId': npcId,
        'trust': trust,
        'relationship': relationship,
        'lastInteractionDay': lastInteractionDay,
      };

  factory RelationshipState.fromJson(Map<String, dynamic> json) =>
      RelationshipState(
        npcId: json['npcId'] as String,
        trust: (json['trust'] as num).toInt(),
        relationship: (json['relationship'] as num).toInt(),
        lastInteractionDay: (json['lastInteractionDay'] as num).toInt(),
      );
}
