import '../../core/models/loan_scheme.dart';
import '../repositories/loan_scheme_repository.dart';
import 'api_client.dart';
import 'dto_mappers.dart';

class RemoteLoanSchemeRepository implements LoanSchemeRepository {
  RemoteLoanSchemeRepository(this._client);

  final ApiClient _client;

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
    return loanSchemeFromJson(json as Map<String, dynamic>);
  }

  @override
  Future<LoanScheme> setActive(String id, bool active) async {
    final json = await _client.patch(
      '/loan-schemes/$id',
      body: {'active': active},
    );
    return loanSchemeFromJson(json as Map<String, dynamic>);
  }

  @override
  Future<void> delete(String id) => _client.delete('/loan-schemes/$id');
}
