import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../domain/entities/raw_jmdict.dart';
import '../../../domain/entities/raw_kanjidic.dart';
import '../../../domain/entities/raw_kanjivg.dart';
import '../../dto/raw_jmdict_dto.dart';
import '../../dto/raw_kanjidic_dto.dart';
import '../../dto/raw_kanjivg_dto.dart';

// ---------------------------------------------------------------------------
// KanjiVG converters
// ---------------------------------------------------------------------------

class KanjiVgStrokesConverter
    extends TypeConverter<List<KanjiVgStroke>, String> {
  const KanjiVgStrokesConverter();

  @override
  List<KanjiVgStroke> fromSql(String fromDb) {
    final list = jsonDecode(fromDb) as List;
    return list
        .map((e) =>
            KanjiVgStrokeDto.fromJson(e as Map<String, Object?>).toDomain())
        .toList();
  }

  @override
  String toSql(List<KanjiVgStroke> value) {
    final dtos = value.map(KanjiVgStrokeDto.fromDomain).toList();
    return jsonEncode(dtos.map((d) => d.toJson()).toList());
  }
}

class KanjiVgComponentConverter
    extends TypeConverter<KanjiVgComponent, String> {
  const KanjiVgComponentConverter();

  @override
  KanjiVgComponent fromSql(String fromDb) {
    final json = jsonDecode(fromDb) as Map<String, Object?>;
    return KanjiVgComponentDto.fromJson(json).toDomain();
  }

  @override
  String toSql(KanjiVgComponent value) {
    return jsonEncode(KanjiVgComponentDto.fromDomain(value).toJson());
  }
}

// ---------------------------------------------------------------------------
// Kanjidic converters
// ---------------------------------------------------------------------------

class KanjidicCodepointsConverter
    extends TypeConverter<KanjidicCodepoints, String> {
  const KanjidicCodepointsConverter();

  @override
  KanjidicCodepoints fromSql(String fromDb) {
    final json = jsonDecode(fromDb) as Map<String, Object?>;
    return KanjidicCodepointsDto.fromJson(json).toDomain();
  }

  @override
  String toSql(KanjidicCodepoints value) {
    return jsonEncode(KanjidicCodepointsDto.fromDomain(value).toJson());
  }
}

class KanjidicRadicalsConverter
    extends TypeConverter<KanjidicRadicals, String> {
  const KanjidicRadicalsConverter();

  @override
  KanjidicRadicals fromSql(String fromDb) {
    final json = jsonDecode(fromDb) as Map<String, Object?>;
    return KanjidicRadicalsDto.fromJson(json).toDomain();
  }

  @override
  String toSql(KanjidicRadicals value) {
    return jsonEncode(KanjidicRadicalsDto.fromDomain(value).toJson());
  }
}

class KanjidicDictRefsConverter
    extends TypeConverter<KanjidicDictRefs?, String?> {
  const KanjidicDictRefsConverter();

  @override
  KanjidicDictRefs? fromSql(String? fromDb) {
    if (fromDb == null) return null;
    final json = jsonDecode(fromDb) as Map<String, Object?>;
    return KanjidicDictRefsDto.fromJson(json).toDomain();
  }

  @override
  String? toSql(KanjidicDictRefs? value) {
    if (value == null) return null;
    return jsonEncode(KanjidicDictRefsDto.fromDomain(value).toJson());
  }
}

class KanjidicQueryCodesConverter
    extends TypeConverter<KanjidicQueryCodes?, String?> {
  const KanjidicQueryCodesConverter();

  @override
  KanjidicQueryCodes? fromSql(String? fromDb) {
    if (fromDb == null) return null;
    final json = jsonDecode(fromDb) as Map<String, Object?>;
    return KanjidicQueryCodesDto.fromJson(json).toDomain();
  }

  @override
  String? toSql(KanjidicQueryCodes? value) {
    if (value == null) return null;
    return jsonEncode(KanjidicQueryCodesDto.fromDomain(value).toJson());
  }
}

class KanjidicReadingsConverter
    extends TypeConverter<KanjidicReadings, String> {
  const KanjidicReadingsConverter();

  @override
  KanjidicReadings fromSql(String fromDb) {
    final json = jsonDecode(fromDb) as Map<String, Object?>;
    return KanjidicReadingsDto.fromJson(json).toDomain();
  }

  @override
  String toSql(KanjidicReadings value) {
    return jsonEncode(KanjidicReadingsDto.fromDomain(value).toJson());
  }
}

