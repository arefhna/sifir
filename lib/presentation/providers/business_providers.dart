import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/business_model.dart';
import 'game_providers.dart';
import 'player_notifier.dart';

final allBusinessesProvider = FutureProvider<List<Business>>((ref) async {
  return ref.watch(businessRepositoryProvider).loadBusinesses();
});

final ownedBusinessesProvider = Provider<List<OwnedBusiness>>((ref) {
  final state = ref.watch(playerStateProvider);
  return state?.ownedBusinesses ?? const [];
});

final availableBusinessesProvider = Provider<List<Business>>((ref) {
  final playerState = ref.watch(playerStateProvider);
  if (playerState == null) return const [];

  final all = ref.watch(allBusinessesProvider).maybeWhen(
        data: (list) => list,
        orElse: () => const <Business>[],
      );

  final service = ref.watch(businessServiceProvider);
  return all.where((b) {
    return service.canPurchase(
      business: b,
      capital: playerState.capital,
      reputation: playerState.reputation,
      day: playerState.day,
      owned: playerState.ownedBusinesses,
    );
  }).toList();
});

final lockedBusinessesProvider = Provider<List<Business>>((ref) {
  final playerState = ref.watch(playerStateProvider);
  if (playerState == null) return const [];

  final all = ref.watch(allBusinessesProvider).maybeWhen(
        data: (list) => list,
        orElse: () => const <Business>[],
      );

  final service = ref.watch(businessServiceProvider);
  return all.where((b) {
    return !service.canPurchase(
      business: b,
      capital: playerState.capital,
      reputation: playerState.reputation,
      day: playerState.day,
      owned: playerState.ownedBusinesses,
    );
  }).toList();
});

final dailyBusinessIncomeProvider = Provider<double>((ref) {
  final playerState = ref.watch(playerStateProvider);
  if (playerState == null) return 0;

  final catalog = ref.watch(allBusinessesProvider).maybeWhen(
        data: (list) => list,
        orElse: () => const <Business>[],
      );

  return ref.watch(businessServiceProvider).totalDailyIncome(
        catalog: catalog,
        owned: playerState.ownedBusinesses,
      );
});
