import 'package:freezed_annotation/freezed_annotation.dart';

part 'area.freezed.dart';

/// ─── Area Model ──────────────────────────────────────────────────
/// customers/activeLoans/outstanding are derived server-side from the
/// borrowers assigned to this area - never caller-supplied.
@freezed
abstract class Area with _$Area {
  const factory Area({
    required String id,
    required String code,
    required String name,
    required bool active,
    required int customers,
    required int activeLoans,
    required double outstanding,
  }) = _Area;
}
