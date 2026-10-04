enum InvestmentStatus { active, success, failed }

class Investment {
  const Investment({
    required this.id,
    required this.title,
    required this.cost,
    required this.expectedReward,
    required this.riskPercent,
    required this.startDay,
    required this.duration,
    required this.endDay,
    required this.status,
    required this.actualReward,
  });

  final String id;
  final String title;
  final double cost;
  final double expectedReward;
  final int riskPercent;
  final int startDay;
  final int duration;
  final int endDay;
  final InvestmentStatus status;
  final double actualReward;

  bool isMatured(int currentDay) => currentDay >= endDay;

  Investment copyWith({
    InvestmentStatus? status,
    double? actualReward,
  }) =>
      Investment(
        id: id,
        title: title,
        cost: cost,
        expectedReward: expectedReward,
        riskPercent: riskPercent,
        startDay: startDay,
        duration: duration,
        endDay: endDay,
        status: status ?? this.status,
        actualReward: actualReward ?? this.actualReward,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'cost': cost,
        'expectedReward': expectedReward,
        'riskPercent': riskPercent,
        'startDay': startDay,
        'duration': duration,
        'endDay': endDay,
        'status': status.name,
        'actualReward': actualReward,
      };

  factory Investment.fromJson(Map<String, dynamic> json) => Investment(
        id: json['id'] as String,
        title: json['title'] as String,
        cost: (json['cost'] as num).toDouble(),
        expectedReward: (json['expectedReward'] as num).toDouble(),
        riskPercent: (json['riskPercent'] as num).toInt(),
        startDay: (json['startDay'] as num).toInt(),
        duration: (json['duration'] as num).toInt(),
        endDay: (json['endDay'] as num).toInt(),
        status: InvestmentStatus.values.firstWhere(
          (s) => s.name == json['status'],
          orElse: () => InvestmentStatus.active,
        ),
        actualReward: (json['actualReward'] as num).toDouble(),
      );
}
