import '../../core/constants/game_balance.dart';
import '../../core/utils/random_utils.dart';
import '../../data/models/loan_model.dart';
import 'reputation_service.dart';

class LoanOffer {
  const LoanOffer({
    required this.principal,
    required this.interestRate,
    required this.termDays,
    required this.totalDue,
    required this.dailyPayment,
  });

  final double principal;
  final double interestRate;
  final int termDays;
  final double totalDue;
  final double dailyPayment;
}

class LoanService {
  LoanService(this._reputationService);

  final ReputationService _reputationService;

  LoanOffer generateOffer({
    required double principal,
    required int reputation,
  }) {
    final baseRate = RandomUtils.doubleInRange(
      GameBalance.loanInterestMin,
      GameBalance.loanInterestMax,
    );
    final modifier = _reputationService.loanRateModifier(reputation);
    final rate = (baseRate + modifier).clamp(0.05, 0.4);
    final term = RandomUtils.intInRange(
      GameBalance.loanTermMinDays,
      GameBalance.loanTermMaxDays,
    );
    final totalDue = principal * (1 + rate);
    final daily = totalDue / term;

    return LoanOffer(
      principal: principal,
      interestRate: double.parse(rate.toStringAsFixed(3)),
      termDays: term,
      totalDue: double.parse(totalDue.toStringAsFixed(2)),
      dailyPayment: double.parse(daily.toStringAsFixed(2)),
    );
  }

  Loan createLoan({
    required LoanOffer offer,
    required int currentDay,
  }) {
    return Loan(
      id: 'loan_${DateTime.now().microsecondsSinceEpoch}',
      principal: offer.principal,
      interestRate: offer.interestRate,
      termDays: offer.termDays,
      startDay: currentDay,
      dueDay: currentDay + offer.termDays,
      remaining: offer.totalDue,
      paid: 0,
    );
  }

  Loan applyDailyPayment(Loan loan) {
    if (loan.remaining <= 0) return loan;
    final payment = loan.dailyPayment;
    final applied = payment > loan.remaining ? loan.remaining : payment;
    return loan.copyWith(
      remaining: double.parse((loan.remaining - applied).toStringAsFixed(2)),
      paid: double.parse((loan.paid + applied).toStringAsFixed(2)),
    );
  }

  bool isFullyPaid(Loan loan) => loan.remaining <= 0.01;

  double overduePenalty(Loan loan, int currentDay) {
    if (!loan.isOverdue(currentDay)) return 0;
    final daysLate = currentDay - loan.dueDay;
    return double.parse((loan.remaining * 0.02 * daysLate).toStringAsFixed(2));
  }

  double maxLoanAmount({
    required double capital,
    required double dailyIncome,
    required int reputation,
  }) {
    final tierBonus = _reputationService.bonusMultiplier(reputation);
    final base = 500.0 + (capital * 0.5) + (dailyIncome * 10);
    return (base * tierBonus).clamp(500, 500000);
  }

  double totalDebt(List<Loan> loans) {
    return loans.fold<double>(0, (sum, l) => sum + l.remaining);
  }
}
