import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/errors/app_exception.dart';
import '../../core/models/role.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/async_value_view.dart';
import 'providers/role_providers.dart';

/// Roles & Permissions — matches Stitch's screen: a role list on the
/// left/top, the selected role's permission checklist below, backed by
/// backend/src/services/roleService.js (or MockDatabase in mock mode) on
/// both ends. Toggling a switch here edits the real RolePermission grant.
class RolesPermissionsScreen extends ConsumerStatefulWidget {
  const RolesPermissionsScreen({super.key});

  @override
  ConsumerState<RolesPermissionsScreen> createState() =>
      _RolesPermissionsScreenState();
}

class _RolesPermissionsScreenState
    extends ConsumerState<RolesPermissionsScreen> {
  String? _selectedRoleId;

  @override
  Widget build(BuildContext context) {
    final rolesAsync = ref.watch(rolesProvider);
    // Keeps these autoDispose controllers alive across their async submit()
    // calls below - a bare ref.read() would let them get torn down before
    // the write completes.
    ref.watch(setRolePermissionControllerProvider);
    ref.watch(createRoleControllerProvider);
    ref.watch(deleteRoleControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Roles & Permissions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => _createRole(context),
          ),
        ],
      ),
      body: AsyncValueView<List<Role>>(
        value: rolesAsync,
        onRetry: () => ref.invalidate(rolesProvider),
        data: (roles) {
          if (roles.isEmpty) {
            return const Center(child: Text('No roles yet'));
          }
          final selected = roles.firstWhere(
            (r) => r.id == _selectedRoleId,
            orElse: () => roles.first,
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.marginMobile),
                child: Text(
                  'MANAGE ROLES',
                  style: AppTypography.labelSm.copyWith(
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.marginMobile,
                ),
                child: Column(
                  children: [
                    for (final role in roles)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _RoleTile(
                          role: role,
                          selected: role.id == selected.id,
                          onTap: () =>
                              setState(() => _selectedRoleId = role.id),
                          onDelete: role.isSystem
                              ? null
                              : () => _deleteRole(context, role),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.marginMobile,
                  ),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${selected.name} Permissions',
                          style: AppTypography.titleLg.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        for (final group in selected.permissionGroups) ...[
                          Text(
                            group.group.toUpperCase(),
                            style: AppTypography.labelSm.copyWith(
                              color: AppColors.onSurfaceVariant,
                              letterSpacing: 1,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 4),
                          for (final permission in group.permissions)
                            _PermissionRow(
                              permission: permission,
                              onChanged: (granted) => _togglePermission(
                                context,
                                selected.id,
                                permission.id,
                                granted,
                              ),
                            ),
                          const SizedBox(height: AppSpacing.sm),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _togglePermission(
    BuildContext context,
    String roleId,
    String permissionId,
    bool granted,
  ) async {
    await ref
        .read(setRolePermissionControllerProvider.notifier)
        .submit(roleId, permissionId, granted);
    final error = ref.read(setRolePermissionControllerProvider).error;
    if (error != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error is AppException
                ? error.message
                : 'Could not update permission',
          ),
        ),
      );
    }
  }

  Future<void> _createRole(BuildContext context) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Role'),
        content: TextField(
          controller: controller,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(labelText: 'Role name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Create'),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty || !context.mounted) return;

    final role = await ref
        .read(createRoleControllerProvider.notifier)
        .submit(name);
    if (!context.mounted) return;
    if (role == null) {
      final error = ref.read(createRoleControllerProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error is AppException ? error.message : 'Could not create role',
          ),
        ),
      );
    } else {
      setState(() => _selectedRoleId = role.id);
    }
  }

  Future<void> _deleteRole(BuildContext context, Role role) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete role?'),
        content: Text('This removes "${role.name}" permanently.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final ok = await ref
        .read(deleteRoleControllerProvider.notifier)
        .submit(role.id);
    if (!context.mounted) return;
    if (!ok) {
      final error = ref.read(deleteRoleControllerProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error is AppException ? error.message : 'Something went wrong',
          ),
        ),
      );
    } else if (_selectedRoleId == role.id) {
      setState(() => _selectedRoleId = null);
    }
  }
}

class _RoleTile extends StatelessWidget {
  final Role role;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const _RoleTile({
    required this.role,
    required this.selected,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryContainer.withValues(alpha: 0.12)
              : AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.cardBorder,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                role.name,
                style: AppTypography.titleMd.copyWith(
                  color: selected ? AppColors.primary : AppColors.onSurface,
                  fontSize: 14,
                ),
              ),
            ),
            if (selected)
              const Padding(
                padding: EdgeInsets.only(right: 4),
                child: Icon(
                  Icons.check_circle_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, size: 18),
                color: AppColors.danger,
                visualDensity: VisualDensity.compact,
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    );
  }
}

class _PermissionRow extends StatelessWidget {
  final Permission permission;
  final ValueChanged<bool> onChanged;

  const _PermissionRow({required this.permission, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              permission.label,
              style: AppTypography.bodyMd.copyWith(
                color: permission.granted
                    ? AppColors.onSurface
                    : AppColors.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
          ),
          Switch(value: permission.granted, onChanged: onChanged),
        ],
      ),
    );
  }
}
