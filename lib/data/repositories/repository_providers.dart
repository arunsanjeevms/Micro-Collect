import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'borrower_repository.dart';
import 'collection_repository.dart';
import 'loan_repository.dart';

part 'repository_providers.g.dart';

/// Unbound seams: the UI depends on these, never on a concrete
/// implementation. lib/data/mock/mock_bindings.dart supplies the mock
/// implementations via ProviderScope overrides; a real backend would
/// override the same three providers with its own implementations and
/// nothing outside this file would change.

@Riverpod(keepAlive: true)
BorrowerRepository borrowerRepository(Ref ref) {
  throw UnimplementedError(
    'borrowerRepositoryProvider must be overridden in ProviderScope - see '
    'lib/data/mock/mock_bindings.dart',
  );
}

@Riverpod(keepAlive: true)
LoanRepository loanRepository(Ref ref) {
  throw UnimplementedError(
    'loanRepositoryProvider must be overridden in ProviderScope - see '
    'lib/data/mock/mock_bindings.dart',
  );
}

@Riverpod(keepAlive: true)
CollectionRepository collectionRepository(Ref ref) {
  throw UnimplementedError(
    'collectionRepositoryProvider must be overridden in ProviderScope - see '
    'lib/data/mock/mock_bindings.dart',
  );
}
