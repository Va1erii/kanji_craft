// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'raw_kanjivg.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RawKanjiVg {

 int get importId; String get character; String get unicodeHex; String get viewBox; int get strokeCount; List<KanjiVgStroke> get strokes; KanjiVgComponent get components; DateTime get createdAt;
/// Create a copy of RawKanjiVg
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RawKanjiVgCopyWith<RawKanjiVg> get copyWith => _$RawKanjiVgCopyWithImpl<RawKanjiVg>(this as RawKanjiVg, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RawKanjiVg&&(identical(other.importId, importId) || other.importId == importId)&&(identical(other.character, character) || other.character == character)&&(identical(other.unicodeHex, unicodeHex) || other.unicodeHex == unicodeHex)&&(identical(other.viewBox, viewBox) || other.viewBox == viewBox)&&(identical(other.strokeCount, strokeCount) || other.strokeCount == strokeCount)&&const DeepCollectionEquality().equals(other.strokes, strokes)&&(identical(other.components, components) || other.components == components)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,importId,character,unicodeHex,viewBox,strokeCount,const DeepCollectionEquality().hash(strokes),components,createdAt);

@override
String toString() {
  return 'RawKanjiVg(importId: $importId, character: $character, unicodeHex: $unicodeHex, viewBox: $viewBox, strokeCount: $strokeCount, strokes: $strokes, components: $components, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $RawKanjiVgCopyWith<$Res>  {
  factory $RawKanjiVgCopyWith(RawKanjiVg value, $Res Function(RawKanjiVg) _then) = _$RawKanjiVgCopyWithImpl;
@useResult
$Res call({
 int importId, String character, String unicodeHex, String viewBox, int strokeCount, List<KanjiVgStroke> strokes, KanjiVgComponent components, DateTime createdAt
});


$KanjiVgComponentCopyWith<$Res> get components;

}
/// @nodoc
class _$RawKanjiVgCopyWithImpl<$Res>
    implements $RawKanjiVgCopyWith<$Res> {
  _$RawKanjiVgCopyWithImpl(this._self, this._then);

  final RawKanjiVg _self;
  final $Res Function(RawKanjiVg) _then;

/// Create a copy of RawKanjiVg
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? importId = null,Object? character = null,Object? unicodeHex = null,Object? viewBox = null,Object? strokeCount = null,Object? strokes = null,Object? components = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
importId: null == importId ? _self.importId : importId // ignore: cast_nullable_to_non_nullable
as int,character: null == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String,unicodeHex: null == unicodeHex ? _self.unicodeHex : unicodeHex // ignore: cast_nullable_to_non_nullable
as String,viewBox: null == viewBox ? _self.viewBox : viewBox // ignore: cast_nullable_to_non_nullable
as String,strokeCount: null == strokeCount ? _self.strokeCount : strokeCount // ignore: cast_nullable_to_non_nullable
as int,strokes: null == strokes ? _self.strokes : strokes // ignore: cast_nullable_to_non_nullable
as List<KanjiVgStroke>,components: null == components ? _self.components : components // ignore: cast_nullable_to_non_nullable
as KanjiVgComponent,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of RawKanjiVg
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KanjiVgComponentCopyWith<$Res> get components {
  
  return $KanjiVgComponentCopyWith<$Res>(_self.components, (value) {
    return _then(_self.copyWith(components: value));
  });
}
}


