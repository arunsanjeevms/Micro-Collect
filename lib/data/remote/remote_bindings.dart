import '../../core/auth/auth_controller.dart';
import '../../core/auth/backend_mode.dart';
import '../../core/data/data_revision.dart';
import '../repositories/repository_providers.dart';
import 'api_client.dart';
import 'remote_borrower_repository.dart';
import 'remote_change_feed.dart';
import 'remote_collection_repository.dart';
import 'remote_loan_repository.dart';

/// Every ProviderScope override the real Node/MySQL backend needs -
/// overrides the same three repository providers and changeFeedProvider
/// as lib/data/mock/mock_bindings.dart, so swapping between mock and
/// remote is a one-line change in main.dart and nothing else in the app
/// needs to know which is active.
///
/// All three repositories share one RemoteChangeFeed (each publishes into
/// it after a successful write - see remote_change_feed.dart) and each
/// gets its own ApiClient reading the current token from
/// authControllerProvider on every request, so a login/logout is picked
/// up immediately without rebuilding the repositories.
// ignore: strict_top_level_inference
remoteBackendOverrides() {
  final changeFeed = RemoteChangeFeed();

  return [
    usesRemoteBackendProvider.overrideWith((ref) => true),
    changeFeedProvider.overrideWith((ref) => changeFeed),
    borrowerRepositoryProvider.overrideWith(
      (ref) => RemoteBorrowerRepository(
        ApiClient(tokenProvider: () => ref.read(authControllerProvider).token),
        changeFeed,
      ),
    ),
    loanRepositoryProvider.overrideWith(
      (ref) => RemoteLoanRepository(
        ApiClient(tokenProvider: () => ref.read(authControllerProvider).token),
        changeFeed,
      ),
    ),
    collectionRepositoryProvider.overrideWith(
      (ref) => RemoteCollectionRepository(
        ApiClient(tokenProvider: () => ref.read(authControllerProvider).token),
        changeFeed,
      ),
    ),
  ];
}
