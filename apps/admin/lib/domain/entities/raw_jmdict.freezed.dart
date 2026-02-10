// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'raw_jmdict.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RawJmdict {

 int get importId; int get entSeq; List<JmdictKanjiElement>? get kanjiElements; List<JmdictReadingElement> get readingElements; List<JmdictSense> get senses; List<JmdictExample>? get examples;
/// Create a copy of RawJmdict
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RawJmdictCopyWith<RawJmdict> get copyWith => _$RawJmdictCopyWithImpl<RawJmdict>(this as RawJmdict, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RawJmdict&&(identical(other.importId, importId) || other.importId == importId)&&(identical(other.entSeq, entSeq) || other.entSeq == entSeq)&&const DeepCollectionEquality().equals(other.kanjiElements, kanjiElements)&&const DeepCollectionEquality().equals(other.readingElements, readingElements)&&const DeepCollectionEquality().equals(other.senses, senses)&&const DeepCollectionEquality().equals(other.examples, examples));
}


@override
int get hashCode => Object.hash(runtimeType,importId,entSeq,const DeepCollectionEquality().hash(kanjiElements),const DeepCollectionEquality().hash(readingElements),const DeepCollectionEquality().hash(senses),const DeepCollectionEquality().hash(examples));

@override
String toString() {
  return 'RawJmdict(importId: $importId, entSeq: $entSeq, kanjiElements: $kanjiElements, readingElements: $readingElements, senses: $senses, examples: $examples)';
}


}

/// @nodoc
abstract mixin class $RawJmdictCopyWith<$Res>  {
  factory $RawJmdictCopyWith(RawJmdict value, $Res Function(RawJmdict) _then) = _$RawJmdictCopyWithImpl;
@useResult
$Res call({
 int importId, int entSeq, List<JmdictKanjiElement>? kanjiElements, List<JmdictReadingElement> readingElements, List<JmdictSense> senses, List<JmdictExample>? examples
});




}
/// @nodoc
class _$RawJmdictCopyWithImpl<$Res>
    implements $RawJmdictCopyWith<$Res> {
  _$RawJmdictCopyWithImpl(this._self, this._then);

  final RawJmdict _self;
  final $Res Function(RawJmdict) _then;

/// Create a copy of RawJmdict
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? importId = null,Object? entSeq = null,Object? kanjiElements = freezed,Object? readingElements = null,Object? senses = null,Object? examples = freezed,}) {
  return _then(_self.copyWith(
importId: null == importId ? _self.importId : importId // ignore: cast_nullable_to_non_nullable
as int,entSeq: null == entSeq ? _self.entSeq : entSeq // ignore: cast_nullable_to_non_nullable
as int,kanjiElements: freezed == kanjiElements ? _self.kanjiElements : kanjiElements // ignore: cast_nullable_to_non_nullable
as List<JmdictKanjiElement>?,readingElements: null == readingElements ? _self.readingElements : readingElements // ignore: cast_nullable_to_non_nullable
as List<JmdictReadingElement>,senses: null == senses ? _self.senses : senses // ignore: cast_nullable_to_non_nullable
as List<JmdictSense>,examples: freezed == examples ? _self.examples : examples // ignore: cast_nullable_to_non_nullable
as List<JmdictExample>?,
  ));
}

}


/// Adds pattern-matching-related methods to [RawJmdict].
extension RawJmdictPatterns on RawJmdict {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RawJmdict value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RawJmdict() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RawJmdict value)  $default,){
final _that = this;
switch (_that) {
case _RawJmdict():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RawJmdict value)?  $default,){
final _that = this;
switch (_that) {
case _RawJmdict() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int importId,  int entSeq,  List<JmdictKanjiElement>? kanjiElements,  List<JmdictReadingElement> readingElements,  List<JmdictSense> senses,  List<JmdictExample>? examples)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RawJmdict() when $default != null:
return $default(_that.importId,_that.entSeq,_that.kanjiElements,_that.readingElements,_that.senses,_that.examples);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int importId,  int entSeq,  List<JmdictKanjiElement>? kanjiElements,  List<JmdictReadingElement> readingElements,  List<JmdictSense> senses,  List<JmdictExample>? examples)  $default,) {final _that = this;
switch (_that) {
case _RawJmdict():
return $default(_that.importId,_that.entSeq,_that.kanjiElements,_that.readingElements,_that.senses,_that.examples);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int importId,  int entSeq,  List<JmdictKanjiElement>? kanjiElements,  List<JmdictReadingElement> readingElements,  List<JmdictSense> senses,  List<JmdictExample>? examples)?  $default,) {final _that = this;
switch (_that) {
case _RawJmdict() when $default != null:
return $default(_that.importId,_that.entSeq,_that.kanjiElements,_that.readingElements,_that.senses,_that.examples);case _:
  return null;

}
}

}

/// @nodoc


