// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(todayCollections)
final todayCollectionsProvider = TodayCollectionsProvider._();

final class TodayCollectionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CollectionEntry>>,
          List<CollectionEntry>,
          FutureOr<List<CollectionEntry>>
        >
    with
        $FutureModifier<List<CollectionEntry>>,
        $FutureProvider<List<CollectionEntry>> {
  TodayCollectionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todayCollectionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todayCollectionsHash();

  @$internal
  @override
  $FutureProviderElement<List<CollectionEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CollectionEntry>> create(Ref ref) {
    return todayCollections(ref);
  }
}

String _$todayCollectionsHash() => r'e812b86f93835998cd88b709e253f3f8ce6b2304';

@ProviderFor(collectionSummary)
final collectionSummaryProvider = CollectionSummaryProvider._();

final class CollectionSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<CollectionSummary>,
          CollectionSummary,
          FutureOr<CollectionSummary>
        >
    with
        $FutureModifier<CollectionSummary>,
        $FutureProvider<CollectionSummary> {
  CollectionSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'collectionSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$collectionSummaryHash();

  @$internal
  @override
  $FutureProviderElement<CollectionSummary> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CollectionSummary> create(Ref ref) {
    return collectionSummary(ref);
  }
}

String _$collectionSummaryHash() => r'4905d96f7d77305805120058efecaebd2d29f590';

@ProviderFor(CollectionStatusFilter)
final collectionStatusFilterProvider = CollectionStatusFilterProvider._();

final class CollectionStatusFilterProvider
    extends $NotifierProvider<CollectionStatusFilter, CollectionStatus?> {
  CollectionStatusFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'collectionStatusFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$collectionStatusFilterHash();

  @$internal
  @override
  CollectionStatusFilter create() => CollectionStatusFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CollectionStatus? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CollectionStatus?>(value),
    );
  }
}

String _$collectionStatusFilterHash() =>
    r'a1f9ddc364d1744fdaa95b5bfa65cb090b1dfc44';

abstract class _$CollectionStatusFilter extends $Notifier<CollectionStatus?> {
  CollectionStatus? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CollectionStatus?, CollectionStatus?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CollectionStatus?, CollectionStatus?>,
              CollectionStatus?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(filteredCollections)
final filteredCollectionsProvider = FilteredCollectionsProvider._();

final class FilteredCollectionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CollectionEntry>>,
          List<CollectionEntry>,
          FutureOr<List<CollectionEntry>>
        >
    with
        $FutureModifier<List<CollectionEntry>>,
        $FutureProvider<List<CollectionEntry>> {
  FilteredCollectionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredCollectionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredCollectionsHash();

  @$internal
  @override
  $FutureProviderElement<List<CollectionEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CollectionEntry>> create(Ref ref) {
    return filteredCollections(ref);
  }
}

String _$filteredCollectionsHash() =>
    r'c68a48890704fb3ae8d311183bf58ddc09a65708';

@ProviderFor(paymentsForLoan)
final paymentsForLoanProvider = PaymentsForLoanFamily._();

final class PaymentsForLoanProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Payment>>,
          List<Payment>,
          FutureOr<List<Payment>>
        >
    with $FutureModifier<List<Payment>>, $FutureProvider<List<Payment>> {
  PaymentsForLoanProvider._({
    required PaymentsForLoanFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'paymentsForLoanProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$paymentsForLoanHash();

  @override
  String toString() {
    return r'paymentsForLoanProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Payment>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Payment>> create(Ref ref) {
    final argument = this.argument as String;
    return paymentsForLoan(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PaymentsForLoanProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$paymentsForLoanHash() => r'5955ec370b39b58c781e2fbca952d6a031c245f9';

final class PaymentsForLoanFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Payment>>, String> {
  PaymentsForLoanFamily._()
    : super(
        retry: null,
        name: r'paymentsForLoanProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PaymentsForLoanProvider call(String loanId) =>
      PaymentsForLoanProvider._(argument: loanId, from: this);

  @override
  String toString() => r'paymentsForLoanProvider';
}

@ProviderFor(paymentsForBorrower)
final paymentsForBorrowerProvider = PaymentsForBorrowerFamily._();

final class PaymentsForBorrowerProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Payment>>,
          List<Payment>,
          FutureOr<List<Payment>>
        >
    with $FutureModifier<List<Payment>>, $FutureProvider<List<Payment>> {
  PaymentsForBorrowerProvider._({
    required PaymentsForBorrowerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'paymentsForBorrowerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$paymentsForBorrowerHash();

  @override
  String toString() {
    return r'paymentsForBorrowerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Payment>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Payment>> create(Ref ref) {
    final argument = this.argument as String;
    return paymentsForBorrower(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PaymentsForBorrowerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$paymentsForBorrowerHash() =>
    r'f495b6302d31da54e1f9128cf23e161d26bab161';

final class PaymentsForBorrowerFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Payment>>, String> {
  PaymentsForBorrowerFamily._()
    : super(
        retry: null,
        name: r'paymentsForBorrowerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PaymentsForBorrowerProvider call(String borrowerId) =>
      PaymentsForBorrowerProvider._(argument: borrowerId, from: this);

  @override
  String toString() => r'paymentsForBorrowerProvider';
}

/// The record-payment sheet's controller. Deliberately doesn't call
/// ref.invalidate anywhere - MockDatabase.recordPayment's DataChange
/// propagates through dataRevisionProvider to every provider above (and to
/// borrower/loan providers) on its own.

@ProviderFor(RecordPaymentController)
final recordPaymentControllerProvider = RecordPaymentControllerProvider._();

/// The record-payment sheet's controller. Deliberately doesn't call
/// ref.invalidate anywhere - MockDatabase.recordPayment's DataChange
/// propagates through dataRevisionProvider to every provider above (and to
/// borrower/loan providers) on its own.
final class RecordPaymentControllerProvider
    extends $AsyncNotifierProvider<RecordPaymentController, PaymentReceipt?> {
  /// The record-payment sheet's controller. Deliberately doesn't call
  /// ref.invalidate anywhere - MockDatabase.recordPayment's DataChange
  /// propagates through dataRevisionProvider to every provider above (and to
  /// borrower/loan providers) on its own.
  RecordPaymentControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recordPaymentControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recordPaymentControllerHash();

  @$internal
  @override
  RecordPaymentController create() => RecordPaymentController();
}

String _$recordPaymentControllerHash() =>
    r'11e67bf9d3a2acdcf37cf833735a40d7130eb1a7';

/// The record-payment sheet's controller. Deliberately doesn't call
/// ref.invalidate anywhere - MockDatabase.recordPayment's DataChange
/// propagates through dataRevisionProvider to every provider above (and to
/// borrower/loan providers) on its own.

abstract class _$RecordPaymentController
    extends $AsyncNotifier<PaymentReceipt?> {
  FutureOr<PaymentReceipt?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PaymentReceipt?>, PaymentReceipt?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PaymentReceipt?>, PaymentReceipt?>,
              AsyncValue<PaymentReceipt?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