class KanjidicVariantsConverter
    extends TypeConverter<List<KanjidicVariant>?, String?> {
  const KanjidicVariantsConverter();

  @override
  List<KanjidicVariant>? fromSql(String? fromDb) {
    if (fromDb == null) return null;
    final list = jsonDecode(fromDb) as List;
    return list
        .map((e) =>
            KanjidicVariantDto.fromJson(e as Map<String, Object?>).toDomain())
        .toList();
  }

  @override
  String? toSql(List<KanjidicVariant>? value) {
    if (value == null) return null;
    final dtos = value.map(KanjidicVariantDto.fromDomain).toList();
    return jsonEncode(dtos.map((d) => d.toJson()).toList());
  }
}

// ---------------------------------------------------------------------------
// Generic converters
// ---------------------------------------------------------------------------

class IntListConverter extends TypeConverter<List<int>?, String?> {
  const IntListConverter();

  @override
  List<int>? fromSql(String? fromDb) {
    if (fromDb == null) return null;
    final list = jsonDecode(fromDb) as List;
    return list.cast<int>();
  }

  @override
  String? toSql(List<int>? value) {
    if (value == null) return null;
    return jsonEncode(value);
  }
}

class StringListConverter extends TypeConverter<List<String>?, String?> {
  const StringListConverter();

  @override
  List<String>? fromSql(String? fromDb) {
    if (fromDb == null) return null;
    final list = jsonDecode(fromDb) as List;
    return list.cast<String>();
  }

  @override
  String? toSql(List<String>? value) {
    if (value == null) return null;
    return jsonEncode(value);
  }
}

class MeaningsConverter
    extends TypeConverter<Map<String, List<String>>, String> {
  const MeaningsConverter();

  @override
  Map<String, List<String>> fromSql(String fromDb) {
    final map = jsonDecode(fromDb) as Map<String, Object?>;
    return map.map(
      (key, value) => MapEntry(key, (value! as List).cast<String>()),
    );
  }

  @override
  String toSql(Map<String, List<String>> value) => jsonEncode(value);
}

// ---------------------------------------------------------------------------
// JMDict converters
// ---------------------------------------------------------------------------

class JmdictKanjiElementsConverter
    extends TypeConverter<List<JmdictKanjiElement>, String> {
  const JmdictKanjiElementsConverter();

  @override
  List<JmdictKanjiElement> fromSql(String fromDb) {
    final list = jsonDecode(fromDb) as List;
    return list
        .map((e) => JmdictKanjiElementDto.fromJson(e as Map<String, Object?>)
            .toDomain())
        .toList();
  }

  @override
  String toSql(List<JmdictKanjiElement> value) {
    final dtos = value.map(JmdictKanjiElementDto.fromDomain).toList();
    return jsonEncode(dtos.map((d) => d.toJson()).toList());
  }
}

class JmdictReadingElementsConverter
    extends TypeConverter<List<JmdictReadingElement>, String> {
  const JmdictReadingElementsConverter();

  @override
  List<JmdictReadingElement> fromSql(String fromDb) {
    final list = jsonDecode(fromDb) as List;
    return list
        .map((e) =>
            JmdictReadingElementDto.fromJson(e as Map<String, Object?>)
                .toDomain())
        .toList();
  }

  @override
  String toSql(List<JmdictReadingElement> value) {
    final dtos = value.map(JmdictReadingElementDto.fromDomain).toList();
    return jsonEncode(dtos.map((d) => d.toJson()).toList());
  }
}

class JmdictSensesConverter
    extends TypeConverter<List<JmdictSense>, String> {
  const JmdictSensesConverter();

  @override
  List<JmdictSense> fromSql(String fromDb) {
    final list = jsonDecode(fromDb) as List;
    return list
        .map((e) =>
            JmdictSenseDto.fromJson(e as Map<String, Object?>).toDomain())
        .toList();
  }

  @override
  String toSql(List<JmdictSense> value) {
    final dtos = value.map(JmdictSenseDto.fromDomain).toList();
    return jsonEncode(dtos.map((d) => d.toJson()).toList());
  }
}

// ---------------------------------------------------------------------------
// Generic converters
// ---------------------------------------------------------------------------

class JsonMapConverter extends TypeConverter<Map<String, Object?>?, String?> {
  const JsonMapConverter();

  @override
  Map<String, Object?>? fromSql(String? fromDb) {
    if (fromDb == null) return null;
    return jsonDecode(fromDb) as Map<String, Object?>;
  }

  @override
  String? toSql(Map<String, Object?>? value) {
    if (value == null) return null;
    return jsonEncode(value);
  }
}