class _RawJmdict implements RawJmdict {
  const _RawJmdict({required this.importId, required this.entSeq, final  List<JmdictKanjiElement>? kanjiElements, required final  List<JmdictReadingElement> readingElements, required final  List<JmdictSense> senses, final  List<JmdictExample>? examples}): _kanjiElements = kanjiElements,_readingElements = readingElements,_senses = senses,_examples = examples;
  

@override final  int importId;
@override final  int entSeq;
 final  List<JmdictKanjiElement>? _kanjiElements;
@override List<JmdictKanjiElement>? get kanjiElements {
  final value = _kanjiElements;
  if (value == null) return null;
  if (_kanjiElements is EqualUnmodifiableListView) return _kanjiElements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<JmdictReadingElement> _readingElements;
@override List<JmdictReadingElement> get readingElements {
  if (_readingElements is EqualUnmodifiableListView) return _readingElements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_readingElements);
}

 final  List<JmdictSense> _senses;
@override List<JmdictSense> get senses {
  if (_senses is EqualUnmodifiableListView) return _senses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_senses);
}

 final  List<JmdictExample>? _examples;
@override List<JmdictExample>? get examples {
  final value = _examples;
  if (value == null) return null;
  if (_examples is EqualUnmodifiableListView) return _examples;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of RawJmdict
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RawJmdictCopyWith<_RawJmdict> get copyWith => __$RawJmdictCopyWithImpl<_RawJmdict>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RawJmdict&&(identical(other.importId, importId) || other.importId == importId)&&(identical(other.entSeq, entSeq) || other.entSeq == entSeq)&&const DeepCollectionEquality().equals(other._kanjiElements, _kanjiElements)&&const DeepCollectionEquality().equals(other._readingElements, _readingElements)&&const DeepCollectionEquality().equals(other._senses, _senses)&&const DeepCollectionEquality().equals(other._examples, _examples));
}


@override
int get hashCode => Object.hash(runtimeType,importId,entSeq,const DeepCollectionEquality().hash(_kanjiElements),const DeepCollectionEquality().hash(_readingElements),const DeepCollectionEquality().hash(_senses),const DeepCollectionEquality().hash(_examples));

@override
String toString() {
  return 'RawJmdict(importId: $importId, entSeq: $entSeq, kanjiElements: $kanjiElements, readingElements: $readingElements, senses: $senses, examples: $examples)';
}


}

/// @nodoc
abstract mixin class _$RawJmdictCopyWith<$Res> implements $RawJmdictCopyWith<$Res> {
  factory _$RawJmdictCopyWith(_RawJmdict value, $Res Function(_RawJmdict) _then) = __$RawJmdictCopyWithImpl;
@override @useResult
$Res call({
 int importId, int entSeq, List<JmdictKanjiElement>? kanjiElements, List<JmdictReadingElement> readingElements, List<JmdictSense> senses, List<JmdictExample>? examples
});




}
/// @nodoc
class __$RawJmdictCopyWithImpl<$Res>
    implements _$RawJmdictCopyWith<$Res> {
  __$RawJmdictCopyWithImpl(this._self, this._then);

  final _RawJmdict _self;
  final $Res Function(_RawJmdict) _then;

/// Create a copy of RawJmdict
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? importId = null,Object? entSeq = null,Object? kanjiElements = freezed,Object? readingElements = null,Object? senses = null,Object? examples = freezed,}) {
  return _then(_RawJmdict(
importId: null == importId ? _self.importId : importId // ignore: cast_nullable_to_non_nullable
as int,entSeq: null == entSeq ? _self.entSeq : entSeq // ignore: cast_nullable_to_non_nullable
as int,kanjiElements: freezed == kanjiElements ? _self._kanjiElements : kanjiElements // ignore: cast_nullable_to_non_nullable
as List<JmdictKanjiElement>?,readingElements: null == readingElements ? _self._readingElements : readingElements // ignore: cast_nullable_to_non_nullable
as List<JmdictReadingElement>,senses: null == senses ? _self._senses : senses // ignore: cast_nullable_to_non_nullable
as List<JmdictSense>,examples: freezed == examples ? _self._examples : examples // ignore: cast_nullable_to_non_nullable
as List<JmdictExample>?,
  ));
}


}

/// @nodoc
mixin _$JmdictKanjiElement {

 String get keb; List<String>? get keInf; List<String>? get kePri;
/// Create a copy of JmdictKanjiElement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JmdictKanjiElementCopyWith<JmdictKanjiElement> get copyWith => _$JmdictKanjiElementCopyWithImpl<JmdictKanjiElement>(this as JmdictKanjiElement, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JmdictKanjiElement&&(identical(other.keb, keb) || other.keb == keb)&&const DeepCollectionEquality().equals(other.keInf, keInf)&&const DeepCollectionEquality().equals(other.kePri, kePri));
}


@override
int get hashCode => Object.hash(runtimeType,keb,const DeepCollectionEquality().hash(keInf),const DeepCollectionEquality().hash(kePri));

