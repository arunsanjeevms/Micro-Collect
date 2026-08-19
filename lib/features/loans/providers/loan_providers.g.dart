// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(loans)
final loansProvider = LoansProvider._();

final class LoansProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Loan>>,
          List<Loan>,
          FutureOr<List<Loan>>
        >
    with $FutureModifier<List<Loan>>, $FutureProvider<List<Loan>> {
  LoansProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loansProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loansHash();

  @$internal
  @override
  $FutureProviderElement<List<Loan>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Loan>> create(Ref ref) {
    return loans(ref);
  }
}

String _$loansHash() => r'955c2593808175aefa5c8e54ccd266f52cb86124';

@ProviderFor(loanById)
final loanByIdProvider = LoanByIdFamily._();

final class LoanByIdProvider
    extends $FunctionalProvider<AsyncValue<Loan>, Loan, FutureOr<Loan>>
    with $FutureModifier<Loan>, $FutureProvider<Loan> {
  LoanByIdProvider._({
    required LoanByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'loanByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$loanByIdHash();

  @override
  String toString() {
    return r'loanByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Loan> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Loan> create(Ref ref) {
    final argument = this.argument as String;
    return loanById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LoanByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$loanByIdHash() => r'279ec8301e07fb1110b2c3edb1f4ad821a6dc3bd';

final class LoanByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Loan>, String> {
  LoanByIdFamily._()
    : super(
        retry: null,
        name: r'loanByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LoanByIdProvider call(String id) =>
      LoanByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'loanByIdProvider';
}

@ProviderFor(loansForBorrower)
final loansForBorrowerProvider = LoansForBorrowerFamily._();

final class LoansForBorrowerProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Loan>>,
          List<Loan>,
          FutureOr<List<Loan>>
        >
    with $FutureModifier<List<Loan>>, $FutureProvider<List<Loan>> {
  LoansForBorrowerProvider._({
    required LoansForBorrowerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'loansForBorrowerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$loansForBorrowerHash();

  @override
  String toString() {
    return r'loansForBorrowerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Loan>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Loan>> create(Ref ref) {
    final argument = this.argument as String;
    return loansForBorrower(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LoansForBorrowerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$loansForBorrowerHash() => r'17bae0d08accd6129838feb095a7472c634758ce';

final class LoansForBorrowerFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Loan>>, String> {
  LoansForBorrowerFamily._()
    : super(
        retry: null,
        name: r'loansForBorrowerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LoansForBorrowerProvider call(String borrowerId) =>
      LoansForBorrowerProvider._(argument: borrowerId, from: this);

  @override
  String toString() => r'loansForBorrowerProvider';
}

/// The create-loan form's controller. Like RecordPaymentController, calls
/// no invalidate anywhere - MockDatabase.insertLoan's DataChange (loan +
/// borrower) propagates to every dependent provider on its own.

@ProviderFor(CreateLoanController)
final createLoanControllerProvider = CreateLoanControllerProvider._();

/// The create-loan form's controller. Like RecordPaymentController, calls
/// no invalidate anywhere - MockDatabase.insertLoan's DataChange (loan +
/// borrower) propagates to every dependent provider on its own.
final class CreateLoanControllerProvider
    extends $AsyncNotifierProvider<CreateLoanController, Loan?> {
  /// The create-loan form's controller. Like RecordPaymentController, calls
  /// no invalidate anywhere - MockDatabase.insertLoan's DataChange (loan +
  /// borrower) propagates to every dependent provider on its own.
  CreateLoanControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createLoanControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createLoanControllerHash();

  @$internal
  @override
  CreateLoanController create() => CreateLoanController();
}

String _$createLoanControllerHash() =>
    r'3dc5f4b97fc784f03c7812aa65ce64eedd5df7f6';

/// The create-loan form's controller. Like RecordPaymentController, calls
/// no invalidate anywhere - MockDatabase.insertLoan's DataChange (loan +
/// borrower) propagates to every dependent provider on its own.

abstract class _$CreateLoanController extends $AsyncNotifier<Loan?> {
  FutureOr<Loan?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Loan?>, Loan?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Loan?>, Loan?>,
              AsyncValue<Loan?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The Loan Closure screen's controller. Reuses PaymentReceipt so the
/// success flow can be the same PaymentSuccessScreen/PaymentReceiptScreen
/// a regular payment lands on.

@ProviderFor(CloseLoanController)
final closeLoanControllerProvider = CloseLoanControllerProvider._();

/// The Loan Closure screen's controller. Reuses PaymentReceipt so the
/// success flow can be the same PaymentSuccessScreen/PaymentReceiptScreen
/// a regular payment lands on.
final class CloseLoanControllerProvider
    extends $AsyncNotifierProvider<CloseLoanController, PaymentReceipt?> {
  /// The Loan Closure screen's controller. Reuses PaymentReceipt so the
  /// success flow can be the same PaymentSuccessScreen/PaymentReceiptScreen
  /// a regular payment lands on.
  CloseLoanControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'closeLoanControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$closeLoanControllerHash();

  @$internal
  @override
  CloseLoanController create() => CloseLoanController();
}

String _$closeLoanControllerHash() =>
    r'8c657eab69e94278ff00cb32d48a679ad7c3b076';

/// The Loan Closure screen's controller. Reuses PaymentReceipt so the
/// success flow can be the same PaymentSuccessScreen/PaymentReceiptScreen
/// a regular payment lands on.

abstract class _$CloseLoanController extends $AsyncNotifier<PaymentReceipt?> {
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
