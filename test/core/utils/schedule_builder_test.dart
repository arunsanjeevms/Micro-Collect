import 'package:flutter_test/flutter_test.dart';
import 'package:microcollect/core/models/installment.dart';
import 'package:microcollect/core/utils/schedule_builder.dart';

void main() {
  group('build', () {
    test('generates one pending instalment per period, all unpaid', () {
      final schedule = ScheduleBuilder.build(
        loanId: 'L001',
        disbursementDate: DateTime(2026, 1, 15),
        totalInstallments: 3,
        installmentAmount: 2400,
        frequency: 'monthly',
      );

      expect(schedule, hasLength(3));
      for (final installment in schedule) {
        expect(installment.status, InstallmentStatus.pending);
        expect(installment.amount, 2400);
        expect(installment.paidAmount, isNull);
        expect(installment.paidDate, isNull);
      }
    });

    test('numbers instalments sequentially starting at 1', () {
      final schedule = ScheduleBuilder.build(
        loanId: 'L001',
        disbursementDate: DateTime(2026, 1, 15),
        totalInstallments: 3,
        installmentAmount: 2400,
        frequency: 'monthly',
      );

      expect(schedule.map((i) => i.number), [1, 2, 3]);
    });

    test('ids are unique and derived from the loan id', () {
      final schedule = ScheduleBuilder.build(
        loanId: 'L001',
        disbursementDate: DateTime(2026, 1, 15),
        totalInstallments: 2,
        installmentAmount: 2400,
        frequency: 'monthly',
      );

      expect(schedule.map((i) => i.id), ['L001-I001', 'L001-I002']);
    });

    test('monthly instalments fall one calendar month apart', () {
      final schedule = ScheduleBuilder.build(
        loanId: 'L001',
        disbursementDate: DateTime(2026, 1, 15),
        totalInstallments: 3,
        installmentAmount: 2400,
        frequency: 'monthly',
      );

      expect(schedule[0].dueDate, DateTime(2026, 2, 15));
      expect(schedule[1].dueDate, DateTime(2026, 3, 15));
      expect(schedule[2].dueDate, DateTime(2026, 4, 15));
    });

    test('weekly instalments fall seven days apart', () {
      final schedule = ScheduleBuilder.build(
        loanId: 'L002',
        disbursementDate: DateTime(2026, 1, 1),
        totalInstallments: 3,
        installmentAmount: 640,
        frequency: 'weekly',
      );

      expect(schedule[0].dueDate, DateTime(2026, 1, 8));
      expect(schedule[1].dueDate, DateTime(2026, 1, 15));
      expect(schedule[2].dueDate, DateTime(2026, 1, 22));
    });

    test('daily instalments fall one day apart', () {
      final schedule = ScheduleBuilder.build(
        loanId: 'L004',
        disbursementDate: DateTime(2026, 1, 1),
        totalInstallments: 3,
        installmentAmount: 63,
        frequency: 'daily',
      );

      expect(schedule[0].dueDate, DateTime(2026, 1, 2));
      expect(schedule[1].dueDate, DateTime(2026, 1, 3));
      expect(schedule[2].dueDate, DateTime(2026, 1, 4));
    });

    test('falls back to monthly spacing for an unknown frequency', () {
      final schedule = ScheduleBuilder.build(
        loanId: 'L005',
        disbursementDate: DateTime(2026, 1, 15),
        totalInstallments: 1,
        installmentAmount: 1000,
        frequency: 'yearly',
      );

      expect(schedule.single.dueDate, DateTime(2026, 2, 15));
    });

    test('returns an empty schedule for zero instalments', () {
      final schedule = ScheduleBuilder.build(
        loanId: 'L006',
        disbursementDate: DateTime(2026, 1, 15),
        totalInstallments: 0,
        installmentAmount: 3050,
        frequency: 'monthly',
      );

      expect(schedule, isEmpty);
    });
  });
}