/// Adds pattern-matching-related methods to [RawKanjiVg].
extension RawKanjiVgPatterns on RawKanjiVg {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RawKanjiVg value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RawKanjiVg() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RawKanjiVg value)  $default,){
final _that = this;
switch (_that) {
case _RawKanjiVg():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RawKanjiVg value)?  $default,){
final _that = this;
switch (_that) {
case _RawKanjiVg() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int importId,  String character,  String unicodeHex,  String viewBox,  int strokeCount,  List<KanjiVgStroke> strokes,  KanjiVgComponent components,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RawKanjiVg() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int importId,  String character,  String unicodeHex,  String viewBox,  int strokeCount,  List<KanjiVgStroke> strokes,  KanjiVgComponent components,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _RawKanjiVg():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int importId,  String character,  String unicodeHex,  String viewBox,  int strokeCount,  List<KanjiVgStroke> strokes,  KanjiVgComponent components,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _RawKanjiVg() when $default != null:
return $default(_that.importId,_that.character,_that.unicodeHex,_that.viewBox,_that.strokeCount,_that.strokes,_that.components,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _RawKanjiVg implements RawKanjiVg {
  const _RawKanjiVg({required this.importId, required this.character, required this.unicodeHex, required this.viewBox, required this.strokeCount, required final  List<KanjiVgStroke> strokes, required this.components, required this.createdAt}): _strokes = strokes;
  

@override final  int importId;
@override final  String character;
@override final  String unicodeHex;
@override final  String viewBox;
@override final  int strokeCount;
 final  List<KanjiVgStroke> _strokes;
@override List<KanjiVgStroke> get strokes {
  if (_strokes is EqualUnmodifiableListView) return _strokes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_strokes);
}

@override final  KanjiVgComponent components;
@override final  DateTime createdAt;

/// Create a copy of RawKanjiVg
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RawKanjiVgCopyWith<_RawKanjiVg> get copyWith => __$RawKanjiVgCopyWithImpl<_RawKanjiVg>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RawKanjiVg&&(identical(other.importId, importId) || other.importId == importId)&&(identical(other.character, character) || other.character == character)&&(identical(other.unicodeHex, unicodeHex) || other.unicodeHex == unicodeHex)&&(identical(other.viewBox, viewBox) || other.viewBox == viewBox)&&(identical(other.strokeCount, strokeCount) || other.strokeCount == strokeCount)&&const DeepCollectionEquality().equals(other._strokes, _strokes)&&(identical(other.components, components) || other.components == components)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,importId,character,unicodeHex,viewBox,strokeCount,const DeepCollectionEquality().hash(_strokes),components,createdAt);

@override
String toString() {
  return 'RawKanjiVg(importId: $importId, character: $character, unicodeHex: $unicodeHex, viewBox: $viewBox, strokeCount: $strokeCount, strokes: $strokes, components: $components, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$RawKanjiVgCopyWith<$Res> implements $RawKanjiVgCopyWith<$Res> {
  factory _$RawKanjiVgCopyWith(_RawKanjiVg value, $Res Function(_RawKanjiVg) _then) = __$RawKanjiVgCopyWithImpl;
@override @useResult
$Res call({
 int importId, String character, String unicodeHex, String viewBox, int strokeCount, List<KanjiVgStroke> strokes, KanjiVgComponent components, DateTime createdAt
});


@override $KanjiVgComponentCopyWith<$Res> get components;

}
/// @nodoc
class __$RawKanjiVgCopyWithImpl<$Res>
    implements _$RawKanjiVgCopyWith<$Res> {
  __$RawKanjiVgCopyWithImpl(this._self, this._then);

  final _RawKanjiVg _self;
  final $Res Function(_RawKanjiVg) _then;

/// Create a copy of RawKanjiVg
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? importId = null,Object? character = null,Object? unicodeHex = null,Object? viewBox = null,Object? strokeCount = null,Object? strokes = null,Object? components = null,Object? createdAt = null,}) {
  return _then(_RawKanjiVg(
importId: null == importId ? _self.importId : importId // ignore: cast_nullable_to_non_nullable
as int,character: null == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String,unicodeHex: null == unicodeHex ? _self.unicodeHex : unicodeHex // ignore: cast_nullable_to_non_nullable
as String,viewBox: null == viewBox ? _self.viewBox : viewBox // ignore: cast_nullable_to_non_nullable
as String,strokeCount: null == strokeCount ? _self.strokeCount : strokeCount // ignore: cast_nullable_to_non_nullable
as int,strokes: null == strokes ? _self._strokes : strokes // ignore: cast_nullable_to_non_nullable
as List<KanjiVgStroke>,components: null == components ? _self.components : components // ignore: cast_nullable_to_non_nullable
as KanjiVgComponent,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of RawKanjiVg
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KanjiVgComponentCopyWith<$Res> get components {
  
  return $KanjiVgComponentCopyWith<$Res>(_self.components, (value) {
    return _then(_self.copyWith(components: value));
  });
}
}

/// @nodoc
mixin _$KanjiVgStroke {

 int get number; String get type; String get pathData;
/// Create a copy of KanjiVgStroke
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KanjiVgStrokeCopyWith<KanjiVgStroke> get copyWith => _$KanjiVgStrokeCopyWithImpl<KanjiVgStroke>(this as KanjiVgStroke, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KanjiVgStroke&&(identical(other.number, number) || other.number == number)&&(identical(other.type, type) || other.type == type)&&(identical(other.pathData, pathData) || other.pathData == pathData));
}


@override
int get hashCode => Object.hash(runtimeType,number,type,pathData);

@override
String toString() {
  return 'KanjiVgStroke(number: $number, type: $type, pathData: $pathData)';
}


}

/// @nodoc
abstract mixin class $KanjiVgStrokeCopyWith<$Res>  {
  factory $KanjiVgStrokeCopyWith(KanjiVgStroke value, $Res Function(KanjiVgStroke) _then) = _$KanjiVgStrokeCopyWithImpl;
@useResult
$Res call({
 int number, String type, String pathData
});




}
/// @nodoc
class _$KanjiVgStrokeCopyWithImpl<$Res>
    implements $KanjiVgStrokeCopyWith<$Res> {
  _$KanjiVgStrokeCopyWithImpl(this._self, this._then);

  final KanjiVgStroke _self;
  final $Res Function(KanjiVgStroke) _then;

/// Create a copy of KanjiVgStroke
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


/// Adds pattern-matching-related methods to [KanjiVgStroke].
extension KanjiVgStrokePatterns on KanjiVgStroke {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KanjiVgStroke value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KanjiVgStroke() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KanjiVgStroke value)  $default,){
final _that = this;
switch (_that) {
case _KanjiVgStroke():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KanjiVgStroke value)?  $default,){
final _that = this;
switch (_that) {
case _KanjiVgStroke() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int number,  String type,  String pathData)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KanjiVgStroke() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int number,  String type,  String pathData)  $default,) {final _that = this;
switch (_that) {
case _KanjiVgStroke():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int number,  String type,  String pathData)?  $default,) {final _that = this;
switch (_that) {
case _KanjiVgStroke() when $default != null:
return $default(_that.number,_that.type,_that.pathData);case _:
  return null;

}
}

}

