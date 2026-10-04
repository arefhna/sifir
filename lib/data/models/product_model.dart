class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.basePrice,
    required this.currentPrice,
    required this.demand,
    required this.supply,
    required this.risk,
    required this.trend,
    required this.profitMargin,
    required this.duration,
    required this.icon,
  });

  final String id;
  final String name;
  final String category;
  final double basePrice;
  final double currentPrice;
  final int demand;
  final int supply;
  final int risk;
  final double trend;
  final double profitMargin;
  final int duration;
  final String icon;

  Product copyWith({
    double? currentPrice,
    int? demand,
    int? supply,
    double? trend,
  }) {
    return Product(
      id: id,
      name: name,
      category: category,
      basePrice: basePrice,
      currentPrice: currentPrice ?? this.currentPrice,
      demand: demand ?? this.demand,
      supply: supply ?? this.supply,
      risk: risk,
      trend: trend ?? this.trend,
      profitMargin: profitMargin,
      duration: duration,
      icon: icon,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'basePrice': basePrice,
        'currentPrice': currentPrice,
        'demand': demand,
        'supply': supply,
        'risk': risk,
        'trend': trend,
        'profitMargin': profitMargin,
        'duration': duration,
        'icon': icon,
      };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as String,
        name: json['name'] as String,
        category: json['category'] as String,
        basePrice: (json['basePrice'] as num).toDouble(),
        currentPrice: (json['currentPrice'] as num).toDouble(),
        demand: (json['demand'] as num).toInt(),
        supply: (json['supply'] as num).toInt(),
        risk: (json['risk'] as num).toInt(),
        trend: (json['trend'] as num).toDouble(),
        profitMargin: (json['profitMargin'] as num).toDouble(),
        duration: (json['duration'] as num).toInt(),
        icon: json['icon'] as String,
      );
}
