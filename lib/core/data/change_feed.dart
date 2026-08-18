import 'entity_kind.dart';

/// A source of change notifications the reactivity spine subscribes to.
/// The mock backend implements this over its in-memory store; a real
/// backend would implement it over websockets, polling, or push.
abstract interface class ChangeFeed {
  Stream<DataChange> get changes;
}
