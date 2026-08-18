import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'change_feed.dart';
import 'entity_kind.dart';

part 'data_revision.g.dart';

/// The mock backend (or, later, a real one) overrides this in ProviderScope.
/// Nothing outside the backend binding ever constructs a ChangeFeed directly.
@Riverpod(keepAlive: true)
ChangeFeed changeFeed(Ref ref) {
  throw UnimplementedError(
    'changeFeedProvider must be overridden in ProviderScope - see '
    'lib/data/mock/mock_bindings.dart',
  );
}

/// Bumps by one every time a write touches [kind]. Every read provider that
/// depends on an entity kind should `ref.watch(dataRevisionProvider(kind))`
/// so a write anywhere propagates to every dependent provider automatically,
/// without any screen or controller ever calling ref.invalidate itself.
@Riverpod(keepAlive: true)
class DataRevision extends _$DataRevision {
  @override
  int build(EntityKind kind) {
    final subscription = ref
        .watch(changeFeedProvider)
        .changes
        .where((change) => change.touches(kind))
        .listen((_) => state = state + 1);
    ref.onDispose(subscription.cancel);
    return 0;
  }
}
