import 'dart:math';

import '../../core/utils/random_utils.dart';
import '../../data/models/market_condition_model.dart';
import '../../data/models/product_model.dart';

class MarketService {
  MarketService(this._rng);

  final Random _rng;

  List<Product> updatePrices(
    List<Product> products,
    List<MarketCondition> activeConditions,
  ) {
    return products.map((product) {
      final matching = activeConditions.where(
        (c) => c.affectedCategories.contains(product.category),
      );

      double demandMultiplier = 1.0;
      double priceMultiplier = 1.0;

      for (final condition in matching) {
        demandMultiplier *= condition.demandMultiplier;
        priceMultiplier *= condition.priceMultiplier;
      }

      final effectiveDemand =
          (product.demand * demandMultiplier).clamp(0, 100).toDouble();
      final demandPressure = (effectiveDemand - product.supply) / 100.0;

      final trendShift =
          demandPressure * 0.15 + RandomUtils.doubleInRange(-0.05, 0.05);
      final newTrend = (product.trend + trendShift).clamp(-0.5, 0.5);
      final newPrice =
          (product.basePrice * priceMultiplier * (1 + newTrend))
              .clamp(product.basePrice * 0.5, product.basePrice * 2.0);

      final newDemand =
          (product.demand + RandomUtils.intInRange(-5, 5)).clamp(0, 100);
      final newSupply =
          (product.supply + RandomUtils.intInRange(-5, 5)).clamp(0, 100);

      return product.copyWith(
        currentPrice: double.parse(newPrice.toStringAsFixed(2)),
        demand: newDemand,
        supply: newSupply,
        trend: newTrend,
      );
    }).toList();
  }

  double calculateExpectedReward({
    required Product product,
    required int quantity,
    required int reputation,
  }) {
    final reputationBonus = 1 + (reputation / 200.0);
    final margin =
        product.currentPrice * product.profitMargin * quantity * reputationBonus;
    return double.parse(margin.toStringAsFixed(2));
  }

  int estimateRisk({
    required Product product,
    required int playerRisk,
  }) {
    final base = product.risk.toDouble();
    final playerFactor = playerRisk * 0.2;
    return (base + playerFactor).clamp(0, 95).round();
  }

  MarketCondition? pickCondition(List<MarketCondition> pool) {
    if (pool.isEmpty) return null;
    if (_rng.nextDouble() < 0.35) {
      return RandomUtils.pick(pool);
    }
    return null;
  }

  List<String> categories(List<Product> products) {
    final set = <String>{};
    for (final p in products) {
      set.add(p.category);
    }
    return set.toList()..sort();
  }

  double trendValue(Product product) {
    if (product.basePrice <= 0) return 0;
    return (product.currentPrice - product.basePrice) / product.basePrice;
  }

  String trendIcon(Product product) {
    final change = trendValue(product);
    if (change > 0.03) return '▲';
    if (change < -0.03) return '▼';
    return '▬';
  }
}
