// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_revision.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The mock backend (or, later, a real one) overrides this in ProviderScope.
/// Nothing outside the backend binding ever constructs a ChangeFeed directly.

@ProviderFor(changeFeed)
final changeFeedProvider = ChangeFeedProvider._();

/// The mock backend (or, later, a real one) overrides this in ProviderScope.
/// Nothing outside the backend binding ever constructs a ChangeFeed directly.

final class ChangeFeedProvider
    extends $FunctionalProvider<ChangeFeed, ChangeFeed, ChangeFeed>
    with $Provider<ChangeFeed> {
  /// The mock backend (or, later, a real one) overrides this in ProviderScope.
  /// Nothing outside the backend binding ever constructs a ChangeFeed directly.
  ChangeFeedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'changeFeedProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$changeFeedHash();

  @$internal
  @override
  $ProviderElement<ChangeFeed> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChangeFeed create(Ref ref) {
    return changeFeed(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChangeFeed value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChangeFeed>(value),
    );
  }
}

String _$changeFeedHash() => r'74b657b67d4fc940e89b83251975c68156adeaba';

/// Bumps by one every time a write touches [kind]. Every read provider that
/// depends on an entity kind should `ref.watch(dataRevisionProvider(kind))`
/// so a write anywhere propagates to every dependent provider automatically,
/// without any screen or controller ever calling ref.invalidate itself.

@ProviderFor(DataRevision)
final dataRevisionProvider = DataRevisionFamily._();

/// Bumps by one every time a write touches [kind]. Every read provider that
/// depends on an entity kind should `ref.watch(dataRevisionProvider(kind))`
/// so a write anywhere propagates to every dependent provider automatically,
/// without any screen or controller ever calling ref.invalidate itself.
final class DataRevisionProvider extends $NotifierProvider<DataRevision, int> {
  /// Bumps by one every time a write touches [kind]. Every read provider that
  /// depends on an entity kind should `ref.watch(dataRevisionProvider(kind))`
  /// so a write anywhere propagates to every dependent provider automatically,
  /// without any screen or controller ever calling ref.invalidate itself.
  DataRevisionProvider._({
    required DataRevisionFamily super.from,
    required EntityKind super.argument,
  }) : super(
         retry: null,
         name: r'dataRevisionProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dataRevisionHash();

  @override
  String toString() {
    return r'dataRevisionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DataRevision create() => DataRevision();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DataRevisionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dataRevisionHash() => r'67340f0842a3adfda4b5b4c454e78f6a65675151';

/// Bumps by one every time a write touches [kind]. Every read provider that
/// depends on an entity kind should `ref.watch(dataRevisionProvider(kind))`
/// so a write anywhere propagates to every dependent provider automatically,
/// without any screen or controller ever calling ref.invalidate itself.

final class DataRevisionFamily extends $Family
    with $ClassFamilyOverride<DataRevision, int, int, int, EntityKind> {
  DataRevisionFamily._()
    : super(
        retry: null,
        name: r'dataRevisionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// Bumps by one every time a write touches [kind]. Every read provider that
  /// depends on an entity kind should `ref.watch(dataRevisionProvider(kind))`
  /// so a write anywhere propagates to every dependent provider automatically,
  /// without any screen or controller ever calling ref.invalidate itself.

  DataRevisionProvider call(EntityKind kind) =>
      DataRevisionProvider._(argument: kind, from: this);

  @override
  String toString() => r'dataRevisionProvider';
}

/// Bumps by one every time a write touches [kind]. Every read provider that
/// depends on an entity kind should `ref.watch(dataRevisionProvider(kind))`
/// so a write anywhere propagates to every dependent provider automatically,
/// without any screen or controller ever calling ref.invalidate itself.

abstract class _$DataRevision extends $Notifier<int> {
  late final _$args = ref.$arg as EntityKind;
  EntityKind get kind => _$args;

  int build(EntityKind kind);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