@override
String toString() {
  return 'JmdictKanjiElement(keb: $keb, keInf: $keInf, kePri: $kePri)';
}


}

/// @nodoc
abstract mixin class $JmdictKanjiElementCopyWith<$Res>  {
  factory $JmdictKanjiElementCopyWith(JmdictKanjiElement value, $Res Function(JmdictKanjiElement) _then) = _$JmdictKanjiElementCopyWithImpl;
@useResult
$Res call({
 String keb, List<String>? keInf, List<String>? kePri
});




}
/// @nodoc
class _$JmdictKanjiElementCopyWithImpl<$Res>
    implements $JmdictKanjiElementCopyWith<$Res> {
  _$JmdictKanjiElementCopyWithImpl(this._self, this._then);

  final JmdictKanjiElement _self;
  final $Res Function(JmdictKanjiElement) _then;

/// Create a copy of JmdictKanjiElement
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


/// Adds pattern-matching-related methods to [JmdictKanjiElement].
extension JmdictKanjiElementPatterns on JmdictKanjiElement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JmdictKanjiElement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JmdictKanjiElement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JmdictKanjiElement value)  $default,){
final _that = this;
switch (_that) {
case _JmdictKanjiElement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JmdictKanjiElement value)?  $default,){
final _that = this;
switch (_that) {
case _JmdictKanjiElement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String keb,  List<String>? keInf,  List<String>? kePri)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JmdictKanjiElement() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String keb,  List<String>? keInf,  List<String>? kePri)  $default,) {final _that = this;
switch (_that) {
case _JmdictKanjiElement():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String keb,  List<String>? keInf,  List<String>? kePri)?  $default,) {final _that = this;
switch (_that) {
case _JmdictKanjiElement() when $default != null:
return $default(_that.keb,_that.keInf,_that.kePri);case _:
  return null;

}
}

}

/// @nodoc


class _JmdictKanjiElement implements JmdictKanjiElement {
  const _JmdictKanjiElement({required this.keb, final  List<String>? keInf, final  List<String>? kePri}): _keInf = keInf,_kePri = kePri;
  

@override final  String keb;
 final  List<String>? _keInf;
@override List<String>? get keInf {
  final value = _keInf;
  if (value == null) return null;
  if (_keInf is EqualUnmodifiableListView) return _keInf;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _kePri;
@override List<String>? get kePri {
  final value = _kePri;
  if (value == null) return null;
  if (_kePri is EqualUnmodifiableListView) return _kePri;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of JmdictKanjiElement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JmdictKanjiElementCopyWith<_JmdictKanjiElement> get copyWith => __$JmdictKanjiElementCopyWithImpl<_JmdictKanjiElement>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JmdictKanjiElement&&(identical(other.keb, keb) || other.keb == keb)&&const DeepCollectionEquality().equals(other._keInf, _keInf)&&const DeepCollectionEquality().equals(other._kePri, _kePri));
}


@override
int get hashCode => Object.hash(runtimeType,keb,const DeepCollectionEquality().hash(_keInf),const DeepCollectionEquality().hash(_kePri));

@override
String toString() {
  return 'JmdictKanjiElement(keb: $keb, keInf: $keInf, kePri: $kePri)';
}


}

