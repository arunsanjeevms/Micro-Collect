// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'borrower_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(borrowers)
final borrowersProvider = BorrowersProvider._();

final class BorrowersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Borrower>>,
          List<Borrower>,
          FutureOr<List<Borrower>>
        >
    with $FutureModifier<List<Borrower>>, $FutureProvider<List<Borrower>> {
  BorrowersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'borrowersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$borrowersHash();

  @$internal
  @override
  $FutureProviderElement<List<Borrower>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Borrower>> create(Ref ref) {
    return borrowers(ref);
  }
}

String _$borrowersHash() => r'bbc8a9228e112910a26c70015095841d394241ae';

@ProviderFor(borrowerById)
final borrowerByIdProvider = BorrowerByIdFamily._();

final class BorrowerByIdProvider
    extends
        $FunctionalProvider<AsyncValue<Borrower>, Borrower, FutureOr<Borrower>>
    with $FutureModifier<Borrower>, $FutureProvider<Borrower> {
  BorrowerByIdProvider._({
    required BorrowerByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'borrowerByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$borrowerByIdHash();

  @override
  String toString() {
    return r'borrowerByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Borrower> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Borrower> create(Ref ref) {
    final argument = this.argument as String;
    return borrowerById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BorrowerByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$borrowerByIdHash() => r'257e333f5a07ee893a3ef5172939546a6ad67f77';

final class BorrowerByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Borrower>, String> {
  BorrowerByIdFamily._()
    : super(
        retry: null,
        name: r'borrowerByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BorrowerByIdProvider call(String id) =>
      BorrowerByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'borrowerByIdProvider';
}

/// Counts per status, for the filter chips - derived from the same list the
/// screen already fetched rather than a separate repository round trip.

@ProviderFor(borrowerStatusCounts)
final borrowerStatusCountsProvider = BorrowerStatusCountsProvider._();

/// Counts per status, for the filter chips - derived from the same list the
/// screen already fetched rather than a separate repository round trip.

final class BorrowerStatusCountsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<BorrowerStatus, int>>,
          Map<BorrowerStatus, int>,
          FutureOr<Map<BorrowerStatus, int>>
        >
    with
        $FutureModifier<Map<BorrowerStatus, int>>,
        $FutureProvider<Map<BorrowerStatus, int>> {
  /// Counts per status, for the filter chips - derived from the same list the
  /// screen already fetched rather than a separate repository round trip.
  BorrowerStatusCountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'borrowerStatusCountsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$borrowerStatusCountsHash();

  @$internal
  @override
  $FutureProviderElement<Map<BorrowerStatus, int>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<BorrowerStatus, int>> create(Ref ref) {
    return borrowerStatusCounts(ref);
  }
}

String _$borrowerStatusCountsHash() =>
    r'aed3626181a2ce91e4fa2f74ad2f1209d48d740f';

/// Search/filter state lives client-side rather than as a repository
/// parameter: with injected network latency, a per-keystroke repository
/// call would feel terrible. When the borrower list is large enough that
/// this stops scaling, fetchAll() becomes fetch(BorrowerQuery) and
/// filteredBorrowersProvider collapses to a one-line passthrough.

@ProviderFor(BorrowerQuery)
final borrowerQueryProvider = BorrowerQueryProvider._();

/// Search/filter state lives client-side rather than as a repository
/// parameter: with injected network latency, a per-keystroke repository
/// call would feel terrible. When the borrower list is large enough that
/// this stops scaling, fetchAll() becomes fetch(BorrowerQuery) and
/// filteredBorrowersProvider collapses to a one-line passthrough.
final class BorrowerQueryProvider
    extends $NotifierProvider<BorrowerQuery, BorrowerFilter> {
  /// Search/filter state lives client-side rather than as a repository
  /// parameter: with injected network latency, a per-keystroke repository
  /// call would feel terrible. When the borrower list is large enough that
  /// this stops scaling, fetchAll() becomes fetch(BorrowerQuery) and
  /// filteredBorrowersProvider collapses to a one-line passthrough.
  BorrowerQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'borrowerQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$borrowerQueryHash();

  @$internal
  @override
  BorrowerQuery create() => BorrowerQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BorrowerFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BorrowerFilter>(value),
    );
  }
}

String _$borrowerQueryHash() => r'3a7c2733bb4a1877aae6a8c11a02d433fe082f5f';

/// Search/filter state lives client-side rather than as a repository
/// parameter: with injected network latency, a per-keystroke repository
/// call would feel terrible. When the borrower list is large enough that
/// this stops scaling, fetchAll() becomes fetch(BorrowerQuery) and
/// filteredBorrowersProvider collapses to a one-line passthrough.

abstract class _$BorrowerQuery extends $Notifier<BorrowerFilter> {
  BorrowerFilter build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<BorrowerFilter, BorrowerFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BorrowerFilter, BorrowerFilter>,
              BorrowerFilter,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(filteredBorrowers)
final filteredBorrowersProvider = FilteredBorrowersProvider._();

final class FilteredBorrowersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Borrower>>,
          List<Borrower>,
          FutureOr<List<Borrower>>
        >
    with $FutureModifier<List<Borrower>>, $FutureProvider<List<Borrower>> {
  FilteredBorrowersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredBorrowersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredBorrowersHash();

  @$internal
  @override
  $FutureProviderElement<List<Borrower>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Borrower>> create(Ref ref) {
    return filteredBorrowers(ref);
  }
}

String _$filteredBorrowersHash() => r'c24dc98bab3235e089c8736395ac8dfef2347e8b';
