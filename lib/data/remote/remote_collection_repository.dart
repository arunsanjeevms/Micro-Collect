import '../../core/data/entity_kind.dart';
import '../../core/models/collection_entry.dart';
import '../../core/models/payment.dart';
import '../repositories/collection_repository.dart';
import 'api_client.dart';
import 'dto_mappers.dart';
import 'remote_change_feed.dart';

String _dateParam(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

class RemoteCollectionRepository implements CollectionRepository {
  RemoteCollectionRepository(this._client, this._changeFeed);

  final ApiClient _client;
  final RemoteChangeFeed _changeFeed;

  @override
  Future<List<CollectionEntry>> fetchForDate(DateTime date) async {
    final json = await _client.get(
      '/collections',
      query: {'date': _dateParam(date)},
    ) as List;
    return json
        .map((e) => collectionEntryFromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<CollectionSummary> summaryForDate(DateTime date) async {
    final json = await _client.get(
      '/collections/summary',
      query: {'date': _dateParam(date)},
    );
    return collectionSummaryFromJson(json as Map<String, dynamic>);
  }

  @override
  Future<PaymentReceipt> recordPayment(RecordPaymentInput input) async {
    final json = await _client.post(
      '/collections/${input.collectionId}/payments',
      body: {
        'amount': input.amount,
        'mode': input.mode.name,
        'notes': input.notes,
      },
    );
    final receipt = paymentReceiptFromJson(json as Map<String, dynamic>);
    _changeFeed.publish(
      const DataChange({
        EntityKind.loan,
        EntityKind.installment,
        EntityKind.borrower,
        EntityKind.collection,
        EntityKind.payment,
        EntityKind.report,
      }),
    );
    return receipt;
  }

  @override
  Future<List<Payment>> paymentsForDate(DateTime date) async {
    final json = await _client.get(
      '/collections/payments',
      query: {'date': _dateParam(date)},
    ) as List;
    return json.map((e) => paymentFromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<Payment>> paymentsForLoan(String loanId) async {
    final json = await _client.get('/loans/$loanId/payments') as List;
    return json.map((e) => paymentFromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<Payment>> paymentsForBorrower(
    String borrowerId, {
    int limit = 10,
  }) async {
    final json = await _client.get(
      '/borrowers/$borrowerId/payments',
      query: {'limit': '$limit'},
    ) as List;
    return json.map((e) => paymentFromJson(e as Map<String, dynamic>)).toList();
  }
}
