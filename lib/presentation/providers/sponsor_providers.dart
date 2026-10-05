import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/sponsor_model.dart';
import 'game_providers.dart';

final allSponsorsProvider = FutureProvider<List<Sponsor>>((ref) async {
  return ref.watch(sponsorRepositoryProvider).loadSponsors();
});

final dashboardSponsorsProvider = FutureProvider<List<Sponsor>>((ref) async {
  return ref
      .watch(sponsorRepositoryProvider)
      .loadActiveSponsors(placement: 'dashboard');
});

final marketSponsorsProvider = FutureProvider<List<Sponsor>>((ref) async {
  return ref
      .watch(sponsorRepositoryProvider)
      .loadActiveSponsors(placement: 'market');
});

final profileSponsorsProvider = FutureProvider<List<Sponsor>>((ref) async {
  return ref
      .watch(sponsorRepositoryProvider)
      .loadActiveSponsors(placement: 'profile');
});

final activeSponsorCountProvider = FutureProvider<int>((ref) async {
  final sponsors = await ref.watch(allSponsorsProvider.future);
  final now = DateTime.now();
  return sponsors.where((s) => s.isActiveOn(now)).length;
});
