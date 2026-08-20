import 'package:freezed_annotation/freezed_annotation.dart';

part 'borrower.freezed.dart';

enum BorrowerStatus { active, overdue, closed }

/// ─── Borrower Model ──────────────────────────────────────────────
@freezed
abstract class Borrower with _$Borrower {
  const Borrower._();

  const factory Borrower({
    required String id,
    required String name,
    required String mobile,
    required String aadhaar,
    required String village,
    required String address,
    required String pinCode,
    String? photoUrl,
    required DateTime joinDate,
    required int activeLoans,
    required double totalOutstanding,
    required BorrowerStatus status,
    String? areaId,
  }) = _Borrower;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}';
    }
    return name.isEmpty ? '?' : name.substring(0, 1);
  }
}
