import 'dart:async';

import '../../core/data/change_feed.dart';
import '../../core/data/entity_kind.dart';

/// ChangeFeed implementation for the remote backend. The Node API has no
/// push channel yet (see backend/README.md), so this is fed by the remote
/// repositories themselves: each publishes the same DataChange its mock
/// counterpart would immediately after a successful write, which is what
/// lets every dataRevisionProvider watcher refresh without any explicit
/// ref.invalidate call - identical behavior to the mock backend, just
/// sourced from "I just wrote this" instead of a server-pushed event.
class RemoteChangeFeed implements ChangeFeed {
  final _controller = StreamController<DataChange>.broadcast();

  @override
  Stream<DataChange> get changes => _controller.stream;

  void publish(DataChange change) => _controller.add(change);

  void dispose() => _controller.close();
}
