import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/product_model.dart';
import '../../modals/investment_modal.dart';
import '../../providers/game_providers.dart';
import '../../providers/market_providers.dart';
import '../../providers/player_notifier.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/market_tile.dart';

class MarketScreen extends ConsumerStatefulWidget {
  const MarketScreen({super.key});

  @override
  ConsumerState<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends ConsumerState<MarketScreen> {
  String _selectedCategory = 'Hamısı';
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

  Future<void> _openInvestment(Product product) async {
    final playerState = ref.read(playerStateProvider);
    if (playerState == null) return;

    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => InvestmentModal(
        product: product,
        playerCapital: playerState.capital,
        playerReputation: playerState.reputation,
        playerRisk: playerState.risk,
        marketService: ref.read(marketServiceProvider),
        onConfirm: (qty) => Navigator.of(ctx).pop(true),
      ),
    );

    if (confirmed != true || !mounted) return;

    final notifier = ref.read(playerStateProvider.notifier);
    final service = ref.read(marketServiceProvider);

    final expected = service.calculateExpectedReward(
      product: product,
      quantity: _lastQuantity,
      reputation: playerState.reputation,
    );

    final effectiveRisk = service.estimateRisk(
      product: product,
      playerRisk: playerState.risk,
    );

    await notifier.startInvestment(
      title: product.name,
      cost: product.currentPrice * _lastQuantity,
      expectedReward: expected,
      riskPercent: effectiveRisk,
      durationDays: product.duration,
      reputationDelta: 1,
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${product.name} — $_lastQuantity ədəd investisiya edildi',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  int _lastQuantity = 1;

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(marketProductsProvider);
    final playerState = ref.watch(playerStateProvider);
    final service = ref.watch(marketServiceProvider);

    final categories = <String>['Hamısı'];
    final categorySet = <String>{};
    for (final p in products) {
      categorySet.add(p.category);
    }
    categories.addAll(categorySet.toList()..sort());

    final filtered = _selectedCategory == 'Hamısı'
        ? products
        : products.where((p) => p.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bazar', style: AppTypography.headline),
                  const SizedBox(height: 4),
                  Text(
                    playerState == null
                        ? 'Yüklənir...'
                        : '${products.length} məhsul • Kapital: ${playerState.capital.toStringAsFixed(0)} ₼',
                    style: AppTypography.bodySecondary,
                  ),
                ],
              ),
            ),
            if (products.isNotEmpty)
              SizedBox(
                height: 42,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (ctx, i) {
                    final cat = categories[i];
                    return CategoryChip(
                      label: cat,
                      selected: _selectedCategory == cat,
                      onTap: () => setState(() => _selectedCategory = cat),
                    );
                  },
                ),
              ),
            const SizedBox(height: 12),
            Expanded(
              child: products.isEmpty
                  ? const EmptyState(
                      icon: Icons.store_outlined,
                      title: 'Bazar yüklənir',
                      description: 'Zəhmət olmasa bir az gözlə.',
                    )
                  : filtered.isEmpty
                      ? const EmptyState(
                          icon: Icons.inbox_outlined,
                          title: 'Bu kateqoriyada məhsul yoxdur',
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (ctx, i) {
                            final product = filtered[i];
                            final changePercent =
                                service.trendValue(product) * 100;
                            return MarketTile(
                              product: product,
                              changePercent: changePercent,
                              onTap: () => _openInvestment(product),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
