import '../../domain/entities/data_import.dart';
import '../../domain/entities/import_status.dart';
import '../../domain/entities/kanji_component_review.dart';
import 'package:kanji_craft_core/domain/entities/verification_status.dart';
import '../datasources/supabase_data_import_datasource.dart';
import '../datasources/supabase_kanji_component_review_datasource.dart';
import '../datasources/supabase_raw_kanjidic_datasource.dart';
import '../datasources/supabase_raw_kanjivg_datasource.dart';
import '../local/admin_database.dart';
import '../repositories/drift_data_import_repository.dart';
import '../repositories/drift_kanji_component_review_repository.dart';
import '../repositories/drift_raw_kanjidic_repository.dart';
import '../repositories/drift_raw_kanjivg_repository.dart';

class AdminSyncService {
  AdminSyncService({
    required AdminDatabase db,
    required SupabaseDataImportDataSource remoteImports,
    required DriftDataImportRepository localImports,
    required SupabaseRawKanjiVgDataSource remoteKanjiVg,
    required DriftRawKanjiVgRepository localKanjiVg,
    required SupabaseRawKanjidicDataSource remoteKanjidic,
    required DriftRawKanjidicRepository localKanjidic,
    required SupabaseKanjiComponentReviewDataSource remoteReviews,
    required DriftKanjiComponentReviewRepository localReviews,
  })  : _db = db,
        _remoteImports = remoteImports,
        _localImports = localImports,
        _remoteKanjiVg = remoteKanjiVg,
        _localKanjiVg = localKanjiVg,
        _remoteKanjidic = remoteKanjidic,
        _localKanjidic = localKanjidic,
        _remoteReviews = remoteReviews,
        _localReviews = localReviews;

  final AdminDatabase _db;
  final SupabaseDataImportDataSource _remoteImports;
  final DriftDataImportRepository _localImports;
  final SupabaseRawKanjiVgDataSource _remoteKanjiVg;
  final DriftRawKanjiVgRepository _localKanjiVg;
  final SupabaseRawKanjidicDataSource _remoteKanjidic;
  final DriftRawKanjidicRepository _localKanjidic;
  final SupabaseKanjiComponentReviewDataSource _remoteReviews;
  final DriftKanjiComponentReviewRepository _localReviews;

  // -- Sync metadata helpers --

  Future<DateTime?> _getLastSynced(String key) async {
    final row = await (_db.select(_db.syncMetadataEntries)
          ..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    return row?.lastSyncedAt;
  }

  Future<void> _setLastSynced(String key) async {
    await _db.into(_db.syncMetadataEntries).insertOnConflictUpdate(
          SyncMetadataEntriesCompanion.insert(
            key: key,
            lastSyncedAt: DateTime.now().toUtc(),
          ),
        );
  }

  // -- Pull methods --

  /// Pulls imports from Supabase into local Drift (incremental if possible).
  Future<void> pullImports() async {
    const key = 'imports';
    final lastSynced = await _getLastSynced(key);

    final imports = lastSynced == null
        ? await _remoteImports.listAll()
        : await _remoteImports.listUpdatedSince(lastSynced);

    if (imports.isNotEmpty) {
      await _localImports.upsertAll(imports);
    }
    await _setLastSynced(key);
  }

  /// Pulls KanjiVG rows for [importId] (incremental if possible).
  Future<void> pullKanjiVg(int importId) async {
    final key = 'kanjivg:$importId';
    final lastSynced = await _getLastSynced(key);

    final rows = lastSynced == null
        ? await _remoteKanjiVg.getByImportId(importId)
        : await _remoteKanjiVg.getByImportIdCreatedSince(
            importId, lastSynced);

    if (rows.isNotEmpty) {
      await _localKanjiVg.upsertAll(rows);
    }
    await _setLastSynced(key);
  }

  /// Pulls KANJIDIC rows for [importId] (incremental if possible).
  Future<void> pullKanjidic(int importId) async {
    final key = 'kanjidic:$importId';
    final lastSynced = await _getLastSynced(key);

    final rows = lastSynced == null
        ? await _remoteKanjidic.getByImportId(importId)
        : await _remoteKanjidic.getByImportIdCreatedSince(
            importId, lastSynced);

    if (rows.isNotEmpty) {
      await _localKanjidic.upsertAll(rows);
    }
    await _setLastSynced(key);
  }

  /// Pulls reviews from Supabase (incremental if possible).
  Future<void> pullReviews() async {
    const key = 'reviews';
    final lastSynced = await _getLastSynced(key);

    final reviews = lastSynced == null
        ? await _remoteReviews.getDraftReviews()
        : await _remoteReviews.getUpdatedSince(lastSynced);

    if (reviews.isNotEmpty) {
      await _localReviews.upsertAll(reviews);
    }
    await _setLastSynced(key);
  }

  /// Pulls everything: imports, their data rows, and reviews.
  Future<void> pullAll() async {
    await pullImports();

    final imports = await _localImports.listAll();
    for (final imp in imports) {
      await pullKanjiVg(imp.id);
      await pullKanjidic(imp.id);
    }

    await pullReviews();
  }

  // -- Push methods --

  /// Pushes an import status update to Supabase and syncs back locally.
  Future<DataImport> pushImportStatus({
    required int id,
    required ImportStatus status,
    int? recordCount,
    String? errorMessage,
  }) async {
    final updated = await _remoteImports.updateStatus(
      id: id,
      status: status,
      recordCount: recordCount,
      errorMessage: errorMessage,
    );
    await _localImports.upsertAll([updated]);
    return updated;
  }

  /// Pushes a review status update to Supabase and syncs back locally.
  Future<KanjiComponentReview> pushReviewStatus({
    required int id,
    required VerificationStatus status,
  }) async {
    final updated = await _remoteReviews.updateStatus(
      id: id,
      status: status,
    );
    await _localReviews.upsertAll([updated]);
    return updated;
  }
}
