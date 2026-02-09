// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'raw_jmdict_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RawJmdictDto {

@JsonKey(name: 'import_id') int get importId;@JsonKey(name: 'ent_seq') int get entSeq;@JsonKey(name: 'kanji_elements') List<JmdictKanjiElementDto> get kanjiElements;@JsonKey(name: 'reading_elements') List<JmdictReadingElementDto> get readingElements; List<JmdictSenseDto> get senses;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of RawJmdictDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RawJmdictDtoCopyWith<RawJmdictDto> get copyWith => _$RawJmdictDtoCopyWithImpl<RawJmdictDto>(this as RawJmdictDto, _$identity);

  /// Serializes this RawJmdictDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RawJmdictDto&&(identical(other.importId, importId) || other.importId == importId)&&(identical(other.entSeq, entSeq) || other.entSeq == entSeq)&&const DeepCollectionEquality().equals(other.kanjiElements, kanjiElements)&&const DeepCollectionEquality().equals(other.readingElements, readingElements)&&const DeepCollectionEquality().equals(other.senses, senses)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,importId,entSeq,const DeepCollectionEquality().hash(kanjiElements),const DeepCollectionEquality().hash(readingElements),const DeepCollectionEquality().hash(senses),createdAt);

@override
String toString() {
  return 'RawJmdictDto(importId: $importId, entSeq: $entSeq, kanjiElements: $kanjiElements, readingElements: $readingElements, senses: $senses, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $RawJmdictDtoCopyWith<$Res>  {
  factory $RawJmdictDtoCopyWith(RawJmdictDto value, $Res Function(RawJmdictDto) _then) = _$RawJmdictDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'import_id') int importId,@JsonKey(name: 'ent_seq') int entSeq,@JsonKey(name: 'kanji_elements') List<JmdictKanjiElementDto> kanjiElements,@JsonKey(name: 'reading_elements') List<JmdictReadingElementDto> readingElements, List<JmdictSenseDto> senses,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$RawJmdictDtoCopyWithImpl<$Res>
    implements $RawJmdictDtoCopyWith<$Res> {
  _$RawJmdictDtoCopyWithImpl(this._self, this._then);

  final RawJmdictDto _self;
  final $Res Function(RawJmdictDto) _then;

/// Create a copy of RawJmdictDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? importId = null,Object? entSeq = null,Object? kanjiElements = null,Object? readingElements = null,Object? senses = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
importId: null == importId ? _self.importId : importId // ignore: cast_nullable_to_non_nullable
as int,entSeq: null == entSeq ? _self.entSeq : entSeq // ignore: cast_nullable_to_non_nullable
as int,kanjiElements: null == kanjiElements ? _self.kanjiElements : kanjiElements // ignore: cast_nullable_to_non_nullable
as List<JmdictKanjiElementDto>,readingElements: null == readingElements ? _self.readingElements : readingElements // ignore: cast_nullable_to_non_nullable
as List<JmdictReadingElementDto>,senses: null == senses ? _self.senses : senses // ignore: cast_nullable_to_non_nullable
as List<JmdictSenseDto>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [RawJmdictDto].
extension RawJmdictDtoPatterns on RawJmdictDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RawJmdictDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RawJmdictDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RawJmdictDto value)  $default,){
final _that = this;
switch (_that) {
case _RawJmdictDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RawJmdictDto value)?  $default,){
final _that = this;
switch (_that) {
case _RawJmdictDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'import_id')  int importId, @JsonKey(name: 'ent_seq')  int entSeq, @JsonKey(name: 'kanji_elements')  List<JmdictKanjiElementDto> kanjiElements, @JsonKey(name: 'reading_elements')  List<JmdictReadingElementDto> readingElements,  List<JmdictSenseDto> senses, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RawJmdictDto() when $default != null:
return $default(_that.importId,_that.entSeq,_that.kanjiElements,_that.readingElements,_that.senses,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'import_id')  int importId, @JsonKey(name: 'ent_seq')  int entSeq, @JsonKey(name: 'kanji_elements')  List<JmdictKanjiElementDto> kanjiElements, @JsonKey(name: 'reading_elements')  List<JmdictReadingElementDto> readingElements,  List<JmdictSenseDto> senses, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _RawJmdictDto():
return $default(_that.importId,_that.entSeq,_that.kanjiElements,_that.readingElements,_that.senses,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'import_id')  int importId, @JsonKey(name: 'ent_seq')  int entSeq, @JsonKey(name: 'kanji_elements')  List<JmdictKanjiElementDto> kanjiElements, @JsonKey(name: 'reading_elements')  List<JmdictReadingElementDto> readingElements,  List<JmdictSenseDto> senses, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _RawJmdictDto() when $default != null:
return $default(_that.importId,_that.entSeq,_that.kanjiElements,_that.readingElements,_that.senses,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RawJmdictDto extends RawJmdictDto {
  const _RawJmdictDto({@JsonKey(name: 'import_id') required this.importId, @JsonKey(name: 'ent_seq') required this.entSeq, @JsonKey(name: 'kanji_elements') required final  List<JmdictKanjiElementDto> kanjiElements, @JsonKey(name: 'reading_elements') required final  List<JmdictReadingElementDto> readingElements, required final  List<JmdictSenseDto> senses, @JsonKey(name: 'created_at') required this.createdAt}): _kanjiElements = kanjiElements,_readingElements = readingElements,_senses = senses,super._();
  factory _RawJmdictDto.fromJson(Map<String, dynamic> json) => _$RawJmdictDtoFromJson(json);

@override@JsonKey(name: 'import_id') final  int importId;
@override@JsonKey(name: 'ent_seq') final  int entSeq;
 final  List<JmdictKanjiElementDto> _kanjiElements;
@override@JsonKey(name: 'kanji_elements') List<JmdictKanjiElementDto> get kanjiElements {
  if (_kanjiElements is EqualUnmodifiableListView) return _kanjiElements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_kanjiElements);
}

 final  List<JmdictReadingElementDto> _readingElements;
@override@JsonKey(name: 'reading_elements') List<JmdictReadingElementDto> get readingElements {
  if (_readingElements is EqualUnmodifiableListView) return _readingElements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_readingElements);
}

 final  List<JmdictSenseDto> _senses;
@override List<JmdictSenseDto> get senses {
  if (_senses is EqualUnmodifiableListView) return _senses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_senses);
}

