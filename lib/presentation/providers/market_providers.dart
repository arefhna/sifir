import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/market_condition_model.dart';
import '../../data/models/product_model.dart';
import 'game_providers.dart';
import 'player_notifier.dart';

final marketProductsProvider = Provider<List<Product>>((ref) {
  final notifier = ref.watch(playerStateProvider.notifier);
  final live = notifier.products;
  if (live.isNotEmpty) return live;
  final async = ref.watch(productsFutureProvider);
  return async.maybeWhen(
    data: (list) => list,
    orElse: () => const [],
  );
});

final marketConditionsProvider = Provider<List<MarketCondition>>((ref) {
  final async = ref.watch(marketConditionsFutureProvider);
  return async.maybeWhen(
    data: (list) => list,
    orElse: () => const [],
  );
});

final marketCategoriesProvider = Provider<List<String>>((ref) {
  final products = ref.watch(marketProductsProvider);
  final service = ref.watch(marketServiceProvider);
  return service.categories(products);
});

final filteredProductsProvider =
    Provider.family<List<Product>, String>((ref, category) {
  final products = ref.watch(marketProductsProvider);
  if (category == 'Hamısı') return products;
  return products.where((p) => p.category == category).toList();
});