/// @nodoc


class _KanjiVgStroke implements KanjiVgStroke {
  const _KanjiVgStroke({required this.number, required this.type, required this.pathData});
  

@override final  int number;
@override final  String type;
@override final  String pathData;

/// Create a copy of KanjiVgStroke
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KanjiVgStrokeCopyWith<_KanjiVgStroke> get copyWith => __$KanjiVgStrokeCopyWithImpl<_KanjiVgStroke>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KanjiVgStroke&&(identical(other.number, number) || other.number == number)&&(identical(other.type, type) || other.type == type)&&(identical(other.pathData, pathData) || other.pathData == pathData));
}


@override
int get hashCode => Object.hash(runtimeType,number,type,pathData);

@override
String toString() {
  return 'KanjiVgStroke(number: $number, type: $type, pathData: $pathData)';
}


}

/// @nodoc
abstract mixin class _$KanjiVgStrokeCopyWith<$Res> implements $KanjiVgStrokeCopyWith<$Res> {
  factory _$KanjiVgStrokeCopyWith(_KanjiVgStroke value, $Res Function(_KanjiVgStroke) _then) = __$KanjiVgStrokeCopyWithImpl;
@override @useResult
$Res call({
 int number, String type, String pathData
});




}
/// @nodoc
class __$KanjiVgStrokeCopyWithImpl<$Res>
    implements _$KanjiVgStrokeCopyWith<$Res> {
  __$KanjiVgStrokeCopyWithImpl(this._self, this._then);

  final _KanjiVgStroke _self;
  final $Res Function(_KanjiVgStroke) _then;

/// Create a copy of KanjiVgStroke
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? number = null,Object? type = null,Object? pathData = null,}) {
  return _then(_KanjiVgStroke(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,pathData: null == pathData ? _self.pathData : pathData // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$KanjiVgComponent {

 String get element; String? get position; bool? get variant; String? get original; int? get part; int? get number; String? get radical; String? get phon; String? get tradForm; bool? get partial; bool? get radicalForm; List<int> get strokeIndices; List<KanjiVgComponent> get children;
/// Create a copy of KanjiVgComponent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KanjiVgComponentCopyWith<KanjiVgComponent> get copyWith => _$KanjiVgComponentCopyWithImpl<KanjiVgComponent>(this as KanjiVgComponent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KanjiVgComponent&&(identical(other.element, element) || other.element == element)&&(identical(other.position, position) || other.position == position)&&(identical(other.variant, variant) || other.variant == variant)&&(identical(other.original, original) || other.original == original)&&(identical(other.part, part) || other.part == part)&&(identical(other.number, number) || other.number == number)&&(identical(other.radical, radical) || other.radical == radical)&&(identical(other.phon, phon) || other.phon == phon)&&(identical(other.tradForm, tradForm) || other.tradForm == tradForm)&&(identical(other.partial, partial) || other.partial == partial)&&(identical(other.radicalForm, radicalForm) || other.radicalForm == radicalForm)&&const DeepCollectionEquality().equals(other.strokeIndices, strokeIndices)&&const DeepCollectionEquality().equals(other.children, children));
}


@override
int get hashCode => Object.hash(runtimeType,element,position,variant,original,part,number,radical,phon,tradForm,partial,radicalForm,const DeepCollectionEquality().hash(strokeIndices),const DeepCollectionEquality().hash(children));

@override
String toString() {
  return 'KanjiVgComponent(element: $element, position: $position, variant: $variant, original: $original, part: $part, number: $number, radical: $radical, phon: $phon, tradForm: $tradForm, partial: $partial, radicalForm: $radicalForm, strokeIndices: $strokeIndices, children: $children)';
}


}

/// @nodoc
abstract mixin class $KanjiVgComponentCopyWith<$Res>  {
  factory $KanjiVgComponentCopyWith(KanjiVgComponent value, $Res Function(KanjiVgComponent) _then) = _$KanjiVgComponentCopyWithImpl;
@useResult
$Res call({
 String element, String? position, bool? variant, String? original, int? part, int? number, String? radical, String? phon, String? tradForm, bool? partial, bool? radicalForm, List<int> strokeIndices, List<KanjiVgComponent> children
});




}
/// @nodoc
class _$KanjiVgComponentCopyWithImpl<$Res>
    implements $KanjiVgComponentCopyWith<$Res> {
  _$KanjiVgComponentCopyWithImpl(this._self, this._then);

  final KanjiVgComponent _self;
  final $Res Function(KanjiVgComponent) _then;

/// Create a copy of KanjiVgComponent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? element = null,Object? position = freezed,Object? variant = freezed,Object? original = freezed,Object? part = freezed,Object? number = freezed,Object? radical = freezed,Object? phon = freezed,Object? tradForm = freezed,Object? partial = freezed,Object? radicalForm = freezed,Object? strokeIndices = null,Object? children = null,}) {
  return _then(_self.copyWith(
element: null == element ? _self.element : element // ignore: cast_nullable_to_non_nullable
as String,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String?,variant: freezed == variant ? _self.variant : variant // ignore: cast_nullable_to_non_nullable
as bool?,original: freezed == original ? _self.original : original // ignore: cast_nullable_to_non_nullable
as String?,part: freezed == part ? _self.part : part // ignore: cast_nullable_to_non_nullable
as int?,number: freezed == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int?,radical: freezed == radical ? _self.radical : radical // ignore: cast_nullable_to_non_nullable
as String?,phon: freezed == phon ? _self.phon : phon // ignore: cast_nullable_to_non_nullable
as String?,tradForm: freezed == tradForm ? _self.tradForm : tradForm // ignore: cast_nullable_to_non_nullable
as String?,partial: freezed == partial ? _self.partial : partial // ignore: cast_nullable_to_non_nullable
as bool?,radicalForm: freezed == radicalForm ? _self.radicalForm : radicalForm // ignore: cast_nullable_to_non_nullable
as bool?,strokeIndices: null == strokeIndices ? _self.strokeIndices : strokeIndices // ignore: cast_nullable_to_non_nullable
as List<int>,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<KanjiVgComponent>,
  ));
}

}


