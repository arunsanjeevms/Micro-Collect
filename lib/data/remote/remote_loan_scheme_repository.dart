import '../../core/data/entity_kind.dart';
import '../../core/models/loan_scheme.dart';
import '../repositories/loan_scheme_repository.dart';
import 'api_client.dart';
import 'dto_mappers.dart';
import 'remote_change_feed.dart';

class RemoteLoanSchemeRepository implements LoanSchemeRepository {
  RemoteLoanSchemeRepository(this._client, this._changeFeed);

  final ApiClient _client;
  final RemoteChangeFeed _changeFeed;

  @override
  Future<List<LoanScheme>> fetchAll() async {
    final json = await _client.get('/loan-schemes') as List;
    return json
        .map((e) => loanSchemeFromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<LoanScheme> create(LoanSchemeDraft draft) async {
    final json = await _client.post(
      '/loan-schemes',
      body: {
        'code': draft.code,
        'name': draft.name,
        'active': draft.active,
        'principalMin': draft.principalMin,
        'principalMax': draft.principalMax,
        'tenureMin': draft.tenureMin,
        'tenureMax': draft.tenureMax,
        'tenureUnit': draft.tenureUnit,
        'frequency': draft.frequency,
      },
    );
    final scheme = loanSchemeFromJson(json as Map<String, dynamic>);
    _changeFeed.publish(const DataChange({EntityKind.loanScheme}));
    return scheme;
  }

  @override
  Future<LoanScheme> setActive(String id, bool active) async {
    final json = await _client.patch(
      '/loan-schemes/$id',
      body: {'active': active},
    );
    final scheme = loanSchemeFromJson(json as Map<String, dynamic>);
    _changeFeed.publish(const DataChange({EntityKind.loanScheme}));
    return scheme;
  }

  @override
  Future<void> delete(String id) async {
    await _client.delete('/loan-schemes/$id');
    _changeFeed.publish(const DataChange({EntityKind.loanScheme}));
  }
}
