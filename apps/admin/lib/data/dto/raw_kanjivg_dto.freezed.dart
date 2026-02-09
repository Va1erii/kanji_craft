// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'raw_kanjivg_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RawKanjiVgDto {

@JsonKey(name: 'import_id') int get importId; String get character;@JsonKey(name: 'unicode_hex') String get unicodeHex;@JsonKey(name: 'view_box') String get viewBox;@JsonKey(name: 'stroke_count') int get strokeCount; List<KanjiVgStrokeDto> get strokes; KanjiVgComponentDto get components;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of RawKanjiVgDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RawKanjiVgDtoCopyWith<RawKanjiVgDto> get copyWith => _$RawKanjiVgDtoCopyWithImpl<RawKanjiVgDto>(this as RawKanjiVgDto, _$identity);

  /// Serializes this RawKanjiVgDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RawKanjiVgDto&&(identical(other.importId, importId) || other.importId == importId)&&(identical(other.character, character) || other.character == character)&&(identical(other.unicodeHex, unicodeHex) || other.unicodeHex == unicodeHex)&&(identical(other.viewBox, viewBox) || other.viewBox == viewBox)&&(identical(other.strokeCount, strokeCount) || other.strokeCount == strokeCount)&&const DeepCollectionEquality().equals(other.strokes, strokes)&&(identical(other.components, components) || other.components == components)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,importId,character,unicodeHex,viewBox,strokeCount,const DeepCollectionEquality().hash(strokes),components,createdAt);

@override
String toString() {
  return 'RawKanjiVgDto(importId: $importId, character: $character, unicodeHex: $unicodeHex, viewBox: $viewBox, strokeCount: $strokeCount, strokes: $strokes, components: $components, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $RawKanjiVgDtoCopyWith<$Res>  {
  factory $RawKanjiVgDtoCopyWith(RawKanjiVgDto value, $Res Function(RawKanjiVgDto) _then) = _$RawKanjiVgDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'import_id') int importId, String character,@JsonKey(name: 'unicode_hex') String unicodeHex,@JsonKey(name: 'view_box') String viewBox,@JsonKey(name: 'stroke_count') int strokeCount, List<KanjiVgStrokeDto> strokes, KanjiVgComponentDto components,@JsonKey(name: 'created_at') DateTime createdAt
});


$KanjiVgComponentDtoCopyWith<$Res> get components;

}
/// @nodoc
class _$RawKanjiVgDtoCopyWithImpl<$Res>
    implements $RawKanjiVgDtoCopyWith<$Res> {
  _$RawKanjiVgDtoCopyWithImpl(this._self, this._then);

  final RawKanjiVgDto _self;
  final $Res Function(RawKanjiVgDto) _then;

/// Create a copy of RawKanjiVgDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? importId = null,Object? character = null,Object? unicodeHex = null,Object? viewBox = null,Object? strokeCount = null,Object? strokes = null,Object? components = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
importId: null == importId ? _self.importId : importId // ignore: cast_nullable_to_non_nullable
as int,character: null == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String,unicodeHex: null == unicodeHex ? _self.unicodeHex : unicodeHex // ignore: cast_nullable_to_non_nullable
as String,viewBox: null == viewBox ? _self.viewBox : viewBox // ignore: cast_nullable_to_non_nullable
as String,strokeCount: null == strokeCount ? _self.strokeCount : strokeCount // ignore: cast_nullable_to_non_nullable
as int,strokes: null == strokes ? _self.strokes : strokes // ignore: cast_nullable_to_non_nullable
as List<KanjiVgStrokeDto>,components: null == components ? _self.components : components // ignore: cast_nullable_to_non_nullable
as KanjiVgComponentDto,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of RawKanjiVgDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KanjiVgComponentDtoCopyWith<$Res> get components {
  
  return $KanjiVgComponentDtoCopyWith<$Res>(_self.components, (value) {
    return _then(_self.copyWith(components: value));
  });
}
}


