import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../domain/services/loan_service.dart';

class LoanModal extends StatefulWidget {
  const LoanModal({
    required this.loanService,
    required this.playerCapital,
    required this.playerDailyIncome,
    required this.playerReputation,
    required this.onConfirm,
    super.key,
  });

  final LoanService loanService;
  final double playerCapital;
  final double playerDailyIncome;
  final int playerReputation;
  final void Function(double amount) onConfirm;

  @override
  State<LoanModal> createState() => _LoanModalState();
}

class _LoanModalState extends State<LoanModal> {
  double _amount = 1000;

  double get _maxAmount => widget.loanService.maxLoanAmount(
        capital: widget.playerCapital,
        dailyIncome: widget.playerDailyIncome,
        reputation: widget.playerReputation,
      );

  LoanOffer get _offer => widget.loanService.generateOffer(
        principal: _amount,
        reputation: widget.playerReputation,
      );

  @override
  void initState() {
    super.initState();
    final max = _maxAmount;
    if (max < 1000) {
      _amount = max < 100 ? 100 : max;
    } else {
      _amount = 1000;
    }
  }

  @override
  Widget build(BuildContext context) {
    final offer = _offer;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(20),
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
            Text('Kredit götür', style: AppTypography.headline),
            const SizedBox(height: 4),
            Text(
              'Faiz dərəcəsi reputasiyadan asılıdır.',
              style: AppTypography.bodySecondary,
            ),
            const SizedBox(height: 20),
            Text('Məbləğ seçin', style: AppTypography.title),
            const SizedBox(height: 8),
            Slider(
              value: _amount.clamp(0, _maxAmount),
              min: 0,
              max: _maxAmount > 100 ? _maxAmount : 100,
              divisions: 20,
              activeColor: AppColors.accent,
              inactiveColor: AppColors.surfaceElevated,
              onChanged: (v) => setState(() {
                _amount = (v / 100).round() * 100.0;
                if (_amount < 100) _amount = 100;
              }),
            ),
            Center(
              child: Text(
                Formatters.money(_amount),
                style: AppTypography.statValue.copyWith(
                  color: AppColors.accent,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _Row(
                    label: 'Maksimum',
                    value: Formatters.moneyShort(_maxAmount),
                  ),
                  const Divider(height: 16),
                  _Row(
                    label: 'Faiz dərəcəsi',
                    value: '${(offer.interestRate * 100).toStringAsFixed(2)}%',
                    valueColor: AppColors.warning,
                  ),
                  const Divider(height: 16),
                  _Row(
                    label: 'Müddət',
                    value: '${offer.termDays} gün',
                  ),
                  const Divider(height: 16),
                  _Row(
                    label: 'Ümumi qaytarılacaq',
                    value: Formatters.money(offer.totalDue),
                    valueColor: AppColors.danger,
                    bold: true,
                  ),
                  const Divider(height: 16),
                  _Row(
                    label: 'Gündəlik ödəniş',
                    value: Formatters.money(offer.dailyPayment),
                    valueColor: AppColors.warning,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _amount > 0
                    ? () {
                        Navigator.of(context).pop();
                        widget.onConfirm(_amount);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'KREDİTİ GÖTÜR',
                  style: AppTypography.button,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
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
