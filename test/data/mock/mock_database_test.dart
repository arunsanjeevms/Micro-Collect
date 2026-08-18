import 'package:flutter_test/flutter_test.dart';
import 'package:microcollect/core/data/entity_kind.dart';
import 'package:microcollect/core/errors/app_exception.dart';
import 'package:microcollect/core/models/borrower.dart';
import 'package:microcollect/core/models/collection_entry.dart';
import 'package:microcollect/core/models/installment.dart';
import 'package:microcollect/core/models/loan.dart';
import 'package:microcollect/data/mock/mock_database.dart';
import 'package:microcollect/data/repositories/borrower_repository.dart';
import 'package:microcollect/data/repositories/collection_repository.dart';
import 'package:microcollect/data/repositories/loan_repository.dart';

void main() {
  group('MockDatabase seed data', () {
    late MockDatabase db;

    setUp(() => db = MockDatabase());
    tearDown(() => db.dispose());

    test('seeds one loan per borrower it references, with matching ids', () {
      // This is a regression test for the original static MockData, where
      // three collection entries (C005/C006/C007) pointed at another
      // borrower's loan - invisible while data was read-only, but silently
      // wrong the moment a payment could actually credit the wrong account.
      for (final loan in db.loans()) {
        final borrower = db.borrower(loan.borrowerId);
        expect(
          borrower,
          isNotNull,
          reason: '${loan.id} references missing borrower ${loan.borrowerId}',
        );
      }
    });

    test('every seeded borrower has at least one loan', () {
      for (final borrower in db.borrowers()) {
        expect(
          db.loansForBorrower(borrower.id),
          isNotEmpty,
          reason: '${borrower.id} (${borrower.name}) has no loans',
        );
      }
    });

    test('every today collection entry references a loan owned by the same borrower', () {
      for (final entry in db.collectionsForDate(DateTime.now())) {
        final loan = db.loan(entry.loanId);
        expect(
          loan,
          isNotNull,
          reason: '${entry.id} references missing loan ${entry.loanId}',
        );
        expect(
          loan!.borrowerId,
          entry.borrowerId,
          reason:
              '${entry.id} claims borrower ${entry.borrowerId} but '
              '${entry.loanId} belongs to ${loan.borrowerId}',
        );
      }
    });

    test('borrower.activeLoans/totalOutstanding/status are derived from loans, not seeded literals', () {
      final borrower = db.borrower(
        'B002',
      )!; // Lakshmi Devi: L002 (overdue) + L003 (active)
      final loans = db.loansForBorrower('B002');

      expect(borrower.activeLoans, loans.length);
      expect(
        borrower.totalOutstanding,
        loans.fold<double>(0, (sum, l) => sum + l.outstanding),
      );
      expect(borrower.status, BorrowerStatus.overdue);
    });

    test('a borrower whose only loan is closed is itself closed', () {
      final borrower = db.borrower('B004')!; // Padma Kumari: L005 closed
      expect(borrower.activeLoans, 0);
      expect(borrower.totalOutstanding, 0);
      expect(borrower.status, BorrowerStatus.closed);
    });

    test('a generated loan schedule sums to the loan\'s totalRepayable', () {
      final loan = db.loan('L003')!; // Lakshmi Devi's second loan, generated
      final scheduleTotal = loan.installments.fold<double>(
        0,
        (sum, i) => sum + i.amount,
      );
      expect(scheduleTotal, closeTo(loan.totalRepayable, 1));
    });

    test('a generated loan\'s paid instalments sum to totalPaid', () {
      final loan = db.loan('L006')!;
      final paidTotal = loan.installments
          .where((i) => i.status.name == 'paid')
          .fold<double>(0, (sum, i) => sum + i.amount);
      expect(paidTotal, closeTo(loan.totalPaid, 1));
    });
  });

  group('MockDatabase.insertBorrower', () {
    late MockDatabase db;

    setUp(() => db = MockDatabase());
    tearDown(() => db.dispose());

    test('assigns a fresh id after the highest existing one', () {
      final before = db.borrowers().length;

      final created = db.insertBorrower(
        const BorrowerDraft(
          name: 'Test Borrower',
          mobile: '9000000000',
          aadhaar: '111122223333',
          village: 'Testville',
          address: 'Test address',
          pinCode: '500001',
        ),
      );

      expect(created.id, 'B009');
      expect(db.borrowers(), hasLength(before + 1));
      expect(db.borrower(created.id), created);
    });

    test('starts a new borrower with no loans and zero outstanding', () {
      final created = db.insertBorrower(
        const BorrowerDraft(
          name: 'Test Borrower',
          mobile: '9000000000',
          aadhaar: '111122223333',
          village: 'Testville',
          address: 'Test address',
          pinCode: '500001',
        ),
      );

      expect(created.activeLoans, 0);
      expect(created.totalOutstanding, 0);
      expect(created.status, BorrowerStatus.active);
    });

    test('emits a borrower change', () async {
      final future = db.changes.first;

      db.insertBorrower(
        const BorrowerDraft(
          name: 'Test Borrower',
          mobile: '9000000000',
          aadhaar: '111122223333',
          village: 'Testville',
          address: 'Test address',
          pinCode: '500001',
        ),
      );

      final change = await future;
      expect(change.kinds, {EntityKind.borrower});
    });
  });

  group('MockDatabase.insertLoan', () {
    late MockDatabase db;

    setUp(() => db = MockDatabase());
    tearDown(() => db.dispose());

    test('rejects a loan for a borrower that does not exist', () {
      expect(
        () => db.insertLoan(
          const LoanDraft(
            borrowerId: 'B999',
            principal: 10000,
            annualRate: 24,
            tenureMonths: 6,
            frequency: 'monthly',
          ),
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('generates a schedule and recomputes the borrower', () {
      final before = db.borrower(
        'B004',
      )!; // Padma Kumari: closed, no outstanding

      final loan = db.insertLoan(
        const LoanDraft(
          borrowerId: 'B004',
          principal: 12000,
          annualRate: 24,
          tenureMonths: 6,
          frequency: 'monthly',
        ),
      );

      expect(loan.borrowerId, 'B004');
      expect(loan.borrowerName, before.name);
      expect(loan.installments, hasLength(loan.totalInstallments));
      expect(loan.status, LoanStatus.disbursed);

      final after = db.borrower('B004')!;
      expect(after.activeLoans, 1);
      expect(after.totalOutstanding, closeTo(loan.totalRepayable, 1));
      expect(after.status, BorrowerStatus.active);
    });
  });

  group('MockDatabase.recordPayment', () {
    late MockDatabase db;

    setUp(() => db = MockDatabase());
    tearDown(() => db.dispose());

    test('rejects a non-positive amount', () {
      expect(
        () => db.recordPayment(
          const RecordPaymentInput(
            collectionId: 'C006',
            amount: 0,
            mode: PaymentMode.cash,
          ),
        ),
        throwsA(isA<ValidationException>()),
      );
    });

    test('rejects an unknown collection entry', () {
      expect(
        () => db.recordPayment(
          const RecordPaymentInput(
            collectionId: 'C999',
            amount: 100,
            mode: PaymentMode.cash,
          ),
        ),
        throwsA(isA<NotFoundException>()),
      );
    });

    test('a full payment marks the collection entry collected', () {
      final entryBefore = db
          .collectionsForDate(DateTime.now())
          .firstWhere((c) => c.id == 'C006'); // Mahesh Goud, pending, due 1520

      final receipt = db.recordPayment(
        RecordPaymentInput(
          collectionId: 'C006',
          amount: entryBefore.amountDue,
          mode: PaymentMode.upi,
        ),
      );

      final entryAfter = db
          .collectionsForDate(DateTime.now())
          .firstWhere((c) => c.id == 'C006');
      expect(entryAfter.status, CollectionStatus.collected);
      expect(entryAfter.amountPaid, entryBefore.amountDue);
      expect(entryAfter.paymentMode, PaymentMode.upi);
      expect(receipt.payment.amount, entryBefore.amountDue);
      expect(receipt.payment.mode, PaymentMode.upi);
    });

    test(
      'a partial payment marks the collection entry partial, not collected',
      () {
        final entryBefore = db
            .collectionsForDate(DateTime.now())
            .firstWhere((c) => c.id == 'C006');

        db.recordPayment(
          RecordPaymentInput(
            collectionId: 'C006',
            amount: entryBefore.amountDue / 2,
            mode: PaymentMode.cash,
          ),
        );

        final entryAfter = db
            .collectionsForDate(DateTime.now())
            .firstWhere((c) => c.id == 'C006');
        expect(entryAfter.status, CollectionStatus.partial);
        expect(entryAfter.amountPaid, entryBefore.amountDue / 2);
      },
    );

    test('a payment covering previousDue and amountDue together collects the entry', () {
      final entryBefore = db
          .collectionsForDate(DateTime.now())
          .firstWhere(
            (c) => c.id == 'C004',
          ); // Lakshmi Devi: previousDue 640 + amountDue 640
      expect(entryBefore.previousDue, greaterThan(0));

      db.recordPayment(
        RecordPaymentInput(
          collectionId: 'C004',
          amount: entryBefore.totalDue,
          mode: PaymentMode.cash,
        ),
      );

      final entryAfter = db
          .collectionsForDate(DateTime.now())
          .firstWhere((c) => c.id == 'C004');
      expect(entryAfter.status, CollectionStatus.collected);
    });

    test('updates the loan\'s totalPaid and marks the paid instalment', () {
      final loanBefore = db.loan('L008')!; // Mahesh Goud's loan (C006)
      final loanTotalPaidBefore = loanBefore.totalPaid;

      db.recordPayment(
        const RecordPaymentInput(
          collectionId: 'C006',
          amount: 1520,
          mode: PaymentMode.upi,
        ),
      );

      final loanAfter = db.loan('L008')!;
      expect(loanAfter.totalPaid, loanTotalPaidBefore + 1520);
      expect(
        loanAfter.installments.any((i) => i.status == InstallmentStatus.paid),
        isTrue,
      );
    });

    test(
      'closes the loan when the payment brings totalPaid to totalRepayable',
      () {
        final loan = db.loan('L006')!; // Venkat Rao, active
        final outstanding = loan.outstanding;

        db.recordPayment(
          RecordPaymentInput(
            collectionId: 'C003', // Venkat Rao's today entry, loan L006
            amount: outstanding,
            mode: PaymentMode.cash,
          ),
        );

        final loanAfter = db.loan('L006')!;
        expect(loanAfter.status, LoanStatus.closed);
        expect(loanAfter.closedDate, isNotNull);
        expect(loanAfter.outstanding, 0);
      },
    );

    test('recomputes the borrower\'s outstanding balance after payment', () {
      final loan = db.loan('L006')!;
      final borrowerBefore = db.borrower('B005')!;

      db.recordPayment(
        const RecordPaymentInput(
          collectionId: 'C003',
          amount: 1000,
          mode: PaymentMode.cash,
        ),
      );

      final borrowerAfter = db.borrower('B005')!;
      expect(
        borrowerAfter.totalOutstanding,
        closeTo(borrowerBefore.totalOutstanding - 1000, 0.01),
      );
      expect(loan.borrowerId, 'B005');
    });

    test(
      'records a Payment with a receipt number and returns it in the receipt',
      () {
        final receipt = db.recordPayment(
          const RecordPaymentInput(
            collectionId: 'C006',
            amount: 500,
            mode: PaymentMode.cash,
            notes: 'Partial today',
          ),
        );

        expect(receipt.payment.receiptNo, startsWith('RCP-'));
        expect(receipt.payment.borrowerId, 'B007');
        expect(receipt.payment.loanId, 'L008');
        expect(receipt.payment.notes, 'Partial today');
        expect(db.paymentsForLoan('L008'), contains(receipt.payment));
      },
    );

    test('paymentsForBorrower returns only that borrower\'s payments, newest first', () {
      db.recordPayment(
        const RecordPaymentInput(
          collectionId: 'C006',
          amount: 500,
          mode: PaymentMode.cash,
        ),
      );
      db.recordPayment(
        const RecordPaymentInput(
          collectionId: 'C006',
          amount: 300,
          mode: PaymentMode.cash,
        ),
      );

      final payments = db.paymentsForBorrower('B007');
      expect(payments, hasLength(2));
      expect(payments.first.amount, 300); // most recent first
    });

    test(
      'emits a DataChange covering loan, borrower, collection and payment',
      () async {
        final future = db.changes.first;

        db.recordPayment(
          const RecordPaymentInput(
            collectionId: 'C006',
            amount: 500,
            mode: PaymentMode.cash,
          ),
        );

        final change = await future;
        expect(
          change.kinds,
          containsAll({
            EntityKind.loan,
            EntityKind.installment,
            EntityKind.borrower,
            EntityKind.collection,
            EntityKind.payment,
          }),
        );
      },
    );
  });

  group('MockDatabase.reset / loadDemo', () {
    test('reset clears every collection', () {
      final db = MockDatabase();
      db.reset();

      expect(db.borrowers(), isEmpty);
      expect(db.loans(), isEmpty);
      expect(db.collectionsForDate(DateTime.now()), isEmpty);
      expect(db.weeklyCollections(), isEmpty);

      db.dispose();
    });

    test('loadDemo repopulates after a reset', () {
      final db = MockDatabase();
      db.reset();
      db.loadDemo();

      expect(db.borrowers(), isNotEmpty);
      expect(db.loans(), isNotEmpty);

      db.dispose();
    });
  });
}
