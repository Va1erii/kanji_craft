import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/raw_kanjivg.dart';
import '../dto/raw_kanjivg_dto.dart';

class SupabaseRawKanjiVgDataSource {
  SupabaseRawKanjiVgDataSource(this._client);

  final SupabaseClient _client;

  static const _table = 'raw_kanjivg';

  Future<void> insertBatch(List<RawKanjiVg> rows) async {
    final payload =
        rows.map((r) => RawKanjiVgDto.fromDomain(r).toJson()).toList();
    await _client.from(_table).insert(payload);
  }

  Future<List<RawKanjiVg>> getByImportId(int importId) async {
    final response = await _client
        .from(_table)
        .select()
        .eq('import_id', importId)
        .order('character');
    return response
        .map((json) => RawKanjiVgDto.fromJson(json).toDomain())
        .toList();
  }

  Future<RawKanjiVg?> getByCharacter({
    required int importId,
    required String character,
  }) async {
    final response = await _client
        .from(_table)
        .select()
        .eq('import_id', importId)
        .eq('character', character)
        .maybeSingle();
    if (response == null) return null;
    return RawKanjiVgDto.fromJson(response).toDomain();
  }

  Future<int> countByImportId(int importId) async {
    final response = await _client
        .from(_table)
        .select()
        .eq('import_id', importId)
        .count(CountOption.exact);
    return response.count;
  }

  Future<List<RawKanjiVg>> getByImportIdCreatedSince(
    int importId,
    DateTime since,
  ) async {
    final response = await _client
        .from(_table)
        .select()
        .eq('import_id', importId)
        .gt('created_at', since.toIso8601String())
        .order('character');
    return response
        .map((json) => RawKanjiVgDto.fromJson(json).toDomain())
        .toList();
  }
}
