import 'package:freezed_annotation/freezed_annotation.dart';

part 'vocabulary.freezed.dart';

@freezed
abstract class Vocabulary with _$Vocabulary {
  const factory Vocabulary({
    required int id,
    required String word,
    int? minJlptLevel,
    required int frequencyRank,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Vocabulary;
}
