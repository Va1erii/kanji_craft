import 'package:freezed_annotation/freezed_annotation.dart';

import '../logic_hint.dart';
import '../radical/position.dart';

part 'kanji_component.freezed.dart';

@freezed
abstract class KanjiComponent with _$KanjiComponent {
  const factory KanjiComponent({
    required int id,
    required int kanjiId,
    required int radicalId,
    required Position position,
    required LogicHint logicHint,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _KanjiComponent;
}
