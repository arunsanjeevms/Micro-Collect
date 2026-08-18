import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'mock_database.dart';

part 'mock_database_provider.g.dart';

/// The one MockDatabase instance for the app's lifetime - not a seam, since
/// nothing outside lib/data/mock ever references the concrete type
/// directly; other code depends on ChangeFeed and the repository
/// interfaces, both of which MockDatabase (or its repositories) satisfy.
@Riverpod(keepAlive: true)
MockDatabase mockDatabase(Ref ref) {
  final db = MockDatabase();
  ref.onDispose(db.dispose);
  return db;
}
