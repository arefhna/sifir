class MarketCondition {
  const MarketCondition({
    required this.id,
    required this.name,
    required this.description,
    required this.affectedCategories,
    required this.demandMultiplier,
    required this.priceMultiplier,
    required this.durationDays,
  });

  final String id;
  final String name;
  final String description;
  final List<String> affectedCategories;
  final double demandMultiplier;
  final double priceMultiplier;
  final int durationDays;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'affectedCategories': affectedCategories,
        'demandMultiplier': demandMultiplier,
        'priceMultiplier': priceMultiplier,
        'durationDays': durationDays,
      };

  factory MarketCondition.fromJson(Map<String, dynamic> json) =>
      MarketCondition(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        affectedCategories: (json['affectedCategories'] as List).cast<String>(),
        demandMultiplier: (json['demandMultiplier'] as num).toDouble(),
        priceMultiplier: (json['priceMultiplier'] as num).toDouble(),
        durationDays: (json['durationDays'] as num).toInt(),
      );
}
