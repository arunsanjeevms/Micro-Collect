// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_collection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DailyCollection {

 DateTime get date; double get collected; double get due;
/// Create a copy of DailyCollection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyCollectionCopyWith<DailyCollection> get copyWith => _$DailyCollectionCopyWithImpl<DailyCollection>(this as DailyCollection, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyCollection&&(identical(other.date, date) || other.date == date)&&(identical(other.collected, collected) || other.collected == collected)&&(identical(other.due, due) || other.due == due));
}


@override
int get hashCode => Object.hash(runtimeType,date,collected,due);

@override
String toString() {
  return 'DailyCollection(date: $date, collected: $collected, due: $due)';
}


}

/// @nodoc
abstract mixin class $DailyCollectionCopyWith<$Res>  {
  factory $DailyCollectionCopyWith(DailyCollection value, $Res Function(DailyCollection) _then) = _$DailyCollectionCopyWithImpl;
@useResult
$Res call({
 DateTime date, double collected, double due
});




}
/// @nodoc
class _$DailyCollectionCopyWithImpl<$Res>
    implements $DailyCollectionCopyWith<$Res> {
  _$DailyCollectionCopyWithImpl(this._self, this._then);

  final DailyCollection _self;
  final $Res Function(DailyCollection) _then;

/// Create a copy of DailyCollection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? collected = null,Object? due = null,}) {
  return _then(DailyCollection(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,collected: null == collected ? _self.collected : collected // ignore: cast_nullable_to_non_nullable
as double,due: null == due ? _self.due : due // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyCollection].
extension DailyCollectionPatterns on DailyCollection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyCollection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyCollection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyCollection value)  $default,){
final _that = this;
switch (_that) {
case _DailyCollection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyCollection value)?  $default,){
final _that = this;
switch (_that) {
case _DailyCollection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  double collected,  double due)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyCollection() when $default != null:
return $default(_that.date,_that.collected,_that.due);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  double collected,  double due)  $default,) {final _that = this;
switch (_that) {
case _DailyCollection():
return $default(_that.date,_that.collected,_that.due);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  double collected,  double due)?  $default,) {final _that = this;
switch (_that) {
case _DailyCollection() when $default != null:
return $default(_that.date,_that.collected,_that.due);case _:
  return null;

}
}

}

/// @nodoc


class _DailyCollection extends DailyCollection {
  const _DailyCollection({required this.date, required this.collected, required this.due}): super._();
  

@override final  DateTime date;
@override final  double collected;
@override final  double due;

/// Create a copy of DailyCollection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyCollectionCopyWith<_DailyCollection> get copyWith => __$DailyCollectionCopyWithImpl<_DailyCollection>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyCollection&&(identical(other.date, date) || other.date == date)&&(identical(other.collected, collected) || other.collected == collected)&&(identical(other.due, due) || other.due == due));
}


@override
int get hashCode => Object.hash(runtimeType,date,collected,due);

@override
String toString() {
  return 'DailyCollection(date: $date, collected: $collected, due: $due)';
}


}

/// @nodoc
abstract mixin class _$DailyCollectionCopyWith<$Res> implements $DailyCollectionCopyWith<$Res> {
  factory _$DailyCollectionCopyWith(_DailyCollection value, $Res Function(_DailyCollection) _then) = __$DailyCollectionCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, double collected, double due
});




}
/// @nodoc
class __$DailyCollectionCopyWithImpl<$Res>
    implements _$DailyCollectionCopyWith<$Res> {
  __$DailyCollectionCopyWithImpl(this._self, this._then);

  final _DailyCollection _self;
  final $Res Function(_DailyCollection) _then;

/// Create a copy of DailyCollection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? collected = null,Object? due = null,}) {
  return _then(_DailyCollection(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,collected: null == collected ? _self.collected : collected // ignore: cast_nullable_to_non_nullable
as double,due: null == due ? _self.due : due // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
