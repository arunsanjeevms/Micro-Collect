import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Settings — matches Stitch's screen: a hub linking to Company Profile,
/// Printer Settings, User Security, and Backup/Terms sections, plus two
/// quick-access toggles kept as local UI state.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _offlineSync = true;

  void _notAvailable(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label isn\'t available in this preview yet')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        children: [
          Text(
            'Manage your account and app preferences.',
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          _SettingsGroup(
            title: 'Account',
            icon: Icons.person_outline_rounded,
            children: [
              _SettingsLink(
                icon: Icons.business_outlined,
                label: 'Company Profile',
                onTap: () => context.push('/more/company-profile'),
              ),
              _SettingsLink(
                icon: Icons.manage_accounts_outlined,
                label: 'User Profile',
                onTap: () => _notAvailable('User Profile'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          _SettingsGroup(
            title: 'System',
            icon: Icons.dns_outlined,
            children: [
              _SettingsLink(
                icon: Icons.print_outlined,
                label: 'Printer Settings',
                onTap: () => context.push('/more/printer-settings'),
              ),
              _SettingsToggle(
                icon: Icons.cloud_sync_outlined,
                label: 'Offline Sync',
                value: _offlineSync,
                onChanged: (v) => setState(() => _offlineSync = v),
              ),
              _SettingsLink(
                icon: Icons.notifications_outlined,
                label: 'Notification Settings',
                onTap: () => _notAvailable('Notification Settings'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          _SettingsGroup(
            title: 'Security',
            icon: Icons.security_outlined,
            children: [
              _SettingsLink(
                icon: Icons.lock_outline_rounded,
                label: 'Change PIN, Biometrics & Timeout',
                onTap: () => context.push('/more/security'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          _SettingsGroup(
            title: 'About',
            icon: Icons.info_outline_rounded,
            children: [
              _SettingsLink(
                icon: Icons.restore_outlined,
                label: 'Backup & Restore',
                onTap: () => _notAvailable('Backup & Restore'),
              ),
              _SettingsLink(
                icon: Icons.description_outlined,
                label: 'Terms & Privacy',
                onTap: () => _notAvailable('Terms & Privacy'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: Column(
              children: [
                Text(
                  'MicroCollect v0.1.0 (prototype)',
                  style: AppTypography.labelMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Center(
            child: OutlinedButton.icon(
              onPressed: () => _notAvailable('Logout'),
              icon: const Icon(Icons.logout_rounded, color: AppColors.danger),
              label: const Text('Logout'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.danger,
                side: const BorderSide(color: AppColors.danger),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SettingsGroup({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                Icon(icon, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: AppTypography.titleMd.copyWith(
                    color: AppColors.primary,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1) const Divider(height: 1, indent: 56),
          ],
        ],
      ),
    );
  }
}

class _SettingsLink extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SettingsLink({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.onSurfaceVariant),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
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

class _SettingsToggle extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsToggle({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: AppTypography.bodyMd.copyWith(fontSize: 14),
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
