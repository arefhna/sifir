import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static final NumberFormat _money = NumberFormat('#,##0', 'en_US');
  static final NumberFormat _moneyDecimal = NumberFormat('#,##0.00', 'en_US');
  static final DateFormat _date = DateFormat('dd.MM.yyyy');

  static String money(double value) {
    final abs = value.abs();
    final formatted = abs >= 1000
        ? _money.format(abs.round())
        : _moneyDecimal.format(abs);
    return '${value < 0 ? '-' : ''}$formatted ₼';
  }

  static String moneyShort(double value) {
    final abs = value.abs();
    final sign = value < 0 ? '-' : '';
    if (abs >= 1000000) {
      return '$sign${(abs / 1000000).toStringAsFixed(1)}M ₼';
    }
    if (abs >= 1000) {
      return '$sign${(abs / 1000).toStringAsFixed(1)}K ₼';
    }
    return '$sign${_money.format(abs.round())} ₼';
  }

  static String percent(num value) => '${value.toStringAsFixed(0)}%';

  static String date(DateTime date) => _date.format(date);

  static String dayLabel(int day) => 'Gün $day';
}
