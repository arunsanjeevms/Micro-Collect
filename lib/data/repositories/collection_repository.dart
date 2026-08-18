import '../../core/models/collection_entry.dart';

/// Aggregate figures for a day's collections - the numbers the collections
/// screen's summary card and the dashboard both need, computed once by the
/// repository instead of by every screen that wants them.
class CollectionSummary {
  const CollectionSummary({
    required this.totalDue,
    required this.totalCollected,
    required this.collectedCount,
    required this.pendingCount,
    required this.overdueCount,
    required this.partialCount,
  });

  final double totalDue;
  final double totalCollected;
  final int collectedCount;
  final int pendingCount;
  final int overdueCount;
  final int partialCount;

  double get efficiency => totalDue > 0 ? (totalCollected / totalDue) * 100 : 100;
}

abstract interface class CollectionRepository {
  Future<List<CollectionEntry>> fetchForDate(DateTime date);

  Future<CollectionSummary> summaryForDate(DateTime date);
}