/// @nodoc
abstract mixin class _$JmdictKanjiElementCopyWith<$Res> implements $JmdictKanjiElementCopyWith<$Res> {
  factory _$JmdictKanjiElementCopyWith(_JmdictKanjiElement value, $Res Function(_JmdictKanjiElement) _then) = __$JmdictKanjiElementCopyWithImpl;
@override @useResult
$Res call({
 String keb, List<String>? keInf, List<String>? kePri
});




}
/// @nodoc
class __$JmdictKanjiElementCopyWithImpl<$Res>
    implements _$JmdictKanjiElementCopyWith<$Res> {
  __$JmdictKanjiElementCopyWithImpl(this._self, this._then);

  final _JmdictKanjiElement _self;
  final $Res Function(_JmdictKanjiElement) _then;

/// Create a copy of JmdictKanjiElement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? keb = null,Object? keInf = freezed,Object? kePri = freezed,}) {
  return _then(_JmdictKanjiElement(
keb: null == keb ? _self.keb : keb // ignore: cast_nullable_to_non_nullable
as String,keInf: freezed == keInf ? _self._keInf : keInf // ignore: cast_nullable_to_non_nullable
as List<String>?,kePri: freezed == kePri ? _self._kePri : kePri // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

/// @nodoc
mixin _$JmdictReadingElement {

 String get reb; bool get reNokanji; List<String>? get reRestr; List<String>? get reInf; List<String>? get rePri;
/// Create a copy of JmdictReadingElement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JmdictReadingElementCopyWith<JmdictReadingElement> get copyWith => _$JmdictReadingElementCopyWithImpl<JmdictReadingElement>(this as JmdictReadingElement, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JmdictReadingElement&&(identical(other.reb, reb) || other.reb == reb)&&(identical(other.reNokanji, reNokanji) || other.reNokanji == reNokanji)&&const DeepCollectionEquality().equals(other.reRestr, reRestr)&&const DeepCollectionEquality().equals(other.reInf, reInf)&&const DeepCollectionEquality().equals(other.rePri, rePri));
}


@override
int get hashCode => Object.hash(runtimeType,reb,reNokanji,const DeepCollectionEquality().hash(reRestr),const DeepCollectionEquality().hash(reInf),const DeepCollectionEquality().hash(rePri));

@override
String toString() {
  return 'JmdictReadingElement(reb: $reb, reNokanji: $reNokanji, reRestr: $reRestr, reInf: $reInf, rePri: $rePri)';
}


}

/// @nodoc
abstract mixin class $JmdictReadingElementCopyWith<$Res>  {
  factory $JmdictReadingElementCopyWith(JmdictReadingElement value, $Res Function(JmdictReadingElement) _then) = _$JmdictReadingElementCopyWithImpl;
@useResult
$Res call({
 String reb, bool reNokanji, List<String>? reRestr, List<String>? reInf, List<String>? rePri
});




}
/// @nodoc
class _$JmdictReadingElementCopyWithImpl<$Res>
    implements $JmdictReadingElementCopyWith<$Res> {
  _$JmdictReadingElementCopyWithImpl(this._self, this._then);

  final JmdictReadingElement _self;
  final $Res Function(JmdictReadingElement) _then;

/// Create a copy of JmdictReadingElement
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


/// Adds pattern-matching-related methods to [JmdictReadingElement].
extension JmdictReadingElementPatterns on JmdictReadingElement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JmdictReadingElement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JmdictReadingElement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JmdictReadingElement value)  $default,){
final _that = this;
switch (_that) {
case _JmdictReadingElement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JmdictReadingElement value)?  $default,){
final _that = this;
switch (_that) {
case _JmdictReadingElement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String reb,  bool reNokanji,  List<String>? reRestr,  List<String>? reInf,  List<String>? rePri)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JmdictReadingElement() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String reb,  bool reNokanji,  List<String>? reRestr,  List<String>? reInf,  List<String>? rePri)  $default,) {final _that = this;
switch (_that) {
case _JmdictReadingElement():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String reb,  bool reNokanji,  List<String>? reRestr,  List<String>? reInf,  List<String>? rePri)?  $default,) {final _that = this;
switch (_that) {
case _JmdictReadingElement() when $default != null:
return $default(_that.reb,_that.reNokanji,_that.reRestr,_that.reInf,_that.rePri);case _:
  return null;

}
}

}

/// @nodoc


