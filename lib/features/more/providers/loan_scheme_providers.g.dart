// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_scheme_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(loanSchemes)
final loanSchemesProvider = LoanSchemesProvider._();

final class LoanSchemesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LoanScheme>>,
          List<LoanScheme>,
          FutureOr<List<LoanScheme>>
        >
    with $FutureModifier<List<LoanScheme>>, $FutureProvider<List<LoanScheme>> {
  LoanSchemesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loanSchemesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loanSchemesHash();

  @$internal
  @override
  $FutureProviderElement<List<LoanScheme>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<LoanScheme>> create(Ref ref) {
    return loanSchemes(ref);
  }
}

String _$loanSchemesHash() => r'6008adb1fc31a7d3d9fae70048b73d105cc6a176';

@ProviderFor(CreateLoanSchemeController)
final createLoanSchemeControllerProvider =
    CreateLoanSchemeControllerProvider._();

final class CreateLoanSchemeControllerProvider
    extends $AsyncNotifierProvider<CreateLoanSchemeController, LoanScheme?> {
  CreateLoanSchemeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createLoanSchemeControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createLoanSchemeControllerHash();

  @$internal
  @override
  CreateLoanSchemeController create() => CreateLoanSchemeController();
}

String _$createLoanSchemeControllerHash() =>
    r'0e1c8e7fc098da9b3581ab8e4bd4dfd2187eb550';

abstract class _$CreateLoanSchemeController
    extends $AsyncNotifier<LoanScheme?> {
  FutureOr<LoanScheme?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<LoanScheme?>, LoanScheme?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LoanScheme?>, LoanScheme?>,
              AsyncValue<LoanScheme?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(SetLoanSchemeActiveController)
final setLoanSchemeActiveControllerProvider =
    SetLoanSchemeActiveControllerProvider._();

final class SetLoanSchemeActiveControllerProvider
    extends $AsyncNotifierProvider<SetLoanSchemeActiveController, LoanScheme?> {
  SetLoanSchemeActiveControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setLoanSchemeActiveControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$setLoanSchemeActiveControllerHash();

  @$internal
  @override
  SetLoanSchemeActiveController create() => SetLoanSchemeActiveController();
}

String _$setLoanSchemeActiveControllerHash() =>
    r'ca8e497482031c0cb4527522f172730300059a24';

abstract class _$SetLoanSchemeActiveController
    extends $AsyncNotifier<LoanScheme?> {
  FutureOr<LoanScheme?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<LoanScheme?>, LoanScheme?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LoanScheme?>, LoanScheme?>,
              AsyncValue<LoanScheme?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(DeleteLoanSchemeController)
final deleteLoanSchemeControllerProvider =
    DeleteLoanSchemeControllerProvider._();

final class DeleteLoanSchemeControllerProvider
    extends $AsyncNotifierProvider<DeleteLoanSchemeController, void> {
  DeleteLoanSchemeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteLoanSchemeControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteLoanSchemeControllerHash();

  @$internal
  @override
  DeleteLoanSchemeController create() => DeleteLoanSchemeController();
}

String _$deleteLoanSchemeControllerHash() =>
    r'4927a76cb9086f260b1a953170d41ae986ef49d9';

abstract class _$DeleteLoanSchemeController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
