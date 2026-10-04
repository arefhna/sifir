import '../../core/utils/random_utils.dart';

class RiskResult {
  const RiskResult({
    required this.success,
    required this.actualReward,
    required this.message,
  });

  final bool success;
  final double actualReward;
  final String message;
}

class RiskService {
  const RiskService();

  int applyDelta(int current, int delta) => (current + delta).clamp(0, 100);

  int effectiveRiskPercent({
    required int baseRisk,
    required int playerRisk,
    required int reputation,
    required double debt,
  }) {
    double risk = baseRisk.toDouble();
    risk += playerRisk * 0.2;
    if (reputation < 30) risk += 10;
    if (reputation >= 80) risk -= 10;
    if (debt > 0) risk += 5;
    return risk.clamp(0, 95).round();
  }

  RiskResult resolve({
    required int effectiveRiskPercent,
    required double expectedReward,
    required String successMessage,
    required String failMessage,
  }) {
    final failProbability = effectiveRiskPercent / 100.0;
    final success = !RandomUtils.chance(failProbability);

    if (!success) {
      return RiskResult(
        success: false,
        actualReward: 0,
        message: failMessage.isEmpty ? 'Uğursuz nəticə.' : failMessage,
      );
    }

    final factor = RandomUtils.doubleInRange(0.7, 1.5);
    final reward = double.parse((expectedReward * factor).toStringAsFixed(2));

    return RiskResult(
      success: true,
      actualReward: reward,
      message: successMessage.isEmpty ? 'Uğurlu nəticə!' : successMessage,
    );
  }

  int dailyRiskDrift({
    required double debt,
    required int activeLoans,
    required double capital,
  }) {
    if (debt > 0) return 2;
    if (activeLoans > 0) return 1;
    if (capital > 50000) return -2;
    if (capital > 10000) return -1;
    return 0;
  }

  bool isCritical(int risk) => risk >= 95;

  String riskLabel(int risk) {
    if (risk <= 20) return 'Aşağı';
    if (risk <= 40) return 'Orta';
    if (risk <= 60) return 'Yüksək';
    if (risk <= 80) return 'Çox yüksək';
    return 'Kritik';
  }
}
