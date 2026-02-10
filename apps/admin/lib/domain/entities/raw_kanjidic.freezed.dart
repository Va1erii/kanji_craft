// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'raw_kanjidic.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RawKanjidic {

 int get importId; String get literal; int get strokeCount; List<int>? get strokeCountMisstrokes; int? get grade; int? get jlpt; int? get frequency; KanjidicCodepoints get codepoints; KanjidicRadicals get radicals; KanjidicDictRefs? get dictRefs; KanjidicQueryCodes? get queryCodes; KanjidicReadings get readings; List<String>? get nanori; Map<String, List<String>> get meanings; List<KanjidicVariant>? get variants; List<String>? get radicalNames;
/// Create a copy of RawKanjidic
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RawKanjidicCopyWith<RawKanjidic> get copyWith => _$RawKanjidicCopyWithImpl<RawKanjidic>(this as RawKanjidic, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RawKanjidic&&(identical(other.importId, importId) || other.importId == importId)&&(identical(other.literal, literal) || other.literal == literal)&&(identical(other.strokeCount, strokeCount) || other.strokeCount == strokeCount)&&const DeepCollectionEquality().equals(other.strokeCountMisstrokes, strokeCountMisstrokes)&&(identical(other.grade, grade) || other.grade == grade)&&(identical(other.jlpt, jlpt) || other.jlpt == jlpt)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.codepoints, codepoints) || other.codepoints == codepoints)&&(identical(other.radicals, radicals) || other.radicals == radicals)&&(identical(other.dictRefs, dictRefs) || other.dictRefs == dictRefs)&&(identical(other.queryCodes, queryCodes) || other.queryCodes == queryCodes)&&(identical(other.readings, readings) || other.readings == readings)&&const DeepCollectionEquality().equals(other.nanori, nanori)&&const DeepCollectionEquality().equals(other.meanings, meanings)&&const DeepCollectionEquality().equals(other.variants, variants)&&const DeepCollectionEquality().equals(other.radicalNames, radicalNames));
}


@override
int get hashCode => Object.hash(runtimeType,importId,literal,strokeCount,const DeepCollectionEquality().hash(strokeCountMisstrokes),grade,jlpt,frequency,codepoints,radicals,dictRefs,queryCodes,readings,const DeepCollectionEquality().hash(nanori),const DeepCollectionEquality().hash(meanings),const DeepCollectionEquality().hash(variants),const DeepCollectionEquality().hash(radicalNames));

@override
String toString() {
  return 'RawKanjidic(importId: $importId, literal: $literal, strokeCount: $strokeCount, strokeCountMisstrokes: $strokeCountMisstrokes, grade: $grade, jlpt: $jlpt, frequency: $frequency, codepoints: $codepoints, radicals: $radicals, dictRefs: $dictRefs, queryCodes: $queryCodes, readings: $readings, nanori: $nanori, meanings: $meanings, variants: $variants, radicalNames: $radicalNames)';
}


}

/// @nodoc
abstract mixin class $RawKanjidicCopyWith<$Res>  {
  factory $RawKanjidicCopyWith(RawKanjidic value, $Res Function(RawKanjidic) _then) = _$RawKanjidicCopyWithImpl;
@useResult
$Res call({
 int importId, String literal, int strokeCount, List<int>? strokeCountMisstrokes, int? grade, int? jlpt, int? frequency, KanjidicCodepoints codepoints, KanjidicRadicals radicals, KanjidicDictRefs? dictRefs, KanjidicQueryCodes? queryCodes, KanjidicReadings readings, List<String>? nanori, Map<String, List<String>> meanings, List<KanjidicVariant>? variants, List<String>? radicalNames
});


$KanjidicCodepointsCopyWith<$Res> get codepoints;$KanjidicRadicalsCopyWith<$Res> get radicals;$KanjidicDictRefsCopyWith<$Res>? get dictRefs;$KanjidicQueryCodesCopyWith<$Res>? get queryCodes;$KanjidicReadingsCopyWith<$Res> get readings;

}
/// @nodoc
class _$RawKanjidicCopyWithImpl<$Res>
    implements $RawKanjidicCopyWith<$Res> {
  _$RawKanjidicCopyWithImpl(this._self, this._then);

  final RawKanjidic _self;
  final $Res Function(RawKanjidic) _then;

/// Create a copy of RawKanjidic
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? importId = null,Object? literal = null,Object? strokeCount = null,Object? strokeCountMisstrokes = freezed,Object? grade = freezed,Object? jlpt = freezed,Object? frequency = freezed,Object? codepoints = null,Object? radicals = null,Object? dictRefs = freezed,Object? queryCodes = freezed,Object? readings = null,Object? nanori = freezed,Object? meanings = null,Object? variants = freezed,Object? radicalNames = freezed,}) {
  return _then(_self.copyWith(
importId: null == importId ? _self.importId : importId // ignore: cast_nullable_to_non_nullable
as int,literal: null == literal ? _self.literal : literal // ignore: cast_nullable_to_non_nullable
as String,strokeCount: null == strokeCount ? _self.strokeCount : strokeCount // ignore: cast_nullable_to_non_nullable
as int,strokeCountMisstrokes: freezed == strokeCountMisstrokes ? _self.strokeCountMisstrokes : strokeCountMisstrokes // ignore: cast_nullable_to_non_nullable
as List<int>?,grade: freezed == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as int?,jlpt: freezed == jlpt ? _self.jlpt : jlpt // ignore: cast_nullable_to_non_nullable
as int?,frequency: freezed == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as int?,codepoints: null == codepoints ? _self.codepoints : codepoints // ignore: cast_nullable_to_non_nullable
as KanjidicCodepoints,radicals: null == radicals ? _self.radicals : radicals // ignore: cast_nullable_to_non_nullable
as KanjidicRadicals,dictRefs: freezed == dictRefs ? _self.dictRefs : dictRefs // ignore: cast_nullable_to_non_nullable
as KanjidicDictRefs?,queryCodes: freezed == queryCodes ? _self.queryCodes : queryCodes // ignore: cast_nullable_to_non_nullable
as KanjidicQueryCodes?,readings: null == readings ? _self.readings : readings // ignore: cast_nullable_to_non_nullable
as KanjidicReadings,nanori: freezed == nanori ? _self.nanori : nanori // ignore: cast_nullable_to_non_nullable
as List<String>?,meanings: null == meanings ? _self.meanings : meanings // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>,variants: freezed == variants ? _self.variants : variants // ignore: cast_nullable_to_non_nullable
as List<KanjidicVariant>?,radicalNames: freezed == radicalNames ? _self.radicalNames : radicalNames // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}
/// Create a copy of RawKanjidic
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KanjidicCodepointsCopyWith<$Res> get codepoints {
  
  return $KanjidicCodepointsCopyWith<$Res>(_self.codepoints, (value) {
    return _then(_self.copyWith(codepoints: value));
  });
}/// Create a copy of RawKanjidic
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KanjidicRadicalsCopyWith<$Res> get radicals {
  
  return $KanjidicRadicalsCopyWith<$Res>(_self.radicals, (value) {
    return _then(_self.copyWith(radicals: value));
  });
}/// Create a copy of RawKanjidic
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KanjidicDictRefsCopyWith<$Res>? get dictRefs {
    if (_self.dictRefs == null) {
    return null;
  }

  return $KanjidicDictRefsCopyWith<$Res>(_self.dictRefs!, (value) {
    return _then(_self.copyWith(dictRefs: value));
  });
}/// Create a copy of RawKanjidic
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KanjidicQueryCodesCopyWith<$Res>? get queryCodes {
    if (_self.queryCodes == null) {
    return null;
  }

  return $KanjidicQueryCodesCopyWith<$Res>(_self.queryCodes!, (value) {
    return _then(_self.copyWith(queryCodes: value));
  });
}/// Create a copy of RawKanjidic
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KanjidicReadingsCopyWith<$Res> get readings {
  
  return $KanjidicReadingsCopyWith<$Res>(_self.readings, (value) {
    return _then(_self.copyWith(readings: value));
  });
}
}


/// Adds pattern-matching-related methods to [RawKanjidic].
extension RawKanjidicPatterns on RawKanjidic {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RawKanjidic value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RawKanjidic() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RawKanjidic value)  $default,){
final _that = this;
switch (_that) {
case _RawKanjidic():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RawKanjidic value)?  $default,){
final _that = this;
switch (_that) {
case _RawKanjidic() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int importId,  String literal,  int strokeCount,  List<int>? strokeCountMisstrokes,  int? grade,  int? jlpt,  int? frequency,  KanjidicCodepoints codepoints,  KanjidicRadicals radicals,  KanjidicDictRefs? dictRefs,  KanjidicQueryCodes? queryCodes,  KanjidicReadings readings,  List<String>? nanori,  Map<String, List<String>> meanings,  List<KanjidicVariant>? variants,  List<String>? radicalNames)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RawKanjidic() when $default != null:
return $default(_that.importId,_that.literal,_that.strokeCount,_that.strokeCountMisstrokes,_that.grade,_that.jlpt,_that.frequency,_that.codepoints,_that.radicals,_that.dictRefs,_that.queryCodes,_that.readings,_that.nanori,_that.meanings,_that.variants,_that.radicalNames);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int importId,  String literal,  int strokeCount,  List<int>? strokeCountMisstrokes,  int? grade,  int? jlpt,  int? frequency,  KanjidicCodepoints codepoints,  KanjidicRadicals radicals,  KanjidicDictRefs? dictRefs,  KanjidicQueryCodes? queryCodes,  KanjidicReadings readings,  List<String>? nanori,  Map<String, List<String>> meanings,  List<KanjidicVariant>? variants,  List<String>? radicalNames)  $default,) {final _that = this;
switch (_that) {
case _RawKanjidic():
return $default(_that.importId,_that.literal,_that.strokeCount,_that.strokeCountMisstrokes,_that.grade,_that.jlpt,_that.frequency,_that.codepoints,_that.radicals,_that.dictRefs,_that.queryCodes,_that.readings,_that.nanori,_that.meanings,_that.variants,_that.radicalNames);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int importId,  String literal,  int strokeCount,  List<int>? strokeCountMisstrokes,  int? grade,  int? jlpt,  int? frequency,  KanjidicCodepoints codepoints,  KanjidicRadicals radicals,  KanjidicDictRefs? dictRefs,  KanjidicQueryCodes? queryCodes,  KanjidicReadings readings,  List<String>? nanori,  Map<String, List<String>> meanings,  List<KanjidicVariant>? variants,  List<String>? radicalNames)?  $default,) {final _that = this;
switch (_that) {
case _RawKanjidic() when $default != null:
return $default(_that.importId,_that.literal,_that.strokeCount,_that.strokeCountMisstrokes,_that.grade,_that.jlpt,_that.frequency,_that.codepoints,_that.radicals,_that.dictRefs,_that.queryCodes,_that.readings,_that.nanori,_that.meanings,_that.variants,_that.radicalNames);case _:
  return null;

}
}

}

