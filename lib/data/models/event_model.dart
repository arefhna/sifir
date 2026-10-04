enum EventType { opportunity, threat, neutral }

class GameEvent {
  const GameEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.weight,
    required this.minDay,
    required this.minReputation,
    required this.minCapital,
    required this.choices,
  });

  final String id;
  final String title;
  final String description;
  final EventType type;
  final int weight;
  final int minDay;
  final int minReputation;
  final double minCapital;
  final List<EventChoice> choices;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'type': type.name,
        'weight': weight,
        'minDay': minDay,
        'minReputation': minReputation,
        'minCapital': minCapital,
        'choices': choices.map((c) => c.toJson()).toList(),
      };

  factory GameEvent.fromJson(Map<String, dynamic> json) => GameEvent(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        type: EventType.values.firstWhere((t) => t.name == json['type']),
        weight: (json['weight'] as num).toInt(),
        minDay: (json['minDay'] as num).toInt(),
        minReputation: (json['minReputation'] as num).toInt(),
        minCapital: (json['minCapital'] as num).toDouble(),
        choices: (json['choices'] as List)
            .map((c) => EventChoice.fromJson(c as Map<String, dynamic>))
            .toList(),
      );
}

class EventChoice {
  const EventChoice({
    required this.id,
    required this.label,
    required this.description,
    required this.cost,
    required this.expectedReward,
    required this.riskPercent,
    required this.duration,
    required this.reputationDelta,
    required this.successMessage,
    required this.failMessage,
  });

  final String id;
  final String label;
  final String description;
  final double cost;
  final double expectedReward;
  final int riskPercent;
  final int duration;
  final int reputationDelta;
  final String successMessage;
  final String failMessage;

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'description': description,
        'cost': cost,
        'expectedReward': expectedReward,
        'riskPercent': riskPercent,
        'duration': duration,
        'reputationDelta': reputationDelta,
        'successMessage': successMessage,
        'failMessage': failMessage,
      };

  factory EventChoice.fromJson(Map<String, dynamic> json) => EventChoice(
        id: json['id'] as String,
        label: json['label'] as String,
        description: json['description'] as String,
        cost: (json['cost'] as num).toDouble(),
        expectedReward: (json['expectedReward'] as num).toDouble(),
        riskPercent: (json['riskPercent'] as num).toInt(),
        duration: (json['duration'] as num).toInt(),
        reputationDelta: (json['reputationDelta'] as num).toInt(),
        successMessage: json['successMessage'] as String,
        failMessage: json['failMessage'] as String,
      );
}
