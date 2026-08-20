import '../../core/data/entity_kind.dart';
import '../../core/errors/app_exception.dart';
import '../../core/models/borrower.dart';
import '../repositories/borrower_repository.dart';
import 'api_client.dart';
import 'dto_mappers.dart';
import 'remote_change_feed.dart';

class RemoteBorrowerRepository implements BorrowerRepository {
  RemoteBorrowerRepository(this._client, this._changeFeed);

  final ApiClient _client;
  final RemoteChangeFeed _changeFeed;

  @override
  Future<List<Borrower>> fetchAll() async {
    final json = await _client.get('/borrowers') as List;
    return json
        .map((e) => borrowerFromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Borrower?> findById(String id) async {
    try {
      final json = await _client.get('/borrowers/$id') as Map<String, dynamic>;
      return borrowerFromJson(json);
    } on NotFoundException {
      return null;
    }
  }

  @override
  Future<Borrower> create(BorrowerDraft draft) async {
    final json = await _client.post(
      '/borrowers',
      body: {
        'name': draft.name,
        'mobile': draft.mobile,
        'aadhaar': draft.aadhaar,
        'village': draft.village,
        'address': draft.address,
        'pinCode': draft.pinCode,
      },
    );
    final borrower = borrowerFromJson(json as Map<String, dynamic>);
    _changeFeed.publish(const DataChange({EntityKind.borrower}));
    return borrower;
  }
}