/// @nodoc


class _RawKanjidic implements RawKanjidic {
  const _RawKanjidic({required this.importId, required this.literal, required this.strokeCount, final  List<int>? strokeCountMisstrokes, this.grade, this.jlpt, this.frequency, required this.codepoints, required this.radicals, this.dictRefs, this.queryCodes, required this.readings, final  List<String>? nanori, required final  Map<String, List<String>> meanings, final  List<KanjidicVariant>? variants, final  List<String>? radicalNames}): _strokeCountMisstrokes = strokeCountMisstrokes,_nanori = nanori,_meanings = meanings,_variants = variants,_radicalNames = radicalNames;
  

@override final  int importId;
@override final  String literal;
@override final  int strokeCount;
 final  List<int>? _strokeCountMisstrokes;
@override List<int>? get strokeCountMisstrokes {
  final value = _strokeCountMisstrokes;
  if (value == null) return null;
  if (_strokeCountMisstrokes is EqualUnmodifiableListView) return _strokeCountMisstrokes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  int? grade;
@override final  int? jlpt;
@override final  int? frequency;
@override final  KanjidicCodepoints codepoints;
@override final  KanjidicRadicals radicals;
@override final  KanjidicDictRefs? dictRefs;
@override final  KanjidicQueryCodes? queryCodes;
@override final  KanjidicReadings readings;
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

 final  List<KanjidicVariant>? _variants;
@override List<KanjidicVariant>? get variants {
  final value = _variants;
  if (value == null) return null;
  if (_variants is EqualUnmodifiableListView) return _variants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _radicalNames;
@override List<String>? get radicalNames {
  final value = _radicalNames;
  if (value == null) return null;
  if (_radicalNames is EqualUnmodifiableListView) return _radicalNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of RawKanjidic
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RawKanjidicCopyWith<_RawKanjidic> get copyWith => __$RawKanjidicCopyWithImpl<_RawKanjidic>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RawKanjidic&&(identical(other.importId, importId) || other.importId == importId)&&(identical(other.literal, literal) || other.literal == literal)&&(identical(other.strokeCount, strokeCount) || other.strokeCount == strokeCount)&&const DeepCollectionEquality().equals(other._strokeCountMisstrokes, _strokeCountMisstrokes)&&(identical(other.grade, grade) || other.grade == grade)&&(identical(other.jlpt, jlpt) || other.jlpt == jlpt)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.codepoints, codepoints) || other.codepoints == codepoints)&&(identical(other.radicals, radicals) || other.radicals == radicals)&&(identical(other.dictRefs, dictRefs) || other.dictRefs == dictRefs)&&(identical(other.queryCodes, queryCodes) || other.queryCodes == queryCodes)&&(identical(other.readings, readings) || other.readings == readings)&&const DeepCollectionEquality().equals(other._nanori, _nanori)&&const DeepCollectionEquality().equals(other._meanings, _meanings)&&const DeepCollectionEquality().equals(other._variants, _variants)&&const DeepCollectionEquality().equals(other._radicalNames, _radicalNames));
}


@override
int get hashCode => Object.hash(runtimeType,importId,literal,strokeCount,const DeepCollectionEquality().hash(_strokeCountMisstrokes),grade,jlpt,frequency,codepoints,radicals,dictRefs,queryCodes,readings,const DeepCollectionEquality().hash(_nanori),const DeepCollectionEquality().hash(_meanings),const DeepCollectionEquality().hash(_variants),const DeepCollectionEquality().hash(_radicalNames));

@override
String toString() {
  return 'RawKanjidic(importId: $importId, literal: $literal, strokeCount: $strokeCount, strokeCountMisstrokes: $strokeCountMisstrokes, grade: $grade, jlpt: $jlpt, frequency: $frequency, codepoints: $codepoints, radicals: $radicals, dictRefs: $dictRefs, queryCodes: $queryCodes, readings: $readings, nanori: $nanori, meanings: $meanings, variants: $variants, radicalNames: $radicalNames)';
}


}

