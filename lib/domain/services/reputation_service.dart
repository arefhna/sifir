class ReputationTier {
  const ReputationTier({
    required this.name,
    required this.minValue,
    required this.maxValue,
    required this.bonusMultiplier,
    required this.loanRateModifier,
  });

  final String name;
  final int minValue;
  final int maxValue;
  final double bonusMultiplier;
  final double loanRateModifier;
}

class ReputationService {
  const ReputationService();

  static const List<ReputationTier> tiers = [
    ReputationTier(
      name: 'Tanınmayan',
      minValue: 0,
      maxValue: 20,
      bonusMultiplier: 1.0,
      loanRateModifier: 0.15,
    ),
    ReputationTier(
      name: 'Yeni başlayan',
      minValue: 21,
      maxValue: 40,
      bonusMultiplier: 1.05,
      loanRateModifier: 0.10,
    ),
    ReputationTier(
      name: 'Etibarlı',
      minValue: 41,
      maxValue: 60,
      bonusMultiplier: 1.12,
      loanRateModifier: 0.05,
    ),
    ReputationTier(
      name: 'Tanınmış',
      minValue: 61,
      maxValue: 80,
      bonusMultiplier: 1.20,
      loanRateModifier: 0.0,
    ),
    ReputationTier(
      name: 'Güvənilən biznes sahibi',
      minValue: 81,
      maxValue: 100,
      bonusMultiplier: 1.30,
      loanRateModifier: -0.03,
    ),
  ];

  ReputationTier tierFor(int reputation) {
    final clamped = reputation.clamp(0, 100);
    for (final tier in tiers) {
      if (clamped >= tier.minValue && clamped <= tier.maxValue) {
        return tier;
      }
    }
    return tiers.first;
  }

  int applyDelta(int current, int delta) {
    final next = current + delta;
    return next.clamp(0, 100);
  }

  double bonusMultiplier(int reputation) => tierFor(reputation).bonusMultiplier;

  double loanRateModifier(int reputation) =>
      tierFor(reputation).loanRateModifier;

  bool meetsRequirement(int reputation, int requirement) =>
      reputation >= requirement;

  double eventWeightMultiplier(int reputation) {
    if (reputation >= 80) return 1.5;
    if (reputation >= 60) return 1.25;
    if (reputation >= 40) return 1.0;
    if (reputation >= 20) return 0.85;
    return 0.7;
  }

  String statusLabel(int reputation) => tierFor(reputation).name;
}