@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of RawJmdictDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RawJmdictDtoCopyWith<_RawJmdictDto> get copyWith => __$RawJmdictDtoCopyWithImpl<_RawJmdictDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RawJmdictDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RawJmdictDto&&(identical(other.importId, importId) || other.importId == importId)&&(identical(other.entSeq, entSeq) || other.entSeq == entSeq)&&const DeepCollectionEquality().equals(other._kanjiElements, _kanjiElements)&&const DeepCollectionEquality().equals(other._readingElements, _readingElements)&&const DeepCollectionEquality().equals(other._senses, _senses)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,importId,entSeq,const DeepCollectionEquality().hash(_kanjiElements),const DeepCollectionEquality().hash(_readingElements),const DeepCollectionEquality().hash(_senses),createdAt);

@override
String toString() {
  return 'RawJmdictDto(importId: $importId, entSeq: $entSeq, kanjiElements: $kanjiElements, readingElements: $readingElements, senses: $senses, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$RawJmdictDtoCopyWith<$Res> implements $RawJmdictDtoCopyWith<$Res> {
  factory _$RawJmdictDtoCopyWith(_RawJmdictDto value, $Res Function(_RawJmdictDto) _then) = __$RawJmdictDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'import_id') int importId,@JsonKey(name: 'ent_seq') int entSeq,@JsonKey(name: 'kanji_elements') List<JmdictKanjiElementDto> kanjiElements,@JsonKey(name: 'reading_elements') List<JmdictReadingElementDto> readingElements, List<JmdictSenseDto> senses,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$RawJmdictDtoCopyWithImpl<$Res>
    implements _$RawJmdictDtoCopyWith<$Res> {
  __$RawJmdictDtoCopyWithImpl(this._self, this._then);

  final _RawJmdictDto _self;
  final $Res Function(_RawJmdictDto) _then;

/// Create a copy of RawJmdictDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? importId = null,Object? entSeq = null,Object? kanjiElements = null,Object? readingElements = null,Object? senses = null,Object? createdAt = null,}) {
  return _then(_RawJmdictDto(
importId: null == importId ? _self.importId : importId // ignore: cast_nullable_to_non_nullable
as int,entSeq: null == entSeq ? _self.entSeq : entSeq // ignore: cast_nullable_to_non_nullable
as int,kanjiElements: null == kanjiElements ? _self._kanjiElements : kanjiElements // ignore: cast_nullable_to_non_nullable
as List<JmdictKanjiElementDto>,readingElements: null == readingElements ? _self._readingElements : readingElements // ignore: cast_nullable_to_non_nullable
as List<JmdictReadingElementDto>,senses: null == senses ? _self._senses : senses // ignore: cast_nullable_to_non_nullable
as List<JmdictSenseDto>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$JmdictKanjiElementDto {

 String get keb;@JsonKey(name: 'ke_inf') List<String>? get keInf;@JsonKey(name: 'ke_pri') List<String>? get kePri;
/// Create a copy of JmdictKanjiElementDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JmdictKanjiElementDtoCopyWith<JmdictKanjiElementDto> get copyWith => _$JmdictKanjiElementDtoCopyWithImpl<JmdictKanjiElementDto>(this as JmdictKanjiElementDto, _$identity);

  /// Serializes this JmdictKanjiElementDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JmdictKanjiElementDto&&(identical(other.keb, keb) || other.keb == keb)&&const DeepCollectionEquality().equals(other.keInf, keInf)&&const DeepCollectionEquality().equals(other.kePri, kePri));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,keb,const DeepCollectionEquality().hash(keInf),const DeepCollectionEquality().hash(kePri));

@override
String toString() {
  return 'JmdictKanjiElementDto(keb: $keb, keInf: $keInf, kePri: $kePri)';
}


}

/// @nodoc
abstract mixin class $JmdictKanjiElementDtoCopyWith<$Res>  {
  factory $JmdictKanjiElementDtoCopyWith(JmdictKanjiElementDto value, $Res Function(JmdictKanjiElementDto) _then) = _$JmdictKanjiElementDtoCopyWithImpl;
@useResult
$Res call({
 String keb,@JsonKey(name: 'ke_inf') List<String>? keInf,@JsonKey(name: 'ke_pri') List<String>? kePri
});




}
/// @nodoc
class _$JmdictKanjiElementDtoCopyWithImpl<$Res>
    implements $JmdictKanjiElementDtoCopyWith<$Res> {
  _$JmdictKanjiElementDtoCopyWithImpl(this._self, this._then);

  final JmdictKanjiElementDto _self;
  final $Res Function(JmdictKanjiElementDto) _then;

/// Create a copy of JmdictKanjiElementDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? keb = null,Object? keInf = freezed,Object? kePri = freezed,}) {
  return _then(_self.copyWith(
keb: null == keb ? _self.keb : keb // ignore: cast_nullable_to_non_nullable
as String,keInf: freezed == keInf ? _self.keInf : keInf // ignore: cast_nullable_to_non_nullable
as List<String>?,kePri: freezed == kePri ? _self.kePri : kePri // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [JmdictKanjiElementDto].
extension JmdictKanjiElementDtoPatterns on JmdictKanjiElementDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JmdictKanjiElementDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JmdictKanjiElementDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JmdictKanjiElementDto value)  $default,){
final _that = this;
switch (_that) {
case _JmdictKanjiElementDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JmdictKanjiElementDto value)?  $default,){
final _that = this;
switch (_that) {
case _JmdictKanjiElementDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String keb, @JsonKey(name: 'ke_inf')  List<String>? keInf, @JsonKey(name: 'ke_pri')  List<String>? kePri)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JmdictKanjiElementDto() when $default != null:
return $default(_that.keb,_that.keInf,_that.kePri);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String keb, @JsonKey(name: 'ke_inf')  List<String>? keInf, @JsonKey(name: 'ke_pri')  List<String>? kePri)  $default,) {final _that = this;
switch (_that) {
case _JmdictKanjiElementDto():
return $default(_that.keb,_that.keInf,_that.kePri);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String keb, @JsonKey(name: 'ke_inf')  List<String>? keInf, @JsonKey(name: 'ke_pri')  List<String>? kePri)?  $default,) {final _that = this;
switch (_that) {
case _JmdictKanjiElementDto() when $default != null:
return $default(_that.keb,_that.keInf,_that.kePri);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JmdictKanjiElementDto extends JmdictKanjiElementDto {
  const _JmdictKanjiElementDto({required this.keb, @JsonKey(name: 'ke_inf') final  List<String>? keInf, @JsonKey(name: 'ke_pri') final  List<String>? kePri}): _keInf = keInf,_kePri = kePri,super._();
  factory _JmdictKanjiElementDto.fromJson(Map<String, dynamic> json) => _$JmdictKanjiElementDtoFromJson(json);

@override final  String keb;
 final  List<String>? _keInf;
@override@JsonKey(name: 'ke_inf') List<String>? get keInf {
  final value = _keInf;
  if (value == null) return null;
  if (_keInf is EqualUnmodifiableListView) return _keInf;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _kePri;
@override@JsonKey(name: 'ke_pri') List<String>? get kePri {
  final value = _kePri;
  if (value == null) return null;
  if (_kePri is EqualUnmodifiableListView) return _kePri;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of JmdictKanjiElementDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JmdictKanjiElementDtoCopyWith<_JmdictKanjiElementDto> get copyWith => __$JmdictKanjiElementDtoCopyWithImpl<_JmdictKanjiElementDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JmdictKanjiElementDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JmdictKanjiElementDto&&(identical(other.keb, keb) || other.keb == keb)&&const DeepCollectionEquality().equals(other._keInf, _keInf)&&const DeepCollectionEquality().equals(other._kePri, _kePri));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,keb,const DeepCollectionEquality().hash(_keInf),const DeepCollectionEquality().hash(_kePri));

@override
String toString() {
  return 'JmdictKanjiElementDto(keb: $keb, keInf: $keInf, kePri: $kePri)';
}


}

/// @nodoc
abstract mixin class _$JmdictKanjiElementDtoCopyWith<$Res> implements $JmdictKanjiElementDtoCopyWith<$Res> {
  factory _$JmdictKanjiElementDtoCopyWith(_JmdictKanjiElementDto value, $Res Function(_JmdictKanjiElementDto) _then) = __$JmdictKanjiElementDtoCopyWithImpl;
@override @useResult
$Res call({
 String keb,@JsonKey(name: 'ke_inf') List<String>? keInf,@JsonKey(name: 'ke_pri') List<String>? kePri
});




}
/// @nodoc
class __$JmdictKanjiElementDtoCopyWithImpl<$Res>
    implements _$JmdictKanjiElementDtoCopyWith<$Res> {
  __$JmdictKanjiElementDtoCopyWithImpl(this._self, this._then);

  final _JmdictKanjiElementDto _self;
  final $Res Function(_JmdictKanjiElementDto) _then;

/// Create a copy of JmdictKanjiElementDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? keb = null,Object? keInf = freezed,Object? kePri = freezed,}) {
  return _then(_JmdictKanjiElementDto(
keb: null == keb ? _self.keb : keb // ignore: cast_nullable_to_non_nullable
as String,keInf: freezed == keInf ? _self._keInf : keInf // ignore: cast_nullable_to_non_nullable
as List<String>?,kePri: freezed == kePri ? _self._kePri : kePri // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}


/// @nodoc
mixin _$JmdictReadingElementDto {

 String get reb;@JsonKey(name: 're_nokanji') bool get reNokanji;@JsonKey(name: 're_restr') List<String>? get reRestr;@JsonKey(name: 're_inf') List<String>? get reInf;@JsonKey(name: 're_pri') List<String>? get rePri;
/// Create a copy of JmdictReadingElementDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JmdictReadingElementDtoCopyWith<JmdictReadingElementDto> get copyWith => _$JmdictReadingElementDtoCopyWithImpl<JmdictReadingElementDto>(this as JmdictReadingElementDto, _$identity);

  /// Serializes this JmdictReadingElementDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JmdictReadingElementDto&&(identical(other.reb, reb) || other.reb == reb)&&(identical(other.reNokanji, reNokanji) || other.reNokanji == reNokanji)&&const DeepCollectionEquality().equals(other.reRestr, reRestr)&&const DeepCollectionEquality().equals(other.reInf, reInf)&&const DeepCollectionEquality().equals(other.rePri, rePri));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reb,reNokanji,const DeepCollectionEquality().hash(reRestr),const DeepCollectionEquality().hash(reInf),const DeepCollectionEquality().hash(rePri));

@override
String toString() {
  return 'JmdictReadingElementDto(reb: $reb, reNokanji: $reNokanji, reRestr: $reRestr, reInf: $reInf, rePri: $rePri)';
}


}

/// @nodoc
abstract mixin class $JmdictReadingElementDtoCopyWith<$Res>  {
  factory $JmdictReadingElementDtoCopyWith(JmdictReadingElementDto value, $Res Function(JmdictReadingElementDto) _then) = _$JmdictReadingElementDtoCopyWithImpl;
@useResult
$Res call({
 String reb,@JsonKey(name: 're_nokanji') bool reNokanji,@JsonKey(name: 're_restr') List<String>? reRestr,@JsonKey(name: 're_inf') List<String>? reInf,@JsonKey(name: 're_pri') List<String>? rePri
});




}
/// @nodoc
class _$JmdictReadingElementDtoCopyWithImpl<$Res>
    implements $JmdictReadingElementDtoCopyWith<$Res> {
  _$JmdictReadingElementDtoCopyWithImpl(this._self, this._then);

  final JmdictReadingElementDto _self;
  final $Res Function(JmdictReadingElementDto) _then;

/// Create a copy of JmdictReadingElementDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reb = null,Object? reNokanji = null,Object? reRestr = freezed,Object? reInf = freezed,Object? rePri = freezed,}) {
  return _then(_self.copyWith(
reb: null == reb ? _self.reb : reb // ignore: cast_nullable_to_non_nullable
as String,reNokanji: null == reNokanji ? _self.reNokanji : reNokanji // ignore: cast_nullable_to_non_nullable
as bool,reRestr: freezed == reRestr ? _self.reRestr : reRestr // ignore: cast_nullable_to_non_nullable
as List<String>?,reInf: freezed == reInf ? _self.reInf : reInf // ignore: cast_nullable_to_non_nullable
as List<String>?,rePri: freezed == rePri ? _self.rePri : rePri // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [JmdictReadingElementDto].
extension JmdictReadingElementDtoPatterns on JmdictReadingElementDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JmdictReadingElementDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JmdictReadingElementDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JmdictReadingElementDto value)  $default,){
final _that = this;
switch (_that) {
case _JmdictReadingElementDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JmdictReadingElementDto value)?  $default,){
final _that = this;
switch (_that) {
case _JmdictReadingElementDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String reb, @JsonKey(name: 're_nokanji')  bool reNokanji, @JsonKey(name: 're_restr')  List<String>? reRestr, @JsonKey(name: 're_inf')  List<String>? reInf, @JsonKey(name: 're_pri')  List<String>? rePri)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JmdictReadingElementDto() when $default != null:
return $default(_that.reb,_that.reNokanji,_that.reRestr,_that.reInf,_that.rePri);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String reb, @JsonKey(name: 're_nokanji')  bool reNokanji, @JsonKey(name: 're_restr')  List<String>? reRestr, @JsonKey(name: 're_inf')  List<String>? reInf, @JsonKey(name: 're_pri')  List<String>? rePri)  $default,) {final _that = this;
switch (_that) {
case _JmdictReadingElementDto():
return $default(_that.reb,_that.reNokanji,_that.reRestr,_that.reInf,_that.rePri);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String reb, @JsonKey(name: 're_nokanji')  bool reNokanji, @JsonKey(name: 're_restr')  List<String>? reRestr, @JsonKey(name: 're_inf')  List<String>? reInf, @JsonKey(name: 're_pri')  List<String>? rePri)?  $default,) {final _that = this;
switch (_that) {
case _JmdictReadingElementDto() when $default != null:
return $default(_that.reb,_that.reNokanji,_that.reRestr,_that.reInf,_that.rePri);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JmdictReadingElementDto extends JmdictReadingElementDto {
  const _JmdictReadingElementDto({required this.reb, @JsonKey(name: 're_nokanji') this.reNokanji = false, @JsonKey(name: 're_restr') final  List<String>? reRestr, @JsonKey(name: 're_inf') final  List<String>? reInf, @JsonKey(name: 're_pri') final  List<String>? rePri}): _reRestr = reRestr,_reInf = reInf,_rePri = rePri,super._();
  factory _JmdictReadingElementDto.fromJson(Map<String, dynamic> json) => _$JmdictReadingElementDtoFromJson(json);

@override final  String reb;
@override@JsonKey(name: 're_nokanji') final  bool reNokanji;
 final  List<String>? _reRestr;
@override@JsonKey(name: 're_restr') List<String>? get reRestr {
  final value = _reRestr;
  if (value == null) return null;
  if (_reRestr is EqualUnmodifiableListView) return _reRestr;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _reInf;
@override@JsonKey(name: 're_inf') List<String>? get reInf {
  final value = _reInf;
  if (value == null) return null;
  if (_reInf is EqualUnmodifiableListView) return _reInf;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _rePri;
@override@JsonKey(name: 're_pri') List<String>? get rePri {
  final value = _rePri;
  if (value == null) return null;
  if (_rePri is EqualUnmodifiableListView) return _rePri;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of JmdictReadingElementDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JmdictReadingElementDtoCopyWith<_JmdictReadingElementDto> get copyWith => __$JmdictReadingElementDtoCopyWithImpl<_JmdictReadingElementDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JmdictReadingElementDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JmdictReadingElementDto&&(identical(other.reb, reb) || other.reb == reb)&&(identical(other.reNokanji, reNokanji) || other.reNokanji == reNokanji)&&const DeepCollectionEquality().equals(other._reRestr, _reRestr)&&const DeepCollectionEquality().equals(other._reInf, _reInf)&&const DeepCollectionEquality().equals(other._rePri, _rePri));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reb,reNokanji,const DeepCollectionEquality().hash(_reRestr),const DeepCollectionEquality().hash(_reInf),const DeepCollectionEquality().hash(_rePri));

@override
String toString() {
  return 'JmdictReadingElementDto(reb: $reb, reNokanji: $reNokanji, reRestr: $reRestr, reInf: $reInf, rePri: $rePri)';
}


}

/// @nodoc
abstract mixin class _$JmdictReadingElementDtoCopyWith<$Res> implements $JmdictReadingElementDtoCopyWith<$Res> {
  factory _$JmdictReadingElementDtoCopyWith(_JmdictReadingElementDto value, $Res Function(_JmdictReadingElementDto) _then) = __$JmdictReadingElementDtoCopyWithImpl;
@override @useResult
$Res call({
 String reb,@JsonKey(name: 're_nokanji') bool reNokanji,@JsonKey(name: 're_restr') List<String>? reRestr,@JsonKey(name: 're_inf') List<String>? reInf,@JsonKey(name: 're_pri') List<String>? rePri
});




}
/// @nodoc
class __$JmdictReadingElementDtoCopyWithImpl<$Res>
    implements _$JmdictReadingElementDtoCopyWith<$Res> {
  __$JmdictReadingElementDtoCopyWithImpl(this._self, this._then);

  final _JmdictReadingElementDto _self;
  final $Res Function(_JmdictReadingElementDto) _then;

/// Create a copy of JmdictReadingElementDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reb = null,Object? reNokanji = null,Object? reRestr = freezed,Object? reInf = freezed,Object? rePri = freezed,}) {
  return _then(_JmdictReadingElementDto(
reb: null == reb ? _self.reb : reb // ignore: cast_nullable_to_non_nullable
as String,reNokanji: null == reNokanji ? _self.reNokanji : reNokanji // ignore: cast_nullable_to_non_nullable
as bool,reRestr: freezed == reRestr ? _self._reRestr : reRestr // ignore: cast_nullable_to_non_nullable
as List<String>?,reInf: freezed == reInf ? _self._reInf : reInf // ignore: cast_nullable_to_non_nullable
as List<String>?,rePri: freezed == rePri ? _self._rePri : rePri // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}


/// @nodoc
mixin _$JmdictSenseDto {

 List<String>? get stagk; List<String>? get stagr; List<String>? get pos; List<String>? get xref; List<String>? get ant; List<String>? get field; List<String>? get misc;@JsonKey(name: 's_inf') List<String>? get sInf; List<JmdictLsourceDto>? get lsource; List<String>? get dial; Map<String, List<String>> get glosses;
/// Create a copy of JmdictSenseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JmdictSenseDtoCopyWith<JmdictSenseDto> get copyWith => _$JmdictSenseDtoCopyWithImpl<JmdictSenseDto>(this as JmdictSenseDto, _$identity);

  /// Serializes this JmdictSenseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JmdictSenseDto&&const DeepCollectionEquality().equals(other.stagk, stagk)&&const DeepCollectionEquality().equals(other.stagr, stagr)&&const DeepCollectionEquality().equals(other.pos, pos)&&const DeepCollectionEquality().equals(other.xref, xref)&&const DeepCollectionEquality().equals(other.ant, ant)&&const DeepCollectionEquality().equals(other.field, field)&&const DeepCollectionEquality().equals(other.misc, misc)&&const DeepCollectionEquality().equals(other.sInf, sInf)&&const DeepCollectionEquality().equals(other.lsource, lsource)&&const DeepCollectionEquality().equals(other.dial, dial)&&const DeepCollectionEquality().equals(other.glosses, glosses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(stagk),const DeepCollectionEquality().hash(stagr),const DeepCollectionEquality().hash(pos),const DeepCollectionEquality().hash(xref),const DeepCollectionEquality().hash(ant),const DeepCollectionEquality().hash(field),const DeepCollectionEquality().hash(misc),const DeepCollectionEquality().hash(sInf),const DeepCollectionEquality().hash(lsource),const DeepCollectionEquality().hash(dial),const DeepCollectionEquality().hash(glosses));

@override
String toString() {
  return 'JmdictSenseDto(stagk: $stagk, stagr: $stagr, pos: $pos, xref: $xref, ant: $ant, field: $field, misc: $misc, sInf: $sInf, lsource: $lsource, dial: $dial, glosses: $glosses)';
}


}

/// @nodoc
abstract mixin class $JmdictSenseDtoCopyWith<$Res>  {
  factory $JmdictSenseDtoCopyWith(JmdictSenseDto value, $Res Function(JmdictSenseDto) _then) = _$JmdictSenseDtoCopyWithImpl;
@useResult
$Res call({
 List<String>? stagk, List<String>? stagr, List<String>? pos, List<String>? xref, List<String>? ant, List<String>? field, List<String>? misc,@JsonKey(name: 's_inf') List<String>? sInf, List<JmdictLsourceDto>? lsource, List<String>? dial, Map<String, List<String>> glosses
});




}
/// @nodoc
class _$JmdictSenseDtoCopyWithImpl<$Res>
    implements $JmdictSenseDtoCopyWith<$Res> {
  _$JmdictSenseDtoCopyWithImpl(this._self, this._then);

  final JmdictSenseDto _self;
  final $Res Function(JmdictSenseDto) _then;

/// Create a copy of JmdictSenseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stagk = freezed,Object? stagr = freezed,Object? pos = freezed,Object? xref = freezed,Object? ant = freezed,Object? field = freezed,Object? misc = freezed,Object? sInf = freezed,Object? lsource = freezed,Object? dial = freezed,Object? glosses = null,}) {
  return _then(_self.copyWith(
stagk: freezed == stagk ? _self.stagk : stagk // ignore: cast_nullable_to_non_nullable
as List<String>?,stagr: freezed == stagr ? _self.stagr : stagr // ignore: cast_nullable_to_non_nullable
as List<String>?,pos: freezed == pos ? _self.pos : pos // ignore: cast_nullable_to_non_nullable
as List<String>?,xref: freezed == xref ? _self.xref : xref // ignore: cast_nullable_to_non_nullable
as List<String>?,ant: freezed == ant ? _self.ant : ant // ignore: cast_nullable_to_non_nullable
as List<String>?,field: freezed == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as List<String>?,misc: freezed == misc ? _self.misc : misc // ignore: cast_nullable_to_non_nullable
as List<String>?,sInf: freezed == sInf ? _self.sInf : sInf // ignore: cast_nullable_to_non_nullable
as List<String>?,lsource: freezed == lsource ? _self.lsource : lsource // ignore: cast_nullable_to_non_nullable
as List<JmdictLsourceDto>?,dial: freezed == dial ? _self.dial : dial // ignore: cast_nullable_to_non_nullable
as List<String>?,glosses: null == glosses ? _self.glosses : glosses // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>,
  ));
}

}


/// Adds pattern-matching-related methods to [JmdictSenseDto].
extension JmdictSenseDtoPatterns on JmdictSenseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JmdictSenseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JmdictSenseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JmdictSenseDto value)  $default,){
final _that = this;
switch (_that) {
case _JmdictSenseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JmdictSenseDto value)?  $default,){
final _that = this;
switch (_that) {
case _JmdictSenseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String>? stagk,  List<String>? stagr,  List<String>? pos,  List<String>? xref,  List<String>? ant,  List<String>? field,  List<String>? misc, @JsonKey(name: 's_inf')  List<String>? sInf,  List<JmdictLsourceDto>? lsource,  List<String>? dial,  Map<String, List<String>> glosses)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JmdictSenseDto() when $default != null:
return $default(_that.stagk,_that.stagr,_that.pos,_that.xref,_that.ant,_that.field,_that.misc,_that.sInf,_that.lsource,_that.dial,_that.glosses);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String>? stagk,  List<String>? stagr,  List<String>? pos,  List<String>? xref,  List<String>? ant,  List<String>? field,  List<String>? misc, @JsonKey(name: 's_inf')  List<String>? sInf,  List<JmdictLsourceDto>? lsource,  List<String>? dial,  Map<String, List<String>> glosses)  $default,) {final _that = this;
switch (_that) {
case _JmdictSenseDto():
return $default(_that.stagk,_that.stagr,_that.pos,_that.xref,_that.ant,_that.field,_that.misc,_that.sInf,_that.lsource,_that.dial,_that.glosses);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String>? stagk,  List<String>? stagr,  List<String>? pos,  List<String>? xref,  List<String>? ant,  List<String>? field,  List<String>? misc, @JsonKey(name: 's_inf')  List<String>? sInf,  List<JmdictLsourceDto>? lsource,  List<String>? dial,  Map<String, List<String>> glosses)?  $default,) {final _that = this;
switch (_that) {
case _JmdictSenseDto() when $default != null:
return $default(_that.stagk,_that.stagr,_that.pos,_that.xref,_that.ant,_that.field,_that.misc,_that.sInf,_that.lsource,_that.dial,_that.glosses);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JmdictSenseDto extends JmdictSenseDto {
  const _JmdictSenseDto({final  List<String>? stagk, final  List<String>? stagr, final  List<String>? pos, final  List<String>? xref, final  List<String>? ant, final  List<String>? field, final  List<String>? misc, @JsonKey(name: 's_inf') final  List<String>? sInf, final  List<JmdictLsourceDto>? lsource, final  List<String>? dial, required final  Map<String, List<String>> glosses}): _stagk = stagk,_stagr = stagr,_pos = pos,_xref = xref,_ant = ant,_field = field,_misc = misc,_sInf = sInf,_lsource = lsource,_dial = dial,_glosses = glosses,super._();
  factory _JmdictSenseDto.fromJson(Map<String, dynamic> json) => _$JmdictSenseDtoFromJson(json);

 final  List<String>? _stagk;
@override List<String>? get stagk {
  final value = _stagk;
  if (value == null) return null;
  if (_stagk is EqualUnmodifiableListView) return _stagk;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _stagr;
@override List<String>? get stagr {
  final value = _stagr;
  if (value == null) return null;
  if (_stagr is EqualUnmodifiableListView) return _stagr;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _pos;
@override List<String>? get pos {
  final value = _pos;
  if (value == null) return null;
  if (_pos is EqualUnmodifiableListView) return _pos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _xref;
@override List<String>? get xref {
  final value = _xref;
  if (value == null) return null;
  if (_xref is EqualUnmodifiableListView) return _xref;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _ant;
@override List<String>? get ant {
  final value = _ant;
  if (value == null) return null;
  if (_ant is EqualUnmodifiableListView) return _ant;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _field;
@override List<String>? get field {
  final value = _field;
  if (value == null) return null;
  if (_field is EqualUnmodifiableListView) return _field;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _misc;
@override List<String>? get misc {
  final value = _misc;
  if (value == null) return null;
  if (_misc is EqualUnmodifiableListView) return _misc;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _sInf;
@override@JsonKey(name: 's_inf') List<String>? get sInf {
  final value = _sInf;
  if (value == null) return null;
  if (_sInf is EqualUnmodifiableListView) return _sInf;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<JmdictLsourceDto>? _lsource;
@override List<JmdictLsourceDto>? get lsource {
  final value = _lsource;
  if (value == null) return null;
  if (_lsource is EqualUnmodifiableListView) return _lsource;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _dial;
@override List<String>? get dial {
  final value = _dial;
  if (value == null) return null;
  if (_dial is EqualUnmodifiableListView) return _dial;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  Map<String, List<String>> _glosses;
@override Map<String, List<String>> get glosses {
  if (_glosses is EqualUnmodifiableMapView) return _glosses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_glosses);
}


/// Create a copy of JmdictSenseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JmdictSenseDtoCopyWith<_JmdictSenseDto> get copyWith => __$JmdictSenseDtoCopyWithImpl<_JmdictSenseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JmdictSenseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JmdictSenseDto&&const DeepCollectionEquality().equals(other._stagk, _stagk)&&const DeepCollectionEquality().equals(other._stagr, _stagr)&&const DeepCollectionEquality().equals(other._pos, _pos)&&const DeepCollectionEquality().equals(other._xref, _xref)&&const DeepCollectionEquality().equals(other._ant, _ant)&&const DeepCollectionEquality().equals(other._field, _field)&&const DeepCollectionEquality().equals(other._misc, _misc)&&const DeepCollectionEquality().equals(other._sInf, _sInf)&&const DeepCollectionEquality().equals(other._lsource, _lsource)&&const DeepCollectionEquality().equals(other._dial, _dial)&&const DeepCollectionEquality().equals(other._glosses, _glosses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_stagk),const DeepCollectionEquality().hash(_stagr),const DeepCollectionEquality().hash(_pos),const DeepCollectionEquality().hash(_xref),const DeepCollectionEquality().hash(_ant),const DeepCollectionEquality().hash(_field),const DeepCollectionEquality().hash(_misc),const DeepCollectionEquality().hash(_sInf),const DeepCollectionEquality().hash(_lsource),const DeepCollectionEquality().hash(_dial),const DeepCollectionEquality().hash(_glosses));

@override
String toString() {
  return 'JmdictSenseDto(stagk: $stagk, stagr: $stagr, pos: $pos, xref: $xref, ant: $ant, field: $field, misc: $misc, sInf: $sInf, lsource: $lsource, dial: $dial, glosses: $glosses)';
}


}

/// @nodoc
abstract mixin class _$JmdictSenseDtoCopyWith<$Res> implements $JmdictSenseDtoCopyWith<$Res> {
  factory _$JmdictSenseDtoCopyWith(_JmdictSenseDto value, $Res Function(_JmdictSenseDto) _then) = __$JmdictSenseDtoCopyWithImpl;
@override @useResult
$Res call({
 List<String>? stagk, List<String>? stagr, List<String>? pos, List<String>? xref, List<String>? ant, List<String>? field, List<String>? misc,@JsonKey(name: 's_inf') List<String>? sInf, List<JmdictLsourceDto>? lsource, List<String>? dial, Map<String, List<String>> glosses
});




}
/// @nodoc
class __$JmdictSenseDtoCopyWithImpl<$Res>
    implements _$JmdictSenseDtoCopyWith<$Res> {
  __$JmdictSenseDtoCopyWithImpl(this._self, this._then);

  final _JmdictSenseDto _self;
  final $Res Function(_JmdictSenseDto) _then;

/// Create a copy of JmdictSenseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stagk = freezed,Object? stagr = freezed,Object? pos = freezed,Object? xref = freezed,Object? ant = freezed,Object? field = freezed,Object? misc = freezed,Object? sInf = freezed,Object? lsource = freezed,Object? dial = freezed,Object? glosses = null,}) {
  return _then(_JmdictSenseDto(
stagk: freezed == stagk ? _self._stagk : stagk // ignore: cast_nullable_to_non_nullable
as List<String>?,stagr: freezed == stagr ? _self._stagr : stagr // ignore: cast_nullable_to_non_nullable
as List<String>?,pos: freezed == pos ? _self._pos : pos // ignore: cast_nullable_to_non_nullable
as List<String>?,xref: freezed == xref ? _self._xref : xref // ignore: cast_nullable_to_non_nullable
as List<String>?,ant: freezed == ant ? _self._ant : ant // ignore: cast_nullable_to_non_nullable
as List<String>?,field: freezed == field ? _self._field : field // ignore: cast_nullable_to_non_nullable
as List<String>?,misc: freezed == misc ? _self._misc : misc // ignore: cast_nullable_to_non_nullable
as List<String>?,sInf: freezed == sInf ? _self._sInf : sInf // ignore: cast_nullable_to_non_nullable
as List<String>?,lsource: freezed == lsource ? _self._lsource : lsource // ignore: cast_nullable_to_non_nullable
as List<JmdictLsourceDto>?,dial: freezed == dial ? _self._dial : dial // ignore: cast_nullable_to_non_nullable
as List<String>?,glosses: null == glosses ? _self._glosses : glosses // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>,
  ));
}


}


/// @nodoc
mixin _$JmdictLsourceDto {

 String get lang; String? get value;@JsonKey(name: 'ls_type') String? get lsType;@JsonKey(name: 'ls_wasei') bool get lsWasei;
/// Create a copy of JmdictLsourceDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JmdictLsourceDtoCopyWith<JmdictLsourceDto> get copyWith => _$JmdictLsourceDtoCopyWithImpl<JmdictLsourceDto>(this as JmdictLsourceDto, _$identity);

  /// Serializes this JmdictLsourceDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JmdictLsourceDto&&(identical(other.lang, lang) || other.lang == lang)&&(identical(other.value, value) || other.value == value)&&(identical(other.lsType, lsType) || other.lsType == lsType)&&(identical(other.lsWasei, lsWasei) || other.lsWasei == lsWasei));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lang,value,lsType,lsWasei);

@override
String toString() {
  return 'JmdictLsourceDto(lang: $lang, value: $value, lsType: $lsType, lsWasei: $lsWasei)';
}


}

/// @nodoc
abstract mixin class $JmdictLsourceDtoCopyWith<$Res>  {
  factory $JmdictLsourceDtoCopyWith(JmdictLsourceDto value, $Res Function(JmdictLsourceDto) _then) = _$JmdictLsourceDtoCopyWithImpl;
@useResult
$Res call({
 String lang, String? value,@JsonKey(name: 'ls_type') String? lsType,@JsonKey(name: 'ls_wasei') bool lsWasei
});




}
/// @nodoc
class _$JmdictLsourceDtoCopyWithImpl<$Res>
    implements $JmdictLsourceDtoCopyWith<$Res> {
  _$JmdictLsourceDtoCopyWithImpl(this._self, this._then);

  final JmdictLsourceDto _self;
  final $Res Function(JmdictLsourceDto) _then;

/// Create a copy of JmdictLsourceDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lang = null,Object? value = freezed,Object? lsType = freezed,Object? lsWasei = null,}) {
  return _then(_self.copyWith(
lang: null == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as String,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,lsType: freezed == lsType ? _self.lsType : lsType // ignore: cast_nullable_to_non_nullable
as String?,lsWasei: null == lsWasei ? _self.lsWasei : lsWasei // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [JmdictLsourceDto].
extension JmdictLsourceDtoPatterns on JmdictLsourceDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JmdictLsourceDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JmdictLsourceDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JmdictLsourceDto value)  $default,){
final _that = this;
switch (_that) {
case _JmdictLsourceDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JmdictLsourceDto value)?  $default,){
final _that = this;
switch (_that) {
case _JmdictLsourceDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String lang,  String? value, @JsonKey(name: 'ls_type')  String? lsType, @JsonKey(name: 'ls_wasei')  bool lsWasei)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JmdictLsourceDto() when $default != null:
return $default(_that.lang,_that.value,_that.lsType,_that.lsWasei);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String lang,  String? value, @JsonKey(name: 'ls_type')  String? lsType, @JsonKey(name: 'ls_wasei')  bool lsWasei)  $default,) {final _that = this;
switch (_that) {
case _JmdictLsourceDto():
return $default(_that.lang,_that.value,_that.lsType,_that.lsWasei);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String lang,  String? value, @JsonKey(name: 'ls_type')  String? lsType, @JsonKey(name: 'ls_wasei')  bool lsWasei)?  $default,) {final _that = this;
switch (_that) {
case _JmdictLsourceDto() when $default != null:
return $default(_that.lang,_that.value,_that.lsType,_that.lsWasei);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JmdictLsourceDto extends JmdictLsourceDto {
  const _JmdictLsourceDto({required this.lang, this.value, @JsonKey(name: 'ls_type') this.lsType, @JsonKey(name: 'ls_wasei') this.lsWasei = false}): super._();
  factory _JmdictLsourceDto.fromJson(Map<String, dynamic> json) => _$JmdictLsourceDtoFromJson(json);

@override final  String lang;
@override final  String? value;
@override@JsonKey(name: 'ls_type') final  String? lsType;
@override@JsonKey(name: 'ls_wasei') final  bool lsWasei;

/// Create a copy of JmdictLsourceDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JmdictLsourceDtoCopyWith<_JmdictLsourceDto> get copyWith => __$JmdictLsourceDtoCopyWithImpl<_JmdictLsourceDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JmdictLsourceDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JmdictLsourceDto&&(identical(other.lang, lang) || other.lang == lang)&&(identical(other.value, value) || other.value == value)&&(identical(other.lsType, lsType) || other.lsType == lsType)&&(identical(other.lsWasei, lsWasei) || other.lsWasei == lsWasei));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lang,value,lsType,lsWasei);

@override
String toString() {
  return 'JmdictLsourceDto(lang: $lang, value: $value, lsType: $lsType, lsWasei: $lsWasei)';
}


}

/// @nodoc
abstract mixin class _$JmdictLsourceDtoCopyWith<$Res> implements $JmdictLsourceDtoCopyWith<$Res> {
  factory _$JmdictLsourceDtoCopyWith(_JmdictLsourceDto value, $Res Function(_JmdictLsourceDto) _then) = __$JmdictLsourceDtoCopyWithImpl;
@override @useResult
$Res call({
 String lang, String? value,@JsonKey(name: 'ls_type') String? lsType,@JsonKey(name: 'ls_wasei') bool lsWasei
});




}
/// @nodoc
class __$JmdictLsourceDtoCopyWithImpl<$Res>
    implements _$JmdictLsourceDtoCopyWith<$Res> {
  __$JmdictLsourceDtoCopyWithImpl(this._self, this._then);

  final _JmdictLsourceDto _self;
  final $Res Function(_JmdictLsourceDto) _then;

/// Create a copy of JmdictLsourceDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lang = null,Object? value = freezed,Object? lsType = freezed,Object? lsWasei = null,}) {
  return _then(_JmdictLsourceDto(
lang: null == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as String,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,lsType: freezed == lsType ? _self.lsType : lsType // ignore: cast_nullable_to_non_nullable
as String?,lsWasei: null == lsWasei ? _self.lsWasei : lsWasei // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