/// @nodoc
abstract mixin class _$RawKanjidicCopyWith<$Res> implements $RawKanjidicCopyWith<$Res> {
  factory _$RawKanjidicCopyWith(_RawKanjidic value, $Res Function(_RawKanjidic) _then) = __$RawKanjidicCopyWithImpl;
@override @useResult
$Res call({
 int importId, String literal, int strokeCount, List<int>? strokeCountMisstrokes, int? grade, int? jlpt, int? frequency, KanjidicCodepoints codepoints, KanjidicRadicals radicals, KanjidicDictRefs? dictRefs, KanjidicQueryCodes? queryCodes, KanjidicReadings readings, List<String>? nanori, Map<String, List<String>> meanings, List<KanjidicVariant>? variants, List<String>? radicalNames
});


@override $KanjidicCodepointsCopyWith<$Res> get codepoints;@override $KanjidicRadicalsCopyWith<$Res> get radicals;@override $KanjidicDictRefsCopyWith<$Res>? get dictRefs;@override $KanjidicQueryCodesCopyWith<$Res>? get queryCodes;@override $KanjidicReadingsCopyWith<$Res> get readings;

}
/// @nodoc
class __$RawKanjidicCopyWithImpl<$Res>
    implements _$RawKanjidicCopyWith<$Res> {
  __$RawKanjidicCopyWithImpl(this._self, this._then);

  final _RawKanjidic _self;
  final $Res Function(_RawKanjidic) _then;

/// Create a copy of RawKanjidic
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? importId = null,Object? literal = null,Object? strokeCount = null,Object? strokeCountMisstrokes = freezed,Object? grade = freezed,Object? jlpt = freezed,Object? frequency = freezed,Object? codepoints = null,Object? radicals = null,Object? dictRefs = freezed,Object? queryCodes = freezed,Object? readings = null,Object? nanori = freezed,Object? meanings = null,Object? variants = freezed,Object? radicalNames = freezed,}) {
  return _then(_RawKanjidic(
importId: null == importId ? _self.importId : importId // ignore: cast_nullable_to_non_nullable
as int,literal: null == literal ? _self.literal : literal // ignore: cast_nullable_to_non_nullable
as String,strokeCount: null == strokeCount ? _self.strokeCount : strokeCount // ignore: cast_nullable_to_non_nullable
as int,strokeCountMisstrokes: freezed == strokeCountMisstrokes ? _self._strokeCountMisstrokes : strokeCountMisstrokes // ignore: cast_nullable_to_non_nullable
as List<int>?,grade: freezed == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as int?,jlpt: freezed == jlpt ? _self.jlpt : jlpt // ignore: cast_nullable_to_non_nullable
as int?,frequency: freezed == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as int?,codepoints: null == codepoints ? _self.codepoints : codepoints // ignore: cast_nullable_to_non_nullable
as KanjidicCodepoints,radicals: null == radicals ? _self.radicals : radicals // ignore: cast_nullable_to_non_nullable
as KanjidicRadicals,dictRefs: freezed == dictRefs ? _self.dictRefs : dictRefs // ignore: cast_nullable_to_non_nullable
as KanjidicDictRefs?,queryCodes: freezed == queryCodes ? _self.queryCodes : queryCodes // ignore: cast_nullable_to_non_nullable
as KanjidicQueryCodes?,readings: null == readings ? _self.readings : readings // ignore: cast_nullable_to_non_nullable
as KanjidicReadings,nanori: freezed == nanori ? _self._nanori : nanori // ignore: cast_nullable_to_non_nullable
as List<String>?,meanings: null == meanings ? _self._meanings : meanings // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>,variants: freezed == variants ? _self._variants : variants // ignore: cast_nullable_to_non_nullable
as List<KanjidicVariant>?,radicalNames: freezed == radicalNames ? _self._radicalNames : radicalNames // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

/// Create a copy of RawKanjidic
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KanjidicCodepointsCopyWith<$Res> get codepoints {
  
  return $KanjidicCodepointsCopyWith<$Res>(_self.codepoints, (value) {
    return _then(_self.copyWith(codepoints: value));
  });
}/// Create a copy of RawKanjidic
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KanjidicRadicalsCopyWith<$Res> get radicals {
  
  return $KanjidicRadicalsCopyWith<$Res>(_self.radicals, (value) {
    return _then(_self.copyWith(radicals: value));
  });
}/// Create a copy of RawKanjidic
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KanjidicDictRefsCopyWith<$Res>? get dictRefs {
    if (_self.dictRefs == null) {
    return null;
  }

  return $KanjidicDictRefsCopyWith<$Res>(_self.dictRefs!, (value) {
    return _then(_self.copyWith(dictRefs: value));
  });
}/// Create a copy of RawKanjidic
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KanjidicQueryCodesCopyWith<$Res>? get queryCodes {
    if (_self.queryCodes == null) {
    return null;
  }

  return $KanjidicQueryCodesCopyWith<$Res>(_self.queryCodes!, (value) {
    return _then(_self.copyWith(queryCodes: value));
  });
}/// Create a copy of RawKanjidic
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KanjidicReadingsCopyWith<$Res> get readings {
  
  return $KanjidicReadingsCopyWith<$Res>(_self.readings, (value) {
    return _then(_self.copyWith(readings: value));
  });
}
}

/// @nodoc
mixin _$KanjidicCodepoints {

 String get ucs; String? get jis208; String? get jis212; String? get jis213;
/// Create a copy of KanjidicCodepoints
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KanjidicCodepointsCopyWith<KanjidicCodepoints> get copyWith => _$KanjidicCodepointsCopyWithImpl<KanjidicCodepoints>(this as KanjidicCodepoints, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KanjidicCodepoints&&(identical(other.ucs, ucs) || other.ucs == ucs)&&(identical(other.jis208, jis208) || other.jis208 == jis208)&&(identical(other.jis212, jis212) || other.jis212 == jis212)&&(identical(other.jis213, jis213) || other.jis213 == jis213));
}


@override
int get hashCode => Object.hash(runtimeType,ucs,jis208,jis212,jis213);

@override
String toString() {
  return 'KanjidicCodepoints(ucs: $ucs, jis208: $jis208, jis212: $jis212, jis213: $jis213)';
}


}

/// @nodoc
abstract mixin class $KanjidicCodepointsCopyWith<$Res>  {
  factory $KanjidicCodepointsCopyWith(KanjidicCodepoints value, $Res Function(KanjidicCodepoints) _then) = _$KanjidicCodepointsCopyWithImpl;
@useResult
$Res call({
 String ucs, String? jis208, String? jis212, String? jis213
});




}
/// @nodoc
class _$KanjidicCodepointsCopyWithImpl<$Res>
    implements $KanjidicCodepointsCopyWith<$Res> {
  _$KanjidicCodepointsCopyWithImpl(this._self, this._then);

  final KanjidicCodepoints _self;
  final $Res Function(KanjidicCodepoints) _then;

/// Create a copy of KanjidicCodepoints
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


/// Adds pattern-matching-related methods to [KanjidicCodepoints].
extension KanjidicCodepointsPatterns on KanjidicCodepoints {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KanjidicCodepoints value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KanjidicCodepoints() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KanjidicCodepoints value)  $default,){
final _that = this;
switch (_that) {
case _KanjidicCodepoints():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KanjidicCodepoints value)?  $default,){
final _that = this;
switch (_that) {
case _KanjidicCodepoints() when $default != null:
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
case _KanjidicCodepoints() when $default != null:
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
case _KanjidicCodepoints():
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
case _KanjidicCodepoints() when $default != null:
return $default(_that.ucs,_that.jis208,_that.jis212,_that.jis213);case _:
  return null;

}
}

}

/// @nodoc


class _KanjidicCodepoints implements KanjidicCodepoints {
  const _KanjidicCodepoints({required this.ucs, this.jis208, this.jis212, this.jis213});
  

@override final  String ucs;
@override final  String? jis208;
@override final  String? jis212;
@override final  String? jis213;

/// Create a copy of KanjidicCodepoints
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KanjidicCodepointsCopyWith<_KanjidicCodepoints> get copyWith => __$KanjidicCodepointsCopyWithImpl<_KanjidicCodepoints>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KanjidicCodepoints&&(identical(other.ucs, ucs) || other.ucs == ucs)&&(identical(other.jis208, jis208) || other.jis208 == jis208)&&(identical(other.jis212, jis212) || other.jis212 == jis212)&&(identical(other.jis213, jis213) || other.jis213 == jis213));
}


@override
int get hashCode => Object.hash(runtimeType,ucs,jis208,jis212,jis213);

@override
String toString() {
  return 'KanjidicCodepoints(ucs: $ucs, jis208: $jis208, jis212: $jis212, jis213: $jis213)';
}


}

