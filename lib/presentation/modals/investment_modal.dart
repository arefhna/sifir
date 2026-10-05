import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/product_model.dart';
import '../../domain/services/market_service.dart';

class InvestmentModal extends StatefulWidget {
  const InvestmentModal({
    required this.product,
    required this.playerCapital,
    required this.playerReputation,
    required this.playerRisk,
    required this.marketService,
    required this.onConfirm,
    super.key,
  });

  final Product product;
  final double playerCapital;
  final int playerReputation;
  final int playerRisk;
  final MarketService marketService;
  final void Function(int quantity) onConfirm;

  @override
  State<InvestmentModal> createState() => _InvestmentModalState();
}

class _InvestmentModalState extends State<InvestmentModal> {
  int _quantity = 1;

  int get _maxAffordable {
    if (widget.product.currentPrice <= 0) return 0;
    return (widget.playerCapital / widget.product.currentPrice).floor();
  }

  @override
  void initState() {
    super.initState();
    if (_maxAffordable > 0) _quantity = 1;
  }

  double get _totalCost => widget.product.currentPrice * _quantity;

  double get _expectedReward {
    return widget.marketService.calculateExpectedReward(
      product: widget.product,
      quantity: _quantity,
      reputation: widget.playerReputation,
    );
  }

  int get _effectiveRisk {
    return widget.marketService.estimateRisk(
      product: widget.product,
      playerRisk: widget.playerRisk,
    );
  }

  void _increment() {
    if (_quantity < _maxAffordable) setState(() => _quantity++);
  }

  void _decrement() {
    if (_quantity > 1) setState(() => _quantity--);
  }

  @override
  Widget build(BuildContext context) {
    final canAfford = _totalCost <= widget.playerCapital && _maxAffordable > 0;
    final netProfit = _expectedReward - _totalCost;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(widget.product.name, style: AppTypography.headline),
            const SizedBox(height: 4),
            Text(widget.product.category, style: AppTypography.bodySecondary),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _InfoRow(
                    label: 'Vahid qiyməti',
                    value: Formatters.money(widget.product.currentPrice),
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    label: 'Sizin kapital',
                    value: Formatters.money(widget.playerCapital),
                    valueColor: AppColors.capital,
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    label: 'Alına bilər',
                    value: '$_maxAffordable ədəd',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (_maxAffordable > 0) ...[
              Text('Miqdar seçin', style: AppTypography.title),
              const SizedBox(height: 10),
              Row(
                children: [
                  _SquareButton(
                    icon: Icons.remove,
                    onTap: _quantity > 1 ? _decrement : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          '$_quantity',
                          style: AppTypography.statValue,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _SquareButton(
                    icon: Icons.add,
                    onTap: _quantity < _maxAffordable ? _increment : null,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _InfoRow(
                      label: 'Ümumi xərc',
                      value: Formatters.money(_totalCost),
                      valueColor: AppColors.danger,
                    ),
                    const Divider(height: 18),
                    _InfoRow(
                      label: 'Gözlənilən gəlir',
                      value: Formatters.money(_expectedReward),
                      valueColor: AppColors.success,
                    ),
                    const Divider(height: 18),
                    _InfoRow(
                      label: 'Xalis qazanc',
                      value: Formatters.money(netProfit),
                      valueColor: netProfit > 0
                          ? AppColors.success
                          : AppColors.danger,
                      bold: true,
                    ),
                    const Divider(height: 18),
                    _InfoRow(
                      label: 'Effektiv risk',
                      value: '$_effectiveRisk%',
                      valueColor: AppColors.warning,
                    ),
                    const Divider(height: 18),
                    _InfoRow(
                      label: 'Müddət',
                      value: '${widget.product.duration} gün',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: canAfford
                      ? () {
                          Navigator.of(context).pop();
                          widget.onConfirm(_quantity);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canAfford
                        ? AppColors.accent
                        : AppColors.surfaceElevated,
                    foregroundColor: canAfford
                        ? AppColors.background
                        : AppColors.textMuted,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    canAfford ? 'İNVESTİSİYA ET' : 'KAPİTAL YOXDUR',
                    style: AppTypography.button,
                  ),
                ),
              ),
            ] else
              Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      color: AppColors.textMuted,
                      size: 40,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Kifayət qədər kapital yoxdur',
                      style: AppTypography.title,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ən azı ${Formatters.money(widget.product.currentPrice)} lazımdır.',
                      style: AppTypography.bodySecondary,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.bold = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodySecondary),
        Text(
          value,
          style: AppTypography.body.copyWith(
            color: valueColor ?? AppColors.textPrimary,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _SquareButton extends StatelessWidget {
  const _SquareButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Material(
      color: enabled ? AppColors.accent : AppColors.surfaceElevated,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 52,
          height: 52,
          child: Icon(
            icon,
            color: enabled ? AppColors.background : AppColors.textMuted,
            size: 22,
          ),
        ),
      ),
    );
  }
}
