class Business {
  const Business({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.initialCost,
    required this.dailyIncome,
    required this.maintenance,
    required this.risk,
    required this.growth,
    required this.reputationRequirement,
    required this.minDay,
    required this.icon,
  });

  final String id;
  final String name;
  final String category;
  final String description;
  final double initialCost;
  final double dailyIncome;
  final double maintenance;
  final int risk;
  final double growth;
  final int reputationRequirement;
  final int minDay;
  final String icon;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'description': description,
        'initialCost': initialCost,
        'dailyIncome': dailyIncome,
        'maintenance': maintenance,
        'risk': risk,
        'growth': growth,
        'reputationRequirement': reputationRequirement,
        'minDay': minDay,
        'icon': icon,
      };

  factory Business.fromJson(Map<String, dynamic> json) => Business(
        id: json['id'] as String,
        name: json['name'] as String,
        category: json['category'] as String,
        description: json['description'] as String,
        initialCost: (json['initialCost'] as num).toDouble(),
        dailyIncome: (json['dailyIncome'] as num).toDouble(),
        maintenance: (json['maintenance'] as num).toDouble(),
        risk: (json['risk'] as num).toInt(),
        growth: (json['growth'] as num).toDouble(),
        reputationRequirement: (json['reputationRequirement'] as num).toInt(),
        minDay: (json['minDay'] as num).toInt(),
        icon: json['icon'] as String,
      );
}

class OwnedBusiness {
  const OwnedBusiness({
    required this.businessId,
    required this.purchasedDay,
    required this.level,
    required this.accumulatedIncome,
  });

  final String businessId;
  final int purchasedDay;
  final int level;
  final double accumulatedIncome;

  OwnedBusiness copyWith({
    int? level,
    double? accumulatedIncome,
  }) =>
      OwnedBusiness(
        businessId: businessId,
        purchasedDay: purchasedDay,
        level: level ?? this.level,
        accumulatedIncome: accumulatedIncome ?? this.accumulatedIncome,
      );

  Map<String, dynamic> toJson() => {
        'businessId': businessId,
        'purchasedDay': purchasedDay,
        'level': level,
        'accumulatedIncome': accumulatedIncome,
      };

  factory OwnedBusiness.fromJson(Map<String, dynamic> json) => OwnedBusiness(
        businessId: json['businessId'] as String,
        purchasedDay: (json['purchasedDay'] as num).toInt(),
        level: (json['level'] as num).toInt(),
        accumulatedIncome: (json['accumulatedIncome'] as num).toDouble(),
      );
}
