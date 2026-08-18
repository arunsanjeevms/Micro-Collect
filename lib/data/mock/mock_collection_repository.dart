import '../../core/models/collection_entry.dart';
import '../dev/mock_op.dart';
import '../repositories/collection_repository.dart';
import 'mock_database.dart';
import 'mock_gateway.dart';

class MockCollectionRepository implements CollectionRepository {
  MockCollectionRepository(this._db, this._gateway);

  final MockDatabase _db;
  final MockGateway _gateway;

  @override
  Future<List<CollectionEntry>> fetchForDate(DateTime date) =>
      _gateway.call(MockOp.read, () => _db.collectionsForDate(date));

  @override
  Future<CollectionSummary> summaryForDate(DateTime date) => _gateway.call(
    MockOp.read,
    () => _summarize(_db.collectionsForDate(date)),
  );

  CollectionSummary _summarize(List<CollectionEntry> entries) {
    var totalDue = 0.0;
    var totalCollected = 0.0;
    var collectedCount = 0;
    var pendingCount = 0;
    var overdueCount = 0;
    var partialCount = 0;

    for (final entry in entries) {
      totalDue += entry.amountDue;
      totalCollected += entry.amountPaid ?? 0;
      switch (entry.status) {
        case CollectionStatus.collected:
          collectedCount++;
        case CollectionStatus.pending:
          pendingCount++;
        case CollectionStatus.overdue:
          overdueCount++;
        case CollectionStatus.partial:
          partialCount++;
      }
    }

    return CollectionSummary(
      totalDue: totalDue,
      totalCollected: totalCollected,
      collectedCount: collectedCount,
      pendingCount: pendingCount,
      overdueCount: overdueCount,
      partialCount: partialCount,
    );
  }
}
