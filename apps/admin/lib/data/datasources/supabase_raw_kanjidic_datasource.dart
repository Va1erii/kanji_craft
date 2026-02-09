import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/raw_kanjidic.dart';
import '../dto/raw_kanjidic_dto.dart';

class SupabaseRawKanjidicDataSource {
  SupabaseRawKanjidicDataSource(this._client);

  final SupabaseClient _client;

  static const _table = 'raw_kanjidic';

  Future<void> insertBatch(List<RawKanjidic> rows) async {
    final payload =
        rows.map((r) => RawKanjidicDto.fromDomain(r).toJson()).toList();
    await _client.from(_table).insert(payload);
  }

  Future<List<RawKanjidic>> getByImportId(int importId) async {
    final response = await _client
        .from(_table)
        .select()
        .eq('import_id', importId)
        .order('literal');
    return response
        .map((json) => RawKanjidicDto.fromJson(json).toDomain())
        .toList();
  }

  Future<RawKanjidic?> getByLiteral({
    required int importId,
    required String literal,
  }) async {
    final response = await _client
        .from(_table)
        .select()
        .eq('import_id', importId)
        .eq('literal', literal)
        .maybeSingle();
    if (response == null) return null;
    return RawKanjidicDto.fromJson(response).toDomain();
  }

  Future<int> countByImportId(int importId) async {
    final response = await _client
        .from(_table)
        .select()
        .eq('import_id', importId)
        .count(CountOption.exact);
    return response.count;
  }

  Future<List<RawKanjidic>> getByImportIdCreatedSince(
    int importId,
    DateTime since,
  ) async {
    final response = await _client
        .from(_table)
        .select()
        .eq('import_id', importId)
        .gt('created_at', since.toIso8601String())
        .order('literal');
    return response
        .map((json) => RawKanjidicDto.fromJson(json).toDomain())
        .toList();
  }
}
