class GameBalance {
  GameBalance._();

  static const double loanInterestMin = 0.08;
  static const double loanInterestMax = 0.25;
  static const int loanTermMinDays = 7;
  static const int loanTermMaxDays = 60;

  static const double reputationEventWeight = 0.15;
  static const double riskReputationMultiplier = 0.2;

  static const double businessMaintenanceRate = 0.05;
  static const double businessGrowthRate = 0.02;

  static const int dailyEventCount = 3;
  static const int startingNpcCount = 3;

  static const double failRecoveryThreshold = 0.3;
}
