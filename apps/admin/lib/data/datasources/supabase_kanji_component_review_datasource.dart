import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/kanji_component_review.dart';
import 'package:kanji_craft_core/domain/entities/verification_status.dart';
import '../dto/kanji_component_review_dto.dart';

class SupabaseKanjiComponentReviewDataSource {
  SupabaseKanjiComponentReviewDataSource(this._client);

  final SupabaseClient _client;

  static const _table = 'kanji_component_reviews';

  Future<KanjiComponentReview> create({
    required int kanjiComponentId,
    required VerificationStatus verificationStatus,
    double? aiConfidence,
  }) async {
    final response = await _client
        .from(_table)
        .insert({
          'kanji_component_id': kanjiComponentId,
          'verification_status': verificationStatus.name,
          'ai_confidence': ?aiConfidence,
        })
        .select()
        .single();
    return KanjiComponentReviewDto.fromJson(response).toDomain();
  }

  Future<KanjiComponentReview?> getByComponentId(
    int kanjiComponentId,
  ) async {
    final response = await _client
        .from(_table)
        .select()
        .eq('kanji_component_id', kanjiComponentId)
        .maybeSingle();
    if (response == null) return null;
    return KanjiComponentReviewDto.fromJson(response).toDomain();
  }

  Future<List<KanjiComponentReview>> listAll() async {
    final response = await _client
        .from(_table)
        .select()
        .order('created_at', ascending: false);
    return response
        .map((json) => KanjiComponentReviewDto.fromJson(json).toDomain())
        .toList();
  }

  Future<List<KanjiComponentReview>> getDraftReviews({int? limit}) async {
    var query = _client
        .from(_table)
        .select()
        .eq('verification_status', VerificationStatus.draft.name)
        .order('ai_confidence', ascending: true);
    if (limit != null) {
      query = query.limit(limit);
    }
    final response = await query;
    return response
        .map((json) => KanjiComponentReviewDto.fromJson(json).toDomain())
        .toList();
  }

  Future<KanjiComponentReview> updateStatus({
    required int id,
    required VerificationStatus status,
  }) async {
    final response = await _client
        .from(_table)
        .update({'verification_status': status.name})
        .eq('id', id)
        .select()
        .single();
    return KanjiComponentReviewDto.fromJson(response).toDomain();
  }

  Future<int> bulkVerify({required double threshold}) async {
    final response = await _client
        .from(_table)
        .update({'verification_status': VerificationStatus.verified.name})
        .eq('verification_status', VerificationStatus.draft.name)
        .gte('ai_confidence', threshold)
        .select()
        .count(CountOption.exact);
    return response.count;
  }

  Future<List<KanjiComponentReview>> getUpdatedSince(DateTime since) async {
    final response = await _client
        .from(_table)
        .select()
        .gt('updated_at', since.toIso8601String())
        .order('updated_at');
    return response
        .map((json) => KanjiComponentReviewDto.fromJson(json).toDomain())
        .toList();
  }
}
