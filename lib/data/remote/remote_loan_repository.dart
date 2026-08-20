import '../../core/data/entity_kind.dart';
import '../../core/errors/app_exception.dart';
import '../../core/models/collection_entry.dart';
import '../../core/models/loan.dart';
import '../repositories/collection_repository.dart';
import '../repositories/loan_repository.dart';
import 'api_client.dart';
import 'dto_mappers.dart';
import 'remote_change_feed.dart';

class RemoteLoanRepository implements LoanRepository {
  RemoteLoanRepository(this._client, this._changeFeed);

  final ApiClient _client;
  final RemoteChangeFeed _changeFeed;

  @override
  Future<List<Loan>> fetchAll() async {
    final json = await _client.get('/loans') as List;
    return json.map((e) => loanFromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<Loan?> findById(String id) async {
    try {
      final json = await _client.get('/loans/$id') as Map<String, dynamic>;
      return loanFromJson(json);
    } on NotFoundException {
      return null;
    }
  }

  @override
  Future<List<Loan>> fetchForBorrower(String borrowerId) async {
    final json = await _client.get('/borrowers/$borrowerId/loans') as List;
    return json.map((e) => loanFromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<Loan> create(LoanDraft draft) async {
    final json = await _client.post(
      '/loans',
      body: {
        'borrowerId': draft.borrowerId,
        'principal': draft.principal,
        'annualRate': draft.annualRate,
        'tenureMonths': draft.tenureMonths,
        'frequency': draft.frequency,
      },
    );
    final loan = loanFromJson(json as Map<String, dynamic>);
    _changeFeed.publish(
      const DataChange({EntityKind.loan, EntityKind.borrower}),
    );
    return loan;
  }

  @override
  Future<PaymentReceipt> closeLoan(
    String loanId, {
    required PaymentMode mode,
    String? notes,
  }) async {
    final json = await _client.post(
      '/loans/$loanId/close',
      body: {'mode': mode.name, 'notes': notes},
    );
    final receipt = paymentReceiptFromJson(json as Map<String, dynamic>);
    _changeFeed.publish(
      const DataChange({
        EntityKind.loan,
        EntityKind.installment,
        EntityKind.borrower,
        EntityKind.payment,
        EntityKind.report,
      }),
    );
    return receipt;
  }
}
