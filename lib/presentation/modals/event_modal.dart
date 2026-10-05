import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/event_model.dart';

class EventModal extends StatelessWidget {
  const EventModal({
    required this.event,
    required this.playerCapital,
    required this.onChoiceSelected,
    super.key,
  });

  final GameEvent event;
  final double playerCapital;
  final void Function(EventChoice choice) onChoiceSelected;

  @override
  Widget build(BuildContext context) {
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
            _TypeBadge(type: event.type),
            const SizedBox(height: 12),
            Text(event.title, style: AppTypography.headline),
            const SizedBox(height: 8),
            Text(event.description, style: AppTypography.bodySecondary),
            const SizedBox(height: 20),
            ...event.choices.map((choice) {
              final canAfford = playerCapital >= choice.cost;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ChoiceTile(
                  choice: choice,
                  canAfford: canAfford,
                  onTap: canAfford
                      ? () {
                          Navigator.of(context).pop();
                          onChoiceSelected(choice);
                        }
                      : null,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});

  final EventType type;

  @override
  Widget build(BuildContext context) {
    late Color color;
    late String label;
    switch (type) {
      case EventType.opportunity:
        color = AppColors.success;
        label = 'FÜRSƏT';
        break;
      case EventType.threat:
        color = AppColors.danger;
        label = 'TƏHLÜKƏ';
        break;
      case EventType.neutral:
        color = AppColors.info;
        label = 'HADİSƏ';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    required this.choice,
    required this.canAfford,
    required this.onTap,
  });

  final EventChoice choice;
  final bool canAfford;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceElevated,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    choice.label,
                    style: AppTypography.title.copyWith(
                      color: canAfford
                          ? AppColors.textPrimary
                          : AppColors.textMuted,
                    ),
                  ),
                  if (choice.cost > 0)
                    Text(
                      Formatters.money(choice.cost),
                      style: AppTypography.body.copyWith(
                        color: canAfford
                            ? AppColors.danger
                            : AppColors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(choice.description, style: AppTypography.caption),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 4,
                children: [
                  if (choice.expectedReward > 0)
                    _MiniStat(
                      icon: Icons.trending_up,
                      label:
                          'Gəlir: ${Formatters.moneyShort(choice.expectedReward)}',
                      color: AppColors.success,
                    ),
                  if (choice.riskPercent > 0)
                    _MiniStat(
                      icon: Icons.warning_amber_outlined,
                      label: 'Risk: ${choice.riskPercent}%',
                      color: AppColors.warning,
                    ),
                  if (choice.duration > 0)
                    _MiniStat(
                      icon: Icons.schedule,
                      label: '${choice.duration} gün',
                      color: AppColors.info,
                    ),
                  if (choice.reputationDelta != 0)
                    _MiniStat(
                      icon: choice.reputationDelta > 0
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      label:
                          '${choice.reputationDelta > 0 ? '+' : ''}${choice.reputationDelta} rep',
                      color: choice.reputationDelta > 0
                          ? AppColors.success
                          : AppColors.danger,
                    ),
                ],
              ),
              if (!canAfford && choice.cost > 0) ...[
                const SizedBox(height: 8),
                Text(
                  'Kifayət qədər kapital yoxdur',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.danger,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTypography.caption.copyWith(color: color),
        ),
      ],
    );
  }
}