/// Adds pattern-matching-related methods to [KanjiVgComponent].
extension KanjiVgComponentPatterns on KanjiVgComponent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KanjiVgComponent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KanjiVgComponent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KanjiVgComponent value)  $default,){
final _that = this;
switch (_that) {
case _KanjiVgComponent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KanjiVgComponent value)?  $default,){
final _that = this;
switch (_that) {
case _KanjiVgComponent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String element,  String? position,  bool? variant,  String? original,  int? part,  int? number,  String? radical,  String? phon,  String? tradForm,  bool? partial,  bool? radicalForm,  List<int> strokeIndices,  List<KanjiVgComponent> children)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KanjiVgComponent() when $default != null:
return $default(_that.element,_that.position,_that.variant,_that.original,_that.part,_that.number,_that.radical,_that.phon,_that.tradForm,_that.partial,_that.radicalForm,_that.strokeIndices,_that.children);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String element,  String? position,  bool? variant,  String? original,  int? part,  int? number,  String? radical,  String? phon,  String? tradForm,  bool? partial,  bool? radicalForm,  List<int> strokeIndices,  List<KanjiVgComponent> children)  $default,) {final _that = this;
switch (_that) {
case _KanjiVgComponent():
return $default(_that.element,_that.position,_that.variant,_that.original,_that.part,_that.number,_that.radical,_that.phon,_that.tradForm,_that.partial,_that.radicalForm,_that.strokeIndices,_that.children);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String element,  String? position,  bool? variant,  String? original,  int? part,  int? number,  String? radical,  String? phon,  String? tradForm,  bool? partial,  bool? radicalForm,  List<int> strokeIndices,  List<KanjiVgComponent> children)?  $default,) {final _that = this;
switch (_that) {
case _KanjiVgComponent() when $default != null:
return $default(_that.element,_that.position,_that.variant,_that.original,_that.part,_that.number,_that.radical,_that.phon,_that.tradForm,_that.partial,_that.radicalForm,_that.strokeIndices,_that.children);case _:
  return null;

}
}

}

