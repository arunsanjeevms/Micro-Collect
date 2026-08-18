import '../models/installment.dart';

/// Frontend-only instalment schedule generation, isolated for the same
/// reason as LoanCalculator: a future backend owns this for real.
class ScheduleBuilder {
  ScheduleBuilder._();

  /// Builds a fully-pending instalment schedule for a new loan, spaced out
  /// from [disbursementDate] according to [frequency].
  static List<Installment> build({
    required String loanId,
    required DateTime disbursementDate,
    required int totalInstallments,
    required double installmentAmount,
    required String frequency, // daily, weekly, monthly
  }) {
    return List.generate(totalInstallments, (i) {
      final number = i + 1;
      return Installment(
        id: '$loanId-I${number.toString().padLeft(3, '0')}',
        number: number,
        dueDate: _dueDate(disbursementDate, frequency, number),
        amount: installmentAmount,
        status: InstallmentStatus.pending,
      );
    });
  }

  static DateTime _dueDate(DateTime start, String frequency, int number) {
    switch (frequency.toLowerCase()) {
      case 'daily':
        return start.add(Duration(days: number));
      case 'weekly':
        return start.add(Duration(days: 7 * number));
      case 'monthly':
      default:
        return DateTime(start.year, start.month + number, start.day);
    }
  }
}
