// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vocabulary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Vocabulary {

 int get id; String get word; List<VocabularySegment> get segments; int? get minJlptLevel; List<PosTag> get posTags; List<MiscTag> get miscTags; List<String> get fieldTags; List<String> get dialectTags; int get frequencyRank; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Vocabulary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VocabularyCopyWith<Vocabulary> get copyWith => _$VocabularyCopyWithImpl<Vocabulary>(this as Vocabulary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Vocabulary&&(identical(other.id, id) || other.id == id)&&(identical(other.word, word) || other.word == word)&&const DeepCollectionEquality().equals(other.segments, segments)&&(identical(other.minJlptLevel, minJlptLevel) || other.minJlptLevel == minJlptLevel)&&const DeepCollectionEquality().equals(other.posTags, posTags)&&const DeepCollectionEquality().equals(other.miscTags, miscTags)&&const DeepCollectionEquality().equals(other.fieldTags, fieldTags)&&const DeepCollectionEquality().equals(other.dialectTags, dialectTags)&&(identical(other.frequencyRank, frequencyRank) || other.frequencyRank == frequencyRank)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,word,const DeepCollectionEquality().hash(segments),minJlptLevel,const DeepCollectionEquality().hash(posTags),const DeepCollectionEquality().hash(miscTags),const DeepCollectionEquality().hash(fieldTags),const DeepCollectionEquality().hash(dialectTags),frequencyRank,createdAt,updatedAt);