/// @nodoc
abstract mixin class _$KanjidicCodepointsCopyWith<$Res> implements $KanjidicCodepointsCopyWith<$Res> {
  factory _$KanjidicCodepointsCopyWith(_KanjidicCodepoints value, $Res Function(_KanjidicCodepoints) _then) = __$KanjidicCodepointsCopyWithImpl;
@override @useResult
$Res call({
 String ucs, String? jis208, String? jis212, String? jis213
});




}
/// @nodoc
class __$KanjidicCodepointsCopyWithImpl<$Res>
    implements _$KanjidicCodepointsCopyWith<$Res> {
  __$KanjidicCodepointsCopyWithImpl(this._self, this._then);

  final _KanjidicCodepoints _self;
  final $Res Function(_KanjidicCodepoints) _then;

/// Create a copy of KanjidicCodepoints
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ucs = null,Object? jis208 = freezed,Object? jis212 = freezed,Object? jis213 = freezed,}) {
  return _then(_KanjidicCodepoints(
ucs: null == ucs ? _self.ucs : ucs // ignore: cast_nullable_to_non_nullable
as String,jis208: freezed == jis208 ? _self.jis208 : jis208 // ignore: cast_nullable_to_non_nullable
as String?,jis212: freezed == jis212 ? _self.jis212 : jis212 // ignore: cast_nullable_to_non_nullable
as String?,jis213: freezed == jis213 ? _self.jis213 : jis213 // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$KanjidicRadicals {

 int get classical; int? get nelsonC;
/// Create a copy of KanjidicRadicals
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KanjidicRadicalsCopyWith<KanjidicRadicals> get copyWith => _$KanjidicRadicalsCopyWithImpl<KanjidicRadicals>(this as KanjidicRadicals, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KanjidicRadicals&&(identical(other.classical, classical) || other.classical == classical)&&(identical(other.nelsonC, nelsonC) || other.nelsonC == nelsonC));
}


@override
int get hashCode => Object.hash(runtimeType,classical,nelsonC);

@override
String toString() {
  return 'KanjidicRadicals(classical: $classical, nelsonC: $nelsonC)';
}


}

/// @nodoc
abstract mixin class $KanjidicRadicalsCopyWith<$Res>  {
  factory $KanjidicRadicalsCopyWith(KanjidicRadicals value, $Res Function(KanjidicRadicals) _then) = _$KanjidicRadicalsCopyWithImpl;
@useResult
$Res call({
 int classical, int? nelsonC
});




}
/// @nodoc
class _$KanjidicRadicalsCopyWithImpl<$Res>
    implements $KanjidicRadicalsCopyWith<$Res> {
  _$KanjidicRadicalsCopyWithImpl(this._self, this._then);

  final KanjidicRadicals _self;
  final $Res Function(KanjidicRadicals) _then;

/// Create a copy of KanjidicRadicals
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? classical = null,Object? nelsonC = freezed,}) {
  return _then(_self.copyWith(
classical: null == classical ? _self.classical : classical // ignore: cast_nullable_to_non_nullable
as int,nelsonC: freezed == nelsonC ? _self.nelsonC : nelsonC // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [KanjidicRadicals].
extension KanjidicRadicalsPatterns on KanjidicRadicals {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KanjidicRadicals value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KanjidicRadicals() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KanjidicRadicals value)  $default,){
final _that = this;
switch (_that) {
case _KanjidicRadicals():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KanjidicRadicals value)?  $default,){
final _that = this;
switch (_that) {
case _KanjidicRadicals() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int classical,  int? nelsonC)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KanjidicRadicals() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int classical,  int? nelsonC)  $default,) {final _that = this;
switch (_that) {
case _KanjidicRadicals():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int classical,  int? nelsonC)?  $default,) {final _that = this;
switch (_that) {
case _KanjidicRadicals() when $default != null:
return $default(_that.classical,_that.nelsonC);case _:
  return null;

}
}

}

/// @nodoc


class _KanjidicRadicals implements KanjidicRadicals {
  const _KanjidicRadicals({required this.classical, this.nelsonC});
  

@override final  int classical;
@override final  int? nelsonC;

/// Create a copy of KanjidicRadicals
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KanjidicRadicalsCopyWith<_KanjidicRadicals> get copyWith => __$KanjidicRadicalsCopyWithImpl<_KanjidicRadicals>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KanjidicRadicals&&(identical(other.classical, classical) || other.classical == classical)&&(identical(other.nelsonC, nelsonC) || other.nelsonC == nelsonC));
}


@override
int get hashCode => Object.hash(runtimeType,classical,nelsonC);

@override
String toString() {
  return 'KanjidicRadicals(classical: $classical, nelsonC: $nelsonC)';
}


}

/// @nodoc
abstract mixin class _$KanjidicRadicalsCopyWith<$Res> implements $KanjidicRadicalsCopyWith<$Res> {
  factory _$KanjidicRadicalsCopyWith(_KanjidicRadicals value, $Res Function(_KanjidicRadicals) _then) = __$KanjidicRadicalsCopyWithImpl;
@override @useResult
$Res call({
 int classical, int? nelsonC
});




}
/// @nodoc
class __$KanjidicRadicalsCopyWithImpl<$Res>
    implements _$KanjidicRadicalsCopyWith<$Res> {
  __$KanjidicRadicalsCopyWithImpl(this._self, this._then);

  final _KanjidicRadicals _self;
  final $Res Function(_KanjidicRadicals) _then;

/// Create a copy of KanjidicRadicals
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? classical = null,Object? nelsonC = freezed,}) {
  return _then(_KanjidicRadicals(
classical: null == classical ? _self.classical : classical // ignore: cast_nullable_to_non_nullable
as int,nelsonC: freezed == nelsonC ? _self.nelsonC : nelsonC // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$KanjidicDictRefs {

 String? get nelsonC; String? get nelsonN; String? get halpernNjecd; String? get halpernKkd; String? get halpernKkld; String? get halpernKkld2ed; String? get heisig; String? get heisig6; String? get gakken; String? get oneillNames; String? get oneillKk; KanjidicMoroRef? get moro; String? get henshall; String? get shKk; String? get shKk2; String? get jfCards; String? get tuttCards; String? get kanjiInContext; String? get kodanshaCompact; String? get skip; String? get busyPeople;
/// Create a copy of KanjidicDictRefs
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KanjidicDictRefsCopyWith<KanjidicDictRefs> get copyWith => _$KanjidicDictRefsCopyWithImpl<KanjidicDictRefs>(this as KanjidicDictRefs, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KanjidicDictRefs&&(identical(other.nelsonC, nelsonC) || other.nelsonC == nelsonC)&&(identical(other.nelsonN, nelsonN) || other.nelsonN == nelsonN)&&(identical(other.halpernNjecd, halpernNjecd) || other.halpernNjecd == halpernNjecd)&&(identical(other.halpernKkd, halpernKkd) || other.halpernKkd == halpernKkd)&&(identical(other.halpernKkld, halpernKkld) || other.halpernKkld == halpernKkld)&&(identical(other.halpernKkld2ed, halpernKkld2ed) || other.halpernKkld2ed == halpernKkld2ed)&&(identical(other.heisig, heisig) || other.heisig == heisig)&&(identical(other.heisig6, heisig6) || other.heisig6 == heisig6)&&(identical(other.gakken, gakken) || other.gakken == gakken)&&(identical(other.oneillNames, oneillNames) || other.oneillNames == oneillNames)&&(identical(other.oneillKk, oneillKk) || other.oneillKk == oneillKk)&&(identical(other.moro, moro) || other.moro == moro)&&(identical(other.henshall, henshall) || other.henshall == henshall)&&(identical(other.shKk, shKk) || other.shKk == shKk)&&(identical(other.shKk2, shKk2) || other.shKk2 == shKk2)&&(identical(other.jfCards, jfCards) || other.jfCards == jfCards)&&(identical(other.tuttCards, tuttCards) || other.tuttCards == tuttCards)&&(identical(other.kanjiInContext, kanjiInContext) || other.kanjiInContext == kanjiInContext)&&(identical(other.kodanshaCompact, kodanshaCompact) || other.kodanshaCompact == kodanshaCompact)&&(identical(other.skip, skip) || other.skip == skip)&&(identical(other.busyPeople, busyPeople) || other.busyPeople == busyPeople));
}


@override
int get hashCode => Object.hashAll([runtimeType,nelsonC,nelsonN,halpernNjecd,halpernKkd,halpernKkld,halpernKkld2ed,heisig,heisig6,gakken,oneillNames,oneillKk,moro,henshall,shKk,shKk2,jfCards,tuttCards,kanjiInContext,kodanshaCompact,skip,busyPeople]);

@override
String toString() {
  return 'KanjidicDictRefs(nelsonC: $nelsonC, nelsonN: $nelsonN, halpernNjecd: $halpernNjecd, halpernKkd: $halpernKkd, halpernKkld: $halpernKkld, halpernKkld2ed: $halpernKkld2ed, heisig: $heisig, heisig6: $heisig6, gakken: $gakken, oneillNames: $oneillNames, oneillKk: $oneillKk, moro: $moro, henshall: $henshall, shKk: $shKk, shKk2: $shKk2, jfCards: $jfCards, tuttCards: $tuttCards, kanjiInContext: $kanjiInContext, kodanshaCompact: $kodanshaCompact, skip: $skip, busyPeople: $busyPeople)';
}


}

/// @nodoc
abstract mixin class $KanjidicDictRefsCopyWith<$Res>  {
  factory $KanjidicDictRefsCopyWith(KanjidicDictRefs value, $Res Function(KanjidicDictRefs) _then) = _$KanjidicDictRefsCopyWithImpl;
@useResult
$Res call({
 String? nelsonC, String? nelsonN, String? halpernNjecd, String? halpernKkd, String? halpernKkld, String? halpernKkld2ed, String? heisig, String? heisig6, String? gakken, String? oneillNames, String? oneillKk, KanjidicMoroRef? moro, String? henshall, String? shKk, String? shKk2, String? jfCards, String? tuttCards, String? kanjiInContext, String? kodanshaCompact, String? skip, String? busyPeople
});


$KanjidicMoroRefCopyWith<$Res>? get moro;

}
/// @nodoc
class _$KanjidicDictRefsCopyWithImpl<$Res>
    implements $KanjidicDictRefsCopyWith<$Res> {
  _$KanjidicDictRefsCopyWithImpl(this._self, this._then);

  final KanjidicDictRefs _self;
  final $Res Function(KanjidicDictRefs) _then;

/// Create a copy of KanjidicDictRefs
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
as KanjidicMoroRef?,henshall: freezed == henshall ? _self.henshall : henshall // ignore: cast_nullable_to_non_nullable
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
/// Create a copy of KanjidicDictRefs
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KanjidicMoroRefCopyWith<$Res>? get moro {
    if (_self.moro == null) {
    return null;
  }

  return $KanjidicMoroRefCopyWith<$Res>(_self.moro!, (value) {
    return _then(_self.copyWith(moro: value));
  });
}
}


/// Adds pattern-matching-related methods to [KanjidicDictRefs].
extension KanjidicDictRefsPatterns on KanjidicDictRefs {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KanjidicDictRefs value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KanjidicDictRefs() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KanjidicDictRefs value)  $default,){
final _that = this;
switch (_that) {
case _KanjidicDictRefs():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KanjidicDictRefs value)?  $default,){
final _that = this;
switch (_that) {
case _KanjidicDictRefs() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? nelsonC,  String? nelsonN,  String? halpernNjecd,  String? halpernKkd,  String? halpernKkld,  String? halpernKkld2ed,  String? heisig,  String? heisig6,  String? gakken,  String? oneillNames,  String? oneillKk,  KanjidicMoroRef? moro,  String? henshall,  String? shKk,  String? shKk2,  String? jfCards,  String? tuttCards,  String? kanjiInContext,  String? kodanshaCompact,  String? skip,  String? busyPeople)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KanjidicDictRefs() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? nelsonC,  String? nelsonN,  String? halpernNjecd,  String? halpernKkd,  String? halpernKkld,  String? halpernKkld2ed,  String? heisig,  String? heisig6,  String? gakken,  String? oneillNames,  String? oneillKk,  KanjidicMoroRef? moro,  String? henshall,  String? shKk,  String? shKk2,  String? jfCards,  String? tuttCards,  String? kanjiInContext,  String? kodanshaCompact,  String? skip,  String? busyPeople)  $default,) {final _that = this;
switch (_that) {
case _KanjidicDictRefs():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? nelsonC,  String? nelsonN,  String? halpernNjecd,  String? halpernKkd,  String? halpernKkld,  String? halpernKkld2ed,  String? heisig,  String? heisig6,  String? gakken,  String? oneillNames,  String? oneillKk,  KanjidicMoroRef? moro,  String? henshall,  String? shKk,  String? shKk2,  String? jfCards,  String? tuttCards,  String? kanjiInContext,  String? kodanshaCompact,  String? skip,  String? busyPeople)?  $default,) {final _that = this;
switch (_that) {
case _KanjidicDictRefs() when $default != null:
return $default(_that.nelsonC,_that.nelsonN,_that.halpernNjecd,_that.halpernKkd,_that.halpernKkld,_that.halpernKkld2ed,_that.heisig,_that.heisig6,_that.gakken,_that.oneillNames,_that.oneillKk,_that.moro,_that.henshall,_that.shKk,_that.shKk2,_that.jfCards,_that.tuttCards,_that.kanjiInContext,_that.kodanshaCompact,_that.skip,_that.busyPeople);case _:
  return null;

}
}

}

