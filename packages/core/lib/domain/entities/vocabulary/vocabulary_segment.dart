import 'package:freezed_annotation/freezed_annotation.dart';

part 'vocabulary_segment.freezed.dart';

@freezed
abstract class VocabularySegment with _$VocabularySegment {
  const factory VocabularySegment({
    required String text,
    String? reading,
    int? kanjiId,
    List<int>? kanjiIds,
  }) = _VocabularySegment;
}
