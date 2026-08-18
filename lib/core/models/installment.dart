import 'package:freezed_annotation/freezed_annotation.dart';

part 'installment.freezed.dart';

enum InstallmentStatus { paid, pending, overdue, partial, advance }

/// ─── Installment Model ──────────────────────────────────────────
@freezed
abstract class Installment with _$Installment {
  const factory Installment({
    required String id,
    required int number,
    required DateTime dueDate,
    required double amount,
    double? paidAmount,
    DateTime? paidDate,
    required InstallmentStatus status,
  }) = _Installment;
}
