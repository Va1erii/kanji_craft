// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'raw_kanjidic_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RawKanjidicDto {

 int get id;@JsonKey(name: 'import_id') int get importId; String get literal;@JsonKey(name: 'stroke_count') int get strokeCount;@JsonKey(name: 'stroke_count_misstrokes') List<int>? get strokeCountMisstrokes; int? get grade; int? get jlpt; int? get frequency; KanjidicCodepointsDto get codepoints; KanjidicRadicalsDto get radicals;@JsonKey(name: 'dict_refs') KanjidicDictRefsDto? get dictRefs;@JsonKey(name: 'query_codes') KanjidicQueryCodesDto? get queryCodes; KanjidicReadingsDto get readings; List<String>? get nanori; Map<String, List<String>> get meanings; List<KanjidicVariantDto>? get variants;@JsonKey(name: 'radical_names') List<String>? get radicalNames;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of RawKanjidicDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RawKanjidicDtoCopyWith<RawKanjidicDto> get copyWith => _$RawKanjidicDtoCopyWithImpl<RawKanjidicDto>(this as RawKanjidicDto, _$identity);

  /// Serializes this RawKanjidicDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RawKanjidicDto&&(identical(other.id, id) || other.id == id)&&(identical(other.importId, importId) || other.importId == importId)&&(identical(other.literal, literal) || other.literal == literal)&&(identical(other.strokeCount, strokeCount) || other.strokeCount == strokeCount)&&const DeepCollectionEquality().equals(other.strokeCountMisstrokes, strokeCountMisstrokes)&&(identical(other.grade, grade) || other.grade == grade)&&(identical(other.jlpt, jlpt) || other.jlpt == jlpt)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.codepoints, codepoints) || other.codepoints == codepoints)&&(identical(other.radicals, radicals) || other.radicals == radicals)&&(identical(other.dictRefs, dictRefs) || other.dictRefs == dictRefs)&&(identical(other.queryCodes, queryCodes) || other.queryCodes == queryCodes)&&(identical(other.readings, readings) || other.readings == readings)&&const DeepCollectionEquality().equals(other.nanori, nanori)&&const DeepCollectionEquality().equals(other.meanings, meanings)&&const DeepCollectionEquality().equals(other.variants, variants)&&const DeepCollectionEquality().equals(other.radicalNames, radicalNames)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,importId,literal,strokeCount,const DeepCollectionEquality().hash(strokeCountMisstrokes),grade,jlpt,frequency,codepoints,radicals,dictRefs,queryCodes,readings,const DeepCollectionEquality().hash(nanori),const DeepCollectionEquality().hash(meanings),const DeepCollectionEquality().hash(variants),const DeepCollectionEquality().hash(radicalNames),createdAt);

@override
String toString() {
  return 'RawKanjidicDto(id: $id, importId: $importId, literal: $literal, strokeCount: $strokeCount, strokeCountMisstrokes: $strokeCountMisstrokes, grade: $grade, jlpt: $jlpt, frequency: $frequency, codepoints: $codepoints, radicals: $radicals, dictRefs: $dictRefs, queryCodes: $queryCodes, readings: $readings, nanori: $nanori, meanings: $meanings, variants: $variants, radicalNames: $radicalNames, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $RawKanjidicDtoCopyWith<$Res>  {
  factory $RawKanjidicDtoCopyWith(RawKanjidicDto value, $Res Function(RawKanjidicDto) _then) = _$RawKanjidicDtoCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'import_id') int importId, String literal,@JsonKey(name: 'stroke_count') int strokeCount,@JsonKey(name: 'stroke_count_misstrokes') List<int>? strokeCountMisstrokes, int? grade, int? jlpt, int? frequency, KanjidicCodepointsDto codepoints, KanjidicRadicalsDto radicals,@JsonKey(name: 'dict_refs') KanjidicDictRefsDto? dictRefs,@JsonKey(name: 'query_codes') KanjidicQueryCodesDto? queryCodes, KanjidicReadingsDto readings, List<String>? nanori, Map<String, List<String>> meanings, List<KanjidicVariantDto>? variants,@JsonKey(name: 'radical_names') List<String>? radicalNames,@JsonKey(name: 'created_at') DateTime createdAt
});


$KanjidicCodepointsDtoCopyWith<$Res> get codepoints;$KanjidicRadicalsDtoCopyWith<$Res> get radicals;$KanjidicDictRefsDtoCopyWith<$Res>? get dictRefs;$KanjidicQueryCodesDtoCopyWith<$Res>? get queryCodes;$KanjidicReadingsDtoCopyWith<$Res> get readings;

}
/// @nodoc
class _$RawKanjidicDtoCopyWithImpl<$Res>
    implements $RawKanjidicDtoCopyWith<$Res> {
  _$RawKanjidicDtoCopyWithImpl(this._self, this._then);

  final RawKanjidicDto _self;
  final $Res Function(RawKanjidicDto) _then;

/// Create a copy of RawKanjidicDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? importId = null,Object? literal = null,Object? strokeCount = null,Object? strokeCountMisstrokes = freezed,Object? grade = freezed,Object? jlpt = freezed,Object? frequency = freezed,Object? codepoints = null,Object? radicals = null,Object? dictRefs = freezed,Object? queryCodes = freezed,Object? readings = null,Object? nanori = freezed,Object? meanings = null,Object? variants = freezed,Object? radicalNames = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,importId: null == importId ? _self.importId : importId // ignore: cast_nullable_to_non_nullable
as int,literal: null == literal ? _self.literal : literal // ignore: cast_nullable_to_non_nullable
as String,strokeCount: null == strokeCount ? _self.strokeCount : strokeCount // ignore: cast_nullable_to_non_nullable
as int,strokeCountMisstrokes: freezed == strokeCountMisstrokes ? _self.strokeCountMisstrokes : strokeCountMisstrokes // ignore: cast_nullable_to_non_nullable
as List<int>?,grade: freezed == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as int?,jlpt: freezed == jlpt ? _self.jlpt : jlpt // ignore: cast_nullable_to_non_nullable
as int?,frequency: freezed == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as int?,codepoints: null == codepoints ? _self.codepoints : codepoints // ignore: cast_nullable_to_non_nullable
as KanjidicCodepointsDto,radicals: null == radicals ? _self.radicals : radicals // ignore: cast_nullable_to_non_nullable
as KanjidicRadicalsDto,dictRefs: freezed == dictRefs ? _self.dictRefs : dictRefs // ignore: cast_nullable_to_non_nullable
as KanjidicDictRefsDto?,queryCodes: freezed == queryCodes ? _self.queryCodes : queryCodes // ignore: cast_nullable_to_non_nullable
as KanjidicQueryCodesDto?,readings: null == readings ? _self.readings : readings // ignore: cast_nullable_to_non_nullable
as KanjidicReadingsDto,nanori: freezed == nanori ? _self.nanori : nanori // ignore: cast_nullable_to_non_nullable
as List<String>?,meanings: null == meanings ? _self.meanings : meanings // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>,variants: freezed == variants ? _self.variants : variants // ignore: cast_nullable_to_non_nullable
as List<KanjidicVariantDto>?,radicalNames: freezed == radicalNames ? _self.radicalNames : radicalNames // ignore: cast_nullable_to_non_nullable
as List<String>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of RawKanjidicDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KanjidicCodepointsDtoCopyWith<$Res> get codepoints {
  
  return $KanjidicCodepointsDtoCopyWith<$Res>(_self.codepoints, (value) {
    return _then(_self.copyWith(codepoints: value));
  });
}/// Create a copy of RawKanjidicDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KanjidicRadicalsDtoCopyWith<$Res> get radicals {
  
  return $KanjidicRadicalsDtoCopyWith<$Res>(_self.radicals, (value) {
    return _then(_self.copyWith(radicals: value));
  });
}/// Create a copy of RawKanjidicDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KanjidicDictRefsDtoCopyWith<$Res>? get dictRefs {
    if (_self.dictRefs == null) {
    return null;
  }

  return $KanjidicDictRefsDtoCopyWith<$Res>(_self.dictRefs!, (value) {
    return _then(_self.copyWith(dictRefs: value));
  });
}/// Create a copy of RawKanjidicDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KanjidicQueryCodesDtoCopyWith<$Res>? get queryCodes {
    if (_self.queryCodes == null) {
    return null;
  }

  return $KanjidicQueryCodesDtoCopyWith<$Res>(_self.queryCodes!, (value) {
    return _then(_self.copyWith(queryCodes: value));
  });
}/// Create a copy of RawKanjidicDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KanjidicReadingsDtoCopyWith<$Res> get readings {
  
  return $KanjidicReadingsDtoCopyWith<$Res>(_self.readings, (value) {
    return _then(_self.copyWith(readings: value));
  });
}
}