class _JmdictReadingElement implements JmdictReadingElement {
  const _JmdictReadingElement({required this.reb, this.reNokanji = false, final  List<String>? reRestr, final  List<String>? reInf, final  List<String>? rePri}): _reRestr = reRestr,_reInf = reInf,_rePri = rePri;
  

@override final  String reb;
@override@JsonKey() final  bool reNokanji;
 final  List<String>? _reRestr;
@override List<String>? get reRestr {
  final value = _reRestr;
  if (value == null) return null;
  if (_reRestr is EqualUnmodifiableListView) return _reRestr;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _reInf;
@override List<String>? get reInf {
  final value = _reInf;
  if (value == null) return null;
  if (_reInf is EqualUnmodifiableListView) return _reInf;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _rePri;
@override List<String>? get rePri {
  final value = _rePri;
  if (value == null) return null;
  if (_rePri is EqualUnmodifiableListView) return _rePri;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of JmdictReadingElement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JmdictReadingElementCopyWith<_JmdictReadingElement> get copyWith => __$JmdictReadingElementCopyWithImpl<_JmdictReadingElement>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JmdictReadingElement&&(identical(other.reb, reb) || other.reb == reb)&&(identical(other.reNokanji, reNokanji) || other.reNokanji == reNokanji)&&const DeepCollectionEquality().equals(other._reRestr, _reRestr)&&const DeepCollectionEquality().equals(other._reInf, _reInf)&&const DeepCollectionEquality().equals(other._rePri, _rePri));
}


@override
int get hashCode => Object.hash(runtimeType,reb,reNokanji,const DeepCollectionEquality().hash(_reRestr),const DeepCollectionEquality().hash(_reInf),const DeepCollectionEquality().hash(_rePri));

@override
String toString() {
  return 'JmdictReadingElement(reb: $reb, reNokanji: $reNokanji, reRestr: $reRestr, reInf: $reInf, rePri: $rePri)';
}


}

/// @nodoc
abstract mixin class _$JmdictReadingElementCopyWith<$Res> implements $JmdictReadingElementCopyWith<$Res> {
  factory _$JmdictReadingElementCopyWith(_JmdictReadingElement value, $Res Function(_JmdictReadingElement) _then) = __$JmdictReadingElementCopyWithImpl;
@override @useResult
$Res call({
 String reb, bool reNokanji, List<String>? reRestr, List<String>? reInf, List<String>? rePri
});




}
/// @nodoc
class __$JmdictReadingElementCopyWithImpl<$Res>
    implements _$JmdictReadingElementCopyWith<$Res> {
  __$JmdictReadingElementCopyWithImpl(this._self, this._then);

  final _JmdictReadingElement _self;
  final $Res Function(_JmdictReadingElement) _then;

/// Create a copy of JmdictReadingElement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reb = null,Object? reNokanji = null,Object? reRestr = freezed,Object? reInf = freezed,Object? rePri = freezed,}) {
  return _then(_JmdictReadingElement(
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
mixin _$JmdictSense {

 List<String>? get stagk; List<String>? get stagr; List<String>? get pos; List<String>? get xref; List<String>? get ant; List<String>? get field; List<String>? get misc; List<String>? get sInf; List<JmdictLsource>? get lsource; List<String>? get dial; Map<String, List<String>> get glosses;
/// Create a copy of JmdictSense
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JmdictSenseCopyWith<JmdictSense> get copyWith => _$JmdictSenseCopyWithImpl<JmdictSense>(this as JmdictSense, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JmdictSense&&const DeepCollectionEquality().equals(other.stagk, stagk)&&const DeepCollectionEquality().equals(other.stagr, stagr)&&const DeepCollectionEquality().equals(other.pos, pos)&&const DeepCollectionEquality().equals(other.xref, xref)&&const DeepCollectionEquality().equals(other.ant, ant)&&const DeepCollectionEquality().equals(other.field, field)&&const DeepCollectionEquality().equals(other.misc, misc)&&const DeepCollectionEquality().equals(other.sInf, sInf)&&const DeepCollectionEquality().equals(other.lsource, lsource)&&const DeepCollectionEquality().equals(other.dial, dial)&&const DeepCollectionEquality().equals(other.glosses, glosses));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(stagk),const DeepCollectionEquality().hash(stagr),const DeepCollectionEquality().hash(pos),const DeepCollectionEquality().hash(xref),const DeepCollectionEquality().hash(ant),const DeepCollectionEquality().hash(field),const DeepCollectionEquality().hash(misc),const DeepCollectionEquality().hash(sInf),const DeepCollectionEquality().hash(lsource),const DeepCollectionEquality().hash(dial),const DeepCollectionEquality().hash(glosses));

@override
String toString() {
  return 'JmdictSense(stagk: $stagk, stagr: $stagr, pos: $pos, xref: $xref, ant: $ant, field: $field, misc: $misc, sInf: $sInf, lsource: $lsource, dial: $dial, glosses: $glosses)';
}


}

/// @nodoc
abstract mixin class $JmdictSenseCopyWith<$Res>  {
  factory $JmdictSenseCopyWith(JmdictSense value, $Res Function(JmdictSense) _then) = _$JmdictSenseCopyWithImpl;
@useResult
$Res call({
 List<String>? stagk, List<String>? stagr, List<String>? pos, List<String>? xref, List<String>? ant, List<String>? field, List<String>? misc, List<String>? sInf, List<JmdictLsource>? lsource, List<String>? dial, Map<String, List<String>> glosses
});




}
/// @nodoc
class _$JmdictSenseCopyWithImpl<$Res>
    implements $JmdictSenseCopyWith<$Res> {
  _$JmdictSenseCopyWithImpl(this._self, this._then);

  final JmdictSense _self;
  final $Res Function(JmdictSense) _then;

/// Create a copy of JmdictSense
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
as List<JmdictLsource>?,dial: freezed == dial ? _self.dial : dial // ignore: cast_nullable_to_non_nullable
as List<String>?,glosses: null == glosses ? _self.glosses : glosses // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>,
  ));
}

}


/// Adds pattern-matching-related methods to [JmdictSense].
extension JmdictSensePatterns on JmdictSense {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JmdictSense value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JmdictSense() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JmdictSense value)  $default,){
final _that = this;
switch (_that) {
case _JmdictSense():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JmdictSense value)?  $default,){
final _that = this;
switch (_that) {
case _JmdictSense() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String>? stagk,  List<String>? stagr,  List<String>? pos,  List<String>? xref,  List<String>? ant,  List<String>? field,  List<String>? misc,  List<String>? sInf,  List<JmdictLsource>? lsource,  List<String>? dial,  Map<String, List<String>> glosses)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JmdictSense() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String>? stagk,  List<String>? stagr,  List<String>? pos,  List<String>? xref,  List<String>? ant,  List<String>? field,  List<String>? misc,  List<String>? sInf,  List<JmdictLsource>? lsource,  List<String>? dial,  Map<String, List<String>> glosses)  $default,) {final _that = this;
switch (_that) {
case _JmdictSense():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String>? stagk,  List<String>? stagr,  List<String>? pos,  List<String>? xref,  List<String>? ant,  List<String>? field,  List<String>? misc,  List<String>? sInf,  List<JmdictLsource>? lsource,  List<String>? dial,  Map<String, List<String>> glosses)?  $default,) {final _that = this;
switch (_that) {
case _JmdictSense() when $default != null:
return $default(_that.stagk,_that.stagr,_that.pos,_that.xref,_that.ant,_that.field,_that.misc,_that.sInf,_that.lsource,_that.dial,_that.glosses);case _:
  return null;

}
}

}