/// @nodoc


class _KanjidicDictRefs implements KanjidicDictRefs {
  const _KanjidicDictRefs({this.nelsonC, this.nelsonN, this.halpernNjecd, this.halpernKkd, this.halpernKkld, this.halpernKkld2ed, this.heisig, this.heisig6, this.gakken, this.oneillNames, this.oneillKk, this.moro, this.henshall, this.shKk, this.shKk2, this.jfCards, this.tuttCards, this.kanjiInContext, this.kodanshaCompact, this.skip, this.busyPeople});
  

@override final  String? nelsonC;
@override final  String? nelsonN;
@override final  String? halpernNjecd;
@override final  String? halpernKkd;
@override final  String? halpernKkld;
@override final  String? halpernKkld2ed;
@override final  String? heisig;
@override final  String? heisig6;
@override final  String? gakken;
@override final  String? oneillNames;
@override final  String? oneillKk;
@override final  KanjidicMoroRef? moro;
@override final  String? henshall;
@override final  String? shKk;
@override final  String? shKk2;
@override final  String? jfCards;
@override final  String? tuttCards;
@override final  String? kanjiInContext;
@override final  String? kodanshaCompact;
@override final  String? skip;
@override final  String? busyPeople;

/// Create a copy of KanjidicDictRefs
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KanjidicDictRefsCopyWith<_KanjidicDictRefs> get copyWith => __$KanjidicDictRefsCopyWithImpl<_KanjidicDictRefs>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KanjidicDictRefs&&(identical(other.nelsonC, nelsonC) || other.nelsonC == nelsonC)&&(identical(other.nelsonN, nelsonN) || other.nelsonN == nelsonN)&&(identical(other.halpernNjecd, halpernNjecd) || other.halpernNjecd == halpernNjecd)&&(identical(other.halpernKkd, halpernKkd) || other.halpernKkd == halpernKkd)&&(identical(other.halpernKkld, halpernKkld) || other.halpernKkld == halpernKkld)&&(identical(other.halpernKkld2ed, halpernKkld2ed) || other.halpernKkld2ed == halpernKkld2ed)&&(identical(other.heisig, heisig) || other.heisig == heisig)&&(identical(other.heisig6, heisig6) || other.heisig6 == heisig6)&&(identical(other.gakken, gakken) || other.gakken == gakken)&&(identical(other.oneillNames, oneillNames) || other.oneillNames == oneillNames)&&(identical(other.oneillKk, oneillKk) || other.oneillKk == oneillKk)&&(identical(other.moro, moro) || other.moro == moro)&&(identical(other.henshall, henshall) || other.henshall == henshall)&&(identical(other.shKk, shKk) || other.shKk == shKk)&&(identical(other.shKk2, shKk2) || other.shKk2 == shKk2)&&(identical(other.jfCards, jfCards) || other.jfCards == jfCards)&&(identical(other.tuttCards, tuttCards) || other.tuttCards == tuttCards)&&(identical(other.kanjiInContext, kanjiInContext) || other.kanjiInContext == kanjiInContext)&&(identical(other.kodanshaCompact, kodanshaCompact) || other.kodanshaCompact == kodanshaCompact)&&(identical(other.skip, skip) || other.skip == skip)&&(identical(other.busyPeople, busyPeople) || other.busyPeople == busyPeople));
}


@override
int get hashCode => Object.hashAll([runtimeType,nelsonC,nelsonN,halpernNjecd,halpernKkd,halpernKkld,halpernKkld2ed,heisig,heisig6,gakken,oneillNames,oneillKk,moro,henshall,shKk,shKk2,jfCards,tuttCards,kanjiInContext,kodanshaCompact,skip,busyPeople]);

@override
String toString() {
  return 'KanjidicDictRefs(nelsonC: $nelsonC, nelsonN: $nelsonN, halpernNjecd: $halpernNjecd, halpernKkd: $halpernKkd, halpernKkld: $halpernKkld, halpernKkld2ed: $halpernKkld2ed, heisig: $heisig, heisig6: $heisig6, gakken: $gakken, oneillNames: $oneillNames, oneillKk: $oneillKk, moro: $moro, henshall: $henshall, shKk: $shKk, shKk2: $shKk2, jfCards: $jfCards, tuttCards: $tuttCards, kanjiInContext: $kanjiInContext, kodanshaCompact: $kodanshaCompact, skip: $skip, busyPeople: $busyPeople)';
}


}

