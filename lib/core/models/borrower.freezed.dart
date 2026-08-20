// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'borrower.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Borrower {

 String get id; String get name; String get mobile; String get aadhaar; String get village; String get address; String get pinCode; String? get photoUrl; DateTime get joinDate; int get activeLoans; double get totalOutstanding; BorrowerStatus get status; String? get areaId;
/// Create a copy of Borrower
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BorrowerCopyWith<Borrower> get copyWith => _$BorrowerCopyWithImpl<Borrower>(this as Borrower, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Borrower&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.mobile, mobile) || other.mobile == mobile)&&(identical(other.aadhaar, aadhaar) || other.aadhaar == aadhaar)&&(identical(other.village, village) || other.village == village)&&(identical(other.address, address) || other.address == address)&&(identical(other.pinCode, pinCode) || other.pinCode == pinCode)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.joinDate, joinDate) || other.joinDate == joinDate)&&(identical(other.activeLoans, activeLoans) || other.activeLoans == activeLoans)&&(identical(other.totalOutstanding, totalOutstanding) || other.totalOutstanding == totalOutstanding)&&(identical(other.status, status) || other.status == status)&&(identical(other.areaId, areaId) || other.areaId == areaId));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,mobile,aadhaar,village,address,pinCode,photoUrl,joinDate,activeLoans,totalOutstanding,status,areaId);

@override
String toString() {
  return 'Borrower(id: $id, name: $name, mobile: $mobile, aadhaar: $aadhaar, village: $village, address: $address, pinCode: $pinCode, photoUrl: $photoUrl, joinDate: $joinDate, activeLoans: $activeLoans, totalOutstanding: $totalOutstanding, status: $status, areaId: $areaId)';
}


}

/// @nodoc
abstract mixin class $BorrowerCopyWith<$Res>  {
  factory $BorrowerCopyWith(Borrower value, $Res Function(Borrower) _then) = _$BorrowerCopyWithImpl;
@useResult
$Res call({
 String id, String name, String mobile, String aadhaar, String village, String address, String pinCode, String? photoUrl, DateTime joinDate, int activeLoans, double totalOutstanding, BorrowerStatus status, String? areaId
});




}
/// @nodoc
class _$BorrowerCopyWithImpl<$Res>
    implements $BorrowerCopyWith<$Res> {
  _$BorrowerCopyWithImpl(this._self, this._then);

  final Borrower _self;
  final $Res Function(Borrower) _then;

/// Create a copy of Borrower
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? mobile = null,Object? aadhaar = null,Object? village = null,Object? address = null,Object? pinCode = null,Object? photoUrl = freezed,Object? joinDate = null,Object? activeLoans = null,Object? totalOutstanding = null,Object? status = null,Object? areaId = freezed,}) {
  return _then(Borrower(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mobile: null == mobile ? _self.mobile : mobile // ignore: cast_nullable_to_non_nullable
as String,aadhaar: null == aadhaar ? _self.aadhaar : aadhaar // ignore: cast_nullable_to_non_nullable
as String,village: null == village ? _self.village : village // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,pinCode: null == pinCode ? _self.pinCode : pinCode // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,joinDate: null == joinDate ? _self.joinDate : joinDate // ignore: cast_nullable_to_non_nullable
as DateTime,activeLoans: null == activeLoans ? _self.activeLoans : activeLoans // ignore: cast_nullable_to_non_nullable
as int,totalOutstanding: null == totalOutstanding ? _self.totalOutstanding : totalOutstanding // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BorrowerStatus,areaId: freezed == areaId ? _self.areaId : areaId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Borrower].
extension BorrowerPatterns on Borrower {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Borrower value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Borrower() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Borrower value)  $default,){
final _that = this;
switch (_that) {
case _Borrower():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Borrower value)?  $default,){
final _that = this;
switch (_that) {
case _Borrower() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String mobile,  String aadhaar,  String village,  String address,  String pinCode,  String? photoUrl,  DateTime joinDate,  int activeLoans,  double totalOutstanding,  BorrowerStatus status,  String? areaId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Borrower() when $default != null:
return $default(_that.id,_that.name,_that.mobile,_that.aadhaar,_that.village,_that.address,_that.pinCode,_that.photoUrl,_that.joinDate,_that.activeLoans,_that.totalOutstanding,_that.status,_that.areaId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String mobile,  String aadhaar,  String village,  String address,  String pinCode,  String? photoUrl,  DateTime joinDate,  int activeLoans,  double totalOutstanding,  BorrowerStatus status,  String? areaId)  $default,) {final _that = this;
switch (_that) {
case _Borrower():
return $default(_that.id,_that.name,_that.mobile,_that.aadhaar,_that.village,_that.address,_that.pinCode,_that.photoUrl,_that.joinDate,_that.activeLoans,_that.totalOutstanding,_that.status,_that.areaId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String mobile,  String aadhaar,  String village,  String address,  String pinCode,  String? photoUrl,  DateTime joinDate,  int activeLoans,  double totalOutstanding,  BorrowerStatus status,  String? areaId)?  $default,) {final _that = this;
switch (_that) {
case _Borrower() when $default != null:
return $default(_that.id,_that.name,_that.mobile,_that.aadhaar,_that.village,_that.address,_that.pinCode,_that.photoUrl,_that.joinDate,_that.activeLoans,_that.totalOutstanding,_that.status,_that.areaId);case _:
  return null;

}
}

}

/// @nodoc


class _Borrower extends Borrower {
  const _Borrower({required this.id, required this.name, required this.mobile, required this.aadhaar, required this.village, required this.address, required this.pinCode, this.photoUrl, required this.joinDate, required this.activeLoans, required this.totalOutstanding, required this.status, this.areaId}): super._();
  

@override final  String id;
@override final  String name;
@override final  String mobile;
@override final  String aadhaar;
@override final  String village;
@override final  String address;
@override final  String pinCode;
@override final  String? photoUrl;
@override final  DateTime joinDate;
@override final  int activeLoans;
@override final  double totalOutstanding;
@override final  BorrowerStatus status;
@override final  String? areaId;

/// Create a copy of Borrower
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BorrowerCopyWith<_Borrower> get copyWith => __$BorrowerCopyWithImpl<_Borrower>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Borrower&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.mobile, mobile) || other.mobile == mobile)&&(identical(other.aadhaar, aadhaar) || other.aadhaar == aadhaar)&&(identical(other.village, village) || other.village == village)&&(identical(other.address, address) || other.address == address)&&(identical(other.pinCode, pinCode) || other.pinCode == pinCode)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.joinDate, joinDate) || other.joinDate == joinDate)&&(identical(other.activeLoans, activeLoans) || other.activeLoans == activeLoans)&&(identical(other.totalOutstanding, totalOutstanding) || other.totalOutstanding == totalOutstanding)&&(identical(other.status, status) || other.status == status)&&(identical(other.areaId, areaId) || other.areaId == areaId));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,mobile,aadhaar,village,address,pinCode,photoUrl,joinDate,activeLoans,totalOutstanding,status,areaId);

