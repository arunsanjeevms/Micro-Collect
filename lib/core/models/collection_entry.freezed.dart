// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collection_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CollectionEntry {

 String get id; String get borrowerId; String get borrowerName; String get loanId; double get amountDue; double? get amountPaid; DateTime get dueDate; DateTime? get paidDate; String? get paymentMode; String? get notes; CollectionStatus get status;
/// Create a copy of CollectionEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CollectionEntryCopyWith<CollectionEntry> get copyWith => _$CollectionEntryCopyWithImpl<CollectionEntry>(this as CollectionEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollectionEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.borrowerId, borrowerId) || other.borrowerId == borrowerId)&&(identical(other.borrowerName, borrowerName) || other.borrowerName == borrowerName)&&(identical(other.loanId, loanId) || other.loanId == loanId)&&(identical(other.amountDue, amountDue) || other.amountDue == amountDue)&&(identical(other.amountPaid, amountPaid) || other.amountPaid == amountPaid)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.paidDate, paidDate) || other.paidDate == paidDate)&&(identical(other.paymentMode, paymentMode) || other.paymentMode == paymentMode)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,id,borrowerId,borrowerName,loanId,amountDue,amountPaid,dueDate,paidDate,paymentMode,notes,status);

@override
String toString() {
  return 'CollectionEntry(id: $id, borrowerId: $borrowerId, borrowerName: $borrowerName, loanId: $loanId, amountDue: $amountDue, amountPaid: $amountPaid, dueDate: $dueDate, paidDate: $paidDate, paymentMode: $paymentMode, notes: $notes, status: $status)';
}


}