/// @nodoc
abstract mixin class _$KanjidicDictRefsCopyWith<$Res> implements $KanjidicDictRefsCopyWith<$Res> {
  factory _$KanjidicDictRefsCopyWith(_KanjidicDictRefs value, $Res Function(_KanjidicDictRefs) _then) = __$KanjidicDictRefsCopyWithImpl;
@override @useResult
$Res call({
 String? nelsonC, String? nelsonN, String? halpernNjecd, String? halpernKkd, String? halpernKkld, String? halpernKkld2ed, String? heisig, String? heisig6, String? gakken, String? oneillNames, String? oneillKk, KanjidicMoroRef? moro, String? henshall, String? shKk, String? shKk2, String? jfCards, String? tuttCards, String? kanjiInContext, String? kodanshaCompact, String? skip, String? busyPeople
});


@override $KanjidicMoroRefCopyWith<$Res>? get moro;

}
/// @nodoc
class __$KanjidicDictRefsCopyWithImpl<$Res>
    implements _$KanjidicDictRefsCopyWith<$Res> {
  __$KanjidicDictRefsCopyWithImpl(this._self, this._then);

  final _KanjidicDictRefs _self;
  final $Res Function(_KanjidicDictRefs) _then;

/// Create a copy of KanjidicDictRefs
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nelsonC = freezed,Object? nelsonN = freezed,Object? halpernNjecd = freezed,Object? halpernKkd = freezed,Object? halpernKkld = freezed,Object? halpernKkld2ed = freezed,Object? heisig = freezed,Object? heisig6 = freezed,Object? gakken = freezed,Object? oneillNames = freezed,Object? oneillKk = freezed,Object? moro = freezed,Object? henshall = freezed,Object? shKk = freezed,Object? shKk2 = freezed,Object? jfCards = freezed,Object? tuttCards = freezed,Object? kanjiInContext = freezed,Object? kodanshaCompact = freezed,Object? skip = freezed,Object? busyPeople = freezed,}) {
  return _then(_KanjidicDictRefs(
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
as KanjidicMoroRef?,henshall: freezed == henshall ? _self.henshall : henshall // ignore: cast_nullable_to_non_nullable
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

/// Create a copy of KanjidicDictRefs
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KanjidicMoroRefCopyWith<$Res>? get moro {
    if (_self.moro == null) {
    return null;
  }

  return $KanjidicMoroRefCopyWith<$Res>(_self.moro!, (value) {
    return _then(_self.copyWith(moro: value));
  });
}
}

/// @nodoc
mixin _$KanjidicMoroRef {

 String get volume; String get page;
/// Create a copy of KanjidicMoroRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KanjidicMoroRefCopyWith<KanjidicMoroRef> get copyWith => _$KanjidicMoroRefCopyWithImpl<KanjidicMoroRef>(this as KanjidicMoroRef, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KanjidicMoroRef&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.page, page) || other.page == page));
}


@override
int get hashCode => Object.hash(runtimeType,volume,page);

@override
String toString() {
  return 'KanjidicMoroRef(volume: $volume, page: $page)';
}


}

/// @nodoc
abstract mixin class $KanjidicMoroRefCopyWith<$Res>  {
  factory $KanjidicMoroRefCopyWith(KanjidicMoroRef value, $Res Function(KanjidicMoroRef) _then) = _$KanjidicMoroRefCopyWithImpl;
@useResult
$Res call({
 String volume, String page
});




}
/// @nodoc
class _$KanjidicMoroRefCopyWithImpl<$Res>
    implements $KanjidicMoroRefCopyWith<$Res> {
  _$KanjidicMoroRefCopyWithImpl(this._self, this._then);

  final KanjidicMoroRef _self;
  final $Res Function(KanjidicMoroRef) _then;

/// Create a copy of KanjidicMoroRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? volume = null,Object? page = null,}) {
  return _then(_self.copyWith(
volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as String,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [KanjidicMoroRef].
extension KanjidicMoroRefPatterns on KanjidicMoroRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KanjidicMoroRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KanjidicMoroRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KanjidicMoroRef value)  $default,){
final _that = this;
switch (_that) {
case _KanjidicMoroRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KanjidicMoroRef value)?  $default,){
final _that = this;
switch (_that) {
case _KanjidicMoroRef() when $default != null:
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
case _KanjidicMoroRef() when $default != null:
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
case _KanjidicMoroRef():
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
case _KanjidicMoroRef() when $default != null:
return $default(_that.volume,_that.page);case _:
  return null;

}
}

}

/// @nodoc


class _KanjidicMoroRef implements KanjidicMoroRef {
  const _KanjidicMoroRef({required this.volume, required this.page});
  

@override final  String volume;
@override final  String page;

/// Create a copy of KanjidicMoroRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KanjidicMoroRefCopyWith<_KanjidicMoroRef> get copyWith => __$KanjidicMoroRefCopyWithImpl<_KanjidicMoroRef>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KanjidicMoroRef&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.page, page) || other.page == page));
}


@override
int get hashCode => Object.hash(runtimeType,volume,page);

@override
String toString() {
  return 'KanjidicMoroRef(volume: $volume, page: $page)';
}


}

/// @nodoc
abstract mixin class _$KanjidicMoroRefCopyWith<$Res> implements $KanjidicMoroRefCopyWith<$Res> {
  factory _$KanjidicMoroRefCopyWith(_KanjidicMoroRef value, $Res Function(_KanjidicMoroRef) _then) = __$KanjidicMoroRefCopyWithImpl;
@override @useResult
$Res call({
 String volume, String page
});




}
/// @nodoc
class __$KanjidicMoroRefCopyWithImpl<$Res>
    implements _$KanjidicMoroRefCopyWith<$Res> {
  __$KanjidicMoroRefCopyWithImpl(this._self, this._then);

  final _KanjidicMoroRef _self;
  final $Res Function(_KanjidicMoroRef) _then;

/// Create a copy of KanjidicMoroRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? volume = null,Object? page = null,}) {
  return _then(_KanjidicMoroRef(
volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as String,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$KanjidicQueryCodes {

 String? get skip; String? get fourCorner; String? get shDesc; String? get deroo; List<KanjidicMisclass>? get misclass;
/// Create a copy of KanjidicQueryCodes
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KanjidicQueryCodesCopyWith<KanjidicQueryCodes> get copyWith => _$KanjidicQueryCodesCopyWithImpl<KanjidicQueryCodes>(this as KanjidicQueryCodes, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KanjidicQueryCodes&&(identical(other.skip, skip) || other.skip == skip)&&(identical(other.fourCorner, fourCorner) || other.fourCorner == fourCorner)&&(identical(other.shDesc, shDesc) || other.shDesc == shDesc)&&(identical(other.deroo, deroo) || other.deroo == deroo)&&const DeepCollectionEquality().equals(other.misclass, misclass));
}


@override
int get hashCode => Object.hash(runtimeType,skip,fourCorner,shDesc,deroo,const DeepCollectionEquality().hash(misclass));

@override
String toString() {
  return 'KanjidicQueryCodes(skip: $skip, fourCorner: $fourCorner, shDesc: $shDesc, deroo: $deroo, misclass: $misclass)';
}


}

/// @nodoc
abstract mixin class $KanjidicQueryCodesCopyWith<$Res>  {
  factory $KanjidicQueryCodesCopyWith(KanjidicQueryCodes value, $Res Function(KanjidicQueryCodes) _then) = _$KanjidicQueryCodesCopyWithImpl;
@useResult
$Res call({
 String? skip, String? fourCorner, String? shDesc, String? deroo, List<KanjidicMisclass>? misclass
});




}
/// @nodoc
class _$KanjidicQueryCodesCopyWithImpl<$Res>
    implements $KanjidicQueryCodesCopyWith<$Res> {
  _$KanjidicQueryCodesCopyWithImpl(this._self, this._then);

  final KanjidicQueryCodes _self;
  final $Res Function(KanjidicQueryCodes) _then;

/// Create a copy of KanjidicQueryCodes
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? skip = freezed,Object? fourCorner = freezed,Object? shDesc = freezed,Object? deroo = freezed,Object? misclass = freezed,}) {
  return _then(_self.copyWith(
skip: freezed == skip ? _self.skip : skip // ignore: cast_nullable_to_non_nullable
as String?,fourCorner: freezed == fourCorner ? _self.fourCorner : fourCorner // ignore: cast_nullable_to_non_nullable
as String?,shDesc: freezed == shDesc ? _self.shDesc : shDesc // ignore: cast_nullable_to_non_nullable
as String?,deroo: freezed == deroo ? _self.deroo : deroo // ignore: cast_nullable_to_non_nullable
as String?,misclass: freezed == misclass ? _self.misclass : misclass // ignore: cast_nullable_to_non_nullable
as List<KanjidicMisclass>?,
  ));
}

}


