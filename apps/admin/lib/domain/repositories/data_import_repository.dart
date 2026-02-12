import '../entities/data_import.dart';
import '../entities/import_source.dart';
import '../entities/import_status.dart';

abstract class DataImportRepository {
  /// Creates a new import run with status [pending].
  Future<DataImport> create({
    required ImportSource source,
    required String sourceVersion,
    Map<String, Object?>? metadata,
  });

  /// Fetches an import by its [id]. Returns null if not found.
  Future<DataImport?> getById(int id);

  /// Returns the active (non-terminal) import for [source], if any.
  /// An import is active if its status is not `processed` or `failed`.
  Future<DataImport?> getActiveBySource(ImportSource source);

  /// Updates the status and related fields of an import.
  Future<DataImport> updateStatus({
    required int id,
    required ImportStatus status,
    int? recordCount,
    String? errorMessage,
    Map<String, Object?>? metadata,
  });

  /// Returns whether a processed import exists for [source] with [sourceVersion].
  Future<bool> hasProcessedVersion({
    required ImportSource source,
    required String sourceVersion,
  });

  /// Deletes an import by [id].
  Future<void> delete(int id);

  /// Lists all imports, most recent first.
  Future<List<DataImport>> listAll();

  /// Bulk upserts imports (insert or replace on conflict).
  Future<void> upsertAll(List<DataImport> imports);
}