/// Adds pattern-matching-related methods to [RawKanjiVgDto].
extension RawKanjiVgDtoPatterns on RawKanjiVgDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RawKanjiVgDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RawKanjiVgDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RawKanjiVgDto value)  $default,){
final _that = this;
switch (_that) {
case _RawKanjiVgDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RawKanjiVgDto value)?  $default,){
final _that = this;
switch (_that) {
case _RawKanjiVgDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'import_id')  int importId,  String character, @JsonKey(name: 'unicode_hex')  String unicodeHex, @JsonKey(name: 'view_box')  String viewBox, @JsonKey(name: 'stroke_count')  int strokeCount,  List<KanjiVgStrokeDto> strokes,  KanjiVgComponentDto components, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RawKanjiVgDto() when $default != null:
return $default(_that.importId,_that.character,_that.unicodeHex,_that.viewBox,_that.strokeCount,_that.strokes,_that.components,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'import_id')  int importId,  String character, @JsonKey(name: 'unicode_hex')  String unicodeHex, @JsonKey(name: 'view_box')  String viewBox, @JsonKey(name: 'stroke_count')  int strokeCount,  List<KanjiVgStrokeDto> strokes,  KanjiVgComponentDto components, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _RawKanjiVgDto():
return $default(_that.importId,_that.character,_that.unicodeHex,_that.viewBox,_that.strokeCount,_that.strokes,_that.components,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'import_id')  int importId,  String character, @JsonKey(name: 'unicode_hex')  String unicodeHex, @JsonKey(name: 'view_box')  String viewBox, @JsonKey(name: 'stroke_count')  int strokeCount,  List<KanjiVgStrokeDto> strokes,  KanjiVgComponentDto components, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _RawKanjiVgDto() when $default != null:
return $default(_that.importId,_that.character,_that.unicodeHex,_that.viewBox,_that.strokeCount,_that.strokes,_that.components,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RawKanjiVgDto extends RawKanjiVgDto {
  const _RawKanjiVgDto({@JsonKey(name: 'import_id') required this.importId, required this.character, @JsonKey(name: 'unicode_hex') required this.unicodeHex, @JsonKey(name: 'view_box') required this.viewBox, @JsonKey(name: 'stroke_count') required this.strokeCount, required final  List<KanjiVgStrokeDto> strokes, required this.components, @JsonKey(name: 'created_at') required this.createdAt}): _strokes = strokes,super._();
  factory _RawKanjiVgDto.fromJson(Map<String, dynamic> json) => _$RawKanjiVgDtoFromJson(json);

@override@JsonKey(name: 'import_id') final  int importId;
@override final  String character;
@override@JsonKey(name: 'unicode_hex') final  String unicodeHex;
@override@JsonKey(name: 'view_box') final  String viewBox;
@override@JsonKey(name: 'stroke_count') final  int strokeCount;
 final  List<KanjiVgStrokeDto> _strokes;
@override List<KanjiVgStrokeDto> get strokes {
  if (_strokes is EqualUnmodifiableListView) return _strokes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_strokes);
}

@override final  KanjiVgComponentDto components;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of RawKanjiVgDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RawKanjiVgDtoCopyWith<_RawKanjiVgDto> get copyWith => __$RawKanjiVgDtoCopyWithImpl<_RawKanjiVgDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RawKanjiVgDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RawKanjiVgDto&&(identical(other.importId, importId) || other.importId == importId)&&(identical(other.character, character) || other.character == character)&&(identical(other.unicodeHex, unicodeHex) || other.unicodeHex == unicodeHex)&&(identical(other.viewBox, viewBox) || other.viewBox == viewBox)&&(identical(other.strokeCount, strokeCount) || other.strokeCount == strokeCount)&&const DeepCollectionEquality().equals(other._strokes, _strokes)&&(identical(other.components, components) || other.components == components)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,importId,character,unicodeHex,viewBox,strokeCount,const DeepCollectionEquality().hash(_strokes),components,createdAt);

@override
String toString() {
  return 'RawKanjiVgDto(importId: $importId, character: $character, unicodeHex: $unicodeHex, viewBox: $viewBox, strokeCount: $strokeCount, strokes: $strokes, components: $components, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$RawKanjiVgDtoCopyWith<$Res> implements $RawKanjiVgDtoCopyWith<$Res> {
  factory _$RawKanjiVgDtoCopyWith(_RawKanjiVgDto value, $Res Function(_RawKanjiVgDto) _then) = __$RawKanjiVgDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'import_id') int importId, String character,@JsonKey(name: 'unicode_hex') String unicodeHex,@JsonKey(name: 'view_box') String viewBox,@JsonKey(name: 'stroke_count') int strokeCount, List<KanjiVgStrokeDto> strokes, KanjiVgComponentDto components,@JsonKey(name: 'created_at') DateTime createdAt
});