/// @nodoc


class _JmdictSense implements JmdictSense {
  const _JmdictSense({final  List<String>? stagk, final  List<String>? stagr, final  List<String>? pos, final  List<String>? xref, final  List<String>? ant, final  List<String>? field, final  List<String>? misc, final  List<String>? sInf, final  List<JmdictLsource>? lsource, final  List<String>? dial, required final  Map<String, List<String>> glosses}): _stagk = stagk,_stagr = stagr,_pos = pos,_xref = xref,_ant = ant,_field = field,_misc = misc,_sInf = sInf,_lsource = lsource,_dial = dial,_glosses = glosses;
  

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
@override List<String>? get sInf {
  final value = _sInf;
  if (value == null) return null;
  if (_sInf is EqualUnmodifiableListView) return _sInf;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<JmdictLsource>? _lsource;
@override List<JmdictLsource>? get lsource {
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


/// Create a copy of JmdictSense
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JmdictSenseCopyWith<_JmdictSense> get copyWith => __$JmdictSenseCopyWithImpl<_JmdictSense>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JmdictSense&&const DeepCollectionEquality().equals(other._stagk, _stagk)&&const DeepCollectionEquality().equals(other._stagr, _stagr)&&const DeepCollectionEquality().equals(other._pos, _pos)&&const DeepCollectionEquality().equals(other._xref, _xref)&&const DeepCollectionEquality().equals(other._ant, _ant)&&const DeepCollectionEquality().equals(other._field, _field)&&const DeepCollectionEquality().equals(other._misc, _misc)&&const DeepCollectionEquality().equals(other._sInf, _sInf)&&const DeepCollectionEquality().equals(other._lsource, _lsource)&&const DeepCollectionEquality().equals(other._dial, _dial)&&const DeepCollectionEquality().equals(other._glosses, _glosses));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_stagk),const DeepCollectionEquality().hash(_stagr),const DeepCollectionEquality().hash(_pos),const DeepCollectionEquality().hash(_xref),const DeepCollectionEquality().hash(_ant),const DeepCollectionEquality().hash(_field),const DeepCollectionEquality().hash(_misc),const DeepCollectionEquality().hash(_sInf),const DeepCollectionEquality().hash(_lsource),const DeepCollectionEquality().hash(_dial),const DeepCollectionEquality().hash(_glosses));

@override
String toString() {
  return 'JmdictSense(stagk: $stagk, stagr: $stagr, pos: $pos, xref: $xref, ant: $ant, field: $field, misc: $misc, sInf: $sInf, lsource: $lsource, dial: $dial, glosses: $glosses)';
}


}

/// @nodoc
abstract mixin class _$JmdictSenseCopyWith<$Res> implements $JmdictSenseCopyWith<$Res> {
  factory _$JmdictSenseCopyWith(_JmdictSense value, $Res Function(_JmdictSense) _then) = __$JmdictSenseCopyWithImpl;
@override @useResult
$Res call({
 List<String>? stagk, List<String>? stagr, List<String>? pos, List<String>? xref, List<String>? ant, List<String>? field, List<String>? misc, List<String>? sInf, List<JmdictLsource>? lsource, List<String>? dial, Map<String, List<String>> glosses
});




}
/// @nodoc
class __$JmdictSenseCopyWithImpl<$Res>
    implements _$JmdictSenseCopyWith<$Res> {
  __$JmdictSenseCopyWithImpl(this._self, this._then);

  final _JmdictSense _self;
  final $Res Function(_JmdictSense) _then;

/// Create a copy of JmdictSense
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stagk = freezed,Object? stagr = freezed,Object? pos = freezed,Object? xref = freezed,Object? ant = freezed,Object? field = freezed,Object? misc = freezed,Object? sInf = freezed,Object? lsource = freezed,Object? dial = freezed,Object? glosses = null,}) {
  return _then(_JmdictSense(
stagk: freezed == stagk ? _self._stagk : stagk // ignore: cast_nullable_to_non_nullable
as List<String>?,stagr: freezed == stagr ? _self._stagr : stagr // ignore: cast_nullable_to_non_nullable
as List<String>?,pos: freezed == pos ? _self._pos : pos // ignore: cast_nullable_to_non_nullable
as List<String>?,xref: freezed == xref ? _self._xref : xref // ignore: cast_nullable_to_non_nullable
as List<String>?,ant: freezed == ant ? _self._ant : ant // ignore: cast_nullable_to_non_nullable
as List<String>?,field: freezed == field ? _self._field : field // ignore: cast_nullable_to_non_nullable
as List<String>?,misc: freezed == misc ? _self._misc : misc // ignore: cast_nullable_to_non_nullable
as List<String>?,sInf: freezed == sInf ? _self._sInf : sInf // ignore: cast_nullable_to_non_nullable
as List<String>?,lsource: freezed == lsource ? _self._lsource : lsource // ignore: cast_nullable_to_non_nullable
as List<JmdictLsource>?,dial: freezed == dial ? _self._dial : dial // ignore: cast_nullable_to_non_nullable
as List<String>?,glosses: null == glosses ? _self._glosses : glosses // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>,
  ));
}


}

