/// ─── Report Data ────────────────────────────────────────────────
class DailyCollection {
  final DateTime date;
  final double collected;
  final double due;

  const DailyCollection({
    required this.date,
    required this.collected,
    required this.due,
  });

  double get efficiency => due > 0 ? (collected / due) * 100 : 100;
}