/// Adds pattern-matching-related methods to [RawKanjidicDto].
extension RawKanjidicDtoPatterns on RawKanjidicDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RawKanjidicDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RawKanjidicDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RawKanjidicDto value)  $default,){
final _that = this;
switch (_that) {
case _RawKanjidicDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RawKanjidicDto value)?  $default,){
final _that = this;
switch (_that) {
case _RawKanjidicDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'import_id')  int importId,  String literal, @JsonKey(name: 'stroke_count')  int strokeCount, @JsonKey(name: 'stroke_count_misstrokes')  List<int>? strokeCountMisstrokes,  int? grade,  int? jlpt,  int? frequency,  KanjidicCodepointsDto codepoints,  KanjidicRadicalsDto radicals, @JsonKey(name: 'dict_refs')  KanjidicDictRefsDto? dictRefs, @JsonKey(name: 'query_codes')  KanjidicQueryCodesDto? queryCodes,  KanjidicReadingsDto readings,  List<String>? nanori,  Map<String, List<String>> meanings,  List<KanjidicVariantDto>? variants, @JsonKey(name: 'radical_names')  List<String>? radicalNames, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RawKanjidicDto() when $default != null:
return $default(_that.id,_that.importId,_that.literal,_that.strokeCount,_that.strokeCountMisstrokes,_that.grade,_that.jlpt,_that.frequency,_that.codepoints,_that.radicals,_that.dictRefs,_that.queryCodes,_that.readings,_that.nanori,_that.meanings,_that.variants,_that.radicalNames,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'import_id')  int importId,  String literal, @JsonKey(name: 'stroke_count')  int strokeCount, @JsonKey(name: 'stroke_count_misstrokes')  List<int>? strokeCountMisstrokes,  int? grade,  int? jlpt,  int? frequency,  KanjidicCodepointsDto codepoints,  KanjidicRadicalsDto radicals, @JsonKey(name: 'dict_refs')  KanjidicDictRefsDto? dictRefs, @JsonKey(name: 'query_codes')  KanjidicQueryCodesDto? queryCodes,  KanjidicReadingsDto readings,  List<String>? nanori,  Map<String, List<String>> meanings,  List<KanjidicVariantDto>? variants, @JsonKey(name: 'radical_names')  List<String>? radicalNames, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _RawKanjidicDto():
return $default(_that.id,_that.importId,_that.literal,_that.strokeCount,_that.strokeCountMisstrokes,_that.grade,_that.jlpt,_that.frequency,_that.codepoints,_that.radicals,_that.dictRefs,_that.queryCodes,_that.readings,_that.nanori,_that.meanings,_that.variants,_that.radicalNames,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'import_id')  int importId,  String literal, @JsonKey(name: 'stroke_count')  int strokeCount, @JsonKey(name: 'stroke_count_misstrokes')  List<int>? strokeCountMisstrokes,  int? grade,  int? jlpt,  int? frequency,  KanjidicCodepointsDto codepoints,  KanjidicRadicalsDto radicals, @JsonKey(name: 'dict_refs')  KanjidicDictRefsDto? dictRefs, @JsonKey(name: 'query_codes')  KanjidicQueryCodesDto? queryCodes,  KanjidicReadingsDto readings,  List<String>? nanori,  Map<String, List<String>> meanings,  List<KanjidicVariantDto>? variants, @JsonKey(name: 'radical_names')  List<String>? radicalNames, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _RawKanjidicDto() when $default != null:
return $default(_that.id,_that.importId,_that.literal,_that.strokeCount,_that.strokeCountMisstrokes,_that.grade,_that.jlpt,_that.frequency,_that.codepoints,_that.radicals,_that.dictRefs,_that.queryCodes,_that.readings,_that.nanori,_that.meanings,_that.variants,_that.radicalNames,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RawKanjidicDto extends RawKanjidicDto {
  const _RawKanjidicDto({required this.id, @JsonKey(name: 'import_id') required this.importId, required this.literal, @JsonKey(name: 'stroke_count') required this.strokeCount, @JsonKey(name: 'stroke_count_misstrokes') final  List<int>? strokeCountMisstrokes, this.grade, this.jlpt, this.frequency, required this.codepoints, required this.radicals, @JsonKey(name: 'dict_refs') this.dictRefs, @JsonKey(name: 'query_codes') this.queryCodes, required this.readings, final  List<String>? nanori, required final  Map<String, List<String>> meanings, final  List<KanjidicVariantDto>? variants, @JsonKey(name: 'radical_names') final  List<String>? radicalNames, @JsonKey(name: 'created_at') required this.createdAt}): _strokeCountMisstrokes = strokeCountMisstrokes,_nanori = nanori,_meanings = meanings,_variants = variants,_radicalNames = radicalNames,super._();
  factory _RawKanjidicDto.fromJson(Map<String, dynamic> json) => _$RawKanjidicDtoFromJson(json);

@override final  int id;
@override@JsonKey(name: 'import_id') final  int importId;
@override final  String literal;
@override@JsonKey(name: 'stroke_count') final  int strokeCount;
 final  List<int>? _strokeCountMisstrokes;
@override@JsonKey(name: 'stroke_count_misstrokes') List<int>? get strokeCountMisstrokes {
  final value = _strokeCountMisstrokes;
  if (value == null) return null;
  if (_strokeCountMisstrokes is EqualUnmodifiableListView) return _strokeCountMisstrokes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  int? grade;
@override final  int? jlpt;
@override final  int? frequency;
@override final  KanjidicCodepointsDto codepoints;
@override final  KanjidicRadicalsDto radicals;
@override@JsonKey(name: 'dict_refs') final  KanjidicDictRefsDto? dictRefs;
@override@JsonKey(name: 'query_codes') final  KanjidicQueryCodesDto? queryCodes;
@override final  KanjidicReadingsDto readings;
 final  List<String>? _nanori;
@override List<String>? get nanori {
  final value = _nanori;
  if (value == null) return null;
  if (_nanori is EqualUnmodifiableListView) return _nanori;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  Map<String, List<String>> _meanings;
@override Map<String, List<String>> get meanings {
  if (_meanings is EqualUnmodifiableMapView) return _meanings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_meanings);
}

 final  List<KanjidicVariantDto>? _variants;
@override List<KanjidicVariantDto>? get variants {
  final value = _variants;
  if (value == null) return null;
  if (_variants is EqualUnmodifiableListView) return _variants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _radicalNames;
@override@JsonKey(name: 'radical_names') List<String>? get radicalNames {
  final value = _radicalNames;
  if (value == null) return null;
  if (_radicalNames is EqualUnmodifiableListView) return _radicalNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of RawKanjidicDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RawKanjidicDtoCopyWith<_RawKanjidicDto> get copyWith => __$RawKanjidicDtoCopyWithImpl<_RawKanjidicDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RawKanjidicDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RawKanjidicDto&&(identical(other.id, id) || other.id == id)&&(identical(other.importId, importId) || other.importId == importId)&&(identical(other.literal, literal) || other.literal == literal)&&(identical(other.strokeCount, strokeCount) || other.strokeCount == strokeCount)&&const DeepCollectionEquality().equals(other._strokeCountMisstrokes, _strokeCountMisstrokes)&&(identical(other.grade, grade) || other.grade == grade)&&(identical(other.jlpt, jlpt) || other.jlpt == jlpt)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.codepoints, codepoints) || other.codepoints == codepoints)&&(identical(other.radicals, radicals) || other.radicals == radicals)&&(identical(other.dictRefs, dictRefs) || other.dictRefs == dictRefs)&&(identical(other.queryCodes, queryCodes) || other.queryCodes == queryCodes)&&(identical(other.readings, readings) || other.readings == readings)&&const DeepCollectionEquality().equals(other._nanori, _nanori)&&const DeepCollectionEquality().equals(other._meanings, _meanings)&&const DeepCollectionEquality().equals(other._variants, _variants)&&const DeepCollectionEquality().equals(other._radicalNames, _radicalNames)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,importId,literal,strokeCount,const DeepCollectionEquality().hash(_strokeCountMisstrokes),grade,jlpt,frequency,codepoints,radicals,dictRefs,queryCodes,readings,const DeepCollectionEquality().hash(_nanori),const DeepCollectionEquality().hash(_meanings),const DeepCollectionEquality().hash(_variants),const DeepCollectionEquality().hash(_radicalNames),createdAt);

@override
String toString() {
  return 'RawKanjidicDto(id: $id, importId: $importId, literal: $literal, strokeCount: $strokeCount, strokeCountMisstrokes: $strokeCountMisstrokes, grade: $grade, jlpt: $jlpt, frequency: $frequency, codepoints: $codepoints, radicals: $radicals, dictRefs: $dictRefs, queryCodes: $queryCodes, readings: $readings, nanori: $nanori, meanings: $meanings, variants: $variants, radicalNames: $radicalNames, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$RawKanjidicDtoCopyWith<$Res> implements $RawKanjidicDtoCopyWith<$Res> {
  factory _$RawKanjidicDtoCopyWith(_RawKanjidicDto value, $Res Function(_RawKanjidicDto) _then) = __$RawKanjidicDtoCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'import_id') int importId, String literal,@JsonKey(name: 'stroke_count') int strokeCount,@JsonKey(name: 'stroke_count_misstrokes') List<int>? strokeCountMisstrokes, int? grade, int? jlpt, int? frequency, KanjidicCodepointsDto codepoints, KanjidicRadicalsDto radicals,@JsonKey(name: 'dict_refs') KanjidicDictRefsDto? dictRefs,@JsonKey(name: 'query_codes') KanjidicQueryCodesDto? queryCodes, KanjidicReadingsDto readings, List<String>? nanori, Map<String, List<String>> meanings, List<KanjidicVariantDto>? variants,@JsonKey(name: 'radical_names') List<String>? radicalNames,@JsonKey(name: 'created_at') DateTime createdAt
});


@override $KanjidicCodepointsDtoCopyWith<$Res> get codepoints;@override $KanjidicRadicalsDtoCopyWith<$Res> get radicals;@override $KanjidicDictRefsDtoCopyWith<$Res>? get dictRefs;@override $KanjidicQueryCodesDtoCopyWith<$Res>? get queryCodes;@override $KanjidicReadingsDtoCopyWith<$Res> get readings;

}
/// @nodoc
class __$RawKanjidicDtoCopyWithImpl<$Res>
    implements _$RawKanjidicDtoCopyWith<$Res> {
  __$RawKanjidicDtoCopyWithImpl(this._self, this._then);

  final _RawKanjidicDto _self;
  final $Res Function(_RawKanjidicDto) _then;

/// Create a copy of RawKanjidicDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? importId = null,Object? literal = null,Object? strokeCount = null,Object? strokeCountMisstrokes = freezed,Object? grade = freezed,Object? jlpt = freezed,Object? frequency = freezed,Object? codepoints = null,Object? radicals = null,Object? dictRefs = freezed,Object? queryCodes = freezed,Object? readings = null,Object? nanori = freezed,Object? meanings = null,Object? variants = freezed,Object? radicalNames = freezed,Object? createdAt = null,}) {
  return _then(_RawKanjidicDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,importId: null == importId ? _self.importId : importId // ignore: cast_nullable_to_non_nullable
as int,literal: null == literal ? _self.literal : literal // ignore: cast_nullable_to_non_nullable
as String,strokeCount: null == strokeCount ? _self.strokeCount : strokeCount // ignore: cast_nullable_to_non_nullable
as int,strokeCountMisstrokes: freezed == strokeCountMisstrokes ? _self._strokeCountMisstrokes : strokeCountMisstrokes // ignore: cast_nullable_to_non_nullable
as List<int>?,grade: freezed == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as int?,jlpt: freezed == jlpt ? _self.jlpt : jlpt // ignore: cast_nullable_to_non_nullable
as int?,frequency: freezed == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as int?,codepoints: null == codepoints ? _self.codepoints : codepoints // ignore: cast_nullable_to_non_nullable
as KanjidicCodepointsDto,radicals: null == radicals ? _self.radicals : radicals // ignore: cast_nullable_to_non_nullable
as KanjidicRadicalsDto,dictRefs: freezed == dictRefs ? _self.dictRefs : dictRefs // ignore: cast_nullable_to_non_nullable
as KanjidicDictRefsDto?,queryCodes: freezed == queryCodes ? _self.queryCodes : queryCodes // ignore: cast_nullable_to_non_nullable
as KanjidicQueryCodesDto?,readings: null == readings ? _self.readings : readings // ignore: cast_nullable_to_non_nullable
as KanjidicReadingsDto,nanori: freezed == nanori ? _self._nanori : nanori // ignore: cast_nullable_to_non_nullable
as List<String>?,meanings: null == meanings ? _self._meanings : meanings // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>,variants: freezed == variants ? _self._variants : variants // ignore: cast_nullable_to_non_nullable
as List<KanjidicVariantDto>?,radicalNames: freezed == radicalNames ? _self._radicalNames : radicalNames // ignore: cast_nullable_to_non_nullable
as List<String>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of RawKanjidicDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KanjidicCodepointsDtoCopyWith<$Res> get codepoints {
  
  return $KanjidicCodepointsDtoCopyWith<$Res>(_self.codepoints, (value) {
    return _then(_self.copyWith(codepoints: value));
  });
}/// Create a copy of RawKanjidicDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KanjidicRadicalsDtoCopyWith<$Res> get radicals {
  
  return $KanjidicRadicalsDtoCopyWith<$Res>(_self.radicals, (value) {
    return _then(_self.copyWith(radicals: value));
  });
}/// Create a copy of RawKanjidicDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KanjidicDictRefsDtoCopyWith<$Res>? get dictRefs {
    if (_self.dictRefs == null) {
    return null;
  }

  return $KanjidicDictRefsDtoCopyWith<$Res>(_self.dictRefs!, (value) {
    return _then(_self.copyWith(dictRefs: value));
  });
}/// Create a copy of RawKanjidicDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KanjidicQueryCodesDtoCopyWith<$Res>? get queryCodes {
    if (_self.queryCodes == null) {
    return null;
  }

  return $KanjidicQueryCodesDtoCopyWith<$Res>(_self.queryCodes!, (value) {
    return _then(_self.copyWith(queryCodes: value));
  });
}/// Create a copy of RawKanjidicDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KanjidicReadingsDtoCopyWith<$Res> get readings {
  
  return $KanjidicReadingsDtoCopyWith<$Res>(_self.readings, (value) {
    return _then(_self.copyWith(readings: value));
  });
}
}