/// Adds pattern-matching-related methods to [KanjidicQueryCodes].
extension KanjidicQueryCodesPatterns on KanjidicQueryCodes {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KanjidicQueryCodes value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KanjidicQueryCodes() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KanjidicQueryCodes value)  $default,){
final _that = this;
switch (_that) {
case _KanjidicQueryCodes():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KanjidicQueryCodes value)?  $default,){
final _that = this;
switch (_that) {
case _KanjidicQueryCodes() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? skip,  String? fourCorner,  String? shDesc,  String? deroo,  List<KanjidicMisclass>? misclass)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KanjidicQueryCodes() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? skip,  String? fourCorner,  String? shDesc,  String? deroo,  List<KanjidicMisclass>? misclass)  $default,) {final _that = this;
switch (_that) {
case _KanjidicQueryCodes():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? skip,  String? fourCorner,  String? shDesc,  String? deroo,  List<KanjidicMisclass>? misclass)?  $default,) {final _that = this;
switch (_that) {
case _KanjidicQueryCodes() when $default != null:
return $default(_that.skip,_that.fourCorner,_that.shDesc,_that.deroo,_that.misclass);case _:
  return null;

}
}

}

/// @nodoc


class _KanjidicQueryCodes implements KanjidicQueryCodes {
  const _KanjidicQueryCodes({this.skip, this.fourCorner, this.shDesc, this.deroo, final  List<KanjidicMisclass>? misclass}): _misclass = misclass;
  

@override final  String? skip;
@override final  String? fourCorner;
@override final  String? shDesc;
@override final  String? deroo;
 final  List<KanjidicMisclass>? _misclass;
@override List<KanjidicMisclass>? get misclass {
  final value = _misclass;
  if (value == null) return null;
  if (_misclass is EqualUnmodifiableListView) return _misclass;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of KanjidicQueryCodes
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KanjidicQueryCodesCopyWith<_KanjidicQueryCodes> get copyWith => __$KanjidicQueryCodesCopyWithImpl<_KanjidicQueryCodes>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KanjidicQueryCodes&&(identical(other.skip, skip) || other.skip == skip)&&(identical(other.fourCorner, fourCorner) || other.fourCorner == fourCorner)&&(identical(other.shDesc, shDesc) || other.shDesc == shDesc)&&(identical(other.deroo, deroo) || other.deroo == deroo)&&const DeepCollectionEquality().equals(other._misclass, _misclass));
}


@override
int get hashCode => Object.hash(runtimeType,skip,fourCorner,shDesc,deroo,const DeepCollectionEquality().hash(_misclass));

@override
String toString() {
  return 'KanjidicQueryCodes(skip: $skip, fourCorner: $fourCorner, shDesc: $shDesc, deroo: $deroo, misclass: $misclass)';
}


}

/// @nodoc
abstract mixin class _$KanjidicQueryCodesCopyWith<$Res> implements $KanjidicQueryCodesCopyWith<$Res> {
  factory _$KanjidicQueryCodesCopyWith(_KanjidicQueryCodes value, $Res Function(_KanjidicQueryCodes) _then) = __$KanjidicQueryCodesCopyWithImpl;
@override @useResult
$Res call({
 String? skip, String? fourCorner, String? shDesc, String? deroo, List<KanjidicMisclass>? misclass
});




}
/// @nodoc
class __$KanjidicQueryCodesCopyWithImpl<$Res>
    implements _$KanjidicQueryCodesCopyWith<$Res> {
  __$KanjidicQueryCodesCopyWithImpl(this._self, this._then);

  final _KanjidicQueryCodes _self;
  final $Res Function(_KanjidicQueryCodes) _then;

/// Create a copy of KanjidicQueryCodes
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? skip = freezed,Object? fourCorner = freezed,Object? shDesc = freezed,Object? deroo = freezed,Object? misclass = freezed,}) {
  return _then(_KanjidicQueryCodes(
skip: freezed == skip ? _self.skip : skip // ignore: cast_nullable_to_non_nullable
as String?,fourCorner: freezed == fourCorner ? _self.fourCorner : fourCorner // ignore: cast_nullable_to_non_nullable
as String?,shDesc: freezed == shDesc ? _self.shDesc : shDesc // ignore: cast_nullable_to_non_nullable
as String?,deroo: freezed == deroo ? _self.deroo : deroo // ignore: cast_nullable_to_non_nullable
as String?,misclass: freezed == misclass ? _self._misclass : misclass // ignore: cast_nullable_to_non_nullable
as List<KanjidicMisclass>?,
  ));
}


}

/// @nodoc
mixin _$KanjidicMisclass {

 String get type; String get value;
/// Create a copy of KanjidicMisclass
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KanjidicMisclassCopyWith<KanjidicMisclass> get copyWith => _$KanjidicMisclassCopyWithImpl<KanjidicMisclass>(this as KanjidicMisclass, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KanjidicMisclass&&(identical(other.type, type) || other.type == type)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,type,value);

@override
String toString() {
  return 'KanjidicMisclass(type: $type, value: $value)';
}


}

/// @nodoc
abstract mixin class $KanjidicMisclassCopyWith<$Res>  {
  factory $KanjidicMisclassCopyWith(KanjidicMisclass value, $Res Function(KanjidicMisclass) _then) = _$KanjidicMisclassCopyWithImpl;
@useResult
$Res call({
 String type, String value
});




}
/// @nodoc
class _$KanjidicMisclassCopyWithImpl<$Res>
    implements $KanjidicMisclassCopyWith<$Res> {
  _$KanjidicMisclassCopyWithImpl(this._self, this._then);

  final KanjidicMisclass _self;
  final $Res Function(KanjidicMisclass) _then;

/// Create a copy of KanjidicMisclass
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? value = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [KanjidicMisclass].
extension KanjidicMisclassPatterns on KanjidicMisclass {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KanjidicMisclass value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KanjidicMisclass() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KanjidicMisclass value)  $default,){
final _that = this;
switch (_that) {
case _KanjidicMisclass():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KanjidicMisclass value)?  $default,){
final _that = this;
switch (_that) {
case _KanjidicMisclass() when $default != null:
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
case _KanjidicMisclass() when $default != null:
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
case _KanjidicMisclass():
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
case _KanjidicMisclass() when $default != null:
return $default(_that.type,_that.value);case _:
  return null;

}
}

}

/// @nodoc


class _KanjidicMisclass implements KanjidicMisclass {
  const _KanjidicMisclass({required this.type, required this.value});
  

@override final  String type;
@override final  String value;

/// Create a copy of KanjidicMisclass
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KanjidicMisclassCopyWith<_KanjidicMisclass> get copyWith => __$KanjidicMisclassCopyWithImpl<_KanjidicMisclass>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KanjidicMisclass&&(identical(other.type, type) || other.type == type)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,type,value);

@override
String toString() {
  return 'KanjidicMisclass(type: $type, value: $value)';
}


}

