import 'dart:math';

class RandomUtils {
  RandomUtils._();

  static final Random _r = Random();

  static int intInRange(int min, int max) {
    if (max <= min) return min;
    return min + _r.nextInt(max - min + 1);
  }

  static double doubleInRange(double min, double max) {
    if (max <= min) return min;
    return min + _r.nextDouble() * (max - min);
  }

  static bool chance(double probability) {
    if (probability <= 0) return false;
    if (probability >= 1) return true;
    return _r.nextDouble() < probability;
  }

  static T pick<T>(List<T> list) {
    return list[_r.nextInt(list.length)];
  }

  static List<T> pickMany<T>(List<T> list, int count) {
    final copy = List<T>.from(list)..shuffle(_r);
    return copy.take(count.clamp(0, copy.length)).toList();
  }

  static double variance(double base, double percent) {
    return base * (1 + doubleInRange(-percent, percent));
  }
}
