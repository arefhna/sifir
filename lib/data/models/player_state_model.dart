import 'business_model.dart';
import 'investment_model.dart';
import 'loan_model.dart';
import 'npc_model.dart';

class PlayerState {
  const PlayerState({
    required this.id,
    required this.playerName,
    required this.createdAt,
    required this.lastPlayedAt,
    required this.day,
    required this.capital,
    required this.reputation,
    required this.risk,
    required this.debt,
    required this.dailyIncome,
    required this.relationships,
    required this.ownedBusinesses,
    required this.activeInvestments,
    required this.activeLoans,
    required this.achievements,
    required this.completedChallenges,
    required this.inventory,
    required this.isGameOver,
    required this.gameOverReason,
  });

  final String id;
  final String playerName;
  final DateTime createdAt;
  final DateTime lastPlayedAt;
  final int day;
  final double capital;
  final int reputation;
  final int risk;
  final double debt;
  final double dailyIncome;
  final Map<String, RelationshipState> relationships;
  final List<OwnedBusiness> ownedBusinesses;
  final List<Investment> activeInvestments;
  final List<Loan> activeLoans;
  final Set<String> achievements;
  final Set<String> completedChallenges;
  final Map<String, int> inventory;
  final bool isGameOver;
  final String gameOverReason;

  static PlayerState initial(String playerName) {
    final now = DateTime.now();
    return PlayerState(
      id: now.millisecondsSinceEpoch.toString(),
      playerName: playerName,
      createdAt: now,
      lastPlayedAt: now,
      day: 1,
      capital: 0,
      reputation: 0,
      risk: 10,
      debt: 0,
      dailyIncome: 0,
      relationships: const {},
      ownedBusinesses: const [],
      activeInvestments: const [],
      activeLoans: const [],
      achievements: const {},
      completedChallenges: const {},
      inventory: const {},
      isGameOver: false,
      gameOverReason: '',
    );
  }

  PlayerState copyWith({
    DateTime? lastPlayedAt,
    int? day,
    double? capital,
    int? reputation,
    int? risk,
    double? debt,
    double? dailyIncome,
    Map<String, RelationshipState>? relationships,
    List<OwnedBusiness>? ownedBusinesses,
    List<Investment>? activeInvestments,
    List<Loan>? activeLoans,
    Set<String>? achievements,
    Set<String>? completedChallenges,
    Map<String, int>? inventory,
    bool? isGameOver,
    String? gameOverReason,
  }) =>
      PlayerState(
        id: id,
        playerName: playerName,
        createdAt: createdAt,
        lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
        day: day ?? this.day,
        capital: capital ?? this.capital,
        reputation: reputation ?? this.reputation,
        risk: risk ?? this.risk,
        debt: debt ?? this.debt,
        dailyIncome: dailyIncome ?? this.dailyIncome,
        relationships: relationships ?? this.relationships,
        ownedBusinesses: ownedBusinesses ?? this.ownedBusinesses,
        activeInvestments: activeInvestments ?? this.activeInvestments,
        activeLoans: activeLoans ?? this.activeLoans,
        achievements: achievements ?? this.achievements,
        completedChallenges: completedChallenges ?? this.completedChallenges,
        inventory: inventory ?? this.inventory,
        isGameOver: isGameOver ?? this.isGameOver,
        gameOverReason: gameOverReason ?? this.gameOverReason,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'playerName': playerName,
        'createdAt': createdAt.toIso8601String(),
        'lastPlayedAt': lastPlayedAt.toIso8601String(),
        'day': day,
        'capital': capital,
        'reputation': reputation,
        'risk': risk,
        'debt': debt,
        'dailyIncome': dailyIncome,
        'relationships': relationships.map((k, v) => MapEntry(k, v.toJson())),
        'ownedBusinesses':
            ownedBusinesses.map((b) => b.toJson()).toList(),
        'activeInvestments':
            activeInvestments.map((i) => i.toJson()).toList(),
        'activeLoans': activeLoans.map((l) => l.toJson()).toList(),
        'achievements': achievements.toList(),
        'completedChallenges': completedChallenges.toList(),
        'inventory': inventory,
        'isGameOver': isGameOver,
        'gameOverReason': gameOverReason,
      };

  factory PlayerState.fromJson(Map<String, dynamic> json) => PlayerState(
        id: json['id'] as String,
        playerName: json['playerName'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        lastPlayedAt: DateTime.parse(json['lastPlayedAt'] as String),
        day: (json['day'] as num).toInt(),
        capital: (json['capital'] as num).toDouble(),
        reputation: (json['reputation'] as num).toInt(),
        risk: (json['risk'] as num).toInt(),
        debt: (json['debt'] as num).toDouble(),
        dailyIncome: (json['dailyIncome'] as num).toDouble(),
        relationships: (json['relationships'] as Map).map(
          (k, v) => MapEntry(
            k as String,
            RelationshipState.fromJson(v as Map<String, dynamic>),
          ),
        ),
        ownedBusinesses: (json['ownedBusinesses'] as List)
            .map((b) => OwnedBusiness.fromJson(b as Map<String, dynamic>))
            .toList(),
        activeInvestments: (json['activeInvestments'] as List)
            .map((i) => Investment.fromJson(i as Map<String, dynamic>))
            .toList(),
        activeLoans: (json['activeLoans'] as List)
            .map((l) => Loan.fromJson(l as Map<String, dynamic>))
            .toList(),
        achievements:
            (json['achievements'] as List).map((e) => e as String).toSet(),
        completedChallenges: (json['completedChallenges'] as List)
            .map((e) => e as String)
            .toSet(),
        inventory: (json['inventory'] as Map).map(
          (k, v) => MapEntry(k as String, (v as num).toInt()),
        ),
        isGameOver: json['isGameOver'] as bool,
        gameOverReason: json['gameOverReason'] as String,
      );
}