@override
String toString() {
  return 'Vocabulary(id: $id, word: $word, segments: $segments, minJlptLevel: $minJlptLevel, posTags: $posTags, miscTags: $miscTags, fieldTags: $fieldTags, dialectTags: $dialectTags, frequencyRank: $frequencyRank, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $VocabularyCopyWith<$Res>  {
  factory $VocabularyCopyWith(Vocabulary value, $Res Function(Vocabulary) _then) = _$VocabularyCopyWithImpl;
@useResult
$Res call({
 int id, String word, List<VocabularySegment> segments, int? minJlptLevel, List<PosTag> posTags, List<MiscTag> miscTags, List<String> fieldTags, List<String> dialectTags, int frequencyRank, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$VocabularyCopyWithImpl<$Res>
    implements $VocabularyCopyWith<$Res> {
  _$VocabularyCopyWithImpl(this._self, this._then);

  final Vocabulary _self;
  final $Res Function(Vocabulary) _then;

/// Create a copy of Vocabulary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? word = null,Object? segments = null,Object? minJlptLevel = freezed,Object? posTags = null,Object? miscTags = null,Object? fieldTags = null,Object? dialectTags = null,Object? frequencyRank = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,segments: null == segments ? _self.segments : segments // ignore: cast_nullable_to_non_nullable
as List<VocabularySegment>,minJlptLevel: freezed == minJlptLevel ? _self.minJlptLevel : minJlptLevel // ignore: cast_nullable_to_non_nullable
as int?,posTags: null == posTags ? _self.posTags : posTags // ignore: cast_nullable_to_non_nullable
as List<PosTag>,miscTags: null == miscTags ? _self.miscTags : miscTags // ignore: cast_nullable_to_non_nullable
as List<MiscTag>,fieldTags: null == fieldTags ? _self.fieldTags : fieldTags // ignore: cast_nullable_to_non_nullable
as List<String>,dialectTags: null == dialectTags ? _self.dialectTags : dialectTags // ignore: cast_nullable_to_non_nullable
as List<String>,frequencyRank: null == frequencyRank ? _self.frequencyRank : frequencyRank // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Vocabulary].
extension VocabularyPatterns on Vocabulary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Vocabulary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Vocabulary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Vocabulary value)  $default,){
final _that = this;
switch (_that) {
case _Vocabulary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Vocabulary value)?  $default,){
final _that = this;
switch (_that) {
case _Vocabulary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String word,  List<VocabularySegment> segments,  int? minJlptLevel,  List<PosTag> posTags,  List<MiscTag> miscTags,  List<String> fieldTags,  List<String> dialectTags,  int frequencyRank,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Vocabulary() when $default != null:
return $default(_that.id,_that.word,_that.segments,_that.minJlptLevel,_that.posTags,_that.miscTags,_that.fieldTags,_that.dialectTags,_that.frequencyRank,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String word,  List<VocabularySegment> segments,  int? minJlptLevel,  List<PosTag> posTags,  List<MiscTag> miscTags,  List<String> fieldTags,  List<String> dialectTags,  int frequencyRank,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Vocabulary():
return $default(_that.id,_that.word,_that.segments,_that.minJlptLevel,_that.posTags,_that.miscTags,_that.fieldTags,_that.dialectTags,_that.frequencyRank,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String word,  List<VocabularySegment> segments,  int? minJlptLevel,  List<PosTag> posTags,  List<MiscTag> miscTags,  List<String> fieldTags,  List<String> dialectTags,  int frequencyRank,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Vocabulary() when $default != null:
return $default(_that.id,_that.word,_that.segments,_that.minJlptLevel,_that.posTags,_that.miscTags,_that.fieldTags,_that.dialectTags,_that.frequencyRank,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Vocabulary implements Vocabulary {
  const _Vocabulary({required this.id, required this.word, required final  List<VocabularySegment> segments, this.minJlptLevel, final  List<PosTag> posTags = const [], final  List<MiscTag> miscTags = const [], final  List<String> fieldTags = const [], final  List<String> dialectTags = const [], required this.frequencyRank, required this.createdAt, required this.updatedAt}): _segments = segments,_posTags = posTags,_miscTags = miscTags,_fieldTags = fieldTags,_dialectTags = dialectTags;
  

@override final  int id;
@override final  String word;
 final  List<VocabularySegment> _segments;
@override List<VocabularySegment> get segments {
  if (_segments is EqualUnmodifiableListView) return _segments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_segments);
}

@override final  int? minJlptLevel;
 final  List<PosTag> _posTags;
@override@JsonKey() List<PosTag> get posTags {
  if (_posTags is EqualUnmodifiableListView) return _posTags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_posTags);
}

 final  List<MiscTag> _miscTags;
@override@JsonKey() List<MiscTag> get miscTags {
  if (_miscTags is EqualUnmodifiableListView) return _miscTags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_miscTags);
}

 final  List<String> _fieldTags;
@override@JsonKey() List<String> get fieldTags {
  if (_fieldTags is EqualUnmodifiableListView) return _fieldTags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fieldTags);
}

 final  List<String> _dialectTags;
@override@JsonKey() List<String> get dialectTags {
  if (_dialectTags is EqualUnmodifiableListView) return _dialectTags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dialectTags);
}

@override final  int frequencyRank;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Vocabulary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VocabularyCopyWith<_Vocabulary> get copyWith => __$VocabularyCopyWithImpl<_Vocabulary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Vocabulary&&(identical(other.id, id) || other.id == id)&&(identical(other.word, word) || other.word == word)&&const DeepCollectionEquality().equals(other._segments, _segments)&&(identical(other.minJlptLevel, minJlptLevel) || other.minJlptLevel == minJlptLevel)&&const DeepCollectionEquality().equals(other._posTags, _posTags)&&const DeepCollectionEquality().equals(other._miscTags, _miscTags)&&const DeepCollectionEquality().equals(other._fieldTags, _fieldTags)&&const DeepCollectionEquality().equals(other._dialectTags, _dialectTags)&&(identical(other.frequencyRank, frequencyRank) || other.frequencyRank == frequencyRank)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,word,const DeepCollectionEquality().hash(_segments),minJlptLevel,const DeepCollectionEquality().hash(_posTags),const DeepCollectionEquality().hash(_miscTags),const DeepCollectionEquality().hash(_fieldTags),const DeepCollectionEquality().hash(_dialectTags),frequencyRank,createdAt,updatedAt);

@override
String toString() {
  return 'Vocabulary(id: $id, word: $word, segments: $segments, minJlptLevel: $minJlptLevel, posTags: $posTags, miscTags: $miscTags, fieldTags: $fieldTags, dialectTags: $dialectTags, frequencyRank: $frequencyRank, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$VocabularyCopyWith<$Res> implements $VocabularyCopyWith<$Res> {
  factory _$VocabularyCopyWith(_Vocabulary value, $Res Function(_Vocabulary) _then) = __$VocabularyCopyWithImpl;
@override @useResult
$Res call({
 int id, String word, List<VocabularySegment> segments, int? minJlptLevel, List<PosTag> posTags, List<MiscTag> miscTags, List<String> fieldTags, List<String> dialectTags, int frequencyRank, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$VocabularyCopyWithImpl<$Res>
    implements _$VocabularyCopyWith<$Res> {
  __$VocabularyCopyWithImpl(this._self, this._then);

  final _Vocabulary _self;
  final $Res Function(_Vocabulary) _then;

/// Create a copy of Vocabulary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? word = null,Object? segments = null,Object? minJlptLevel = freezed,Object? posTags = null,Object? miscTags = null,Object? fieldTags = null,Object? dialectTags = null,Object? frequencyRank = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Vocabulary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,segments: null == segments ? _self._segments : segments // ignore: cast_nullable_to_non_nullable
as List<VocabularySegment>,minJlptLevel: freezed == minJlptLevel ? _self.minJlptLevel : minJlptLevel // ignore: cast_nullable_to_non_nullable
as int?,posTags: null == posTags ? _self._posTags : posTags // ignore: cast_nullable_to_non_nullable
as List<PosTag>,miscTags: null == miscTags ? _self._miscTags : miscTags // ignore: cast_nullable_to_non_nullable
as List<MiscTag>,fieldTags: null == fieldTags ? _self._fieldTags : fieldTags // ignore: cast_nullable_to_non_nullable
as List<String>,dialectTags: null == dialectTags ? _self._dialectTags : dialectTags // ignore: cast_nullable_to_non_nullable
as List<String>,frequencyRank: null == frequencyRank ? _self.frequencyRank : frequencyRank // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