/// @nodoc
mixin _$KanjidicCodepointsDto {

 String get ucs; String? get jis208; String? get jis212; String? get jis213;
/// Create a copy of KanjidicCodepointsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KanjidicCodepointsDtoCopyWith<KanjidicCodepointsDto> get copyWith => _$KanjidicCodepointsDtoCopyWithImpl<KanjidicCodepointsDto>(this as KanjidicCodepointsDto, _$identity);

  /// Serializes this KanjidicCodepointsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KanjidicCodepointsDto&&(identical(other.ucs, ucs) || other.ucs == ucs)&&(identical(other.jis208, jis208) || other.jis208 == jis208)&&(identical(other.jis212, jis212) || other.jis212 == jis212)&&(identical(other.jis213, jis213) || other.jis213 == jis213));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ucs,jis208,jis212,jis213);

@override
String toString() {
  return 'KanjidicCodepointsDto(ucs: $ucs, jis208: $jis208, jis212: $jis212, jis213: $jis213)';
}


}

/// @nodoc
abstract mixin class $KanjidicCodepointsDtoCopyWith<$Res>  {
  factory $KanjidicCodepointsDtoCopyWith(KanjidicCodepointsDto value, $Res Function(KanjidicCodepointsDto) _then) = _$KanjidicCodepointsDtoCopyWithImpl;
@useResult
$Res call({
 String ucs, String? jis208, String? jis212, String? jis213
});




}
/// @nodoc
class _$KanjidicCodepointsDtoCopyWithImpl<$Res>
    implements $KanjidicCodepointsDtoCopyWith<$Res> {
  _$KanjidicCodepointsDtoCopyWithImpl(this._self, this._then);

  final KanjidicCodepointsDto _self;
  final $Res Function(KanjidicCodepointsDto) _then;

/// Create a copy of KanjidicCodepointsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ucs = null,Object? jis208 = freezed,Object? jis212 = freezed,Object? jis213 = freezed,}) {
  return _then(_self.copyWith(
ucs: null == ucs ? _self.ucs : ucs // ignore: cast_nullable_to_non_nullable
as String,jis208: freezed == jis208 ? _self.jis208 : jis208 // ignore: cast_nullable_to_non_nullable
as String?,jis212: freezed == jis212 ? _self.jis212 : jis212 // ignore: cast_nullable_to_non_nullable
as String?,jis213: freezed == jis213 ? _self.jis213 : jis213 // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [KanjidicCodepointsDto].
extension KanjidicCodepointsDtoPatterns on KanjidicCodepointsDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KanjidicCodepointsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KanjidicCodepointsDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KanjidicCodepointsDto value)  $default,){
final _that = this;
switch (_that) {
case _KanjidicCodepointsDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KanjidicCodepointsDto value)?  $default,){
final _that = this;
switch (_that) {
case _KanjidicCodepointsDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String ucs,  String? jis208,  String? jis212,  String? jis213)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KanjidicCodepointsDto() when $default != null:
return $default(_that.ucs,_that.jis208,_that.jis212,_that.jis213);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String ucs,  String? jis208,  String? jis212,  String? jis213)  $default,) {final _that = this;
switch (_that) {
case _KanjidicCodepointsDto():
return $default(_that.ucs,_that.jis208,_that.jis212,_that.jis213);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String ucs,  String? jis208,  String? jis212,  String? jis213)?  $default,) {final _that = this;
switch (_that) {
case _KanjidicCodepointsDto() when $default != null:
return $default(_that.ucs,_that.jis208,_that.jis212,_that.jis213);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KanjidicCodepointsDto extends KanjidicCodepointsDto {
  const _KanjidicCodepointsDto({required this.ucs, this.jis208, this.jis212, this.jis213}): super._();
  factory _KanjidicCodepointsDto.fromJson(Map<String, dynamic> json) => _$KanjidicCodepointsDtoFromJson(json);

@override final  String ucs;
@override final  String? jis208;
@override final  String? jis212;
@override final  String? jis213;

/// Create a copy of KanjidicCodepointsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KanjidicCodepointsDtoCopyWith<_KanjidicCodepointsDto> get copyWith => __$KanjidicCodepointsDtoCopyWithImpl<_KanjidicCodepointsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KanjidicCodepointsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KanjidicCodepointsDto&&(identical(other.ucs, ucs) || other.ucs == ucs)&&(identical(other.jis208, jis208) || other.jis208 == jis208)&&(identical(other.jis212, jis212) || other.jis212 == jis212)&&(identical(other.jis213, jis213) || other.jis213 == jis213));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ucs,jis208,jis212,jis213);

@override
String toString() {
  return 'KanjidicCodepointsDto(ucs: $ucs, jis208: $jis208, jis212: $jis212, jis213: $jis213)';
}


}

/// @nodoc
abstract mixin class _$KanjidicCodepointsDtoCopyWith<$Res> implements $KanjidicCodepointsDtoCopyWith<$Res> {
  factory _$KanjidicCodepointsDtoCopyWith(_KanjidicCodepointsDto value, $Res Function(_KanjidicCodepointsDto) _then) = __$KanjidicCodepointsDtoCopyWithImpl;
@override @useResult
$Res call({
 String ucs, String? jis208, String? jis212, String? jis213
});




}
/// @nodoc
class __$KanjidicCodepointsDtoCopyWithImpl<$Res>
    implements _$KanjidicCodepointsDtoCopyWith<$Res> {
  __$KanjidicCodepointsDtoCopyWithImpl(this._self, this._then);

  final _KanjidicCodepointsDto _self;
  final $Res Function(_KanjidicCodepointsDto) _then;

/// Create a copy of KanjidicCodepointsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ucs = null,Object? jis208 = freezed,Object? jis212 = freezed,Object? jis213 = freezed,}) {
  return _then(_KanjidicCodepointsDto(
ucs: null == ucs ? _self.ucs : ucs // ignore: cast_nullable_to_non_nullable
as String,jis208: freezed == jis208 ? _self.jis208 : jis208 // ignore: cast_nullable_to_non_nullable
as String?,jis212: freezed == jis212 ? _self.jis212 : jis212 // ignore: cast_nullable_to_non_nullable
as String?,jis213: freezed == jis213 ? _self.jis213 : jis213 // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$KanjidicRadicalsDto {

 int get classical;@JsonKey(name: 'nelson_c') int? get nelsonC;
/// Create a copy of KanjidicRadicalsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KanjidicRadicalsDtoCopyWith<KanjidicRadicalsDto> get copyWith => _$KanjidicRadicalsDtoCopyWithImpl<KanjidicRadicalsDto>(this as KanjidicRadicalsDto, _$identity);

  /// Serializes this KanjidicRadicalsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KanjidicRadicalsDto&&(identical(other.classical, classical) || other.classical == classical)&&(identical(other.nelsonC, nelsonC) || other.nelsonC == nelsonC));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,classical,nelsonC);

@override
String toString() {
  return 'KanjidicRadicalsDto(classical: $classical, nelsonC: $nelsonC)';
}


}

/// @nodoc
abstract mixin class $KanjidicRadicalsDtoCopyWith<$Res>  {
  factory $KanjidicRadicalsDtoCopyWith(KanjidicRadicalsDto value, $Res Function(KanjidicRadicalsDto) _then) = _$KanjidicRadicalsDtoCopyWithImpl;
@useResult
$Res call({
 int classical,@JsonKey(name: 'nelson_c') int? nelsonC
});




}
/// @nodoc
class _$KanjidicRadicalsDtoCopyWithImpl<$Res>
    implements $KanjidicRadicalsDtoCopyWith<$Res> {
  _$KanjidicRadicalsDtoCopyWithImpl(this._self, this._then);

  final KanjidicRadicalsDto _self;
  final $Res Function(KanjidicRadicalsDto) _then;

/// Create a copy of KanjidicRadicalsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? classical = null,Object? nelsonC = freezed,}) {
  return _then(_self.copyWith(
classical: null == classical ? _self.classical : classical // ignore: cast_nullable_to_non_nullable
as int,nelsonC: freezed == nelsonC ? _self.nelsonC : nelsonC // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [KanjidicRadicalsDto].
extension KanjidicRadicalsDtoPatterns on KanjidicRadicalsDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KanjidicRadicalsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KanjidicRadicalsDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KanjidicRadicalsDto value)  $default,){
final _that = this;
switch (_that) {
case _KanjidicRadicalsDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KanjidicRadicalsDto value)?  $default,){
final _that = this;
switch (_that) {
case _KanjidicRadicalsDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int classical, @JsonKey(name: 'nelson_c')  int? nelsonC)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KanjidicRadicalsDto() when $default != null:
return $default(_that.classical,_that.nelsonC);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int classical, @JsonKey(name: 'nelson_c')  int? nelsonC)  $default,) {final _that = this;
switch (_that) {
case _KanjidicRadicalsDto():
return $default(_that.classical,_that.nelsonC);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int classical, @JsonKey(name: 'nelson_c')  int? nelsonC)?  $default,) {final _that = this;
switch (_that) {
case _KanjidicRadicalsDto() when $default != null:
return $default(_that.classical,_that.nelsonC);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KanjidicRadicalsDto extends KanjidicRadicalsDto {
  const _KanjidicRadicalsDto({required this.classical, @JsonKey(name: 'nelson_c') this.nelsonC}): super._();
  factory _KanjidicRadicalsDto.fromJson(Map<String, dynamic> json) => _$KanjidicRadicalsDtoFromJson(json);

@override final  int classical;
@override@JsonKey(name: 'nelson_c') final  int? nelsonC;

/// Create a copy of KanjidicRadicalsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KanjidicRadicalsDtoCopyWith<_KanjidicRadicalsDto> get copyWith => __$KanjidicRadicalsDtoCopyWithImpl<_KanjidicRadicalsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KanjidicRadicalsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KanjidicRadicalsDto&&(identical(other.classical, classical) || other.classical == classical)&&(identical(other.nelsonC, nelsonC) || other.nelsonC == nelsonC));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,classical,nelsonC);

@override
String toString() {
  return 'KanjidicRadicalsDto(classical: $classical, nelsonC: $nelsonC)';
}


}

/// @nodoc
abstract mixin class _$KanjidicRadicalsDtoCopyWith<$Res> implements $KanjidicRadicalsDtoCopyWith<$Res> {
  factory _$KanjidicRadicalsDtoCopyWith(_KanjidicRadicalsDto value, $Res Function(_KanjidicRadicalsDto) _then) = __$KanjidicRadicalsDtoCopyWithImpl;
@override @useResult
$Res call({
 int classical,@JsonKey(name: 'nelson_c') int? nelsonC
});




}
/// @nodoc
class __$KanjidicRadicalsDtoCopyWithImpl<$Res>
    implements _$KanjidicRadicalsDtoCopyWith<$Res> {
  __$KanjidicRadicalsDtoCopyWithImpl(this._self, this._then);

  final _KanjidicRadicalsDto _self;
  final $Res Function(_KanjidicRadicalsDto) _then;

/// Create a copy of KanjidicRadicalsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? classical = null,Object? nelsonC = freezed,}) {
  return _then(_KanjidicRadicalsDto(
classical: null == classical ? _self.classical : classical // ignore: cast_nullable_to_non_nullable
as int,nelsonC: freezed == nelsonC ? _self.nelsonC : nelsonC // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$KanjidicDictRefsDto {

@JsonKey(name: 'nelson_c') String? get nelsonC;@JsonKey(name: 'nelson_n') String? get nelsonN;@JsonKey(name: 'halpern_njecd') String? get halpernNjecd;@JsonKey(name: 'halpern_kkd') String? get halpernKkd;@JsonKey(name: 'halpern_kkld') String? get halpernKkld;@JsonKey(name: 'halpern_kkld_2ed') String? get halpernKkld2ed; String? get heisig; String? get heisig6; String? get gakken;@JsonKey(name: 'oneill_names') String? get oneillNames;@JsonKey(name: 'oneill_kk') String? get oneillKk; KanjidicMoroRefDto? get moro; String? get henshall;@JsonKey(name: 'sh_kk') String? get shKk;@JsonKey(name: 'sh_kk2') String? get shKk2;@JsonKey(name: 'jf_cards') String? get jfCards;@JsonKey(name: 'tutt_cards') String? get tuttCards;@JsonKey(name: 'kanji_in_context') String? get kanjiInContext;@JsonKey(name: 'kodansha_compact') String? get kodanshaCompact; String? get skip;@JsonKey(name: 'busy_people') String? get busyPeople;
/// Create a copy of KanjidicDictRefsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KanjidicDictRefsDtoCopyWith<KanjidicDictRefsDto> get copyWith => _$KanjidicDictRefsDtoCopyWithImpl<KanjidicDictRefsDto>(this as KanjidicDictRefsDto, _$identity);

  /// Serializes this KanjidicDictRefsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KanjidicDictRefsDto&&(identical(other.nelsonC, nelsonC) || other.nelsonC == nelsonC)&&(identical(other.nelsonN, nelsonN) || other.nelsonN == nelsonN)&&(identical(other.halpernNjecd, halpernNjecd) || other.halpernNjecd == halpernNjecd)&&(identical(other.halpernKkd, halpernKkd) || other.halpernKkd == halpernKkd)&&(identical(other.halpernKkld, halpernKkld) || other.halpernKkld == halpernKkld)&&(identical(other.halpernKkld2ed, halpernKkld2ed) || other.halpernKkld2ed == halpernKkld2ed)&&(identical(other.heisig, heisig) || other.heisig == heisig)&&(identical(other.heisig6, heisig6) || other.heisig6 == heisig6)&&(identical(other.gakken, gakken) || other.gakken == gakken)&&(identical(other.oneillNames, oneillNames) || other.oneillNames == oneillNames)&&(identical(other.oneillKk, oneillKk) || other.oneillKk == oneillKk)&&(identical(other.moro, moro) || other.moro == moro)&&(identical(other.henshall, henshall) || other.henshall == henshall)&&(identical(other.shKk, shKk) || other.shKk == shKk)&&(identical(other.shKk2, shKk2) || other.shKk2 == shKk2)&&(identical(other.jfCards, jfCards) || other.jfCards == jfCards)&&(identical(other.tuttCards, tuttCards) || other.tuttCards == tuttCards)&&(identical(other.kanjiInContext, kanjiInContext) || other.kanjiInContext == kanjiInContext)&&(identical(other.kodanshaCompact, kodanshaCompact) || other.kodanshaCompact == kodanshaCompact)&&(identical(other.skip, skip) || other.skip == skip)&&(identical(other.busyPeople, busyPeople) || other.busyPeople == busyPeople));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,nelsonC,nelsonN,halpernNjecd,halpernKkd,halpernKkld,halpernKkld2ed,heisig,heisig6,gakken,oneillNames,oneillKk,moro,henshall,shKk,shKk2,jfCards,tuttCards,kanjiInContext,kodanshaCompact,skip,busyPeople]);

@override
String toString() {
  return 'KanjidicDictRefsDto(nelsonC: $nelsonC, nelsonN: $nelsonN, halpernNjecd: $halpernNjecd, halpernKkd: $halpernKkd, halpernKkld: $halpernKkld, halpernKkld2ed: $halpernKkld2ed, heisig: $heisig, heisig6: $heisig6, gakken: $gakken, oneillNames: $oneillNames, oneillKk: $oneillKk, moro: $moro, henshall: $henshall, shKk: $shKk, shKk2: $shKk2, jfCards: $jfCards, tuttCards: $tuttCards, kanjiInContext: $kanjiInContext, kodanshaCompact: $kodanshaCompact, skip: $skip, busyPeople: $busyPeople)';
}


}

/// @nodoc
abstract mixin class $KanjidicDictRefsDtoCopyWith<$Res>  {
  factory $KanjidicDictRefsDtoCopyWith(KanjidicDictRefsDto value, $Res Function(KanjidicDictRefsDto) _then) = _$KanjidicDictRefsDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'nelson_c') String? nelsonC,@JsonKey(name: 'nelson_n') String? nelsonN,@JsonKey(name: 'halpern_njecd') String? halpernNjecd,@JsonKey(name: 'halpern_kkd') String? halpernKkd,@JsonKey(name: 'halpern_kkld') String? halpernKkld,@JsonKey(name: 'halpern_kkld_2ed') String? halpernKkld2ed, String? heisig, String? heisig6, String? gakken,@JsonKey(name: 'oneill_names') String? oneillNames,@JsonKey(name: 'oneill_kk') String? oneillKk, KanjidicMoroRefDto? moro, String? henshall,@JsonKey(name: 'sh_kk') String? shKk,@JsonKey(name: 'sh_kk2') String? shKk2,@JsonKey(name: 'jf_cards') String? jfCards,@JsonKey(name: 'tutt_cards') String? tuttCards,@JsonKey(name: 'kanji_in_context') String? kanjiInContext,@JsonKey(name: 'kodansha_compact') String? kodanshaCompact, String? skip,@JsonKey(name: 'busy_people') String? busyPeople
});


$KanjidicMoroRefDtoCopyWith<$Res>? get moro;

}
/// @nodoc
class _$KanjidicDictRefsDtoCopyWithImpl<$Res>
    implements $KanjidicDictRefsDtoCopyWith<$Res> {
  _$KanjidicDictRefsDtoCopyWithImpl(this._self, this._then);

  final KanjidicDictRefsDto _self;
  final $Res Function(KanjidicDictRefsDto) _then;

/// Create a copy of KanjidicDictRefsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nelsonC = freezed,Object? nelsonN = freezed,Object? halpernNjecd = freezed,Object? halpernKkd = freezed,Object? halpernKkld = freezed,Object? halpernKkld2ed = freezed,Object? heisig = freezed,Object? heisig6 = freezed,Object? gakken = freezed,Object? oneillNames = freezed,Object? oneillKk = freezed,Object? moro = freezed,Object? henshall = freezed,Object? shKk = freezed,Object? shKk2 = freezed,Object? jfCards = freezed,Object? tuttCards = freezed,Object? kanjiInContext = freezed,Object? kodanshaCompact = freezed,Object? skip = freezed,Object? busyPeople = freezed,}) {
  return _then(_self.copyWith(
nelsonC: freezed == nelsonC ? _self.nelsonC : nelsonC // ignore: cast_nullable_to_non_nullable
as String?,nelsonN: freezed == nelsonN ? _self.nelsonN : nelsonN // ignore: cast_nullable_to_non_nullable
as String?,halpernNjecd: freezed == halpernNjecd ? _self.halpernNjecd : halpernNjecd // ignore: cast_nullable_to_non_nullable
as String?,halpernKkd: freezed == halpernKkd ? _self.halpernKkd : halpernKkd // ignore: cast_nullable_to_non_nullable
as String?,halpernKkld: freezed == halpernKkld ? _self.halpernKkld : halpernKkld // ignore: cast_nullable_to_non_nullable
as String?,halpernKkld2ed: freezed == halpernKkld2ed ? _self.halpernKkld2ed : halpernKkld2ed // ignore: cast_nullable_to_non_nullable
as String?,heisig: freezed == heisig ? _self.heisig : heisig // ignore: cast_nullable_to_non_nullable
as String?,heisig6: freezed == heisig6 ? _self.heisig6 : heisig6 // ignore: cast_nullable_to_non_nullable
as String?,gakken: freezed == gakken ? _self.gakken : gakken // ignore: cast_nullable_to_non_nullable
as String?,oneillNames: freezed == oneillNames ? _self.oneillNames : oneillNames // ignore: cast_nullable_to_non_nullable
as String?,oneillKk: freezed == oneillKk ? _self.oneillKk : oneillKk // ignore: cast_nullable_to_non_nullable
as String?,moro: freezed == moro ? _self.moro : moro // ignore: cast_nullable_to_non_nullable
as KanjidicMoroRefDto?,henshall: freezed == henshall ? _self.henshall : henshall // ignore: cast_nullable_to_non_nullable
as String?,shKk: freezed == shKk ? _self.shKk : shKk // ignore: cast_nullable_to_non_nullable
as String?,shKk2: freezed == shKk2 ? _self.shKk2 : shKk2 // ignore: cast_nullable_to_non_nullable
as String?,jfCards: freezed == jfCards ? _self.jfCards : jfCards // ignore: cast_nullable_to_non_nullable
as String?,tuttCards: freezed == tuttCards ? _self.tuttCards : tuttCards // ignore: cast_nullable_to_non_nullable
as String?,kanjiInContext: freezed == kanjiInContext ? _self.kanjiInContext : kanjiInContext // ignore: cast_nullable_to_non_nullable
as String?,kodanshaCompact: freezed == kodanshaCompact ? _self.kodanshaCompact : kodanshaCompact // ignore: cast_nullable_to_non_nullable
as String?,skip: freezed == skip ? _self.skip : skip // ignore: cast_nullable_to_non_nullable
as String?,busyPeople: freezed == busyPeople ? _self.busyPeople : busyPeople // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of KanjidicDictRefsDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KanjidicMoroRefDtoCopyWith<$Res>? get moro {
    if (_self.moro == null) {
    return null;
  }

  return $KanjidicMoroRefDtoCopyWith<$Res>(_self.moro!, (value) {
    return _then(_self.copyWith(moro: value));
  });
}
}


/// Adds pattern-matching-related methods to [KanjidicDictRefsDto].
extension KanjidicDictRefsDtoPatterns on KanjidicDictRefsDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KanjidicDictRefsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KanjidicDictRefsDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KanjidicDictRefsDto value)  $default,){
final _that = this;
switch (_that) {
case _KanjidicDictRefsDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KanjidicDictRefsDto value)?  $default,){
final _that = this;
switch (_that) {
case _KanjidicDictRefsDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'nelson_c')  String? nelsonC, @JsonKey(name: 'nelson_n')  String? nelsonN, @JsonKey(name: 'halpern_njecd')  String? halpernNjecd, @JsonKey(name: 'halpern_kkd')  String? halpernKkd, @JsonKey(name: 'halpern_kkld')  String? halpernKkld, @JsonKey(name: 'halpern_kkld_2ed')  String? halpernKkld2ed,  String? heisig,  String? heisig6,  String? gakken, @JsonKey(name: 'oneill_names')  String? oneillNames, @JsonKey(name: 'oneill_kk')  String? oneillKk,  KanjidicMoroRefDto? moro,  String? henshall, @JsonKey(name: 'sh_kk')  String? shKk, @JsonKey(name: 'sh_kk2')  String? shKk2, @JsonKey(name: 'jf_cards')  String? jfCards, @JsonKey(name: 'tutt_cards')  String? tuttCards, @JsonKey(name: 'kanji_in_context')  String? kanjiInContext, @JsonKey(name: 'kodansha_compact')  String? kodanshaCompact,  String? skip, @JsonKey(name: 'busy_people')  String? busyPeople)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KanjidicDictRefsDto() when $default != null:
return $default(_that.nelsonC,_that.nelsonN,_that.halpernNjecd,_that.halpernKkd,_that.halpernKkld,_that.halpernKkld2ed,_that.heisig,_that.heisig6,_that.gakken,_that.oneillNames,_that.oneillKk,_that.moro,_that.henshall,_that.shKk,_that.shKk2,_that.jfCards,_that.tuttCards,_that.kanjiInContext,_that.kodanshaCompact,_that.skip,_that.busyPeople);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'nelson_c')  String? nelsonC, @JsonKey(name: 'nelson_n')  String? nelsonN, @JsonKey(name: 'halpern_njecd')  String? halpernNjecd, @JsonKey(name: 'halpern_kkd')  String? halpernKkd, @JsonKey(name: 'halpern_kkld')  String? halpernKkld, @JsonKey(name: 'halpern_kkld_2ed')  String? halpernKkld2ed,  String? heisig,  String? heisig6,  String? gakken, @JsonKey(name: 'oneill_names')  String? oneillNames, @JsonKey(name: 'oneill_kk')  String? oneillKk,  KanjidicMoroRefDto? moro,  String? henshall, @JsonKey(name: 'sh_kk')  String? shKk, @JsonKey(name: 'sh_kk2')  String? shKk2, @JsonKey(name: 'jf_cards')  String? jfCards, @JsonKey(name: 'tutt_cards')  String? tuttCards, @JsonKey(name: 'kanji_in_context')  String? kanjiInContext, @JsonKey(name: 'kodansha_compact')  String? kodanshaCompact,  String? skip, @JsonKey(name: 'busy_people')  String? busyPeople)  $default,) {final _that = this;
switch (_that) {
case _KanjidicDictRefsDto():
return $default(_that.nelsonC,_that.nelsonN,_that.halpernNjecd,_that.halpernKkd,_that.halpernKkld,_that.halpernKkld2ed,_that.heisig,_that.heisig6,_that.gakken,_that.oneillNames,_that.oneillKk,_that.moro,_that.henshall,_that.shKk,_that.shKk2,_that.jfCards,_that.tuttCards,_that.kanjiInContext,_that.kodanshaCompact,_that.skip,_that.busyPeople);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'nelson_c')  String? nelsonC, @JsonKey(name: 'nelson_n')  String? nelsonN, @JsonKey(name: 'halpern_njecd')  String? halpernNjecd, @JsonKey(name: 'halpern_kkd')  String? halpernKkd, @JsonKey(name: 'halpern_kkld')  String? halpernKkld, @JsonKey(name: 'halpern_kkld_2ed')  String? halpernKkld2ed,  String? heisig,  String? heisig6,  String? gakken, @JsonKey(name: 'oneill_names')  String? oneillNames, @JsonKey(name: 'oneill_kk')  String? oneillKk,  KanjidicMoroRefDto? moro,  String? henshall, @JsonKey(name: 'sh_kk')  String? shKk, @JsonKey(name: 'sh_kk2')  String? shKk2, @JsonKey(name: 'jf_cards')  String? jfCards, @JsonKey(name: 'tutt_cards')  String? tuttCards, @JsonKey(name: 'kanji_in_context')  String? kanjiInContext, @JsonKey(name: 'kodansha_compact')  String? kodanshaCompact,  String? skip, @JsonKey(name: 'busy_people')  String? busyPeople)?  $default,) {final _that = this;
switch (_that) {
case _KanjidicDictRefsDto() when $default != null:
return $default(_that.nelsonC,_that.nelsonN,_that.halpernNjecd,_that.halpernKkd,_that.halpernKkld,_that.halpernKkld2ed,_that.heisig,_that.heisig6,_that.gakken,_that.oneillNames,_that.oneillKk,_that.moro,_that.henshall,_that.shKk,_that.shKk2,_that.jfCards,_that.tuttCards,_that.kanjiInContext,_that.kodanshaCompact,_that.skip,_that.busyPeople);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KanjidicDictRefsDto extends KanjidicDictRefsDto {
  const _KanjidicDictRefsDto({@JsonKey(name: 'nelson_c') this.nelsonC, @JsonKey(name: 'nelson_n') this.nelsonN, @JsonKey(name: 'halpern_njecd') this.halpernNjecd, @JsonKey(name: 'halpern_kkd') this.halpernKkd, @JsonKey(name: 'halpern_kkld') this.halpernKkld, @JsonKey(name: 'halpern_kkld_2ed') this.halpernKkld2ed, this.heisig, this.heisig6, this.gakken, @JsonKey(name: 'oneill_names') this.oneillNames, @JsonKey(name: 'oneill_kk') this.oneillKk, this.moro, this.henshall, @JsonKey(name: 'sh_kk') this.shKk, @JsonKey(name: 'sh_kk2') this.shKk2, @JsonKey(name: 'jf_cards') this.jfCards, @JsonKey(name: 'tutt_cards') this.tuttCards, @JsonKey(name: 'kanji_in_context') this.kanjiInContext, @JsonKey(name: 'kodansha_compact') this.kodanshaCompact, this.skip, @JsonKey(name: 'busy_people') this.busyPeople}): super._();
  factory _KanjidicDictRefsDto.fromJson(Map<String, dynamic> json) => _$KanjidicDictRefsDtoFromJson(json);

@override@JsonKey(name: 'nelson_c') final  String? nelsonC;
@override@JsonKey(name: 'nelson_n') final  String? nelsonN;
@override@JsonKey(name: 'halpern_njecd') final  String? halpernNjecd;
@override@JsonKey(name: 'halpern_kkd') final  String? halpernKkd;
@override@JsonKey(name: 'halpern_kkld') final  String? halpernKkld;
@override@JsonKey(name: 'halpern_kkld_2ed') final  String? halpernKkld2ed;
@override final  String? heisig;
@override final  String? heisig6;
@override final  String? gakken;
@override@JsonKey(name: 'oneill_names') final  String? oneillNames;
@override@JsonKey(name: 'oneill_kk') final  String? oneillKk;
@override final  KanjidicMoroRefDto? moro;
@override final  String? henshall;
@override@JsonKey(name: 'sh_kk') final  String? shKk;
@override@JsonKey(name: 'sh_kk2') final  String? shKk2;
@override@JsonKey(name: 'jf_cards') final  String? jfCards;
@override@JsonKey(name: 'tutt_cards') final  String? tuttCards;
@override@JsonKey(name: 'kanji_in_context') final  String? kanjiInContext;
@override@JsonKey(name: 'kodansha_compact') final  String? kodanshaCompact;
@override final  String? skip;
@override@JsonKey(name: 'busy_people') final  String? busyPeople;

/// Create a copy of KanjidicDictRefsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KanjidicDictRefsDtoCopyWith<_KanjidicDictRefsDto> get copyWith => __$KanjidicDictRefsDtoCopyWithImpl<_KanjidicDictRefsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KanjidicDictRefsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KanjidicDictRefsDto&&(identical(other.nelsonC, nelsonC) || other.nelsonC == nelsonC)&&(identical(other.nelsonN, nelsonN) || other.nelsonN == nelsonN)&&(identical(other.halpernNjecd, halpernNjecd) || other.halpernNjecd == halpernNjecd)&&(identical(other.halpernKkd, halpernKkd) || other.halpernKkd == halpernKkd)&&(identical(other.halpernKkld, halpernKkld) || other.halpernKkld == halpernKkld)&&(identical(other.halpernKkld2ed, halpernKkld2ed) || other.halpernKkld2ed == halpernKkld2ed)&&(identical(other.heisig, heisig) || other.heisig == heisig)&&(identical(other.heisig6, heisig6) || other.heisig6 == heisig6)&&(identical(other.gakken, gakken) || other.gakken == gakken)&&(identical(other.oneillNames, oneillNames) || other.oneillNames == oneillNames)&&(identical(other.oneillKk, oneillKk) || other.oneillKk == oneillKk)&&(identical(other.moro, moro) || other.moro == moro)&&(identical(other.henshall, henshall) || other.henshall == henshall)&&(identical(other.shKk, shKk) || other.shKk == shKk)&&(identical(other.shKk2, shKk2) || other.shKk2 == shKk2)&&(identical(other.jfCards, jfCards) || other.jfCards == jfCards)&&(identical(other.tuttCards, tuttCards) || other.tuttCards == tuttCards)&&(identical(other.kanjiInContext, kanjiInContext) || other.kanjiInContext == kanjiInContext)&&(identical(other.kodanshaCompact, kodanshaCompact) || other.kodanshaCompact == kodanshaCompact)&&(identical(other.skip, skip) || other.skip == skip)&&(identical(other.busyPeople, busyPeople) || other.busyPeople == busyPeople));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,nelsonC,nelsonN,halpernNjecd,halpernKkd,halpernKkld,halpernKkld2ed,heisig,heisig6,gakken,oneillNames,oneillKk,moro,henshall,shKk,shKk2,jfCards,tuttCards,kanjiInContext,kodanshaCompact,skip,busyPeople]);

@override
String toString() {
  return 'KanjidicDictRefsDto(nelsonC: $nelsonC, nelsonN: $nelsonN, halpernNjecd: $halpernNjecd, halpernKkd: $halpernKkd, halpernKkld: $halpernKkld, halpernKkld2ed: $halpernKkld2ed, heisig: $heisig, heisig6: $heisig6, gakken: $gakken, oneillNames: $oneillNames, oneillKk: $oneillKk, moro: $moro, henshall: $henshall, shKk: $shKk, shKk2: $shKk2, jfCards: $jfCards, tuttCards: $tuttCards, kanjiInContext: $kanjiInContext, kodanshaCompact: $kodanshaCompact, skip: $skip, busyPeople: $busyPeople)';
}


}

/// @nodoc
abstract mixin class _$KanjidicDictRefsDtoCopyWith<$Res> implements $KanjidicDictRefsDtoCopyWith<$Res> {
  factory _$KanjidicDictRefsDtoCopyWith(_KanjidicDictRefsDto value, $Res Function(_KanjidicDictRefsDto) _then) = __$KanjidicDictRefsDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'nelson_c') String? nelsonC,@JsonKey(name: 'nelson_n') String? nelsonN,@JsonKey(name: 'halpern_njecd') String? halpernNjecd,@JsonKey(name: 'halpern_kkd') String? halpernKkd,@JsonKey(name: 'halpern_kkld') String? halpernKkld,@JsonKey(name: 'halpern_kkld_2ed') String? halpernKkld2ed, String? heisig, String? heisig6, String? gakken,@JsonKey(name: 'oneill_names') String? oneillNames,@JsonKey(name: 'oneill_kk') String? oneillKk, KanjidicMoroRefDto? moro, String? henshall,@JsonKey(name: 'sh_kk') String? shKk,@JsonKey(name: 'sh_kk2') String? shKk2,@JsonKey(name: 'jf_cards') String? jfCards,@JsonKey(name: 'tutt_cards') String? tuttCards,@JsonKey(name: 'kanji_in_context') String? kanjiInContext,@JsonKey(name: 'kodansha_compact') String? kodanshaCompact, String? skip,@JsonKey(name: 'busy_people') String? busyPeople
});