/// @nodoc
abstract mixin class $CollectionEntryCopyWith<$Res>  {
  factory $CollectionEntryCopyWith(CollectionEntry value, $Res Function(CollectionEntry) _then) = _$CollectionEntryCopyWithImpl;
@useResult
$Res call({
 String id, String borrowerId, String borrowerName, String loanId, double amountDue, double? amountPaid, DateTime dueDate, DateTime? paidDate, String? paymentMode, String? notes, CollectionStatus status
});




}
/// @nodoc
class _$CollectionEntryCopyWithImpl<$Res>
    implements $CollectionEntryCopyWith<$Res> {
  _$CollectionEntryCopyWithImpl(this._self, this._then);

  final CollectionEntry _self;
  final $Res Function(CollectionEntry) _then;

/// Create a copy of CollectionEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? borrowerId = null,Object? borrowerName = null,Object? loanId = null,Object? amountDue = null,Object? amountPaid = freezed,Object? dueDate = null,Object? paidDate = freezed,Object? paymentMode = freezed,Object? notes = freezed,Object? status = null,}) {
  return _then(CollectionEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,borrowerId: null == borrowerId ? _self.borrowerId : borrowerId // ignore: cast_nullable_to_non_nullable
as String,borrowerName: null == borrowerName ? _self.borrowerName : borrowerName // ignore: cast_nullable_to_non_nullable
as String,loanId: null == loanId ? _self.loanId : loanId // ignore: cast_nullable_to_non_nullable
as String,amountDue: null == amountDue ? _self.amountDue : amountDue // ignore: cast_nullable_to_non_nullable
as double,amountPaid: freezed == amountPaid ? _self.amountPaid : amountPaid // ignore: cast_nullable_to_non_nullable
as double?,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,paidDate: freezed == paidDate ? _self.paidDate : paidDate // ignore: cast_nullable_to_non_nullable
as DateTime?,paymentMode: freezed == paymentMode ? _self.paymentMode : paymentMode // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CollectionStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [CollectionEntry].
extension CollectionEntryPatterns on CollectionEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CollectionEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CollectionEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CollectionEntry value)  $default,){
final _that = this;
switch (_that) {
case _CollectionEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CollectionEntry value)?  $default,){
final _that = this;
switch (_that) {
case _CollectionEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String borrowerId,  String borrowerName,  String loanId,  double amountDue,  double? amountPaid,  DateTime dueDate,  DateTime? paidDate,  String? paymentMode,  String? notes,  CollectionStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CollectionEntry() when $default != null:
return $default(_that.id,_that.borrowerId,_that.borrowerName,_that.loanId,_that.amountDue,_that.amountPaid,_that.dueDate,_that.paidDate,_that.paymentMode,_that.notes,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String borrowerId,  String borrowerName,  String loanId,  double amountDue,  double? amountPaid,  DateTime dueDate,  DateTime? paidDate,  String? paymentMode,  String? notes,  CollectionStatus status)  $default,) {final _that = this;
switch (_that) {
case _CollectionEntry():
return $default(_that.id,_that.borrowerId,_that.borrowerName,_that.loanId,_that.amountDue,_that.amountPaid,_that.dueDate,_that.paidDate,_that.paymentMode,_that.notes,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String borrowerId,  String borrowerName,  String loanId,  double amountDue,  double? amountPaid,  DateTime dueDate,  DateTime? paidDate,  String? paymentMode,  String? notes,  CollectionStatus status)?  $default,) {final _that = this;
switch (_that) {
case _CollectionEntry() when $default != null:
return $default(_that.id,_that.borrowerId,_that.borrowerName,_that.loanId,_that.amountDue,_that.amountPaid,_that.dueDate,_that.paidDate,_that.paymentMode,_that.notes,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _CollectionEntry implements CollectionEntry {
  const _CollectionEntry({required this.id, required this.borrowerId, required this.borrowerName, required this.loanId, required this.amountDue, this.amountPaid, required this.dueDate, this.paidDate, this.paymentMode, this.notes, required this.status});
  

@override final  String id;
@override final  String borrowerId;
@override final  String borrowerName;
@override final  String loanId;
@override final  double amountDue;
@override final  double? amountPaid;
@override final  DateTime dueDate;
@override final  DateTime? paidDate;
@override final  String? paymentMode;
@override final  String? notes;
@override final  CollectionStatus status;

/// Create a copy of CollectionEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CollectionEntryCopyWith<_CollectionEntry> get copyWith => __$CollectionEntryCopyWithImpl<_CollectionEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CollectionEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.borrowerId, borrowerId) || other.borrowerId == borrowerId)&&(identical(other.borrowerName, borrowerName) || other.borrowerName == borrowerName)&&(identical(other.loanId, loanId) || other.loanId == loanId)&&(identical(other.amountDue, amountDue) || other.amountDue == amountDue)&&(identical(other.amountPaid, amountPaid) || other.amountPaid == amountPaid)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.paidDate, paidDate) || other.paidDate == paidDate)&&(identical(other.paymentMode, paymentMode) || other.paymentMode == paymentMode)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,id,borrowerId,borrowerName,loanId,amountDue,amountPaid,dueDate,paidDate,paymentMode,notes,status);

@override
String toString() {
  return 'CollectionEntry(id: $id, borrowerId: $borrowerId, borrowerName: $borrowerName, loanId: $loanId, amountDue: $amountDue, amountPaid: $amountPaid, dueDate: $dueDate, paidDate: $paidDate, paymentMode: $paymentMode, notes: $notes, status: $status)';
}


}

/// @nodoc
abstract mixin class _$CollectionEntryCopyWith<$Res> implements $CollectionEntryCopyWith<$Res> {
  factory _$CollectionEntryCopyWith(_CollectionEntry value, $Res Function(_CollectionEntry) _then) = __$CollectionEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String borrowerId, String borrowerName, String loanId, double amountDue, double? amountPaid, DateTime dueDate, DateTime? paidDate, String? paymentMode, String? notes, CollectionStatus status
});




}
/// @nodoc
class __$CollectionEntryCopyWithImpl<$Res>
    implements _$CollectionEntryCopyWith<$Res> {
  __$CollectionEntryCopyWithImpl(this._self, this._then);

  final _CollectionEntry _self;
  final $Res Function(_CollectionEntry) _then;

/// Create a copy of CollectionEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? borrowerId = null,Object? borrowerName = null,Object? loanId = null,Object? amountDue = null,Object? amountPaid = freezed,Object? dueDate = null,Object? paidDate = freezed,Object? paymentMode = freezed,Object? notes = freezed,Object? status = null,}) {
  return _then(_CollectionEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,borrowerId: null == borrowerId ? _self.borrowerId : borrowerId // ignore: cast_nullable_to_non_nullable
as String,borrowerName: null == borrowerName ? _self.borrowerName : borrowerName // ignore: cast_nullable_to_non_nullable
as String,loanId: null == loanId ? _self.loanId : loanId // ignore: cast_nullable_to_non_nullable
as String,amountDue: null == amountDue ? _self.amountDue : amountDue // ignore: cast_nullable_to_non_nullable
as double,amountPaid: freezed == amountPaid ? _self.amountPaid : amountPaid // ignore: cast_nullable_to_non_nullable
as double?,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,paidDate: freezed == paidDate ? _self.paidDate : paidDate // ignore: cast_nullable_to_non_nullable
as DateTime?,paymentMode: freezed == paymentMode ? _self.paymentMode : paymentMode // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CollectionStatus,
  ));
}


}

// dart format on
