import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_collection.freezed.dart';

/// ─── Report Data ────────────────────────────────────────────────
@freezed
abstract class DailyCollection with _$DailyCollection {
  const DailyCollection._();

  const factory DailyCollection({
    required DateTime date,
    required double collected,
    required double due,
  }) = _DailyCollection;

  double get efficiency => due > 0 ? (collected / due) * 100 : 100;
}
