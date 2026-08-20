import 'package:freezed_annotation/freezed_annotation.dart';

part 'loan_scheme.freezed.dart';

/// ─── Loan Scheme Model ───────────────────────────────────────────
/// A preset an officer can pick from on the New Loan form instead of
/// typing principal/tenure/frequency from scratch.
@freezed
abstract class LoanScheme with _$LoanScheme {
  const factory LoanScheme({
    required String id,
    required String code,
    required String name,
    required bool active,
    required double principalMin,
    required double principalMax,
    required int tenureMin,
    required int tenureMax,
    required String tenureUnit, // Days, Weeks, Months
    required String frequency, // daily, weekly, monthly
  }) = _LoanScheme;
}
