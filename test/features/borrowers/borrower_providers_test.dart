import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:microcollect/core/errors/app_exception.dart';
import 'package:microcollect/core/models/borrower.dart';
import 'package:microcollect/data/mock/mock_bindings.dart';
import 'package:microcollect/features/borrowers/providers/borrower_providers.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(overrides: mockBackendOverrides());
    addTearDown(container.dispose);
  });

  group('borrowersProvider', () {
    test('resolves to every seeded borrower', () async {
      final borrowers = await container.read(borrowersProvider.future);
      expect(borrowers, hasLength(8));
    });
  });

  group('borrowerByIdProvider', () {
    test('resolves a known id', () async {
      final borrower = await container.read(
        borrowerByIdProvider('B001').future,
      );
      expect(borrower.name, 'Rajesh Kumar');
    });

    test('throws NotFoundException for an unknown id', () async {
      await expectLater(
        container.read(borrowerByIdProvider('B999').future),
        throwsA(isA<NotFoundException>()),
      );
    });
  });

  group('borrowerStatusCountsProvider', () {
    test('counts sum to the total number of borrowers', () async {
      final counts = await container.read(borrowerStatusCountsProvider.future);
      final total = counts.values.fold<int>(0, (sum, c) => sum + c);
      expect(total, 8);
    });

    test('every status is present even if its count is zero', () async {
      final counts = await container.read(borrowerStatusCountsProvider.future);
      expect(counts.keys.toSet(), BorrowerStatus.values.toSet());
    });
  });

  group('BorrowerFilter.matches', () {
    final rajesh = Borrower(
      id: 'B001',
      name: 'Rajesh Kumar',
      mobile: '9876543210',
      aadhaar: '234567891234',
      village: 'Kothapalli',
      address: 'H.No 3-45',
      pinCode: '507001',
      joinDate: DateTime(2024, 3, 15),
      activeLoans: 1,
      totalOutstanding: 18500,
      status: BorrowerStatus.active,
    );

    test('an empty, statusless filter matches everything', () {
      const filter = BorrowerFilter();
      expect(filter.isDefault, isTrue);
      expect(filter.matches(rajesh), isTrue);
    });

    test('matches by name case-insensitively', () {
      const filter = BorrowerFilter(search: 'rajesh');
      expect(filter.matches(rajesh), isTrue);
    });

    test('matches by village', () {
      const filter = BorrowerFilter(search: 'kothapalli');
      expect(filter.matches(rajesh), isTrue);
    });

    test('matches by a mobile substring', () {
      const filter = BorrowerFilter(search: '9876');
      expect(filter.matches(rajesh), isTrue);
    });

    test('does not match unrelated text', () {
      const filter = BorrowerFilter(search: 'nonexistent');
      expect(filter.matches(rajesh), isFalse);
    });

    test('a status filter excludes non-matching borrowers', () {
      const filter = BorrowerFilter(status: BorrowerStatus.overdue);
      expect(filter.matches(rajesh), isFalse);
    });

    test('search and status combine with AND', () {
      const filter = BorrowerFilter(
        search: 'rajesh',
        status: BorrowerStatus.overdue,
      );
      expect(filter.matches(rajesh), isFalse);
    });
  });

  group('BorrowerQuery + filteredBorrowersProvider', () {
    setUp(() {
      // filteredBorrowersProvider is auto-dispose, like every read provider
      // in this app - the running screen keeps it alive via ref.watch for
      // as long as it's on screen. A bare container.read here wouldn't hold
      // that subscription open between statements, so the provider would be
      // torn down the moment the query notifier's state changes underneath
      // it. Pin it alive for the test the same way a mounted widget would.
      container.listen(filteredBorrowersProvider, (_, _) {});
    });

    test('starts unfiltered', () async {
      final all = await container.read(borrowersProvider.future);
      final filtered = await container.read(filteredBorrowersProvider.future);
      expect(filtered, hasLength(all.length));
    });

    test('setSearch narrows the filtered list', () async {
      await container.read(filteredBorrowersProvider.future);
      container.read(borrowerQueryProvider.notifier).setSearch('Rajesh');
      final filtered = await container.read(filteredBorrowersProvider.future);
      expect(filtered.map((b) => b.name), ['Rajesh Kumar']);
    });

    test('setStatus(null) clears a previously-set status filter', () async {
      await container.read(filteredBorrowersProvider.future);
      final notifier = container.read(borrowerQueryProvider.notifier);
      notifier.setStatus(BorrowerStatus.closed);
      final closedOnly = await container.read(filteredBorrowersProvider.future);
      expect(closedOnly, hasLength(1)); // Padma Kumari

      notifier.setStatus(null);
      final all = await container.read(borrowersProvider.future);
      final unfiltered = await container.read(filteredBorrowersProvider.future);
      expect(unfiltered, hasLength(all.length));
    });

    test('clear resets both search and status', () async {
      await container.read(filteredBorrowersProvider.future);
      final notifier = container.read(borrowerQueryProvider.notifier);
      notifier.setSearch('Rajesh');
      notifier.setStatus(BorrowerStatus.active);
      notifier.clear();

      expect(container.read(borrowerQueryProvider).isDefault, isTrue);
    });
  });
}