/// @nodoc
abstract mixin class _$KanjidicMisclassCopyWith<$Res> implements $KanjidicMisclassCopyWith<$Res> {
  factory _$KanjidicMisclassCopyWith(_KanjidicMisclass value, $Res Function(_KanjidicMisclass) _then) = __$KanjidicMisclassCopyWithImpl;
@override @useResult
$Res call({
 String type, String value
});




}
/// @nodoc
class __$KanjidicMisclassCopyWithImpl<$Res>
    implements _$KanjidicMisclassCopyWith<$Res> {
  __$KanjidicMisclassCopyWithImpl(this._self, this._then);

  final _KanjidicMisclass _self;
  final $Res Function(_KanjidicMisclass) _then;

/// Create a copy of KanjidicMisclass
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? value = null,}) {
  return _then(_KanjidicMisclass(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$KanjidicVariant {

 String get varType; String get value;
/// Create a copy of KanjidicVariant
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KanjidicVariantCopyWith<KanjidicVariant> get copyWith => _$KanjidicVariantCopyWithImpl<KanjidicVariant>(this as KanjidicVariant, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KanjidicVariant&&(identical(other.varType, varType) || other.varType == varType)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,varType,value);

@override
String toString() {
  return 'KanjidicVariant(varType: $varType, value: $value)';
}


}

/// @nodoc
abstract mixin class $KanjidicVariantCopyWith<$Res>  {
  factory $KanjidicVariantCopyWith(KanjidicVariant value, $Res Function(KanjidicVariant) _then) = _$KanjidicVariantCopyWithImpl;
@useResult
$Res call({
 String varType, String value
});




}
/// @nodoc
class _$KanjidicVariantCopyWithImpl<$Res>
    implements $KanjidicVariantCopyWith<$Res> {
  _$KanjidicVariantCopyWithImpl(this._self, this._then);

  final KanjidicVariant _self;
  final $Res Function(KanjidicVariant) _then;

/// Create a copy of KanjidicVariant
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? varType = null,Object? value = null,}) {
  return _then(_self.copyWith(
varType: null == varType ? _self.varType : varType // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [KanjidicVariant].
extension KanjidicVariantPatterns on KanjidicVariant {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KanjidicVariant value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KanjidicVariant() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KanjidicVariant value)  $default,){
final _that = this;
switch (_that) {
case _KanjidicVariant():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KanjidicVariant value)?  $default,){
final _that = this;
switch (_that) {
case _KanjidicVariant() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String varType,  String value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KanjidicVariant() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String varType,  String value)  $default,) {final _that = this;
switch (_that) {
case _KanjidicVariant():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String varType,  String value)?  $default,) {final _that = this;
switch (_that) {
case _KanjidicVariant() when $default != null:
return $default(_that.varType,_that.value);case _:
  return null;

}
}

}

/// @nodoc


class _KanjidicVariant implements KanjidicVariant {
  const _KanjidicVariant({required this.varType, required this.value});
  

@override final  String varType;
@override final  String value;

/// Create a copy of KanjidicVariant
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KanjidicVariantCopyWith<_KanjidicVariant> get copyWith => __$KanjidicVariantCopyWithImpl<_KanjidicVariant>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KanjidicVariant&&(identical(other.varType, varType) || other.varType == varType)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,varType,value);

@override
String toString() {
  return 'KanjidicVariant(varType: $varType, value: $value)';
}


}

/// @nodoc
abstract mixin class _$KanjidicVariantCopyWith<$Res> implements $KanjidicVariantCopyWith<$Res> {
  factory _$KanjidicVariantCopyWith(_KanjidicVariant value, $Res Function(_KanjidicVariant) _then) = __$KanjidicVariantCopyWithImpl;
@override @useResult
$Res call({
 String varType, String value
});




}
/// @nodoc
class __$KanjidicVariantCopyWithImpl<$Res>
    implements _$KanjidicVariantCopyWith<$Res> {
  __$KanjidicVariantCopyWithImpl(this._self, this._then);

  final _KanjidicVariant _self;
  final $Res Function(_KanjidicVariant) _then;

/// Create a copy of KanjidicVariant
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? varType = null,Object? value = null,}) {
  return _then(_KanjidicVariant(
varType: null == varType ? _self.varType : varType // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$KanjidicReadings {

 List<String> get jaOn; List<String> get jaKun; List<String>? get pinyin; List<String>? get koreanR; List<String>? get koreanH;
/// Create a copy of KanjidicReadings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KanjidicReadingsCopyWith<KanjidicReadings> get copyWith => _$KanjidicReadingsCopyWithImpl<KanjidicReadings>(this as KanjidicReadings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KanjidicReadings&&const DeepCollectionEquality().equals(other.jaOn, jaOn)&&const DeepCollectionEquality().equals(other.jaKun, jaKun)&&const DeepCollectionEquality().equals(other.pinyin, pinyin)&&const DeepCollectionEquality().equals(other.koreanR, koreanR)&&const DeepCollectionEquality().equals(other.koreanH, koreanH));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(jaOn),const DeepCollectionEquality().hash(jaKun),const DeepCollectionEquality().hash(pinyin),const DeepCollectionEquality().hash(koreanR),const DeepCollectionEquality().hash(koreanH));

@override
String toString() {
  return 'KanjidicReadings(jaOn: $jaOn, jaKun: $jaKun, pinyin: $pinyin, koreanR: $koreanR, koreanH: $koreanH)';
}


}

/// @nodoc
abstract mixin class $KanjidicReadingsCopyWith<$Res>  {
  factory $KanjidicReadingsCopyWith(KanjidicReadings value, $Res Function(KanjidicReadings) _then) = _$KanjidicReadingsCopyWithImpl;
@useResult
$Res call({
 List<String> jaOn, List<String> jaKun, List<String>? pinyin, List<String>? koreanR, List<String>? koreanH
});




}
/// @nodoc
class _$KanjidicReadingsCopyWithImpl<$Res>
    implements $KanjidicReadingsCopyWith<$Res> {
  _$KanjidicReadingsCopyWithImpl(this._self, this._then);

  final KanjidicReadings _self;
  final $Res Function(KanjidicReadings) _then;

/// Create a copy of KanjidicReadings
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


/// Adds pattern-matching-related methods to [KanjidicReadings].
extension KanjidicReadingsPatterns on KanjidicReadings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KanjidicReadings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KanjidicReadings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KanjidicReadings value)  $default,){
final _that = this;
switch (_that) {
case _KanjidicReadings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KanjidicReadings value)?  $default,){
final _that = this;
switch (_that) {
case _KanjidicReadings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> jaOn,  List<String> jaKun,  List<String>? pinyin,  List<String>? koreanR,  List<String>? koreanH)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KanjidicReadings() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> jaOn,  List<String> jaKun,  List<String>? pinyin,  List<String>? koreanR,  List<String>? koreanH)  $default,) {final _that = this;
switch (_that) {
case _KanjidicReadings():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> jaOn,  List<String> jaKun,  List<String>? pinyin,  List<String>? koreanR,  List<String>? koreanH)?  $default,) {final _that = this;
switch (_that) {
case _KanjidicReadings() when $default != null:
return $default(_that.jaOn,_that.jaKun,_that.pinyin,_that.koreanR,_that.koreanH);case _:
  return null;

}
}

}

/// @nodoc


class _KanjidicReadings implements KanjidicReadings {
  const _KanjidicReadings({required final  List<String> jaOn, required final  List<String> jaKun, final  List<String>? pinyin, final  List<String>? koreanR, final  List<String>? koreanH}): _jaOn = jaOn,_jaKun = jaKun,_pinyin = pinyin,_koreanR = koreanR,_koreanH = koreanH;
  

 final  List<String> _jaOn;
@override List<String> get jaOn {
  if (_jaOn is EqualUnmodifiableListView) return _jaOn;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_jaOn);
}

 final  List<String> _jaKun;
@override List<String> get jaKun {
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
@override List<String>? get koreanR {
  final value = _koreanR;
  if (value == null) return null;
  if (_koreanR is EqualUnmodifiableListView) return _koreanR;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _koreanH;
@override List<String>? get koreanH {
  final value = _koreanH;
  if (value == null) return null;
  if (_koreanH is EqualUnmodifiableListView) return _koreanH;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of KanjidicReadings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KanjidicReadingsCopyWith<_KanjidicReadings> get copyWith => __$KanjidicReadingsCopyWithImpl<_KanjidicReadings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KanjidicReadings&&const DeepCollectionEquality().equals(other._jaOn, _jaOn)&&const DeepCollectionEquality().equals(other._jaKun, _jaKun)&&const DeepCollectionEquality().equals(other._pinyin, _pinyin)&&const DeepCollectionEquality().equals(other._koreanR, _koreanR)&&const DeepCollectionEquality().equals(other._koreanH, _koreanH));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_jaOn),const DeepCollectionEquality().hash(_jaKun),const DeepCollectionEquality().hash(_pinyin),const DeepCollectionEquality().hash(_koreanR),const DeepCollectionEquality().hash(_koreanH));

@override
String toString() {
  return 'KanjidicReadings(jaOn: $jaOn, jaKun: $jaKun, pinyin: $pinyin, koreanR: $koreanR, koreanH: $koreanH)';
}


}

/// @nodoc
abstract mixin class _$KanjidicReadingsCopyWith<$Res> implements $KanjidicReadingsCopyWith<$Res> {
  factory _$KanjidicReadingsCopyWith(_KanjidicReadings value, $Res Function(_KanjidicReadings) _then) = __$KanjidicReadingsCopyWithImpl;
@override @useResult
$Res call({
 List<String> jaOn, List<String> jaKun, List<String>? pinyin, List<String>? koreanR, List<String>? koreanH
});




}
/// @nodoc
class __$KanjidicReadingsCopyWithImpl<$Res>
    implements _$KanjidicReadingsCopyWith<$Res> {
  __$KanjidicReadingsCopyWithImpl(this._self, this._then);

  final _KanjidicReadings _self;
  final $Res Function(_KanjidicReadings) _then;

/// Create a copy of KanjidicReadings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? jaOn = null,Object? jaKun = null,Object? pinyin = freezed,Object? koreanR = freezed,Object? koreanH = freezed,}) {
  return _then(_KanjidicReadings(
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
