import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class _PermissionGroup {
  final String title;
  final List<(String, bool)> permissions;

  const _PermissionGroup({required this.title, required this.permissions});
}

class _Role {
  final String name;
  final List<_PermissionGroup> groups;

  const _Role({required this.name, required this.groups});
}

// Illustrative roles only - there is no Role/Permission domain model or
// backend yet, so this content is fixed demo data.
const _roles = [
  _Role(
    name: 'Admin',
    groups: [
      _PermissionGroup(
        title: 'Core Functions',
        permissions: [
          ('Can Collect Payments', true),
          ('Can Sync Offline Data', true),
          ('Can Register Customers', true),
        ],
      ),
      _PermissionGroup(
        title: 'Reporting & Analytics',
        permissions: [
          ('Can View Reports (Personal)', true),
          ('Can View Branch Reports', true),
        ],
      ),
      _PermissionGroup(
        title: 'System Settings',
        permissions: [('Can Manage Users', true)],
      ),
    ],
  ),
  _Role(
    name: 'Manager',
    groups: [
      _PermissionGroup(
        title: 'Core Functions',
        permissions: [
          ('Can Collect Payments', true),
          ('Can Sync Offline Data', true),
          ('Can Register Customers', true),
        ],
      ),
      _PermissionGroup(
        title: 'Reporting & Analytics',
        permissions: [
          ('Can View Reports (Personal)', true),
          ('Can View Branch Reports', true),
        ],
      ),
      _PermissionGroup(
        title: 'System Settings',
        permissions: [('Can Manage Users', false)],
      ),
    ],
  ),
  _Role(
    name: 'Field Officer',
    groups: [
      _PermissionGroup(
        title: 'Core Functions',
        permissions: [
          ('Can Collect Payments', true),
          ('Can Sync Offline Data', true),
          ('Can Register Customers', true),
        ],
      ),
      _PermissionGroup(
        title: 'Reporting & Analytics',
        permissions: [
          ('Can View Reports (Personal)', true),
          ('Can View Branch Reports', false),
        ],
      ),
      _PermissionGroup(
        title: 'System Settings',
        permissions: [('Can Manage Users', false)],
      ),
    ],
  ),
  _Role(
    name: 'Cashier',
    groups: [
      _PermissionGroup(
        title: 'Core Functions',
        permissions: [
          ('Can Collect Payments', true),
          ('Can Sync Offline Data', false),
          ('Can Register Customers', false),
        ],
      ),
      _PermissionGroup(
        title: 'Reporting & Analytics',
        permissions: [
          ('Can View Reports (Personal)', true),
          ('Can View Branch Reports', false),
        ],
      ),
      _PermissionGroup(
        title: 'System Settings',
        permissions: [('Can Manage Users', false)],
      ),
    ],
  ),
];

/// Roles & Permissions — matches Stitch's screen: a role list on the left,
/// the selected role's permission checklist on the right. Demo content
/// only: there is no Role/Permission domain model in this app yet.
class RolesPermissionsScreen extends StatefulWidget {
  const RolesPermissionsScreen({super.key});

  @override
  State<RolesPermissionsScreen> createState() => _RolesPermissionsScreenState();
}

class _RolesPermissionsScreenState extends State<RolesPermissionsScreen> {
  int _selected = 2; // Field Officer, matching Stitch's default selection

  @override
  Widget build(BuildContext context) {
    final role = _roles[_selected];

    return Scaffold(
      appBar: AppBar(title: const Text('Roles & Permissions')),
      body: Column(
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
                for (var i = 0; i < _roles.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _RoleTile(
                      name: _roles[i].name,
                      selected: i == _selected,
                      onTap: () => setState(() => _selected = i),
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
                      '${role.name} Permissions',
                      style: AppTypography.titleLg.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    for (final group in role.groups) ...[
                      Text(
                        group.title.toUpperCase(),
                        style: AppTypography.labelSm.copyWith(
                          color: AppColors.onSurfaceVariant,
                          letterSpacing: 1,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 8),
                      for (final (label, granted) in group.permissions)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Icon(
                                granted
                                    ? Icons.check_circle_rounded
                                    : Icons.cancel_outlined,
                                size: 18,
                                color: granted
                                    ? AppColors.success
                                    : AppColors.onSurfaceVariant,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  label,
                                  style: AppTypography.bodyMd.copyWith(
                                    color: granted
                                        ? AppColors.onSurface
                                        : AppColors.onSurfaceVariant,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}

class _RoleTile extends StatelessWidget {
  final String name;
  final bool selected;
  final VoidCallback onTap;

  const _RoleTile({
    required this.name,
    required this.selected,
    required this.onTap,
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
                name,
                style: AppTypography.titleMd.copyWith(
                  color: selected ? AppColors.primary : AppColors.onSurface,
                  fontSize: 14,
                ),
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle_rounded,
                size: 18,
                color: AppColors.primary,
              ),
          ],
        ),
      ),
    );
  }
}