/// @nodoc


class _KanjiVgComponent implements KanjiVgComponent {
  const _KanjiVgComponent({required this.element, this.position, this.variant, this.original, this.part, this.number, this.radical, this.phon, this.tradForm, this.partial, this.radicalForm, required final  List<int> strokeIndices, required final  List<KanjiVgComponent> children}): _strokeIndices = strokeIndices,_children = children;
  

@override final  String element;
@override final  String? position;
@override final  bool? variant;
@override final  String? original;
@override final  int? part;
@override final  int? number;
@override final  String? radical;
@override final  String? phon;
@override final  String? tradForm;
@override final  bool? partial;
@override final  bool? radicalForm;
 final  List<int> _strokeIndices;
@override List<int> get strokeIndices {
  if (_strokeIndices is EqualUnmodifiableListView) return _strokeIndices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_strokeIndices);
}

 final  List<KanjiVgComponent> _children;
@override List<KanjiVgComponent> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}


/// Create a copy of KanjiVgComponent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KanjiVgComponentCopyWith<_KanjiVgComponent> get copyWith => __$KanjiVgComponentCopyWithImpl<_KanjiVgComponent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KanjiVgComponent&&(identical(other.element, element) || other.element == element)&&(identical(other.position, position) || other.position == position)&&(identical(other.variant, variant) || other.variant == variant)&&(identical(other.original, original) || other.original == original)&&(identical(other.part, part) || other.part == part)&&(identical(other.number, number) || other.number == number)&&(identical(other.radical, radical) || other.radical == radical)&&(identical(other.phon, phon) || other.phon == phon)&&(identical(other.tradForm, tradForm) || other.tradForm == tradForm)&&(identical(other.partial, partial) || other.partial == partial)&&(identical(other.radicalForm, radicalForm) || other.radicalForm == radicalForm)&&const DeepCollectionEquality().equals(other._strokeIndices, _strokeIndices)&&const DeepCollectionEquality().equals(other._children, _children));
}


