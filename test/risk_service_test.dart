import 'package:flutter_test/flutter_test.dart';
import 'package:sifir/domain/services/risk_service.dart';

void main() {
  group('RiskService', () {
    final service = const RiskService();

    test('applyDelta clamps to 0..100', () {
      expect(service.applyDelta(50, 10), 60);
      expect(service.applyDelta(5, -20), 0);
      expect(service.applyDelta(95, 20), 100);
    });

    test('effectiveRiskPercent penalizes low reputation', () {
      final low = service.effectiveRiskPercent(
        baseRisk: 50,
        playerRisk: 20,
        reputation: 10,
        debt: 0,
      );
      final high = service.effectiveRiskPercent(
        baseRisk: 50,
        playerRisk: 20,
        reputation: 90,
        debt: 0,
      );
      expect(low, greaterThan(high));
    });

    test('effectiveRiskPercent clamps to 95', () {
      final r = service.effectiveRiskPercent(
        baseRisk: 100,
        playerRisk: 100,
        reputation: 0,
        debt: 10000,
      );
      expect(r, 95);
    });

    test('resolve returns a result', () {
      final result = service.resolve(
        effectiveRiskPercent: 0,
        expectedReward: 1000,
        successMessage: 'OK',
        failMessage: 'FAIL',
      );
      expect(result.success, true);
      expect(result.actualReward, greaterThan(0));
    });

    test('resolve with 100% risk always fails', () {
      final result = service.resolve(
        effectiveRiskPercent: 100,
        expectedReward: 1000,
        successMessage: 'OK',
        failMessage: 'FAIL',
      );
      expect(result.success, false);
      expect(result.actualReward, 0);
    });

    test('riskLabel returns correct labels', () {
      expect(service.riskLabel(10), 'Aşağı');
      expect(service.riskLabel(50), 'Yüksək');
      expect(service.riskLabel(99), 'Kritik');
    });
  });
}
