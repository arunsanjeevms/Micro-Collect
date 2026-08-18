// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mock_database_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The one MockDatabase instance for the app's lifetime - not a seam, since
/// nothing outside lib/data/mock ever references the concrete type
/// directly; other code depends on ChangeFeed and the repository
/// interfaces, both of which MockDatabase (or its repositories) satisfy.

@ProviderFor(mockDatabase)
final mockDatabaseProvider = MockDatabaseProvider._();

/// The one MockDatabase instance for the app's lifetime - not a seam, since
/// nothing outside lib/data/mock ever references the concrete type
/// directly; other code depends on ChangeFeed and the repository
/// interfaces, both of which MockDatabase (or its repositories) satisfy.

final class MockDatabaseProvider
    extends $FunctionalProvider<MockDatabase, MockDatabase, MockDatabase>
    with $Provider<MockDatabase> {
  /// The one MockDatabase instance for the app's lifetime - not a seam, since
  /// nothing outside lib/data/mock ever references the concrete type
  /// directly; other code depends on ChangeFeed and the repository
  /// interfaces, both of which MockDatabase (or its repositories) satisfy.
  MockDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mockDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mockDatabaseHash();

  @$internal
  @override
  $ProviderElement<MockDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MockDatabase create(Ref ref) {
    return mockDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MockDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MockDatabase>(value),
    );
  }
}

String _$mockDatabaseHash() => r'20a153886bedc96319fbea05ea3cf1c7421c6461';