@override $KanjiVgComponentDtoCopyWith<$Res> get components;

}
/// @nodoc
class __$RawKanjiVgDtoCopyWithImpl<$Res>
    implements _$RawKanjiVgDtoCopyWith<$Res> {
  __$RawKanjiVgDtoCopyWithImpl(this._self, this._then);

  final _RawKanjiVgDto _self;
  final $Res Function(_RawKanjiVgDto) _then;

/// Create a copy of RawKanjiVgDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? importId = null,Object? character = null,Object? unicodeHex = null,Object? viewBox = null,Object? strokeCount = null,Object? strokes = null,Object? components = null,Object? createdAt = null,}) {
  return _then(_RawKanjiVgDto(
importId: null == importId ? _self.importId : importId // ignore: cast_nullable_to_non_nullable
as int,character: null == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String,unicodeHex: null == unicodeHex ? _self.unicodeHex : unicodeHex // ignore: cast_nullable_to_non_nullable
as String,viewBox: null == viewBox ? _self.viewBox : viewBox // ignore: cast_nullable_to_non_nullable
as String,strokeCount: null == strokeCount ? _self.strokeCount : strokeCount // ignore: cast_nullable_to_non_nullable
as int,strokes: null == strokes ? _self._strokes : strokes // ignore: cast_nullable_to_non_nullable
as List<KanjiVgStrokeDto>,components: null == components ? _self.components : components // ignore: cast_nullable_to_non_nullable
as KanjiVgComponentDto,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of RawKanjiVgDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KanjiVgComponentDtoCopyWith<$Res> get components {
  
  return $KanjiVgComponentDtoCopyWith<$Res>(_self.components, (value) {
    return _then(_self.copyWith(components: value));
  });
}
}


/// @nodoc
mixin _$KanjiVgStrokeDto {

 int get number; String get type;@JsonKey(name: 'path_data') String get pathData;
/// Create a copy of KanjiVgStrokeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KanjiVgStrokeDtoCopyWith<KanjiVgStrokeDto> get copyWith => _$KanjiVgStrokeDtoCopyWithImpl<KanjiVgStrokeDto>(this as KanjiVgStrokeDto, _$identity);

  /// Serializes this KanjiVgStrokeDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KanjiVgStrokeDto&&(identical(other.number, number) || other.number == number)&&(identical(other.type, type) || other.type == type)&&(identical(other.pathData, pathData) || other.pathData == pathData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,number,type,pathData);

@override
String toString() {
  return 'KanjiVgStrokeDto(number: $number, type: $type, pathData: $pathData)';
}


}

/// @nodoc
abstract mixin class $KanjiVgStrokeDtoCopyWith<$Res>  {
  factory $KanjiVgStrokeDtoCopyWith(KanjiVgStrokeDto value, $Res Function(KanjiVgStrokeDto) _then) = _$KanjiVgStrokeDtoCopyWithImpl;
@useResult
$Res call({
 int number, String type,@JsonKey(name: 'path_data') String pathData
});




}
/// @nodoc
class _$KanjiVgStrokeDtoCopyWithImpl<$Res>
    implements $KanjiVgStrokeDtoCopyWith<$Res> {
  _$KanjiVgStrokeDtoCopyWithImpl(this._self, this._then);

  final KanjiVgStrokeDto _self;
  final $Res Function(KanjiVgStrokeDto) _then;

/// Create a copy of KanjiVgStrokeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? number = null,Object? type = null,Object? pathData = null,}) {
  return _then(_self.copyWith(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,pathData: null == pathData ? _self.pathData : pathData // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [KanjiVgStrokeDto].
extension KanjiVgStrokeDtoPatterns on KanjiVgStrokeDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KanjiVgStrokeDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KanjiVgStrokeDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KanjiVgStrokeDto value)  $default,){
final _that = this;
switch (_that) {
case _KanjiVgStrokeDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KanjiVgStrokeDto value)?  $default,){
final _that = this;
switch (_that) {
case _KanjiVgStrokeDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int number,  String type, @JsonKey(name: 'path_data')  String pathData)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KanjiVgStrokeDto() when $default != null:
return $default(_that.number,_that.type,_that.pathData);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int number,  String type, @JsonKey(name: 'path_data')  String pathData)  $default,) {final _that = this;
switch (_that) {
case _KanjiVgStrokeDto():
return $default(_that.number,_that.type,_that.pathData);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int number,  String type, @JsonKey(name: 'path_data')  String pathData)?  $default,) {final _that = this;
switch (_that) {
case _KanjiVgStrokeDto() when $default != null:
return $default(_that.number,_that.type,_that.pathData);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KanjiVgStrokeDto extends KanjiVgStrokeDto {
  const _KanjiVgStrokeDto({required this.number, required this.type, @JsonKey(name: 'path_data') required this.pathData}): super._();
  factory _KanjiVgStrokeDto.fromJson(Map<String, dynamic> json) => _$KanjiVgStrokeDtoFromJson(json);

@override final  int number;
@override final  String type;
@override@JsonKey(name: 'path_data') final  String pathData;

/// Create a copy of KanjiVgStrokeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KanjiVgStrokeDtoCopyWith<_KanjiVgStrokeDto> get copyWith => __$KanjiVgStrokeDtoCopyWithImpl<_KanjiVgStrokeDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KanjiVgStrokeDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KanjiVgStrokeDto&&(identical(other.number, number) || other.number == number)&&(identical(other.type, type) || other.type == type)&&(identical(other.pathData, pathData) || other.pathData == pathData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,number,type,pathData);

@override
String toString() {
  return 'KanjiVgStrokeDto(number: $number, type: $type, pathData: $pathData)';
}


}

/// @nodoc
abstract mixin class _$KanjiVgStrokeDtoCopyWith<$Res> implements $KanjiVgStrokeDtoCopyWith<$Res> {
  factory _$KanjiVgStrokeDtoCopyWith(_KanjiVgStrokeDto value, $Res Function(_KanjiVgStrokeDto) _then) = __$KanjiVgStrokeDtoCopyWithImpl;
@override @useResult
$Res call({
 int number, String type,@JsonKey(name: 'path_data') String pathData
});




}
/// @nodoc
class __$KanjiVgStrokeDtoCopyWithImpl<$Res>
    implements _$KanjiVgStrokeDtoCopyWith<$Res> {
  __$KanjiVgStrokeDtoCopyWithImpl(this._self, this._then);

  final _KanjiVgStrokeDto _self;
  final $Res Function(_KanjiVgStrokeDto) _then;

/// Create a copy of KanjiVgStrokeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? number = null,Object? type = null,Object? pathData = null,}) {
  return _then(_KanjiVgStrokeDto(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,pathData: null == pathData ? _self.pathData : pathData // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$KanjiVgComponentDto {

 String get element; String? get position; bool? get variant; String? get original; int? get part; String? get radical; String? get phon;@JsonKey(name: 'trad_form') String? get tradForm;@JsonKey(name: 'stroke_indices') List<int> get strokeIndices; List<KanjiVgComponentDto> get children;
/// Create a copy of KanjiVgComponentDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KanjiVgComponentDtoCopyWith<KanjiVgComponentDto> get copyWith => _$KanjiVgComponentDtoCopyWithImpl<KanjiVgComponentDto>(this as KanjiVgComponentDto, _$identity);

  /// Serializes this KanjiVgComponentDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KanjiVgComponentDto&&(identical(other.element, element) || other.element == element)&&(identical(other.position, position) || other.position == position)&&(identical(other.variant, variant) || other.variant == variant)&&(identical(other.original, original) || other.original == original)&&(identical(other.part, part) || other.part == part)&&(identical(other.radical, radical) || other.radical == radical)&&(identical(other.phon, phon) || other.phon == phon)&&(identical(other.tradForm, tradForm) || other.tradForm == tradForm)&&const DeepCollectionEquality().equals(other.strokeIndices, strokeIndices)&&const DeepCollectionEquality().equals(other.children, children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,element,position,variant,original,part,radical,phon,tradForm,const DeepCollectionEquality().hash(strokeIndices),const DeepCollectionEquality().hash(children));

@override
String toString() {
  return 'KanjiVgComponentDto(element: $element, position: $position, variant: $variant, original: $original, part: $part, radical: $radical, phon: $phon, tradForm: $tradForm, strokeIndices: $strokeIndices, children: $children)';
}


}

/// @nodoc
abstract mixin class $KanjiVgComponentDtoCopyWith<$Res>  {
  factory $KanjiVgComponentDtoCopyWith(KanjiVgComponentDto value, $Res Function(KanjiVgComponentDto) _then) = _$KanjiVgComponentDtoCopyWithImpl;
@useResult
$Res call({
 String element, String? position, bool? variant, String? original, int? part, String? radical, String? phon,@JsonKey(name: 'trad_form') String? tradForm,@JsonKey(name: 'stroke_indices') List<int> strokeIndices, List<KanjiVgComponentDto> children
});




}
/// @nodoc
class _$KanjiVgComponentDtoCopyWithImpl<$Res>
    implements $KanjiVgComponentDtoCopyWith<$Res> {
  _$KanjiVgComponentDtoCopyWithImpl(this._self, this._then);

  final KanjiVgComponentDto _self;
  final $Res Function(KanjiVgComponentDto) _then;

/// Create a copy of KanjiVgComponentDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? element = null,Object? position = freezed,Object? variant = freezed,Object? original = freezed,Object? part = freezed,Object? radical = freezed,Object? phon = freezed,Object? tradForm = freezed,Object? strokeIndices = null,Object? children = null,}) {
  return _then(_self.copyWith(
element: null == element ? _self.element : element // ignore: cast_nullable_to_non_nullable
as String,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String?,variant: freezed == variant ? _self.variant : variant // ignore: cast_nullable_to_non_nullable
as bool?,original: freezed == original ? _self.original : original // ignore: cast_nullable_to_non_nullable
as String?,part: freezed == part ? _self.part : part // ignore: cast_nullable_to_non_nullable
as int?,radical: freezed == radical ? _self.radical : radical // ignore: cast_nullable_to_non_nullable
as String?,phon: freezed == phon ? _self.phon : phon // ignore: cast_nullable_to_non_nullable
as String?,tradForm: freezed == tradForm ? _self.tradForm : tradForm // ignore: cast_nullable_to_non_nullable
as String?,strokeIndices: null == strokeIndices ? _self.strokeIndices : strokeIndices // ignore: cast_nullable_to_non_nullable
as List<int>,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<KanjiVgComponentDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [KanjiVgComponentDto].
extension KanjiVgComponentDtoPatterns on KanjiVgComponentDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KanjiVgComponentDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KanjiVgComponentDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KanjiVgComponentDto value)  $default,){
final _that = this;
switch (_that) {
case _KanjiVgComponentDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KanjiVgComponentDto value)?  $default,){
final _that = this;
switch (_that) {
case _KanjiVgComponentDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String element,  String? position,  bool? variant,  String? original,  int? part,  String? radical,  String? phon, @JsonKey(name: 'trad_form')  String? tradForm, @JsonKey(name: 'stroke_indices')  List<int> strokeIndices,  List<KanjiVgComponentDto> children)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KanjiVgComponentDto() when $default != null:
return $default(_that.element,_that.position,_that.variant,_that.original,_that.part,_that.radical,_that.phon,_that.tradForm,_that.strokeIndices,_that.children);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String element,  String? position,  bool? variant,  String? original,  int? part,  String? radical,  String? phon, @JsonKey(name: 'trad_form')  String? tradForm, @JsonKey(name: 'stroke_indices')  List<int> strokeIndices,  List<KanjiVgComponentDto> children)  $default,) {final _that = this;
switch (_that) {
case _KanjiVgComponentDto():
return $default(_that.element,_that.position,_that.variant,_that.original,_that.part,_that.radical,_that.phon,_that.tradForm,_that.strokeIndices,_that.children);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String element,  String? position,  bool? variant,  String? original,  int? part,  String? radical,  String? phon, @JsonKey(name: 'trad_form')  String? tradForm, @JsonKey(name: 'stroke_indices')  List<int> strokeIndices,  List<KanjiVgComponentDto> children)?  $default,) {final _that = this;
switch (_that) {
case _KanjiVgComponentDto() when $default != null:
return $default(_that.element,_that.position,_that.variant,_that.original,_that.part,_that.radical,_that.phon,_that.tradForm,_that.strokeIndices,_that.children);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KanjiVgComponentDto extends KanjiVgComponentDto {
  const _KanjiVgComponentDto({required this.element, this.position, this.variant, this.original, this.part, this.radical, this.phon, @JsonKey(name: 'trad_form') this.tradForm, @JsonKey(name: 'stroke_indices') required final  List<int> strokeIndices, required final  List<KanjiVgComponentDto> children}): _strokeIndices = strokeIndices,_children = children,super._();
  factory _KanjiVgComponentDto.fromJson(Map<String, dynamic> json) => _$KanjiVgComponentDtoFromJson(json);

@override final  String element;
@override final  String? position;
@override final  bool? variant;
@override final  String? original;
@override final  int? part;
@override final  String? radical;
@override final  String? phon;
@override@JsonKey(name: 'trad_form') final  String? tradForm;
 final  List<int> _strokeIndices;
@override@JsonKey(name: 'stroke_indices') List<int> get strokeIndices {
  if (_strokeIndices is EqualUnmodifiableListView) return _strokeIndices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_strokeIndices);
}

 final  List<KanjiVgComponentDto> _children;
@override List<KanjiVgComponentDto> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}


/// Create a copy of KanjiVgComponentDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KanjiVgComponentDtoCopyWith<_KanjiVgComponentDto> get copyWith => __$KanjiVgComponentDtoCopyWithImpl<_KanjiVgComponentDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KanjiVgComponentDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KanjiVgComponentDto&&(identical(other.element, element) || other.element == element)&&(identical(other.position, position) || other.position == position)&&(identical(other.variant, variant) || other.variant == variant)&&(identical(other.original, original) || other.original == original)&&(identical(other.part, part) || other.part == part)&&(identical(other.radical, radical) || other.radical == radical)&&(identical(other.phon, phon) || other.phon == phon)&&(identical(other.tradForm, tradForm) || other.tradForm == tradForm)&&const DeepCollectionEquality().equals(other._strokeIndices, _strokeIndices)&&const DeepCollectionEquality().equals(other._children, _children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,element,position,variant,original,part,radical,phon,tradForm,const DeepCollectionEquality().hash(_strokeIndices),const DeepCollectionEquality().hash(_children));

@override
String toString() {
  return 'KanjiVgComponentDto(element: $element, position: $position, variant: $variant, original: $original, part: $part, radical: $radical, phon: $phon, tradForm: $tradForm, strokeIndices: $strokeIndices, children: $children)';
}


}

/// @nodoc
abstract mixin class _$KanjiVgComponentDtoCopyWith<$Res> implements $KanjiVgComponentDtoCopyWith<$Res> {
  factory _$KanjiVgComponentDtoCopyWith(_KanjiVgComponentDto value, $Res Function(_KanjiVgComponentDto) _then) = __$KanjiVgComponentDtoCopyWithImpl;
@override @useResult
$Res call({
 String element, String? position, bool? variant, String? original, int? part, String? radical, String? phon,@JsonKey(name: 'trad_form') String? tradForm,@JsonKey(name: 'stroke_indices') List<int> strokeIndices, List<KanjiVgComponentDto> children
});




}
/// @nodoc
class __$KanjiVgComponentDtoCopyWithImpl<$Res>
    implements _$KanjiVgComponentDtoCopyWith<$Res> {
  __$KanjiVgComponentDtoCopyWithImpl(this._self, this._then);

  final _KanjiVgComponentDto _self;
  final $Res Function(_KanjiVgComponentDto) _then;

/// Create a copy of KanjiVgComponentDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? element = null,Object? position = freezed,Object? variant = freezed,Object? original = freezed,Object? part = freezed,Object? radical = freezed,Object? phon = freezed,Object? tradForm = freezed,Object? strokeIndices = null,Object? children = null,}) {
  return _then(_KanjiVgComponentDto(
element: null == element ? _self.element : element // ignore: cast_nullable_to_non_nullable
as String,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String?,variant: freezed == variant ? _self.variant : variant // ignore: cast_nullable_to_non_nullable
as bool?,original: freezed == original ? _self.original : original // ignore: cast_nullable_to_non_nullable
as String?,part: freezed == part ? _self.part : part // ignore: cast_nullable_to_non_nullable
as int?,radical: freezed == radical ? _self.radical : radical // ignore: cast_nullable_to_non_nullable
as String?,phon: freezed == phon ? _self.phon : phon // ignore: cast_nullable_to_non_nullable
as String?,tradForm: freezed == tradForm ? _self.tradForm : tradForm // ignore: cast_nullable_to_non_nullable
as String?,strokeIndices: null == strokeIndices ? _self._strokeIndices : strokeIndices // ignore: cast_nullable_to_non_nullable
as List<int>,children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<KanjiVgComponentDto>,
  ));
}


}

// dart format on
