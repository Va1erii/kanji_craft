import 'package:freezed_annotation/freezed_annotation.dart';

import '../logic_hint.dart';

part 'kanji_component.freezed.dart';

@freezed
abstract class KanjiComponent with _$KanjiComponent {
  const factory KanjiComponent({
    required int id,
    required int kanjiId,
    required int radicalId,
    required LogicHint logicHint,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _KanjiComponent;
}
