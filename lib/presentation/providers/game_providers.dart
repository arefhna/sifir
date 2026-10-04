import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data_sources/asset_data_source.dart';
import '../../data/local/game_storage.dart';
import '../../data/models/achievement_model.dart';
import '../../data/models/business_model.dart';
import '../../data/models/challenge_model.dart';
import '../../data/models/event_model.dart';
import '../../data/models/market_condition_model.dart';
import '../../data/models/npc_model.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/achievement_repository.dart';
import '../../data/repositories/business_repository.dart';
import '../../data/repositories/challenge_repository.dart';
import '../../data/repositories/event_repository.dart';
import '../../data/repositories/market_repository.dart';
import '../../data/repositories/npc_repository.dart';
import '../../data/repositories/player_repository.dart';
import '../../data/repositories/sponsor_repository.dart';
import '../../domain/services/achievement_service.dart';
import '../../domain/services/business_service.dart';
import '../../domain/services/challenge_service.dart';
import '../../domain/services/event_service.dart';
import '../../domain/services/loan_service.dart';
import '../../domain/services/market_service.dart';
import '../../domain/services/relationship_service.dart';
import '../../domain/services/reputation_service.dart';
import '../../domain/services/risk_service.dart';
import '../../domain/services/save_service.dart';

final assetDataSourceProvider = Provider<AssetDataSource>((ref) {
  return const AssetDataSource();
});

final gameStorageProvider = Provider<GameStorage>((ref) {
  return const GameStorage();
});

final randomProvider = Provider<Random>((ref) => Random());

final playerRepositoryProvider = Provider<PlayerRepository>((ref) {
  return PlayerRepositoryImpl(ref.watch(gameStorageProvider));
});

final marketRepositoryProvider = Provider<MarketRepository>((ref) {
  return MarketRepositoryImpl(ref.watch(assetDataSourceProvider));
});

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepositoryImpl(ref.watch(assetDataSourceProvider));
});

final businessRepositoryProvider = Provider<BusinessRepository>((ref) {
  return BusinessRepositoryImpl(ref.watch(assetDataSourceProvider));
});

final npcRepositoryProvider = Provider<NpcRepository>((ref) {
  return NpcRepositoryImpl(ref.watch(assetDataSourceProvider));
});

final achievementRepositoryProvider = Provider<AchievementRepository>((ref) {
  return AchievementRepositoryImpl(ref.watch(assetDataSourceProvider));
});

final challengeRepositoryProvider = Provider<ChallengeRepository>((ref) {
  return ChallengeRepositoryImpl(ref.watch(assetDataSourceProvider));
});

final sponsorRepositoryProvider = Provider<SponsorRepository>((ref) {
  return SponsorRepositoryImpl(ref.watch(assetDataSourceProvider));
});

final saveServiceProvider = Provider<SaveService>((ref) {
  return SaveService(ref.watch(playerRepositoryProvider));
});

final reputationServiceProvider = Provider<ReputationService>((ref) {
  return const ReputationService();
});

final riskServiceProvider = Provider<RiskService>((ref) {
  return const RiskService();
});

final marketServiceProvider = Provider<MarketService>((ref) {
  return MarketService(ref.watch(randomProvider));
});

final eventServiceProvider = Provider<EventService>((ref) {
  return const EventService();
});

final loanServiceProvider = Provider<LoanService>((ref) {
  return LoanService(ref.watch(reputationServiceProvider));
});

final businessServiceProvider = Provider<BusinessService>((ref) {
  return const BusinessService();
});

final relationshipServiceProvider = Provider<RelationshipService>((ref) {
  return const RelationshipService();
});

final achievementServiceProvider = Provider<AchievementService>((ref) {
  return const AchievementService();
});

final challengeServiceProvider = Provider<ChallengeService>((ref) {
  return const ChallengeService();
});

final productsFutureProvider = FutureProvider<List<Product>>((ref) async {
  return ref.watch(marketRepositoryProvider).loadProducts();
});

final marketConditionsFutureProvider =
    FutureProvider<List<MarketCondition>>((ref) async {
  return ref.watch(marketRepositoryProvider).loadConditions();
});

final eventsFutureProvider = FutureProvider<List<GameEvent>>((ref) async {
  return ref.watch(eventRepositoryProvider).loadEvents();
});

final businessesFutureProvider = FutureProvider<List<Business>>((ref) async {
  return ref.watch(businessRepositoryProvider).loadBusinesses();
});

final npcsFutureProvider = FutureProvider<List<Npc>>((ref) async {
  return ref.watch(npcRepositoryProvider).loadNpcs();
});

final achievementsFutureProvider =
    FutureProvider<List<Achievement>>((ref) async {
  return ref.watch(achievementRepositoryProvider).loadAchievements();
});

final challengesFutureProvider =
    FutureProvider<List<DailyChallenge>>((ref) async {
  return ref.watch(challengeRepositoryProvider).loadChallenges();
});
