import '../../core/models/borrower.dart';

/// The fields a new borrower registration collects. Deliberately separate
/// from Borrower itself, which also carries fields (activeLoans,
/// totalOutstanding, status) that only the backend can derive.
class BorrowerDraft {
  const BorrowerDraft({
    required this.name,
    required this.mobile,
    required this.aadhaar,
    required this.village,
    required this.address,
    required this.pinCode,
  });

  final String name;
  final String mobile;
  final String aadhaar;
  final String village;
  final String address;
  final String pinCode;
}

/// The UI depends only on this interface, never on how or where borrowers
/// are actually stored - see lib/data/mock/mock_borrower_repository.dart for
/// the implementation bound to it today.
abstract interface class BorrowerRepository {
  Future<List<Borrower>> fetchAll();

  Future<Borrower?> findById(String id);

  Future<Borrower> create(BorrowerDraft draft);
}
