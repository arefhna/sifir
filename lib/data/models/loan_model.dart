class Loan {
  const Loan({
    required this.id,
    required this.principal,
    required this.interestRate,
    required this.termDays,
    required this.startDay,
    required this.dueDay,
    required this.remaining,
    required this.paid,
  });

  final String id;
  final double principal;
  final double interestRate;
  final int termDays;
  final int startDay;
  final int dueDay;
  final double remaining;
  final double paid;

  double get totalDue => principal * (1 + interestRate);
  double get dailyPayment => totalDue / termDays;
  bool isOverdue(int currentDay) => currentDay > dueDay && remaining > 0;

  Loan copyWith({double? remaining, double? paid}) => Loan(
        id: id,
        principal: principal,
        interestRate: interestRate,
        termDays: termDays,
        startDay: startDay,
        dueDay: dueDay,
        remaining: remaining ?? this.remaining,
        paid: paid ?? this.paid,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'principal': principal,
        'interestRate': interestRate,
        'termDays': termDays,
        'startDay': startDay,
        'dueDay': dueDay,
        'remaining': remaining,
        'paid': paid,
      };

  factory Loan.fromJson(Map<String, dynamic> json) => Loan(
        id: json['id'] as String,
        principal: (json['principal'] as num).toDouble(),
        interestRate: (json['interestRate'] as num).toDouble(),
        termDays: (json['termDays'] as num).toInt(),
        startDay: (json['startDay'] as num).toInt(),
        dueDay: (json['dueDay'] as num).toInt(),
        remaining: (json['remaining'] as num).toDouble(),
        paid: (json['paid'] as num).toDouble(),
      );
}
