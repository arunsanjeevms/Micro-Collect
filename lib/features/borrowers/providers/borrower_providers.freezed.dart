// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'borrower_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BorrowerFilter {

 String get search; BorrowerStatus? get status;
/// Create a copy of BorrowerFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BorrowerFilterCopyWith<BorrowerFilter> get copyWith => _$BorrowerFilterCopyWithImpl<BorrowerFilter>(this as BorrowerFilter, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BorrowerFilter&&(identical(other.search, search) || other.search == search)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,search,status);

@override
String toString() {
  return 'BorrowerFilter(search: $search, status: $status)';
}


}

/// @nodoc
abstract mixin class $BorrowerFilterCopyWith<$Res>  {
  factory $BorrowerFilterCopyWith(BorrowerFilter value, $Res Function(BorrowerFilter) _then) = _$BorrowerFilterCopyWithImpl;
@useResult
$Res call({
 String search, BorrowerStatus? status
});




}
/// @nodoc
class _$BorrowerFilterCopyWithImpl<$Res>
    implements $BorrowerFilterCopyWith<$Res> {
  _$BorrowerFilterCopyWithImpl(this._self, this._then);

  final BorrowerFilter _self;
  final $Res Function(BorrowerFilter) _then;

/// Create a copy of BorrowerFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? search = null,Object? status = freezed,}) {
  return _then(BorrowerFilter(
search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BorrowerStatus?,
  ));
}

}


/// Adds pattern-matching-related methods to [BorrowerFilter].
extension BorrowerFilterPatterns on BorrowerFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BorrowerFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BorrowerFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BorrowerFilter value)  $default,){
final _that = this;
switch (_that) {
case _BorrowerFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BorrowerFilter value)?  $default,){
final _that = this;
switch (_that) {
case _BorrowerFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String search,  BorrowerStatus? status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BorrowerFilter() when $default != null:
return $default(_that.search,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String search,  BorrowerStatus? status)  $default,) {final _that = this;
switch (_that) {
case _BorrowerFilter():
return $default(_that.search,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String search,  BorrowerStatus? status)?  $default,) {final _that = this;
switch (_that) {
case _BorrowerFilter() when $default != null:
return $default(_that.search,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _BorrowerFilter extends BorrowerFilter {
  const _BorrowerFilter({this.search = '', this.status}): super._();
  

@override@JsonKey() final  String search;
@override final  BorrowerStatus? status;

/// Create a copy of BorrowerFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BorrowerFilterCopyWith<_BorrowerFilter> get copyWith => __$BorrowerFilterCopyWithImpl<_BorrowerFilter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BorrowerFilter&&(identical(other.search, search) || other.search == search)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,search,status);

@override
String toString() {
  return 'BorrowerFilter(search: $search, status: $status)';
}


}

/// @nodoc
abstract mixin class _$BorrowerFilterCopyWith<$Res> implements $BorrowerFilterCopyWith<$Res> {
  factory _$BorrowerFilterCopyWith(_BorrowerFilter value, $Res Function(_BorrowerFilter) _then) = __$BorrowerFilterCopyWithImpl;
@override @useResult
$Res call({
 String search, BorrowerStatus? status
});




}
/// @nodoc
class __$BorrowerFilterCopyWithImpl<$Res>
    implements _$BorrowerFilterCopyWith<$Res> {
  __$BorrowerFilterCopyWithImpl(this._self, this._then);

  final _BorrowerFilter _self;
  final $Res Function(_BorrowerFilter) _then;

/// Create a copy of BorrowerFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? search = null,Object? status = freezed,}) {
  return _then(_BorrowerFilter(
search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BorrowerStatus?,
  ));
}


}

// dart format on
