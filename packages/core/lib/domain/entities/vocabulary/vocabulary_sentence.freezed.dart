// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vocabulary_sentence.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VocabularySentence {

 int get id; int get vocabularyId; String get langCode; String get sentenceJa; String get sentenceFurigana; String get sentenceTranslated; VerificationStatus get verificationStatus; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of VocabularySentence
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VocabularySentenceCopyWith<VocabularySentence> get copyWith => _$VocabularySentenceCopyWithImpl<VocabularySentence>(this as VocabularySentence, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VocabularySentence&&(identical(other.id, id) || other.id == id)&&(identical(other.vocabularyId, vocabularyId) || other.vocabularyId == vocabularyId)&&(identical(other.langCode, langCode) || other.langCode == langCode)&&(identical(other.sentenceJa, sentenceJa) || other.sentenceJa == sentenceJa)&&(identical(other.sentenceFurigana, sentenceFurigana) || other.sentenceFurigana == sentenceFurigana)&&(identical(other.sentenceTranslated, sentenceTranslated) || other.sentenceTranslated == sentenceTranslated)&&(identical(other.verificationStatus, verificationStatus) || other.verificationStatus == verificationStatus)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,vocabularyId,langCode,sentenceJa,sentenceFurigana,sentenceTranslated,verificationStatus,createdAt,updatedAt);

