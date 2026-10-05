import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/player_state_model.dart';
import 'stat_card.dart';

class StatGrid extends StatelessWidget {
  const StatGrid({required this.state, super.key});

  final PlayerState state;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.55,
      children: [
        StatCard(
          label: 'KAPİTAL',
          value: Formatters.moneyShort(state.capital),
          icon: Icons.account_balance_wallet_outlined,
          color: AppColors.capital,
        ),
        StatCard(
          label: 'REPUTASİYA',
          value: '${state.reputation}/100',
          icon: Icons.verified_outlined,
          color: AppColors.reputation,
        ),
        StatCard(
          label: 'RİSK',
          value: '${state.risk}%',
          icon: Icons.warning_amber_outlined,
          color: AppColors.risk,
        ),
        StatCard(
          label: 'BORC',
          value: Formatters.moneyShort(state.debt),
          icon: Icons.credit_card_outlined,
          color: AppColors.debt,
        ),
      ],
    );
  }
}