/// @nodoc
mixin _$JmdictLsource {

 String get lang; String? get value; String get lsType; bool get lsWasei;
/// Create a copy of JmdictLsource
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JmdictLsourceCopyWith<JmdictLsource> get copyWith => _$JmdictLsourceCopyWithImpl<JmdictLsource>(this as JmdictLsource, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JmdictLsource&&(identical(other.lang, lang) || other.lang == lang)&&(identical(other.value, value) || other.value == value)&&(identical(other.lsType, lsType) || other.lsType == lsType)&&(identical(other.lsWasei, lsWasei) || other.lsWasei == lsWasei));
}


@override
int get hashCode => Object.hash(runtimeType,lang,value,lsType,lsWasei);

@override
String toString() {
  return 'JmdictLsource(lang: $lang, value: $value, lsType: $lsType, lsWasei: $lsWasei)';
}


}

/// @nodoc
abstract mixin class $JmdictLsourceCopyWith<$Res>  {
  factory $JmdictLsourceCopyWith(JmdictLsource value, $Res Function(JmdictLsource) _then) = _$JmdictLsourceCopyWithImpl;
@useResult
$Res call({
 String lang, String? value, String lsType, bool lsWasei
});




}
/// @nodoc
class _$JmdictLsourceCopyWithImpl<$Res>
    implements $JmdictLsourceCopyWith<$Res> {
  _$JmdictLsourceCopyWithImpl(this._self, this._then);

  final JmdictLsource _self;
  final $Res Function(JmdictLsource) _then;

/// Create a copy of JmdictLsource
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lang = null,Object? value = freezed,Object? lsType = null,Object? lsWasei = null,}) {
  return _then(_self.copyWith(
lang: null == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as String,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,lsType: null == lsType ? _self.lsType : lsType // ignore: cast_nullable_to_non_nullable
as String,lsWasei: null == lsWasei ? _self.lsWasei : lsWasei // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [JmdictLsource].
extension JmdictLsourcePatterns on JmdictLsource {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JmdictLsource value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JmdictLsource() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JmdictLsource value)  $default,){
final _that = this;
switch (_that) {
case _JmdictLsource():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JmdictLsource value)?  $default,){
final _that = this;
switch (_that) {
case _JmdictLsource() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String lang,  String? value,  String lsType,  bool lsWasei)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JmdictLsource() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String lang,  String? value,  String lsType,  bool lsWasei)  $default,) {final _that = this;
switch (_that) {
case _JmdictLsource():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String lang,  String? value,  String lsType,  bool lsWasei)?  $default,) {final _that = this;
switch (_that) {
case _JmdictLsource() when $default != null:
return $default(_that.lang,_that.value,_that.lsType,_that.lsWasei);case _:
  return null;

}
}

}

/// @nodoc


class _JmdictLsource implements JmdictLsource {
  const _JmdictLsource({required this.lang, this.value, this.lsType = 'full', this.lsWasei = false});
  

@override final  String lang;
@override final  String? value;
@override@JsonKey() final  String lsType;
@override@JsonKey() final  bool lsWasei;

/// Create a copy of JmdictLsource
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JmdictLsourceCopyWith<_JmdictLsource> get copyWith => __$JmdictLsourceCopyWithImpl<_JmdictLsource>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JmdictLsource&&(identical(other.lang, lang) || other.lang == lang)&&(identical(other.value, value) || other.value == value)&&(identical(other.lsType, lsType) || other.lsType == lsType)&&(identical(other.lsWasei, lsWasei) || other.lsWasei == lsWasei));
}


@override
int get hashCode => Object.hash(runtimeType,lang,value,lsType,lsWasei);

@override
String toString() {
  return 'JmdictLsource(lang: $lang, value: $value, lsType: $lsType, lsWasei: $lsWasei)';
}


}

