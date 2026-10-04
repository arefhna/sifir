import '../../core/constants/game_balance.dart';
import '../../data/models/business_model.dart';

class BusinessService {
  const BusinessService();

  bool canPurchase({
    required Business business,
    required double capital,
    required int reputation,
    required int day,
    required List<OwnedBusiness> owned,
  }) {
    if (capital < business.initialCost) return false;
    if (reputation < business.reputationRequirement) return false;
    if (day < business.minDay) return false;
    final already = owned.any((b) => b.businessId == business.id);
    return !already;
  }

  OwnedBusiness purchase({
    required Business business,
    required int currentDay,
  }) {
    return OwnedBusiness(
      businessId: business.id,
      purchasedDay: currentDay,
      level: 1,
      accumulatedIncome: 0,
    );
  }

  double dailyNetIncome({
    required Business business,
    required OwnedBusiness owned,
  }) {
    final levelMultiplier = 1 + (owned.level - 1) * 0.15;
    final gross = business.dailyIncome * levelMultiplier;
    final maintenance = business.maintenance * levelMultiplier;
    final net = gross - maintenance;
    return net < 0 ? 0 : double.parse(net.toStringAsFixed(2));
  }

  OwnedBusiness applyDailyGrowth({
    required Business business,
    required OwnedBusiness owned,
    required double netIncome,
  }) {
    final growthBoost = netIncome > 0 ? GameBalance.businessGrowthRate : 0.0;
    final newLevel = (owned.level + growthBoost).floor().clamp(1, 10);
    return owned.copyWith(
      level: newLevel,
      accumulatedIncome: double.parse(
        (owned.accumulatedIncome + netIncome).toStringAsFixed(2),
      ),
    );
  }

  double totalDailyIncome({
    required List<Business> catalog,
    required List<OwnedBusiness> owned,
  }) {
    double total = 0;
    for (final o in owned) {
      final match = catalog.where((b) => b.id == o.businessId).toList();
      if (match.isEmpty) continue;
      total += dailyNetIncome(business: match.first, owned: o);
    }
    return double.parse(total.toStringAsFixed(2));
  }

  double upgradeCost({
    required Business business,
    required OwnedBusiness owned,
  }) {
    return double.parse(
      (business.initialCost * 0.6 * owned.level).toStringAsFixed(2),
    );
  }

  bool canUpgrade({
    required Business business,
    required OwnedBusiness owned,
    required double capital,
  }) {
    if (owned.level >= 5) return false;
    return capital >= upgradeCost(business: business, owned: owned);
  }

  OwnedBusiness upgrade(OwnedBusiness owned) =>
      owned.copyWith(level: owned.level + 1);

  String levelLabel(int level) {
    const labels = ['Başlanğıc', 'Kiçik', 'Orta', 'Böyük', 'Böyük+'];
    return labels[(level - 1).clamp(0, labels.length - 1)];
  }
}