@override
String toString() {
  return 'Borrower(id: $id, name: $name, mobile: $mobile, aadhaar: $aadhaar, village: $village, address: $address, pinCode: $pinCode, photoUrl: $photoUrl, joinDate: $joinDate, activeLoans: $activeLoans, totalOutstanding: $totalOutstanding, status: $status, areaId: $areaId)';
}


}

/// @nodoc
abstract mixin class _$BorrowerCopyWith<$Res> implements $BorrowerCopyWith<$Res> {
  factory _$BorrowerCopyWith(_Borrower value, $Res Function(_Borrower) _then) = __$BorrowerCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String mobile, String aadhaar, String village, String address, String pinCode, String? photoUrl, DateTime joinDate, int activeLoans, double totalOutstanding, BorrowerStatus status, String? areaId
});




}
/// @nodoc
class __$BorrowerCopyWithImpl<$Res>
    implements _$BorrowerCopyWith<$Res> {
  __$BorrowerCopyWithImpl(this._self, this._then);

  final _Borrower _self;
  final $Res Function(_Borrower) _then;

/// Create a copy of Borrower
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? mobile = null,Object? aadhaar = null,Object? village = null,Object? address = null,Object? pinCode = null,Object? photoUrl = freezed,Object? joinDate = null,Object? activeLoans = null,Object? totalOutstanding = null,Object? status = null,Object? areaId = freezed,}) {
  return _then(_Borrower(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mobile: null == mobile ? _self.mobile : mobile // ignore: cast_nullable_to_non_nullable
as String,aadhaar: null == aadhaar ? _self.aadhaar : aadhaar // ignore: cast_nullable_to_non_nullable
as String,village: null == village ? _self.village : village // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,pinCode: null == pinCode ? _self.pinCode : pinCode // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,joinDate: null == joinDate ? _self.joinDate : joinDate // ignore: cast_nullable_to_non_nullable
as DateTime,activeLoans: null == activeLoans ? _self.activeLoans : activeLoans // ignore: cast_nullable_to_non_nullable
as int,totalOutstanding: null == totalOutstanding ? _self.totalOutstanding : totalOutstanding // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BorrowerStatus,areaId: freezed == areaId ? _self.areaId : areaId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
