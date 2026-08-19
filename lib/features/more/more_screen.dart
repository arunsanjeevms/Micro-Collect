import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class _MoreItem {
  final IconData icon;
  final String label;
  final String route;

  const _MoreItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}

const _organization = [
  _MoreItem(
    icon: Icons.groups_outlined,
    label: 'Employees',
    route: '/more/employees',
  ),
  _MoreItem(icon: Icons.map_outlined, label: 'Areas', route: '/more/areas'),
  _MoreItem(
    icon: Icons.admin_panel_settings_outlined,
    label: 'Roles & Permissions',
    route: '/more/roles',
  ),
  _MoreItem(
    icon: Icons.category_outlined,
    label: 'Loan Schemes',
    route: '/more/loan-schemes',
  ),
];

const _system = [
  _MoreItem(
    icon: Icons.settings_outlined,
    label: 'Settings',
    route: '/more/settings',
  ),
  _MoreItem(
    icon: Icons.business_outlined,
    label: 'Company Profile',
    route: '/more/company-profile',
  ),
  _MoreItem(
    icon: Icons.print_outlined,
    label: 'Printer Settings',
    route: '/more/printer-settings',
  ),
  _MoreItem(
    icon: Icons.security_outlined,
    label: 'User Security',
    route: '/more/security',
  ),
  _MoreItem(
    icon: Icons.sync_rounded,
    label: 'Sync Center',
    route: '/more/sync',
  ),
];

/// More — the fifth bottom-nav tab, matching Stitch's nav model (Home,
/// Collections, Customers, Loans, More). Home for every screen that has no
/// other natural entry point: org admin and app/device settings.
class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        children: [
          _SectionLabel('ORGANIZATION'),
          const SizedBox(height: AppSpacing.sm),
          _MenuGroup(items: _organization),
          const SizedBox(height: AppSpacing.xl),
          _SectionLabel('SYSTEM'),
          const SizedBox(height: AppSpacing.sm),
          _MenuGroup(items: _system),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.labelSm.copyWith(
        color: AppColors.onSurfaceVariant,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _MenuGroup extends StatelessWidget {
  final List<_MoreItem> items;

  const _MenuGroup({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            _MenuTile(item: items[i]),
            if (i != items.length - 1) const Divider(height: 1, indent: 56),
          ],
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final _MoreItem item;

  const _MenuTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(item.route),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Icon(item.icon, size: 20, color: AppColors.primary),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                item.label,
                style: AppTypography.bodyMd.copyWith(fontSize: 14),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: AppColors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
