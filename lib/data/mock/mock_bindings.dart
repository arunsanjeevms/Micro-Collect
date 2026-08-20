import '../../core/data/data_revision.dart';
import '../dev/dev_settings_controller.dart';
import '../repositories/repository_providers.dart';
import 'mock_area_repository.dart';
import 'mock_collection_repository.dart';
import 'mock_borrower_repository.dart';
import 'mock_database_provider.dart';
import 'mock_employee_repository.dart';
import 'mock_gateway.dart';
import 'mock_loan_repository.dart';
import 'mock_loan_scheme_repository.dart';
import 'mock_role_repository.dart';

/// Every ProviderScope override the mock backend needs. Swapping to a real
/// backend later means replacing this one list with a different one that
/// overrides the same three repository providers and changeFeedProvider -
/// nothing else in the app depends on the fact that these are mocked.
///
/// Return type is inferred rather than spelled out as `List<Override>`:
/// riverpod 3.4.2's public barrels (riverpod.dart, misc.dart) list Override
/// in their `show` clause but it isn't actually reachable through the
/// internals.dart re-export chain they draw from, so naming it as an
/// explicit type fails to resolve. ProviderScope(overrides: ...) still
/// accepts this list via top-down inference from its own parameter type.
// ignore: strict_top_level_inference
mockBackendOverrides() {
  return [
    changeFeedProvider.overrideWith((ref) => ref.watch(mockDatabaseProvider)),
    borrowerRepositoryProvider.overrideWith(
      (ref) => MockBorrowerRepository(
        ref.watch(mockDatabaseProvider),
        MockGateway(() => ref.read(devSettingsControllerProvider)),
      ),
    ),
    loanRepositoryProvider.overrideWith(
      (ref) => MockLoanRepository(
        ref.watch(mockDatabaseProvider),
        MockGateway(() => ref.read(devSettingsControllerProvider)),
      ),
    ),
    collectionRepositoryProvider.overrideWith(
      (ref) => MockCollectionRepository(
        ref.watch(mockDatabaseProvider),
        MockGateway(() => ref.read(devSettingsControllerProvider)),
      ),
    ),
    areaRepositoryProvider.overrideWith(
      (ref) => MockAreaRepository(
        ref.watch(mockDatabaseProvider),
        MockGateway(() => ref.read(devSettingsControllerProvider)),
      ),
    ),
    employeeRepositoryProvider.overrideWith(
      (ref) => MockEmployeeRepository(
        ref.watch(mockDatabaseProvider),
        MockGateway(() => ref.read(devSettingsControllerProvider)),
      ),
    ),
    loanSchemeRepositoryProvider.overrideWith(
      (ref) => MockLoanSchemeRepository(
        ref.watch(mockDatabaseProvider),
        MockGateway(() => ref.read(devSettingsControllerProvider)),
      ),
    ),
    roleRepositoryProvider.overrideWith(
      (ref) => MockRoleRepository(
        ref.watch(mockDatabaseProvider),
        MockGateway(() => ref.read(devSettingsControllerProvider)),
      ),
    ),
  ];
}
