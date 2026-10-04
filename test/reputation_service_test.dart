import 'package:flutter_test/flutter_test.dart';
import 'package:sifir/domain/services/reputation_service.dart';

void main() {
  group('ReputationService', () {
    final service = const ReputationService();

    test('tierFor returns correct tier names', () {
      expect(service.tierFor(0).name, 'Tanınmayan');
      expect(service.tierFor(25).name, 'Yeni başlayan');
      expect(service.tierFor(50).name, 'Etibarlı');
      expect(service.tierFor(70).name, 'Tanınmış');
      expect(service.tierFor(95).name, 'Güvənilən biznes sahibi');
    });

    test('applyDelta clamps to 0..100', () {
      expect(service.applyDelta(50, 10), 60);
      expect(service.applyDelta(5, -20), 0);
      expect(service.applyDelta(95, 20), 100);
    });

    test('bonusMultiplier scales with reputation', () {
      expect(service.bonusMultiplier(10), 1.0);
      expect(service.bonusMultiplier(95), 1.3);
    });

    test('meetsRequirement works', () {
      expect(service.meetsRequirement(50, 40), true);
      expect(service.meetsRequirement(30, 40), false);
    });
  });
}
