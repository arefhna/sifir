enum ChallengeType {
  capitalTarget,
  noDebt,
  profitPercent,
  businessOwned,
  investmentSuccess,
}

class DailyChallenge {
  const DailyChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.targetValue,
    required this.rewardCapital,
    required this.rewardReputation,
  });

  final String id;
  final String title;
  final String description;
  final ChallengeType type;
  final double targetValue;
  final double rewardCapital;
  final int rewardReputation;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'type': type.name,
        'targetValue': targetValue,
        'rewardCapital': rewardCapital,
        'rewardReputation': rewardReputation,
      };

  factory DailyChallenge.fromJson(Map<String, dynamic> json) => DailyChallenge(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        type: ChallengeType.values.firstWhere((t) => t.name == json['type']),
        targetValue: (json['targetValue'] as num).toDouble(),
        rewardCapital: (json['rewardCapital'] as num).toDouble(),
        rewardReputation: (json['rewardReputation'] as num).toInt(),
      );
}