@override
String toString() {
  return 'VocabularySentence(id: $id, vocabularyId: $vocabularyId, langCode: $langCode, sentenceJa: $sentenceJa, sentenceFurigana: $sentenceFurigana, sentenceTranslated: $sentenceTranslated, verificationStatus: $verificationStatus, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $VocabularySentenceCopyWith<$Res>  {
  factory $VocabularySentenceCopyWith(VocabularySentence value, $Res Function(VocabularySentence) _then) = _$VocabularySentenceCopyWithImpl;
@useResult
$Res call({
 int id, int vocabularyId, String langCode, String sentenceJa, String sentenceFurigana, String sentenceTranslated, VerificationStatus verificationStatus, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$VocabularySentenceCopyWithImpl<$Res>
    implements $VocabularySentenceCopyWith<$Res> {
  _$VocabularySentenceCopyWithImpl(this._self, this._then);

  final VocabularySentence _self;
  final $Res Function(VocabularySentence) _then;

/// Create a copy of VocabularySentence
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? vocabularyId = null,Object? langCode = null,Object? sentenceJa = null,Object? sentenceFurigana = null,Object? sentenceTranslated = null,Object? verificationStatus = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,vocabularyId: null == vocabularyId ? _self.vocabularyId : vocabularyId // ignore: cast_nullable_to_non_nullable
as int,langCode: null == langCode ? _self.langCode : langCode // ignore: cast_nullable_to_non_nullable
as String,sentenceJa: null == sentenceJa ? _self.sentenceJa : sentenceJa // ignore: cast_nullable_to_non_nullable
as String,sentenceFurigana: null == sentenceFurigana ? _self.sentenceFurigana : sentenceFurigana // ignore: cast_nullable_to_non_nullable
as String,sentenceTranslated: null == sentenceTranslated ? _self.sentenceTranslated : sentenceTranslated // ignore: cast_nullable_to_non_nullable
as String,verificationStatus: null == verificationStatus ? _self.verificationStatus : verificationStatus // ignore: cast_nullable_to_non_nullable
as VerificationStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [VocabularySentence].
extension VocabularySentencePatterns on VocabularySentence {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VocabularySentence value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VocabularySentence() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VocabularySentence value)  $default,){
final _that = this;
switch (_that) {
case _VocabularySentence():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VocabularySentence value)?  $default,){
final _that = this;
switch (_that) {
case _VocabularySentence() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int vocabularyId,  String langCode,  String sentenceJa,  String sentenceFurigana,  String sentenceTranslated,  VerificationStatus verificationStatus,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VocabularySentence() when $default != null:
return $default(_that.id,_that.vocabularyId,_that.langCode,_that.sentenceJa,_that.sentenceFurigana,_that.sentenceTranslated,_that.verificationStatus,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int vocabularyId,  String langCode,  String sentenceJa,  String sentenceFurigana,  String sentenceTranslated,  VerificationStatus verificationStatus,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _VocabularySentence():
return $default(_that.id,_that.vocabularyId,_that.langCode,_that.sentenceJa,_that.sentenceFurigana,_that.sentenceTranslated,_that.verificationStatus,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int vocabularyId,  String langCode,  String sentenceJa,  String sentenceFurigana,  String sentenceTranslated,  VerificationStatus verificationStatus,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _VocabularySentence() when $default != null:
return $default(_that.id,_that.vocabularyId,_that.langCode,_that.sentenceJa,_that.sentenceFurigana,_that.sentenceTranslated,_that.verificationStatus,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _VocabularySentence implements VocabularySentence {
  const _VocabularySentence({required this.id, required this.vocabularyId, required this.langCode, required this.sentenceJa, required this.sentenceFurigana, required this.sentenceTranslated, required this.verificationStatus, required this.createdAt, required this.updatedAt});
  

@override final  int id;
@override final  int vocabularyId;
@override final  String langCode;
@override final  String sentenceJa;
@override final  String sentenceFurigana;
@override final  String sentenceTranslated;
@override final  VerificationStatus verificationStatus;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of VocabularySentence
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VocabularySentenceCopyWith<_VocabularySentence> get copyWith => __$VocabularySentenceCopyWithImpl<_VocabularySentence>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VocabularySentence&&(identical(other.id, id) || other.id == id)&&(identical(other.vocabularyId, vocabularyId) || other.vocabularyId == vocabularyId)&&(identical(other.langCode, langCode) || other.langCode == langCode)&&(identical(other.sentenceJa, sentenceJa) || other.sentenceJa == sentenceJa)&&(identical(other.sentenceFurigana, sentenceFurigana) || other.sentenceFurigana == sentenceFurigana)&&(identical(other.sentenceTranslated, sentenceTranslated) || other.sentenceTranslated == sentenceTranslated)&&(identical(other.verificationStatus, verificationStatus) || other.verificationStatus == verificationStatus)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,vocabularyId,langCode,sentenceJa,sentenceFurigana,sentenceTranslated,verificationStatus,createdAt,updatedAt);

@override
String toString() {
  return 'VocabularySentence(id: $id, vocabularyId: $vocabularyId, langCode: $langCode, sentenceJa: $sentenceJa, sentenceFurigana: $sentenceFurigana, sentenceTranslated: $sentenceTranslated, verificationStatus: $verificationStatus, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$VocabularySentenceCopyWith<$Res> implements $VocabularySentenceCopyWith<$Res> {
  factory _$VocabularySentenceCopyWith(_VocabularySentence value, $Res Function(_VocabularySentence) _then) = __$VocabularySentenceCopyWithImpl;
@override @useResult
$Res call({
 int id, int vocabularyId, String langCode, String sentenceJa, String sentenceFurigana, String sentenceTranslated, VerificationStatus verificationStatus, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$VocabularySentenceCopyWithImpl<$Res>
    implements _$VocabularySentenceCopyWith<$Res> {
  __$VocabularySentenceCopyWithImpl(this._self, this._then);

  final _VocabularySentence _self;
  final $Res Function(_VocabularySentence) _then;

/// Create a copy of VocabularySentence
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? vocabularyId = null,Object? langCode = null,Object? sentenceJa = null,Object? sentenceFurigana = null,Object? sentenceTranslated = null,Object? verificationStatus = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_VocabularySentence(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,vocabularyId: null == vocabularyId ? _self.vocabularyId : vocabularyId // ignore: cast_nullable_to_non_nullable
as int,langCode: null == langCode ? _self.langCode : langCode // ignore: cast_nullable_to_non_nullable
as String,sentenceJa: null == sentenceJa ? _self.sentenceJa : sentenceJa // ignore: cast_nullable_to_non_nullable
as String,sentenceFurigana: null == sentenceFurigana ? _self.sentenceFurigana : sentenceFurigana // ignore: cast_nullable_to_non_nullable
as String,sentenceTranslated: null == sentenceTranslated ? _self.sentenceTranslated : sentenceTranslated // ignore: cast_nullable_to_non_nullable
as String,verificationStatus: null == verificationStatus ? _self.verificationStatus : verificationStatus // ignore: cast_nullable_to_non_nullable
as VerificationStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