@override $KanjidicMoroRefDtoCopyWith<$Res>? get moro;

}
/// @nodoc
class __$KanjidicDictRefsDtoCopyWithImpl<$Res>
    implements _$KanjidicDictRefsDtoCopyWith<$Res> {
  __$KanjidicDictRefsDtoCopyWithImpl(this._self, this._then);

  final _KanjidicDictRefsDto _self;
  final $Res Function(_KanjidicDictRefsDto) _then;

/// Create a copy of KanjidicDictRefsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nelsonC = freezed,Object? nelsonN = freezed,Object? halpernNjecd = freezed,Object? halpernKkd = freezed,Object? halpernKkld = freezed,Object? halpernKkld2ed = freezed,Object? heisig = freezed,Object? heisig6 = freezed,Object? gakken = freezed,Object? oneillNames = freezed,Object? oneillKk = freezed,Object? moro = freezed,Object? henshall = freezed,Object? shKk = freezed,Object? shKk2 = freezed,Object? jfCards = freezed,Object? tuttCards = freezed,Object? kanjiInContext = freezed,Object? kodanshaCompact = freezed,Object? skip = freezed,Object? busyPeople = freezed,}) {
  return _then(_KanjidicDictRefsDto(
nelsonC: freezed == nelsonC ? _self.nelsonC : nelsonC // ignore: cast_nullable_to_non_nullable
as String?,nelsonN: freezed == nelsonN ? _self.nelsonN : nelsonN // ignore: cast_nullable_to_non_nullable
as String?,halpernNjecd: freezed == halpernNjecd ? _self.halpernNjecd : halpernNjecd // ignore: cast_nullable_to_non_nullable
as String?,halpernKkd: freezed == halpernKkd ? _self.halpernKkd : halpernKkd // ignore: cast_nullable_to_non_nullable
as String?,halpernKkld: freezed == halpernKkld ? _self.halpernKkld : halpernKkld // ignore: cast_nullable_to_non_nullable
as String?,halpernKkld2ed: freezed == halpernKkld2ed ? _self.halpernKkld2ed : halpernKkld2ed // ignore: cast_nullable_to_non_nullable
as String?,heisig: freezed == heisig ? _self.heisig : heisig // ignore: cast_nullable_to_non_nullable
as String?,heisig6: freezed == heisig6 ? _self.heisig6 : heisig6 // ignore: cast_nullable_to_non_nullable
as String?,gakken: freezed == gakken ? _self.gakken : gakken // ignore: cast_nullable_to_non_nullable
as String?,oneillNames: freezed == oneillNames ? _self.oneillNames : oneillNames // ignore: cast_nullable_to_non_nullable
as String?,oneillKk: freezed == oneillKk ? _self.oneillKk : oneillKk // ignore: cast_nullable_to_non_nullable
as String?,moro: freezed == moro ? _self.moro : moro // ignore: cast_nullable_to_non_nullable
as KanjidicMoroRefDto?,henshall: freezed == henshall ? _self.henshall : henshall // ignore: cast_nullable_to_non_nullable
as String?,shKk: freezed == shKk ? _self.shKk : shKk // ignore: cast_nullable_to_non_nullable
as String?,shKk2: freezed == shKk2 ? _self.shKk2 : shKk2 // ignore: cast_nullable_to_non_nullable
as String?,jfCards: freezed == jfCards ? _self.jfCards : jfCards // ignore: cast_nullable_to_non_nullable
as String?,tuttCards: freezed == tuttCards ? _self.tuttCards : tuttCards // ignore: cast_nullable_to_non_nullable
as String?,kanjiInContext: freezed == kanjiInContext ? _self.kanjiInContext : kanjiInContext // ignore: cast_nullable_to_non_nullable
as String?,kodanshaCompact: freezed == kodanshaCompact ? _self.kodanshaCompact : kodanshaCompact // ignore: cast_nullable_to_non_nullable
as String?,skip: freezed == skip ? _self.skip : skip // ignore: cast_nullable_to_non_nullable
as String?,busyPeople: freezed == busyPeople ? _self.busyPeople : busyPeople // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of KanjidicDictRefsDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KanjidicMoroRefDtoCopyWith<$Res>? get moro {
    if (_self.moro == null) {
    return null;
  }

  return $KanjidicMoroRefDtoCopyWith<$Res>(_self.moro!, (value) {
    return _then(_self.copyWith(moro: value));
  });
}
}


/// @nodoc
mixin _$KanjidicMoroRefDto {

 String get volume; String get page;
/// Create a copy of KanjidicMoroRefDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KanjidicMoroRefDtoCopyWith<KanjidicMoroRefDto> get copyWith => _$KanjidicMoroRefDtoCopyWithImpl<KanjidicMoroRefDto>(this as KanjidicMoroRefDto, _$identity);

  /// Serializes this KanjidicMoroRefDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KanjidicMoroRefDto&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.page, page) || other.page == page));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,volume,page);

@override
String toString() {
  return 'KanjidicMoroRefDto(volume: $volume, page: $page)';
}


}

/// @nodoc
abstract mixin class $KanjidicMoroRefDtoCopyWith<$Res>  {
  factory $KanjidicMoroRefDtoCopyWith(KanjidicMoroRefDto value, $Res Function(KanjidicMoroRefDto) _then) = _$KanjidicMoroRefDtoCopyWithImpl;
@useResult
$Res call({
 String volume, String page
});




}
/// @nodoc
class _$KanjidicMoroRefDtoCopyWithImpl<$Res>
    implements $KanjidicMoroRefDtoCopyWith<$Res> {
  _$KanjidicMoroRefDtoCopyWithImpl(this._self, this._then);

  final KanjidicMoroRefDto _self;
  final $Res Function(KanjidicMoroRefDto) _then;

/// Create a copy of KanjidicMoroRefDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? volume = null,Object? page = null,}) {
  return _then(_self.copyWith(
volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as String,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [KanjidicMoroRefDto].
extension KanjidicMoroRefDtoPatterns on KanjidicMoroRefDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KanjidicMoroRefDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KanjidicMoroRefDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KanjidicMoroRefDto value)  $default,){
final _that = this;
switch (_that) {
case _KanjidicMoroRefDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KanjidicMoroRefDto value)?  $default,){
final _that = this;
switch (_that) {
case _KanjidicMoroRefDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String volume,  String page)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KanjidicMoroRefDto() when $default != null:
return $default(_that.volume,_that.page);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String volume,  String page)  $default,) {final _that = this;
switch (_that) {
case _KanjidicMoroRefDto():
return $default(_that.volume,_that.page);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String volume,  String page)?  $default,) {final _that = this;
switch (_that) {
case _KanjidicMoroRefDto() when $default != null:
return $default(_that.volume,_that.page);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KanjidicMoroRefDto extends KanjidicMoroRefDto {
  const _KanjidicMoroRefDto({required this.volume, required this.page}): super._();
  factory _KanjidicMoroRefDto.fromJson(Map<String, dynamic> json) => _$KanjidicMoroRefDtoFromJson(json);

@override final  String volume;
@override final  String page;

/// Create a copy of KanjidicMoroRefDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KanjidicMoroRefDtoCopyWith<_KanjidicMoroRefDto> get copyWith => __$KanjidicMoroRefDtoCopyWithImpl<_KanjidicMoroRefDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KanjidicMoroRefDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KanjidicMoroRefDto&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.page, page) || other.page == page));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,volume,page);

@override
String toString() {
  return 'KanjidicMoroRefDto(volume: $volume, page: $page)';
}


}

/// @nodoc
abstract mixin class _$KanjidicMoroRefDtoCopyWith<$Res> implements $KanjidicMoroRefDtoCopyWith<$Res> {
  factory _$KanjidicMoroRefDtoCopyWith(_KanjidicMoroRefDto value, $Res Function(_KanjidicMoroRefDto) _then) = __$KanjidicMoroRefDtoCopyWithImpl;
@override @useResult
$Res call({
 String volume, String page
});




}
/// @nodoc
class __$KanjidicMoroRefDtoCopyWithImpl<$Res>
    implements _$KanjidicMoroRefDtoCopyWith<$Res> {
  __$KanjidicMoroRefDtoCopyWithImpl(this._self, this._then);

  final _KanjidicMoroRefDto _self;
  final $Res Function(_KanjidicMoroRefDto) _then;

/// Create a copy of KanjidicMoroRefDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? volume = null,Object? page = null,}) {
  return _then(_KanjidicMoroRefDto(
volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as String,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$KanjidicQueryCodesDto {

 String? get skip;@JsonKey(name: 'four_corner') String? get fourCorner;@JsonKey(name: 'sh_desc') String? get shDesc; String? get deroo; List<KanjidicMisclassDto>? get misclass;
/// Create a copy of KanjidicQueryCodesDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KanjidicQueryCodesDtoCopyWith<KanjidicQueryCodesDto> get copyWith => _$KanjidicQueryCodesDtoCopyWithImpl<KanjidicQueryCodesDto>(this as KanjidicQueryCodesDto, _$identity);

  /// Serializes this KanjidicQueryCodesDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KanjidicQueryCodesDto&&(identical(other.skip, skip) || other.skip == skip)&&(identical(other.fourCorner, fourCorner) || other.fourCorner == fourCorner)&&(identical(other.shDesc, shDesc) || other.shDesc == shDesc)&&(identical(other.deroo, deroo) || other.deroo == deroo)&&const DeepCollectionEquality().equals(other.misclass, misclass));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,skip,fourCorner,shDesc,deroo,const DeepCollectionEquality().hash(misclass));

@override
String toString() {
  return 'KanjidicQueryCodesDto(skip: $skip, fourCorner: $fourCorner, shDesc: $shDesc, deroo: $deroo, misclass: $misclass)';
}


}

/// @nodoc
abstract mixin class $KanjidicQueryCodesDtoCopyWith<$Res>  {
  factory $KanjidicQueryCodesDtoCopyWith(KanjidicQueryCodesDto value, $Res Function(KanjidicQueryCodesDto) _then) = _$KanjidicQueryCodesDtoCopyWithImpl;
@useResult
$Res call({
 String? skip,@JsonKey(name: 'four_corner') String? fourCorner,@JsonKey(name: 'sh_desc') String? shDesc, String? deroo, List<KanjidicMisclassDto>? misclass
});




}
/// @nodoc
class _$KanjidicQueryCodesDtoCopyWithImpl<$Res>
    implements $KanjidicQueryCodesDtoCopyWith<$Res> {
  _$KanjidicQueryCodesDtoCopyWithImpl(this._self, this._then);

  final KanjidicQueryCodesDto _self;
  final $Res Function(KanjidicQueryCodesDto) _then;

/// Create a copy of KanjidicQueryCodesDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? skip = freezed,Object? fourCorner = freezed,Object? shDesc = freezed,Object? deroo = freezed,Object? misclass = freezed,}) {
  return _then(_self.copyWith(
skip: freezed == skip ? _self.skip : skip // ignore: cast_nullable_to_non_nullable
as String?,fourCorner: freezed == fourCorner ? _self.fourCorner : fourCorner // ignore: cast_nullable_to_non_nullable
as String?,shDesc: freezed == shDesc ? _self.shDesc : shDesc // ignore: cast_nullable_to_non_nullable
as String?,deroo: freezed == deroo ? _self.deroo : deroo // ignore: cast_nullable_to_non_nullable
as String?,misclass: freezed == misclass ? _self.misclass : misclass // ignore: cast_nullable_to_non_nullable
as List<KanjidicMisclassDto>?,
  ));
}

}


/// Adds pattern-matching-related methods to [KanjidicQueryCodesDto].
extension KanjidicQueryCodesDtoPatterns on KanjidicQueryCodesDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KanjidicQueryCodesDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KanjidicQueryCodesDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KanjidicQueryCodesDto value)  $default,){
final _that = this;
switch (_that) {
case _KanjidicQueryCodesDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KanjidicQueryCodesDto value)?  $default,){
final _that = this;
switch (_that) {
case _KanjidicQueryCodesDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? skip, @JsonKey(name: 'four_corner')  String? fourCorner, @JsonKey(name: 'sh_desc')  String? shDesc,  String? deroo,  List<KanjidicMisclassDto>? misclass)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KanjidicQueryCodesDto() when $default != null:
return $default(_that.skip,_that.fourCorner,_that.shDesc,_that.deroo,_that.misclass);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? skip, @JsonKey(name: 'four_corner')  String? fourCorner, @JsonKey(name: 'sh_desc')  String? shDesc,  String? deroo,  List<KanjidicMisclassDto>? misclass)  $default,) {final _that = this;
switch (_that) {
case _KanjidicQueryCodesDto():
return $default(_that.skip,_that.fourCorner,_that.shDesc,_that.deroo,_that.misclass);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? skip, @JsonKey(name: 'four_corner')  String? fourCorner, @JsonKey(name: 'sh_desc')  String? shDesc,  String? deroo,  List<KanjidicMisclassDto>? misclass)?  $default,) {final _that = this;
switch (_that) {
case _KanjidicQueryCodesDto() when $default != null:
return $default(_that.skip,_that.fourCorner,_that.shDesc,_that.deroo,_that.misclass);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KanjidicQueryCodesDto extends KanjidicQueryCodesDto {
  const _KanjidicQueryCodesDto({this.skip, @JsonKey(name: 'four_corner') this.fourCorner, @JsonKey(name: 'sh_desc') this.shDesc, this.deroo, final  List<KanjidicMisclassDto>? misclass}): _misclass = misclass,super._();
  factory _KanjidicQueryCodesDto.fromJson(Map<String, dynamic> json) => _$KanjidicQueryCodesDtoFromJson(json);

@override final  String? skip;
@override@JsonKey(name: 'four_corner') final  String? fourCorner;
@override@JsonKey(name: 'sh_desc') final  String? shDesc;
@override final  String? deroo;
 final  List<KanjidicMisclassDto>? _misclass;
@override List<KanjidicMisclassDto>? get misclass {
  final value = _misclass;
  if (value == null) return null;
  if (_misclass is EqualUnmodifiableListView) return _misclass;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of KanjidicQueryCodesDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KanjidicQueryCodesDtoCopyWith<_KanjidicQueryCodesDto> get copyWith => __$KanjidicQueryCodesDtoCopyWithImpl<_KanjidicQueryCodesDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KanjidicQueryCodesDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KanjidicQueryCodesDto&&(identical(other.skip, skip) || other.skip == skip)&&(identical(other.fourCorner, fourCorner) || other.fourCorner == fourCorner)&&(identical(other.shDesc, shDesc) || other.shDesc == shDesc)&&(identical(other.deroo, deroo) || other.deroo == deroo)&&const DeepCollectionEquality().equals(other._misclass, _misclass));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,skip,fourCorner,shDesc,deroo,const DeepCollectionEquality().hash(_misclass));

@override
String toString() {
  return 'KanjidicQueryCodesDto(skip: $skip, fourCorner: $fourCorner, shDesc: $shDesc, deroo: $deroo, misclass: $misclass)';
}


}

/// @nodoc
abstract mixin class _$KanjidicQueryCodesDtoCopyWith<$Res> implements $KanjidicQueryCodesDtoCopyWith<$Res> {
  factory _$KanjidicQueryCodesDtoCopyWith(_KanjidicQueryCodesDto value, $Res Function(_KanjidicQueryCodesDto) _then) = __$KanjidicQueryCodesDtoCopyWithImpl;
@override @useResult
$Res call({
 String? skip,@JsonKey(name: 'four_corner') String? fourCorner,@JsonKey(name: 'sh_desc') String? shDesc, String? deroo, List<KanjidicMisclassDto>? misclass
});




}
/// @nodoc
class __$KanjidicQueryCodesDtoCopyWithImpl<$Res>
    implements _$KanjidicQueryCodesDtoCopyWith<$Res> {
  __$KanjidicQueryCodesDtoCopyWithImpl(this._self, this._then);

  final _KanjidicQueryCodesDto _self;
  final $Res Function(_KanjidicQueryCodesDto) _then;

/// Create a copy of KanjidicQueryCodesDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? skip = freezed,Object? fourCorner = freezed,Object? shDesc = freezed,Object? deroo = freezed,Object? misclass = freezed,}) {
  return _then(_KanjidicQueryCodesDto(
skip: freezed == skip ? _self.skip : skip // ignore: cast_nullable_to_non_nullable
as String?,fourCorner: freezed == fourCorner ? _self.fourCorner : fourCorner // ignore: cast_nullable_to_non_nullable
as String?,shDesc: freezed == shDesc ? _self.shDesc : shDesc // ignore: cast_nullable_to_non_nullable
as String?,deroo: freezed == deroo ? _self.deroo : deroo // ignore: cast_nullable_to_non_nullable
as String?,misclass: freezed == misclass ? _self._misclass : misclass // ignore: cast_nullable_to_non_nullable
as List<KanjidicMisclassDto>?,
  ));
}


}


/// @nodoc
mixin _$KanjidicMisclassDto {

 String get type; String get value;
/// Create a copy of KanjidicMisclassDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KanjidicMisclassDtoCopyWith<KanjidicMisclassDto> get copyWith => _$KanjidicMisclassDtoCopyWithImpl<KanjidicMisclassDto>(this as KanjidicMisclassDto, _$identity);

  /// Serializes this KanjidicMisclassDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KanjidicMisclassDto&&(identical(other.type, type) || other.type == type)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,value);

@override
String toString() {
  return 'KanjidicMisclassDto(type: $type, value: $value)';
}


}

/// @nodoc
abstract mixin class $KanjidicMisclassDtoCopyWith<$Res>  {
  factory $KanjidicMisclassDtoCopyWith(KanjidicMisclassDto value, $Res Function(KanjidicMisclassDto) _then) = _$KanjidicMisclassDtoCopyWithImpl;
@useResult
$Res call({
 String type, String value
});




}
/// @nodoc
class _$KanjidicMisclassDtoCopyWithImpl<$Res>
    implements $KanjidicMisclassDtoCopyWith<$Res> {
  _$KanjidicMisclassDtoCopyWithImpl(this._self, this._then);

  final KanjidicMisclassDto _self;
  final $Res Function(KanjidicMisclassDto) _then;

/// Create a copy of KanjidicMisclassDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? value = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [KanjidicMisclassDto].
extension KanjidicMisclassDtoPatterns on KanjidicMisclassDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KanjidicMisclassDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KanjidicMisclassDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KanjidicMisclassDto value)  $default,){
final _that = this;
switch (_that) {
case _KanjidicMisclassDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KanjidicMisclassDto value)?  $default,){
final _that = this;
switch (_that) {
case _KanjidicMisclassDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KanjidicMisclassDto() when $default != null:
return $default(_that.type,_that.value);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String value)  $default,) {final _that = this;
switch (_that) {
case _KanjidicMisclassDto():
return $default(_that.type,_that.value);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String value)?  $default,) {final _that = this;
switch (_that) {
case _KanjidicMisclassDto() when $default != null:
return $default(_that.type,_that.value);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KanjidicMisclassDto extends KanjidicMisclassDto {
  const _KanjidicMisclassDto({required this.type, required this.value}): super._();
  factory _KanjidicMisclassDto.fromJson(Map<String, dynamic> json) => _$KanjidicMisclassDtoFromJson(json);

@override final  String type;
@override final  String value;

/// Create a copy of KanjidicMisclassDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KanjidicMisclassDtoCopyWith<_KanjidicMisclassDto> get copyWith => __$KanjidicMisclassDtoCopyWithImpl<_KanjidicMisclassDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KanjidicMisclassDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KanjidicMisclassDto&&(identical(other.type, type) || other.type == type)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,value);

@override
String toString() {
  return 'KanjidicMisclassDto(type: $type, value: $value)';
}


}

/// @nodoc
abstract mixin class _$KanjidicMisclassDtoCopyWith<$Res> implements $KanjidicMisclassDtoCopyWith<$Res> {
  factory _$KanjidicMisclassDtoCopyWith(_KanjidicMisclassDto value, $Res Function(_KanjidicMisclassDto) _then) = __$KanjidicMisclassDtoCopyWithImpl;
@override @useResult
$Res call({
 String type, String value
});




}
/// @nodoc
class __$KanjidicMisclassDtoCopyWithImpl<$Res>
    implements _$KanjidicMisclassDtoCopyWith<$Res> {
  __$KanjidicMisclassDtoCopyWithImpl(this._self, this._then);

  final _KanjidicMisclassDto _self;
  final $Res Function(_KanjidicMisclassDto) _then;

/// Create a copy of KanjidicMisclassDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? value = null,}) {
  return _then(_KanjidicMisclassDto(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$KanjidicVariantDto {

@JsonKey(name: 'var_type') String get varType; String get value;
/// Create a copy of KanjidicVariantDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KanjidicVariantDtoCopyWith<KanjidicVariantDto> get copyWith => _$KanjidicVariantDtoCopyWithImpl<KanjidicVariantDto>(this as KanjidicVariantDto, _$identity);

  /// Serializes this KanjidicVariantDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KanjidicVariantDto&&(identical(other.varType, varType) || other.varType == varType)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,varType,value);

@override
String toString() {
  return 'KanjidicVariantDto(varType: $varType, value: $value)';
}


}

/// @nodoc
abstract mixin class $KanjidicVariantDtoCopyWith<$Res>  {
  factory $KanjidicVariantDtoCopyWith(KanjidicVariantDto value, $Res Function(KanjidicVariantDto) _then) = _$KanjidicVariantDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'var_type') String varType, String value
});




}
/// @nodoc
class _$KanjidicVariantDtoCopyWithImpl<$Res>
    implements $KanjidicVariantDtoCopyWith<$Res> {
  _$KanjidicVariantDtoCopyWithImpl(this._self, this._then);

  final KanjidicVariantDto _self;
  final $Res Function(KanjidicVariantDto) _then;

/// Create a copy of KanjidicVariantDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? varType = null,Object? value = null,}) {
  return _then(_self.copyWith(
varType: null == varType ? _self.varType : varType // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [KanjidicVariantDto].
extension KanjidicVariantDtoPatterns on KanjidicVariantDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KanjidicVariantDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KanjidicVariantDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KanjidicVariantDto value)  $default,){
final _that = this;
switch (_that) {
case _KanjidicVariantDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KanjidicVariantDto value)?  $default,){
final _that = this;
switch (_that) {
case _KanjidicVariantDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'var_type')  String varType,  String value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KanjidicVariantDto() when $default != null:
return $default(_that.varType,_that.value);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'var_type')  String varType,  String value)  $default,) {final _that = this;
switch (_that) {
case _KanjidicVariantDto():
return $default(_that.varType,_that.value);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'var_type')  String varType,  String value)?  $default,) {final _that = this;
switch (_that) {
case _KanjidicVariantDto() when $default != null:
return $default(_that.varType,_that.value);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KanjidicVariantDto extends KanjidicVariantDto {
  const _KanjidicVariantDto({@JsonKey(name: 'var_type') required this.varType, required this.value}): super._();
  factory _KanjidicVariantDto.fromJson(Map<String, dynamic> json) => _$KanjidicVariantDtoFromJson(json);

@override@JsonKey(name: 'var_type') final  String varType;
@override final  String value;

/// Create a copy of KanjidicVariantDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KanjidicVariantDtoCopyWith<_KanjidicVariantDto> get copyWith => __$KanjidicVariantDtoCopyWithImpl<_KanjidicVariantDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KanjidicVariantDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KanjidicVariantDto&&(identical(other.varType, varType) || other.varType == varType)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,varType,value);

@override
String toString() {
  return 'KanjidicVariantDto(varType: $varType, value: $value)';
}


}

/// @nodoc
abstract mixin class _$KanjidicVariantDtoCopyWith<$Res> implements $KanjidicVariantDtoCopyWith<$Res> {
  factory _$KanjidicVariantDtoCopyWith(_KanjidicVariantDto value, $Res Function(_KanjidicVariantDto) _then) = __$KanjidicVariantDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'var_type') String varType, String value
});




}
/// @nodoc
class __$KanjidicVariantDtoCopyWithImpl<$Res>
    implements _$KanjidicVariantDtoCopyWith<$Res> {
  __$KanjidicVariantDtoCopyWithImpl(this._self, this._then);

  final _KanjidicVariantDto _self;
  final $Res Function(_KanjidicVariantDto) _then;

/// Create a copy of KanjidicVariantDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? varType = null,Object? value = null,}) {
  return _then(_KanjidicVariantDto(
varType: null == varType ? _self.varType : varType // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$KanjidicReadingsDto {

@JsonKey(name: 'ja_on') List<String> get jaOn;@JsonKey(name: 'ja_kun') List<String> get jaKun; List<String>? get pinyin;@JsonKey(name: 'korean_r') List<String>? get koreanR;@JsonKey(name: 'korean_h') List<String>? get koreanH;
/// Create a copy of KanjidicReadingsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KanjidicReadingsDtoCopyWith<KanjidicReadingsDto> get copyWith => _$KanjidicReadingsDtoCopyWithImpl<KanjidicReadingsDto>(this as KanjidicReadingsDto, _$identity);

  /// Serializes this KanjidicReadingsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KanjidicReadingsDto&&const DeepCollectionEquality().equals(other.jaOn, jaOn)&&const DeepCollectionEquality().equals(other.jaKun, jaKun)&&const DeepCollectionEquality().equals(other.pinyin, pinyin)&&const DeepCollectionEquality().equals(other.koreanR, koreanR)&&const DeepCollectionEquality().equals(other.koreanH, koreanH));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(jaOn),const DeepCollectionEquality().hash(jaKun),const DeepCollectionEquality().hash(pinyin),const DeepCollectionEquality().hash(koreanR),const DeepCollectionEquality().hash(koreanH));

@override
String toString() {
  return 'KanjidicReadingsDto(jaOn: $jaOn, jaKun: $jaKun, pinyin: $pinyin, koreanR: $koreanR, koreanH: $koreanH)';
}


}

/// @nodoc
abstract mixin class $KanjidicReadingsDtoCopyWith<$Res>  {
  factory $KanjidicReadingsDtoCopyWith(KanjidicReadingsDto value, $Res Function(KanjidicReadingsDto) _then) = _$KanjidicReadingsDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'ja_on') List<String> jaOn,@JsonKey(name: 'ja_kun') List<String> jaKun, List<String>? pinyin,@JsonKey(name: 'korean_r') List<String>? koreanR,@JsonKey(name: 'korean_h') List<String>? koreanH
});




}
/// @nodoc
class _$KanjidicReadingsDtoCopyWithImpl<$Res>
    implements $KanjidicReadingsDtoCopyWith<$Res> {
  _$KanjidicReadingsDtoCopyWithImpl(this._self, this._then);

  final KanjidicReadingsDto _self;
  final $Res Function(KanjidicReadingsDto) _then;

/// Create a copy of KanjidicReadingsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? jaOn = null,Object? jaKun = null,Object? pinyin = freezed,Object? koreanR = freezed,Object? koreanH = freezed,}) {
  return _then(_self.copyWith(
jaOn: null == jaOn ? _self.jaOn : jaOn // ignore: cast_nullable_to_non_nullable
as List<String>,jaKun: null == jaKun ? _self.jaKun : jaKun // ignore: cast_nullable_to_non_nullable
as List<String>,pinyin: freezed == pinyin ? _self.pinyin : pinyin // ignore: cast_nullable_to_non_nullable
as List<String>?,koreanR: freezed == koreanR ? _self.koreanR : koreanR // ignore: cast_nullable_to_non_nullable
as List<String>?,koreanH: freezed == koreanH ? _self.koreanH : koreanH // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [KanjidicReadingsDto].
extension KanjidicReadingsDtoPatterns on KanjidicReadingsDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KanjidicReadingsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KanjidicReadingsDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KanjidicReadingsDto value)  $default,){
final _that = this;
switch (_that) {
case _KanjidicReadingsDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KanjidicReadingsDto value)?  $default,){
final _that = this;
switch (_that) {
case _KanjidicReadingsDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'ja_on')  List<String> jaOn, @JsonKey(name: 'ja_kun')  List<String> jaKun,  List<String>? pinyin, @JsonKey(name: 'korean_r')  List<String>? koreanR, @JsonKey(name: 'korean_h')  List<String>? koreanH)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KanjidicReadingsDto() when $default != null:
return $default(_that.jaOn,_that.jaKun,_that.pinyin,_that.koreanR,_that.koreanH);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'ja_on')  List<String> jaOn, @JsonKey(name: 'ja_kun')  List<String> jaKun,  List<String>? pinyin, @JsonKey(name: 'korean_r')  List<String>? koreanR, @JsonKey(name: 'korean_h')  List<String>? koreanH)  $default,) {final _that = this;
switch (_that) {
case _KanjidicReadingsDto():
return $default(_that.jaOn,_that.jaKun,_that.pinyin,_that.koreanR,_that.koreanH);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'ja_on')  List<String> jaOn, @JsonKey(name: 'ja_kun')  List<String> jaKun,  List<String>? pinyin, @JsonKey(name: 'korean_r')  List<String>? koreanR, @JsonKey(name: 'korean_h')  List<String>? koreanH)?  $default,) {final _that = this;
switch (_that) {
case _KanjidicReadingsDto() when $default != null:
return $default(_that.jaOn,_that.jaKun,_that.pinyin,_that.koreanR,_that.koreanH);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KanjidicReadingsDto extends KanjidicReadingsDto {
  const _KanjidicReadingsDto({@JsonKey(name: 'ja_on') required final  List<String> jaOn, @JsonKey(name: 'ja_kun') required final  List<String> jaKun, final  List<String>? pinyin, @JsonKey(name: 'korean_r') final  List<String>? koreanR, @JsonKey(name: 'korean_h') final  List<String>? koreanH}): _jaOn = jaOn,_jaKun = jaKun,_pinyin = pinyin,_koreanR = koreanR,_koreanH = koreanH,super._();
  factory _KanjidicReadingsDto.fromJson(Map<String, dynamic> json) => _$KanjidicReadingsDtoFromJson(json);

 final  List<String> _jaOn;
@override@JsonKey(name: 'ja_on') List<String> get jaOn {
  if (_jaOn is EqualUnmodifiableListView) return _jaOn;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_jaOn);
}

 final  List<String> _jaKun;
@override@JsonKey(name: 'ja_kun') List<String> get jaKun {
  if (_jaKun is EqualUnmodifiableListView) return _jaKun;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_jaKun);
}

 final  List<String>? _pinyin;
@override List<String>? get pinyin {
  final value = _pinyin;
  if (value == null) return null;
  if (_pinyin is EqualUnmodifiableListView) return _pinyin;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _koreanR;
@override@JsonKey(name: 'korean_r') List<String>? get koreanR {
  final value = _koreanR;
  if (value == null) return null;
  if (_koreanR is EqualUnmodifiableListView) return _koreanR;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _koreanH;
@override@JsonKey(name: 'korean_h') List<String>? get koreanH {
  final value = _koreanH;
  if (value == null) return null;
  if (_koreanH is EqualUnmodifiableListView) return _koreanH;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of KanjidicReadingsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KanjidicReadingsDtoCopyWith<_KanjidicReadingsDto> get copyWith => __$KanjidicReadingsDtoCopyWithImpl<_KanjidicReadingsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KanjidicReadingsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KanjidicReadingsDto&&const DeepCollectionEquality().equals(other._jaOn, _jaOn)&&const DeepCollectionEquality().equals(other._jaKun, _jaKun)&&const DeepCollectionEquality().equals(other._pinyin, _pinyin)&&const DeepCollectionEquality().equals(other._koreanR, _koreanR)&&const DeepCollectionEquality().equals(other._koreanH, _koreanH));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_jaOn),const DeepCollectionEquality().hash(_jaKun),const DeepCollectionEquality().hash(_pinyin),const DeepCollectionEquality().hash(_koreanR),const DeepCollectionEquality().hash(_koreanH));

@override
String toString() {
  return 'KanjidicReadingsDto(jaOn: $jaOn, jaKun: $jaKun, pinyin: $pinyin, koreanR: $koreanR, koreanH: $koreanH)';
}


}

