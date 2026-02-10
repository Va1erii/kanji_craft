import 'package:freezed_annotation/freezed_annotation.dart';

import '../logic_hint.dart';
import '../radical/position.dart';
import '../radical_type.dart';

part 'kanji_component.freezed.dart';

@freezed
abstract class KanjiComponent with _$KanjiComponent {
  const KanjiComponent._();

  const factory KanjiComponent({
    required int id,
    required int kanjiId,
    required int radicalId,
    required Position position,
    required LogicHint logicHint,
    required RadicalType radicalType,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _KanjiComponent;

  /// Whether this component is the primary dictionary radical for its kanji.
  /// True only when [radicalType] is [RadicalType.general].
  bool get isPrimary => radicalType == RadicalType.general;
}
