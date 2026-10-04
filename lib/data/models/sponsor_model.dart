class Sponsor {
  const Sponsor({
    required this.id,
    required this.name,
    required this.logoAsset,
    required this.description,
    required this.website,
    required this.product,
    required this.productImage,
    required this.campaignText,
    required this.startDate,
    required this.endDate,
    required this.active,
    required this.placements,
  });

  final String id;
  final String name;
  final String logoAsset;
  final String description;
  final String website;
  final String product;
  final String productImage;
  final String campaignText;
  final DateTime startDate;
  final DateTime endDate;
  final bool active;
  final List<String> placements;

  bool isActiveOn(DateTime now) =>
      active && now.isAfter(startDate) && now.isBefore(endDate);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'logoAsset': logoAsset,
        'description': description,
        'website': website,
        'product': product,
        'productImage': productImage,
        'campaignText': campaignText,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'active': active,
        'placements': placements,
      };

  factory Sponsor.fromJson(Map<String, dynamic> json) => Sponsor(
        id: json['id'] as String,
        name: json['name'] as String,
        logoAsset: json['logoAsset'] as String,
        description: json['description'] as String,
        website: json['website'] as String,
        product: json['product'] as String,
        productImage: json['productImage'] as String,
        campaignText: json['campaignText'] as String,
        startDate: DateTime.parse(json['startDate'] as String),
        endDate: DateTime.parse(json['endDate'] as String),
        active: json['active'] as bool,
        placements: (json['placements'] as List).cast<String>(),
      );
}
