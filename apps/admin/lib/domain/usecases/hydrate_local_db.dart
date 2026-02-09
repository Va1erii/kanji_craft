import '../services/admin_state_reader.dart';
import '../services/admin_state_writer.dart';

/// Pulls admin state from Remote into the local database on app startup.
///
/// The admin local DB is ephemeral — import history and review decisions
/// live in the Remote admin schema. This use case rebuilds local state
/// by reading from [AdminStateReader] and writing to [AdminStateWriter].
///
/// Raw data tables are not hydrated; they are rebuilt from source files
/// via [IngestSourceData].
///
/// Yields [HydrationStep]s reporting progress. Stream completion = success.
/// Errors propagate naturally (no catch) — the consuming BLoC handles them.
class HydrateLocalDb {
  HydrateLocalDb({
    required AdminStateReader reader,
    required AdminStateWriter writer,
  })  : _reader = reader,
        _writer = writer;

  final AdminStateReader _reader;
  final AdminStateWriter _writer;

  Stream<HydrationStep> call() async* {
    yield const HydrationStep.pullingImports();
    final imports = await _reader.fetchImports();
    await _writer.saveImports(imports);

    yield const HydrationStep.pullingReviews();
    final reviews = await _reader.fetchReviews();
    await _writer.saveReviews(reviews);
  }
}

sealed class HydrationStep {
  const HydrationStep();
  const factory HydrationStep.pullingImports() = HydrationPullingImports;
  const factory HydrationStep.pullingReviews() = HydrationPullingReviews;
}

class HydrationPullingImports extends HydrationStep {
  const HydrationPullingImports();
}

class HydrationPullingReviews extends HydrationStep {
  const HydrationPullingReviews();
}