@override
int get hashCode => Object.hash(runtimeType,element,position,variant,original,part,number,radical,phon,tradForm,partial,radicalForm,const DeepCollectionEquality().hash(_strokeIndices),const DeepCollectionEquality().hash(_children));

@override
String toString() {
  return 'KanjiVgComponent(element: $element, position: $position, variant: $variant, original: $original, part: $part, number: $number, radical: $radical, phon: $phon, tradForm: $tradForm, partial: $partial, radicalForm: $radicalForm, strokeIndices: $strokeIndices, children: $children)';
}


}

/// @nodoc
abstract mixin class _$KanjiVgComponentCopyWith<$Res> implements $KanjiVgComponentCopyWith<$Res> {
  factory _$KanjiVgComponentCopyWith(_KanjiVgComponent value, $Res Function(_KanjiVgComponent) _then) = __$KanjiVgComponentCopyWithImpl;
@override @useResult
$Res call({
 String element, String? position, bool? variant, String? original, int? part, int? number, String? radical, String? phon, String? tradForm, bool? partial, bool? radicalForm, List<int> strokeIndices, List<KanjiVgComponent> children
});




}
/// @nodoc
class __$KanjiVgComponentCopyWithImpl<$Res>
    implements _$KanjiVgComponentCopyWith<$Res> {
  __$KanjiVgComponentCopyWithImpl(this._self, this._then);

  final _KanjiVgComponent _self;
  final $Res Function(_KanjiVgComponent) _then;

/// Create a copy of KanjiVgComponent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? element = null,Object? position = freezed,Object? variant = freezed,Object? original = freezed,Object? part = freezed,Object? number = freezed,Object? radical = freezed,Object? phon = freezed,Object? tradForm = freezed,Object? partial = freezed,Object? radicalForm = freezed,Object? strokeIndices = null,Object? children = null,}) {
  return _then(_KanjiVgComponent(
element: null == element ? _self.element : element // ignore: cast_nullable_to_non_nullable
as String,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String?,variant: freezed == variant ? _self.variant : variant // ignore: cast_nullable_to_non_nullable
as bool?,original: freezed == original ? _self.original : original // ignore: cast_nullable_to_non_nullable
as String?,part: freezed == part ? _self.part : part // ignore: cast_nullable_to_non_nullable
as int?,number: freezed == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int?,radical: freezed == radical ? _self.radical : radical // ignore: cast_nullable_to_non_nullable
as String?,phon: freezed == phon ? _self.phon : phon // ignore: cast_nullable_to_non_nullable
as String?,tradForm: freezed == tradForm ? _self.tradForm : tradForm // ignore: cast_nullable_to_non_nullable
as String?,partial: freezed == partial ? _self.partial : partial // ignore: cast_nullable_to_non_nullable
as bool?,radicalForm: freezed == radicalForm ? _self.radicalForm : radicalForm // ignore: cast_nullable_to_non_nullable
as bool?,strokeIndices: null == strokeIndices ? _self._strokeIndices : strokeIndices // ignore: cast_nullable_to_non_nullable
as List<int>,children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<KanjiVgComponent>,
  ));
}


}

// dart format on
