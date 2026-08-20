// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(employees)
final employeesProvider = EmployeesProvider._();

final class EmployeesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Employee>>,
          List<Employee>,
          FutureOr<List<Employee>>
        >
    with $FutureModifier<List<Employee>>, $FutureProvider<List<Employee>> {
  EmployeesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'employeesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$employeesHash();

  @$internal
  @override
  $FutureProviderElement<List<Employee>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Employee>> create(Ref ref) {
    return employees(ref);
  }
}

String _$employeesHash() => r'278674688a2ffdacde39733552d94e1702aebe4d';

@ProviderFor(CreateEmployeeController)
final createEmployeeControllerProvider = CreateEmployeeControllerProvider._();

final class CreateEmployeeControllerProvider
    extends $AsyncNotifierProvider<CreateEmployeeController, Employee?> {
  CreateEmployeeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createEmployeeControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createEmployeeControllerHash();

  @$internal
  @override
  CreateEmployeeController create() => CreateEmployeeController();
}

String _$createEmployeeControllerHash() =>
    r'e7ed2c2e51473d4fb5bb6c238fea01582019a5e7';

abstract class _$CreateEmployeeController extends $AsyncNotifier<Employee?> {
  FutureOr<Employee?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Employee?>, Employee?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Employee?>, Employee?>,
              AsyncValue<Employee?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(UpdateEmployeeController)
final updateEmployeeControllerProvider = UpdateEmployeeControllerProvider._();

final class UpdateEmployeeControllerProvider
    extends $AsyncNotifierProvider<UpdateEmployeeController, Employee?> {
  UpdateEmployeeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateEmployeeControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateEmployeeControllerHash();

  @$internal
  @override
  UpdateEmployeeController create() => UpdateEmployeeController();
}

String _$updateEmployeeControllerHash() =>
    r'774cbdb41f7a95b1aa4ea2d45f7a2e9293c9a285';

abstract class _$UpdateEmployeeController extends $AsyncNotifier<Employee?> {
  FutureOr<Employee?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Employee?>, Employee?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Employee?>, Employee?>,
              AsyncValue<Employee?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(DeleteEmployeeController)
final deleteEmployeeControllerProvider = DeleteEmployeeControllerProvider._();

final class DeleteEmployeeControllerProvider
    extends $AsyncNotifierProvider<DeleteEmployeeController, void> {
  DeleteEmployeeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteEmployeeControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteEmployeeControllerHash();

  @$internal
  @override
  DeleteEmployeeController create() => DeleteEmployeeController();
}

String _$deleteEmployeeControllerHash() =>
    r'a2507ec5d25e56006ae0fe2fd725113f155281d3';

abstract class _$DeleteEmployeeController extends $AsyncNotifier<void> {
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