/// @nodoc
abstract mixin class _$JmdictLsourceCopyWith<$Res> implements $JmdictLsourceCopyWith<$Res> {
  factory _$JmdictLsourceCopyWith(_JmdictLsource value, $Res Function(_JmdictLsource) _then) = __$JmdictLsourceCopyWithImpl;
@override @useResult
$Res call({
 String lang, String? value, String lsType, bool lsWasei
});




}
/// @nodoc
class __$JmdictLsourceCopyWithImpl<$Res>
    implements _$JmdictLsourceCopyWith<$Res> {
  __$JmdictLsourceCopyWithImpl(this._self, this._then);

  final _JmdictLsource _self;
  final $Res Function(_JmdictLsource) _then;

/// Create a copy of JmdictLsource
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lang = null,Object? value = freezed,Object? lsType = null,Object? lsWasei = null,}) {
  return _then(_JmdictLsource(
lang: null == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as String,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,lsType: null == lsType ? _self.lsType : lsType // ignore: cast_nullable_to_non_nullable
as String,lsWasei: null == lsWasei ? _self.lsWasei : lsWasei // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$JmdictExample {

 String get sentenceJa; String get sentenceEn;
/// Create a copy of JmdictExample
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JmdictExampleCopyWith<JmdictExample> get copyWith => _$JmdictExampleCopyWithImpl<JmdictExample>(this as JmdictExample, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JmdictExample&&(identical(other.sentenceJa, sentenceJa) || other.sentenceJa == sentenceJa)&&(identical(other.sentenceEn, sentenceEn) || other.sentenceEn == sentenceEn));
}


@override
int get hashCode => Object.hash(runtimeType,sentenceJa,sentenceEn);

@override
String toString() {
  return 'JmdictExample(sentenceJa: $sentenceJa, sentenceEn: $sentenceEn)';
}


}

/// @nodoc
abstract mixin class $JmdictExampleCopyWith<$Res>  {
  factory $JmdictExampleCopyWith(JmdictExample value, $Res Function(JmdictExample) _then) = _$JmdictExampleCopyWithImpl;
@useResult
$Res call({
 String sentenceJa, String sentenceEn
});




}
/// @nodoc
class _$JmdictExampleCopyWithImpl<$Res>
    implements $JmdictExampleCopyWith<$Res> {
  _$JmdictExampleCopyWithImpl(this._self, this._then);

  final JmdictExample _self;
  final $Res Function(JmdictExample) _then;

/// Create a copy of JmdictExample
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sentenceJa = null,Object? sentenceEn = null,}) {
  return _then(_self.copyWith(
sentenceJa: null == sentenceJa ? _self.sentenceJa : sentenceJa // ignore: cast_nullable_to_non_nullable
as String,sentenceEn: null == sentenceEn ? _self.sentenceEn : sentenceEn // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [JmdictExample].
extension JmdictExamplePatterns on JmdictExample {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JmdictExample value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JmdictExample() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JmdictExample value)  $default,){
final _that = this;
switch (_that) {
case _JmdictExample():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JmdictExample value)?  $default,){
final _that = this;
switch (_that) {
case _JmdictExample() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sentenceJa,  String sentenceEn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JmdictExample() when $default != null:
return $default(_that.sentenceJa,_that.sentenceEn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sentenceJa,  String sentenceEn)  $default,) {final _that = this;
switch (_that) {
case _JmdictExample():
return $default(_that.sentenceJa,_that.sentenceEn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sentenceJa,  String sentenceEn)?  $default,) {final _that = this;
switch (_that) {
case _JmdictExample() when $default != null:
return $default(_that.sentenceJa,_that.sentenceEn);case _:
  return null;

}
}

}

/// @nodoc


class _JmdictExample implements JmdictExample {
  const _JmdictExample({required this.sentenceJa, required this.sentenceEn});
  

@override final  String sentenceJa;
@override final  String sentenceEn;

/// Create a copy of JmdictExample
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JmdictExampleCopyWith<_JmdictExample> get copyWith => __$JmdictExampleCopyWithImpl<_JmdictExample>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JmdictExample&&(identical(other.sentenceJa, sentenceJa) || other.sentenceJa == sentenceJa)&&(identical(other.sentenceEn, sentenceEn) || other.sentenceEn == sentenceEn));
}


@override
int get hashCode => Object.hash(runtimeType,sentenceJa,sentenceEn);

@override
String toString() {
  return 'JmdictExample(sentenceJa: $sentenceJa, sentenceEn: $sentenceEn)';
}


}

/// @nodoc
abstract mixin class _$JmdictExampleCopyWith<$Res> implements $JmdictExampleCopyWith<$Res> {
  factory _$JmdictExampleCopyWith(_JmdictExample value, $Res Function(_JmdictExample) _then) = __$JmdictExampleCopyWithImpl;
@override @useResult
$Res call({
 String sentenceJa, String sentenceEn
});




}
/// @nodoc
class __$JmdictExampleCopyWithImpl<$Res>
    implements _$JmdictExampleCopyWith<$Res> {
  __$JmdictExampleCopyWithImpl(this._self, this._then);

  final _JmdictExample _self;
  final $Res Function(_JmdictExample) _then;

/// Create a copy of JmdictExample
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sentenceJa = null,Object? sentenceEn = null,}) {
  return _then(_JmdictExample(
sentenceJa: null == sentenceJa ? _self.sentenceJa : sentenceJa // ignore: cast_nullable_to_non_nullable
as String,sentenceEn: null == sentenceEn ? _self.sentenceEn : sentenceEn // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