/// @nodoc
abstract mixin class _$KanjidicReadingsDtoCopyWith<$Res> implements $KanjidicReadingsDtoCopyWith<$Res> {
  factory _$KanjidicReadingsDtoCopyWith(_KanjidicReadingsDto value, $Res Function(_KanjidicReadingsDto) _then) = __$KanjidicReadingsDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'ja_on') List<String> jaOn,@JsonKey(name: 'ja_kun') List<String> jaKun, List<String>? pinyin,@JsonKey(name: 'korean_r') List<String>? koreanR,@JsonKey(name: 'korean_h') List<String>? koreanH
});




}
/// @nodoc
class __$KanjidicReadingsDtoCopyWithImpl<$Res>
    implements _$KanjidicReadingsDtoCopyWith<$Res> {
  __$KanjidicReadingsDtoCopyWithImpl(this._self, this._then);

  final _KanjidicReadingsDto _self;
  final $Res Function(_KanjidicReadingsDto) _then;

/// Create a copy of KanjidicReadingsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? jaOn = null,Object? jaKun = null,Object? pinyin = freezed,Object? koreanR = freezed,Object? koreanH = freezed,}) {
  return _then(_KanjidicReadingsDto(
jaOn: null == jaOn ? _self._jaOn : jaOn // ignore: cast_nullable_to_non_nullable
as List<String>,jaKun: null == jaKun ? _self._jaKun : jaKun // ignore: cast_nullable_to_non_nullable
as List<String>,pinyin: freezed == pinyin ? _self._pinyin : pinyin // ignore: cast_nullable_to_non_nullable
as List<String>?,koreanR: freezed == koreanR ? _self._koreanR : koreanR // ignore: cast_nullable_to_non_nullable
as List<String>?,koreanH: freezed == koreanH ? _self._koreanH : koreanH // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
