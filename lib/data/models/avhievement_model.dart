class Achievement {
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.targetValue,
    required this.type,
  });

  final String id;
  final String title;
  final String description;
  final String icon;
  final double targetValue;
  final AchievementType type;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'icon': icon,
        'targetValue': targetValue,
        'type': type.name,
      };

  factory Achievement.fromJson(Map<String, dynamic> json) => Achievement(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        icon: json['icon'] as String,
        targetValue: (json['targetValue'] as num).toDouble(),
        type: AchievementType.values.firstWhere(
          (t) => t.name == json['type'],
          orElse: () => AchievementType.custom,
        ),
      );
}

enum AchievementType {
  capital,
  reputation,
  businesses,
  investments,
  debtFreeDays,
  custom,
}
