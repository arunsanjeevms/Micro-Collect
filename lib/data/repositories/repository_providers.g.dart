// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Unbound seams: the UI depends on these, never on a concrete
/// implementation. lib/data/mock/mock_bindings.dart supplies the mock
/// implementations via ProviderScope overrides; a real backend would
/// override the same three providers with its own implementations and
/// nothing outside this file would change.

@ProviderFor(borrowerRepository)
final borrowerRepositoryProvider = BorrowerRepositoryProvider._();

/// Unbound seams: the UI depends on these, never on a concrete
/// implementation. lib/data/mock/mock_bindings.dart supplies the mock
/// implementations via ProviderScope overrides; a real backend would
/// override the same three providers with its own implementations and
/// nothing outside this file would change.

final class BorrowerRepositoryProvider
    extends
        $FunctionalProvider<
          BorrowerRepository,
          BorrowerRepository,
          BorrowerRepository
        >
    with $Provider<BorrowerRepository> {
  /// Unbound seams: the UI depends on these, never on a concrete
  /// implementation. lib/data/mock/mock_bindings.dart supplies the mock
  /// implementations via ProviderScope overrides; a real backend would
  /// override the same three providers with its own implementations and
  /// nothing outside this file would change.
  BorrowerRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'borrowerRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$borrowerRepositoryHash();

  @$internal
  @override
  $ProviderElement<BorrowerRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BorrowerRepository create(Ref ref) {
    return borrowerRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BorrowerRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BorrowerRepository>(value),
    );
  }
}

String _$borrowerRepositoryHash() =>
    r'f58c50b2b637b2742414736a2712f9345bf02c50';

@ProviderFor(loanRepository)
final loanRepositoryProvider = LoanRepositoryProvider._();

final class LoanRepositoryProvider
    extends $FunctionalProvider<LoanRepository, LoanRepository, LoanRepository>
    with $Provider<LoanRepository> {
  LoanRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loanRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loanRepositoryHash();

  @$internal
  @override
  $ProviderElement<LoanRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LoanRepository create(Ref ref) {
    return loanRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoanRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoanRepository>(value),
    );
  }
}

String _$loanRepositoryHash() => r'c6c83a3cca854046109c4e787998202e1dc8a7a7';

@ProviderFor(collectionRepository)
final collectionRepositoryProvider = CollectionRepositoryProvider._();

final class CollectionRepositoryProvider
    extends
        $FunctionalProvider<
          CollectionRepository,
          CollectionRepository,
          CollectionRepository
        >
    with $Provider<CollectionRepository> {
  CollectionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'collectionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$collectionRepositoryHash();

  @$internal
  @override
  $ProviderElement<CollectionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CollectionRepository create(Ref ref) {
    return collectionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CollectionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CollectionRepository>(value),
    );
  }
}

String _$collectionRepositoryHash() =>
    r'2ba0d460e5e3de235c81b356780f013b078029cd';

@ProviderFor(areaRepository)
final areaRepositoryProvider = AreaRepositoryProvider._();

final class AreaRepositoryProvider
    extends $FunctionalProvider<AreaRepository, AreaRepository, AreaRepository>
    with $Provider<AreaRepository> {
  AreaRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'areaRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$areaRepositoryHash();

  @$internal
  @override
  $ProviderElement<AreaRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AreaRepository create(Ref ref) {
    return areaRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AreaRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AreaRepository>(value),
    );
  }
}

String _$areaRepositoryHash() => r'662b52a49cc10bf17947d56b1fcdfc4842ccb40c';

@ProviderFor(employeeRepository)
final employeeRepositoryProvider = EmployeeRepositoryProvider._();

final class EmployeeRepositoryProvider
    extends
        $FunctionalProvider<
          EmployeeRepository,
          EmployeeRepository,
          EmployeeRepository
        >
    with $Provider<EmployeeRepository> {
  EmployeeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'employeeRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$employeeRepositoryHash();

  @$internal
  @override
  $ProviderElement<EmployeeRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EmployeeRepository create(Ref ref) {
    return employeeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmployeeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmployeeRepository>(value),
    );
  }
}

String _$employeeRepositoryHash() =>
    r'0518868ba7ef47d2c911c6c4668672b7b5a76ae8';

@ProviderFor(loanSchemeRepository)
final loanSchemeRepositoryProvider = LoanSchemeRepositoryProvider._();

final class LoanSchemeRepositoryProvider
    extends
        $FunctionalProvider<
          LoanSchemeRepository,
          LoanSchemeRepository,
          LoanSchemeRepository
        >
    with $Provider<LoanSchemeRepository> {
  LoanSchemeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loanSchemeRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loanSchemeRepositoryHash();

  @$internal
  @override
  $ProviderElement<LoanSchemeRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LoanSchemeRepository create(Ref ref) {
    return loanSchemeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoanSchemeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoanSchemeRepository>(value),
    );
  }
}

String _$loanSchemeRepositoryHash() =>
    r'd2f5376b74887a254ea52e917ee16e124aa20b30';

@ProviderFor(roleRepository)
final roleRepositoryProvider = RoleRepositoryProvider._();

final class RoleRepositoryProvider
    extends $FunctionalProvider<RoleRepository, RoleRepository, RoleRepository>
    with $Provider<RoleRepository> {
  RoleRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'roleRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$roleRepositoryHash();

  @$internal
  @override
  $ProviderElement<RoleRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RoleRepository create(Ref ref) {
    return roleRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RoleRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RoleRepository>(value),
    );
  }
}

String _$roleRepositoryHash() => r'45eef7790e3ff5bffa9c01b044676e720114bfba';
