/// ─── Borrower Model ──────────────────────────────────────────────
class Borrower {
  final String id;
  final String name;
  final String mobile;
  final String aadhaar;
  final String village;
  final String address;
  final String pinCode;
  final String? photoUrl;
  final DateTime joinDate;
  final int activeLoans;
  final double totalOutstanding;
  final BorrowerStatus status;

  const Borrower({
    required this.id,
    required this.name,
    required this.mobile,
    required this.aadhaar,
    required this.village,
    required this.address,
    required this.pinCode,
    this.photoUrl,
    required this.joinDate,
    required this.activeLoans,
    required this.totalOutstanding,
    required this.status,
  });

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}';
    return name.substring(0, 1);
  }
}

enum BorrowerStatus { active, overdue, closed }
