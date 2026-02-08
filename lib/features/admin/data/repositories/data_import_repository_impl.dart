import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/data_import.dart';
import '../../domain/entities/import_source.dart';
import '../../domain/entities/import_status.dart';
import '../../domain/repositories/data_import_repository.dart';
import '../dto/data_import_dto.dart';

class DataImportRepositoryImpl implements DataImportRepository {
  DataImportRepositoryImpl(this._client);

  final SupabaseClient _client;

  static const _table = 'data_imports';

  @override
  Future<DataImport> create({
    required ImportSource source,
    required String sourceVersion,
    Map<String, Object?>? metadata,
  }) async {
    final response = await _client
        .from(_table)
        .insert({
          'source': source.name,
          'source_version': sourceVersion,
          'metadata': ?metadata,
        })
        .select()
        .single();
    return DataImportDto.fromJson(response).toDomain();
  }

  @override
  Future<DataImport?> getById(int id) async {
    final response = await _client
        .from(_table)
        .select()
        .eq('id', id)
        .maybeSingle();
    if (response == null) return null;
    return DataImportDto.fromJson(response).toDomain();
  }

  @override
  Future<DataImport?> getActiveBySource(ImportSource source) async {
    final response = await _client
        .from(_table)
        .select()
        .eq('source', source.name)
        .not('status', 'in', '(promoted,failed)')
        .maybeSingle();
    if (response == null) return null;
    return DataImportDto.fromJson(response).toDomain();
  }

  @override
  Future<DataImport> updateStatus({
    required int id,
    required ImportStatus status,
    int? recordCount,
    String? errorMessage,
  }) async {
    final updates = <String, Object?>{
      'status': status.name,
      'record_count': ?recordCount,
      'error_message': ?errorMessage,
    };

    // Set phase timestamps based on status transition.
    switch (status) {
      case ImportStatus.ingested:
        updates['ingested_at'] = DateTime.now().toUtc().toIso8601String();
      case ImportStatus.processed:
        updates['processed_at'] = DateTime.now().toUtc().toIso8601String();
      case ImportStatus.promoted:
        updates['promoted_at'] = DateTime.now().toUtc().toIso8601String();
      case ImportStatus.pending:
      case ImportStatus.processing:
      case ImportStatus.failed:
        break;
    }

    final response = await _client
        .from(_table)
        .update(updates)
        .eq('id', id)
        .select()
        .single();
    return DataImportDto.fromJson(response).toDomain();
  }

  @override
  Future<List<DataImport>> listAll() async {
    final response = await _client
        .from(_table)
        .select()
        .order('created_at', ascending: false);
    return response
        .map((json) => DataImportDto.fromJson(json).toDomain())
        .toList();
  }
}
