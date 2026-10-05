import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/business_model.dart';
import '../../providers/business_providers.dart';
import '../../providers/game_providers.dart';
import '../../providers/player_notifier.dart';
import '../../widgets/business_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/section_header.dart';

class BusinessesScreen extends ConsumerStatefulWidget {
  const BusinessesScreen({super.key});

  @override
  ConsumerState<BusinessesScreen> createState() => _BusinessesScreenState();
}

class _BusinessesScreenState extends ConsumerState<BusinessesScreen> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureLoaded();
    });
  }

  Future<void> _ensureLoaded() async {
    if (_initialized) return;
    _initialized = true;
    final notifier = ref.read(playerStateProvider.notifier);
    if (notifier.currentState == null) {
      await notifier.load();
    }
  }

  Future<void> _handlePurchase(Business business) async {
    final playerState = ref.read(playerStateProvider);
    if (playerState == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Biznes almaq?'),
        content: Text(
          '${business.name}\n'
          'Xərc: ${business.initialCost.toStringAsFixed(0)} ₼\n'
          'Gündəlik: +${business.dailyIncome.toStringAsFixed(0)} ₼',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Ləğv et'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Al'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final notifier = ref.read(playerStateProvider.notifier);
    await notifier.purchaseBusiness(business);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${business.name} alındı!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _handleUpgrade(Business business, OwnedBusiness owned) async {
    final notifier = ref.read(playerStateProvider.notifier);
    await notifier.upgradeBusiness(business, owned);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${business.name} təkmilləşdirildi!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(playerStateProvider);
    final allBusinesses = ref.watch(allBusinessesProvider);
    final dailyIncome = ref.watch(dailyBusinessIncomeProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: allBusinesses.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.accent),
          ),
          error: (e, _) => Center(
            child: Text('Xəta: $e', style: AppTypography.body),
          ),
          data: (catalog) {
            if (playerState == null) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.accent),
              );
            }

            final ownedIds =
                playerState.ownedBusinesses.map((b) => b.businessId).toSet();
            final ownedList = catalog
                .where((b) => ownedIds.contains(b.id))
                .toList();
            final availableList = catalog
                .where((b) => !ownedIds.contains(b.id))
                .toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Biznes', style: AppTypography.headline),
                  const SizedBox(height: 4),
                  Text(
                    'Gündəlik gəlir: ${dailyIncome.toStringAsFixed(0)} ₼',
                    style: AppTypography.bodySecondary,
                  ),
                  const SizedBox(height: 20),
                  if (ownedList.isNotEmpty) ...[
                    SectionHeader(
                      title: 'Sahib olduğun bizneslər (${ownedList.length})',
                    ),
                    ...ownedList.map((business) {
                      final owned = playerState.ownedBusinesses
                          .firstWhere((o) => o.businessId == business.id);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: BusinessCard(
                          business: business,
                          canPurchase: false,
                          isOwned: true,
                          owned: owned,
                          onTap: () => _handleUpgrade(business, owned),
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                  ],
                  SectionHeader(
                    title: 'Mövcud bizneslər (${availableList.length})',
                  ),
                  if (availableList.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: EmptyState(
                        icon: Icons.check_circle_outline,
                        title: 'Bütün bizneslər alınıb',
                        description: 'Yeni bizneslər sonra açılacaq.',
                      ),
                    )
                  else
                    ...availableList.map((business) {
                      final canBuy = playerState.capital >=
                              business.initialCost &&
                          playerState.reputation >=
                              business.reputationRequirement &&
                          playerState.day >= business.minDay;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: BusinessCard(
                          business: business,
                          canPurchase: canBuy,
                          isOwned: false,
                          owned: null,
                          onTap: canBuy ? () => _handlePurchase(business) : () {},
                        ),
                      );
                    }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
