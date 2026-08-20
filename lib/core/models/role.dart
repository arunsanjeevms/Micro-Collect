import 'package:freezed_annotation/freezed_annotation.dart';

part 'role.freezed.dart';

/// ─── Permission Model ────────────────────────────────────────────
@freezed
abstract class Permission with _$Permission {
  const factory Permission({
    required String id,
    required String key,
    required String label,
    required bool granted,
  }) = _Permission;
}

/// A named cluster of permissions (e.g. "Core Functions"), matching how
/// the Roles & Permissions screen groups its checklist.
@freezed
abstract class PermissionGroup with _$PermissionGroup {
  const factory PermissionGroup({
    required String group,
    required List<Permission> permissions,
  }) = _PermissionGroup;
}

/// ─── Role Model ──────────────────────────────────────────────────
@freezed
abstract class Role with _$Role {
  const factory Role({
    required String id,
    required String name,
    required bool isSystem,
    required List<PermissionGroup> permissionGroups,
  }) = _Role;
}
