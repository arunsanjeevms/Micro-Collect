import 'package:flutter_test/flutter_test.dart';
import 'package:microcollect/core/utils/loan_calculator.dart';

void main() {
  group('totalRepayable', () {
    test('adds simple interest to principal', () {
      // Mirrors mock loan L001: ₹20,000 @ 24% for 10 months → ₹24,000
      expect(
        LoanCalculator.totalRepayable(
          principal: 20000,
          annualRate: 24,
          tenureMonths: 10,
        ),
        24000,
      );
    });

    test('returns principal when rate is zero', () {
      expect(
        LoanCalculator.totalRepayable(
          principal: 15000,
          annualRate: 0,
          tenureMonths: 12,
        ),
        15000,
      );
    });
  });

  group('simpleInterest', () {
    test('prorates the annual rate over the tenure in months', () {
      expect(
        LoanCalculator.simpleInterest(
          principal: 20000,
          annualRate: 24,
          tenureMonths: 10,
        ),
        4000,
      );
    });

    test('a full year of interest equals principal times rate', () {
      expect(
        LoanCalculator.simpleInterest(
          principal: 10000,
          annualRate: 20,
          tenureMonths: 12,
        ),
        2000,
      );
    });
  });

  group('installmentAmount', () {
    test('divides evenly when the total splits cleanly', () {
      expect(
        LoanCalculator.installmentAmount(
          totalRepayable: 24000,
          numberOfInstallments: 10,
        ),
        2400,
      );
    });

    test('rounds up so instalments never under-collect', () {
      expect(
        LoanCalculator.installmentAmount(
          totalRepayable: 10000,
          numberOfInstallments: 3,
        ),
        3334,
      );
    });

    test('returns zero rather than dividing by zero', () {
      expect(
        LoanCalculator.installmentAmount(
          totalRepayable: 24000,
          numberOfInstallments: 0,
        ),
        0,
      );
    });
  });

  group('advanceDeduction', () {
    test('deducts the given number of instalments up front', () {
      expect(
        LoanCalculator.advanceDeduction(
          totalRepayable: 24000,
          advanceInstallments: 2,
          totalInstallments: 10,
        ),
        4800,
      );
    });

    test('deducts nothing when no advance is taken', () {
      expect(
        LoanCalculator.advanceDeduction(
          totalRepayable: 24000,
          advanceInstallments: 0,
          totalInstallments: 10,
        ),
        0,
      );
    });

    test('returns zero rather than dividing by zero', () {
      expect(
        LoanCalculator.advanceDeduction(
          totalRepayable: 24000,
          advanceInstallments: 2,
          totalInstallments: 0,
        ),
        0,
      );
    });
  });

  group('disbursementAmount', () {
    test('hands over principal less the advance deduction', () {
      expect(
        LoanCalculator.disbursementAmount(
          principal: 20000,
          advanceDeduction: 4800,
        ),
        15200,
      );
    });
  });

  group('outstandingBalance', () {
    test('is the unpaid remainder', () {
      // Mirrors mock loan L001: ₹24,000 repayable, ₹14,200 paid
      expect(
        LoanCalculator.outstandingBalance(
          totalRepayable: 24000,
          totalPaid: 14200,
        ),
        9800,
      );
    });

    test('clamps to zero on overpayment rather than going negative', () {
      expect(
        LoanCalculator.outstandingBalance(
          totalRepayable: 24000,
          totalPaid: 30000,
        ),
        0,
      );
    });
  });

  group('penaltyAmount', () {
    test('charges the rate pro rata over a 30-day month', () {
      expect(
        LoanCalculator.penaltyAmount(
          installmentAmount: 2200,
          penaltyRate: 2,
          overdueDays: 15,
        ),
        22,
      );
    });

    test('charges nothing when not overdue', () {
      expect(
        LoanCalculator.penaltyAmount(
          installmentAmount: 2200,
          penaltyRate: 2,
          overdueDays: 0,
        ),
        0,
      );
    });
  });

  group('installmentCount', () {
    test('treats a month as 30 days for daily collection', () {
      expect(
        LoanCalculator.installmentCount(tenureMonths: 6, frequency: 'daily'),
        180,
      );
    });

    test('rounds weekly instalments up to cover the full tenure', () {
      // 6 months → 180 days → 25.7 weeks → 26 collections
      expect(
        LoanCalculator.installmentCount(tenureMonths: 6, frequency: 'weekly'),
        26,
      );
    });

    test('monthly collection is one instalment per month', () {
      expect(
        LoanCalculator.installmentCount(tenureMonths: 6, frequency: 'monthly'),
        6,
      );
    });

    test('is case insensitive', () {
      expect(
        LoanCalculator.installmentCount(tenureMonths: 6, frequency: 'DAILY'),
        180,
      );
    });

    test('falls back to monthly for an unknown frequency', () {
      expect(
        LoanCalculator.installmentCount(tenureMonths: 6, frequency: 'yearly'),
        6,
      );
    });
  });

  group('collectionEfficiency', () {
    test('is collected as a percentage of due', () {
      expect(
        LoanCalculator.collectionEfficiency(collected: 25000, due: 50000),
        50,
      );
    });

    test('is 100% when nothing was due', () {
      expect(LoanCalculator.collectionEfficiency(collected: 0, due: 0), 100);
    });

    test('clamps over-collection to 100%', () {
      expect(LoanCalculator.collectionEfficiency(collected: 100, due: 50), 100);
    });
  });
}
