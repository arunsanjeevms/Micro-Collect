import 'package:flutter_test/flutter_test.dart';
import 'package:microcollect/core/models/installment.dart';
import 'package:microcollect/core/utils/payment_allocator.dart';

Installment _pending(String id, DateTime dueDate, double amount) => Installment(
  id: id,
  number: int.parse(id.substring(1)),
  dueDate: dueDate,
  amount: amount,
  status: InstallmentStatus.pending,
);

Installment _overdue(String id, DateTime dueDate, double amount) =>
    _pending(id, dueDate, amount).copyWith(status: InstallmentStatus.overdue);

Installment _partial(
  String id,
  DateTime dueDate,
  double amount,
  double paidSoFar,
) => _pending(
  id,
  dueDate,
  amount,
).copyWith(status: InstallmentStatus.partial, paidAmount: paidSoFar);

void main() {
  final asOf = DateTime(2026, 6, 15);

  group('exact payment', () {
    test('fully paying the only pending instalment marks it paid', () {
      final result = PaymentAllocator.allocate(
        installments: [_pending('I1', asOf, 2200)],
        amount: 2200,
        asOf: asOf,
      );

      expect(result.updatedInstallments.single.status, InstallmentStatus.paid);
      expect(result.updatedInstallments.single.paidAmount, 2200);
      expect(result.updatedInstallments.single.paidDate, asOf);
      expect(result.touchedInstallmentIds, ['I1']);
    });
  });

  group('partial payment', () {
    test('an amount less than the instalment marks it partial', () {
      final result = PaymentAllocator.allocate(
        installments: [_pending('I1', asOf, 2200)],
        amount: 1000,
        asOf: asOf,
      );

      final updated = result.updatedInstallments.single;
      expect(updated.status, InstallmentStatus.partial);
      expect(updated.paidAmount, 1000);
      expect(result.touchedInstallmentIds, ['I1']);
    });

    test('topping up an already-partial instalment can complete it', () {
      final result = PaymentAllocator.allocate(
        installments: [_partial('I1', asOf, 2200, 1000)],
        amount: 1200,
        asOf: asOf,
      );

      final updated = result.updatedInstallments.single;
      expect(updated.status, InstallmentStatus.paid);
      expect(updated.paidAmount, 2200);
    });

    test(
      'topping up an already-partial instalment can still leave it partial',
      () {
        final result = PaymentAllocator.allocate(
          installments: [_partial('I1', asOf, 2200, 1000)],
          amount: 500,
          asOf: asOf,
        );

        final updated = result.updatedInstallments.single;
        expect(updated.status, InstallmentStatus.partial);
        expect(updated.paidAmount, 1500);
      },
    );
  });

  group('ordering', () {
    test('pays the oldest overdue instalment before a newer pending one', () {
      final oldOverdue = _overdue('I1', DateTime(2026, 5, 15), 2200);
      final newPending = _pending('I2', DateTime(2026, 6, 15), 2200);

      final result = PaymentAllocator.allocate(
        installments: [newPending, oldOverdue],
        amount: 2200,
        asOf: asOf,
      );

      expect(result.touchedInstallmentIds, ['I1']);
      final byId = {for (final i in result.updatedInstallments) i.id: i};
      expect(byId['I1']!.status, InstallmentStatus.paid);
      expect(byId['I2']!.status, InstallmentStatus.pending);
    });

    test('multiple overdue instalments are paid oldest-due-date first', () {
      final older = _overdue('I1', DateTime(2026, 4, 15), 2200);
      final newer = _overdue('I2', DateTime(2026, 5, 15), 2200);

      final result = PaymentAllocator.allocate(
        installments: [newer, older],
        amount: 2200,
        asOf: asOf,
      );

      expect(result.touchedInstallmentIds, ['I1']);
    });

    test('paid and advance instalments are never re-touched', () {
      final alreadyPaid = Installment(
        id: 'I1',
        number: 1,
        dueDate: DateTime(2026, 5, 15),
        amount: 2200,
        paidAmount: 2200,
        paidDate: DateTime(2026, 5, 15),
        status: InstallmentStatus.paid,
      );
      final pending = _pending('I2', asOf, 2200);

      final result = PaymentAllocator.allocate(
        installments: [alreadyPaid, pending],
        amount: 2200,
        asOf: asOf,
      );

      expect(result.touchedInstallmentIds, ['I2']);
    });
  });

  group('advance payment', () {
    test('a surplus after the due instalment pays the next one in advance', () {
      final due = _pending('I1', asOf, 2200);
      final future = _pending('I2', DateTime(2026, 7, 15), 2200);

      final result = PaymentAllocator.allocate(
        installments: [due, future],
        amount: 4400,
        asOf: asOf,
      );

      final byId = {for (final i in result.updatedInstallments) i.id: i};
      expect(byId['I1']!.status, InstallmentStatus.paid);
      expect(byId['I2']!.status, InstallmentStatus.advance);
      expect(result.touchedInstallmentIds, ['I1', 'I2']);
    });

    test(
      'an instalment paid before its due date is marked advance, not paid',
      () {
        final future = _pending('I1', DateTime(2026, 7, 15), 2200);

        final result = PaymentAllocator.allocate(
          installments: [future],
          amount: 2200,
          asOf: asOf,
        );

        expect(
          result.updatedInstallments.single.status,
          InstallmentStatus.advance,
        );
      },
    );

    test('a partial surplus into a future instalment marks it partial, not advance', () {
      final due = _pending('I1', asOf, 2200);
      final future = _pending('I2', DateTime(2026, 7, 15), 2200);

      final result = PaymentAllocator.allocate(
        installments: [due, future],
        amount: 3000,
        asOf: asOf,
      );

      final byId = {for (final i in result.updatedInstallments) i.id: i};
      expect(byId['I1']!.status, InstallmentStatus.paid);
      expect(byId['I2']!.status, InstallmentStatus.partial);
      expect(byId['I2']!.paidAmount, 800);
    });
  });

  group('edge cases', () {
    test('a zero amount touches nothing', () {
      final result = PaymentAllocator.allocate(
        installments: [_pending('I1', asOf, 2200)],
        amount: 0,
        asOf: asOf,
      );

      expect(result.touchedInstallmentIds, isEmpty);
      expect(
        result.updatedInstallments.single.status,
        InstallmentStatus.pending,
      );
    });

    test('an amount exceeding every unpaid instalment leaves the surplus unapplied', () {
      final result = PaymentAllocator.allocate(
        installments: [_pending('I1', asOf, 2200)],
        amount: 5000,
        asOf: asOf,
      );

      final updated = result.updatedInstallments.single;
      expect(updated.status, InstallmentStatus.paid);
      expect(
        updated.paidAmount,
        2200,
      ); // not 5000 - never overpays an instalment
    });

    test('a closed loan with no unpaid instalments touches nothing', () {
      final result = PaymentAllocator.allocate(
        installments: [
          Installment(
            id: 'I1',
            number: 1,
            dueDate: asOf,
            amount: 2200,
            paidAmount: 2200,
            paidDate: asOf,
            status: InstallmentStatus.paid,
          ),
        ],
        amount: 1000,
        asOf: asOf,
      );

      expect(result.touchedInstallmentIds, isEmpty);
    });

    test('preserves instalment order and count in the returned list', () {
      final installments = [
        _pending('I1', asOf, 2200),
        _pending('I2', DateTime(2026, 7, 15), 2200),
        _pending('I3', DateTime(2026, 8, 15), 2200),
      ];

      final result = PaymentAllocator.allocate(
        installments: installments,
        amount: 2200,
        asOf: asOf,
      );

      expect(result.updatedInstallments.map((i) => i.id), ['I1', 'I2', 'I3']);
    });
  });
}
