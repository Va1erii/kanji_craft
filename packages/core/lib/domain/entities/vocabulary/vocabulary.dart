import 'package:freezed_annotation/freezed_annotation.dart';

import '../misc_tag.dart';
import '../pos_tag.dart';
import 'vocabulary_segment.dart';

part 'vocabulary.freezed.dart';

@freezed
abstract class Vocabulary with _$Vocabulary {
  const factory Vocabulary({
    required int id,
    required String word,
    required List<VocabularySegment> segments,
    int? minJlptLevel,
    @Default([]) List<PosTag> posTags,
    @Default([]) List<MiscTag> miscTags,
    @Default([]) List<String> fieldTags,
    @Default([]) List<String> dialectTags,
    required int frequencyRank,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Vocabulary;
}
