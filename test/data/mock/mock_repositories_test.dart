import 'package:flutter_test/flutter_test.dart';
import 'package:microcollect/data/dev/dev_settings.dart';
import 'package:microcollect/data/dev/latency_profile.dart';
import 'package:microcollect/data/dev/mock_op.dart';
import 'package:microcollect/data/mock/mock_borrower_repository.dart';
import 'package:microcollect/data/mock/mock_collection_repository.dart';
import 'package:microcollect/data/mock/mock_database.dart';
import 'package:microcollect/data/mock/mock_gateway.dart';
import 'package:microcollect/data/mock/mock_loan_repository.dart';
import 'package:microcollect/data/repositories/borrower_repository.dart';
import 'package:microcollect/data/repositories/collection_repository.dart';
import 'package:microcollect/data/repositories/loan_repository.dart';
import 'package:microcollect/core/errors/app_exception.dart';
import 'package:microcollect/core/models/collection_entry.dart';

MockGateway _instantGateway({Set<MockOp> failingOps = const {}}) => MockGateway(
  () => DevSettings(latency: LatencyProfile.instant, failingOps: failingOps),
);

void main() {
  group('MockBorrowerRepository', () {
    late MockDatabase db;

    setUp(() => db = MockDatabase());
    tearDown(() => db.dispose());

    test('fetchAll returns every seeded borrower', () async {
      final repo = MockBorrowerRepository(db, _instantGateway());
      final borrowers = await repo.fetchAll();
      expect(borrowers, hasLength(8));
    });

    test(
      'findById returns null for an unknown id rather than throwing',
      () async {
        final repo = MockBorrowerRepository(db, _instantGateway());
        final borrower = await repo.findById('B999');
        expect(borrower, isNull);
      },
    );

    test('create persists the borrower into the same database', () async {
      final repo = MockBorrowerRepository(db, _instantGateway());
      final created = await repo.create(
        const BorrowerDraft(
          name: 'New Borrower',
          mobile: '9000000001',
          aadhaar: '111111111111',
          village: 'Newtown',
          address: 'Address',
          pinCode: '500001',
        ),
      );
      expect(db.borrower(created.id), created);
    });

    test('surfaces a gateway failure as the injected exception', () {
      final repo = MockBorrowerRepository(
        db,
        _instantGateway(failingOps: {MockOp.read}),
      );
      expect(repo.fetchAll(), throwsA(isA<NetworkException>()));
    });
  });

  group('MockLoanRepository', () {
    late MockDatabase db;

    setUp(() => db = MockDatabase());
    tearDown(() => db.dispose());

    test('fetchForBorrower only returns that borrower\'s loans', () async {
      final repo = MockLoanRepository(db, _instantGateway());
      final loans = await repo.fetchForBorrower('B002');
      expect(loans, hasLength(2));
      expect(loans.every((l) => l.borrowerId == 'B002'), isTrue);
    });

    test('create disburses a new loan under the requested borrower', () async {
      final repo = MockLoanRepository(db, _instantGateway());
      final loan = await repo.create(
        const LoanDraft(
          borrowerId: 'B003',
          principal: 5000,
          annualRate: 18,
          tenureMonths: 4,
          frequency: 'monthly',
        ),
      );
      expect(loan.borrowerId, 'B003');
      expect(await repo.findById(loan.id), loan);
    });
  });

  group('MockCollectionRepository', () {
    late MockDatabase db;

    setUp(() => db = MockDatabase());
    tearDown(() => db.dispose());

    test('summaryForDate aggregates today\'s collection entries', () async {
      final repo = MockCollectionRepository(db, _instantGateway());
      final today = DateTime.now();

      final entries = await repo.fetchForDate(today);
      final summary = await repo.summaryForDate(today);

      final expectedDue = entries.fold<double>(0, (s, e) => s + e.amountDue);
      final expectedCollected = entries.fold<double>(
        0,
        (s, e) => s + (e.amountPaid ?? 0),
      );

      expect(summary.totalDue, expectedDue);
      expect(summary.totalCollected, expectedCollected);
      expect(
        summary.collectedCount +
            summary.pendingCount +
            summary.overdueCount +
            summary.partialCount,
        entries.length,
      );
    });

    test(
      'summaryForDate on a day with no entries is all zero, not an error',
      () async {
        final repo = MockCollectionRepository(db, _instantGateway());
        final summary = await repo.summaryForDate(DateTime(2000, 1, 1));

        expect(summary.totalDue, 0);
        expect(summary.totalCollected, 0);
        expect(summary.efficiency, 100);
      },
    );

    test(
      'recordPayment applies through the gateway and persists in the database',
      () async {
        final repo = MockCollectionRepository(db, _instantGateway());

        final receipt = await repo.recordPayment(
          const RecordPaymentInput(
            collectionId: 'C006',
            amount: 1520,
            mode: PaymentMode.upi,
          ),
        );

        expect(receipt.payment.amount, 1520);
        final storedEntry = db
            .collectionsForDate(DateTime.now())
            .firstWhere((e) => e.id == 'C006');
        expect(storedEntry.status, CollectionStatus.collected);
      },
    );

    test('recordPayment surfaces an injected payment failure', () {
      final repo = MockCollectionRepository(
        db,
        _instantGateway(failingOps: {MockOp.payment}),
      );

      expect(
        repo.recordPayment(
          const RecordPaymentInput(
            collectionId: 'C006',
            amount: 1520,
            mode: PaymentMode.upi,
          ),
        ),
        throwsA(isA<PaymentFailedException>()),
      );
    });

    test('paymentsForLoan reflects a payment just recorded', () async {
      final repo = MockCollectionRepository(db, _instantGateway());
      await repo.recordPayment(
        const RecordPaymentInput(
          collectionId: 'C006',
          amount: 1520,
          mode: PaymentMode.upi,
        ),
      );

      final payments = await repo.paymentsForLoan('L008');
      expect(payments, hasLength(1));
      expect(payments.single.amount, 1520);
    });
  });
}
