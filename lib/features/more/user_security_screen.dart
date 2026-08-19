import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// User Security — matches Stitch's "Security" screen. Every setting here
/// is local device state (no auth backend exists yet), so toggles simply
/// hold in-memory state for this session.
class UserSecurityScreen extends StatefulWidget {
  const UserSecurityScreen({super.key});

  @override
  State<UserSecurityScreen> createState() => _UserSecurityScreenState();
}

class _UserSecurityScreenState extends State<UserSecurityScreen> {
  bool _biometric = true;
  String _timeout = '10 Minutes';

  Future<void> _changePin() async {
    final controller = TextEditingController();
    final newPin = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change PIN'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          maxLength: 4,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'New 4-digit PIN'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (newPin != null && newPin.length == 4 && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('PIN updated')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Security')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        children: [
          _SecurityCard(
            icon: Icons.pin_outlined,
            title: 'Change PIN',
            description: 'Used to unlock the app and confirm payments',
            trailing: TextButton(
              onPressed: _changePin,
              child: const Text('Change'),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _SecurityCard(
            icon: Icons.fingerprint_rounded,
            title: 'Biometric Login',
            description: 'Use fingerprint or face ID to unlock the app',
            trailing: Switch(
              value: _biometric,
              onChanged: (v) => setState(() => _biometric = v),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _SecurityCard(
            icon: Icons.timer_outlined,
            title: 'Session Timeout',
            description: 'Automatically log out after inactivity',
            trailing: DropdownButton<String>(
              value: _timeout,
              underline: const SizedBox.shrink(),
              items: const [
                DropdownMenuItem(value: '5 Minutes', child: Text('5 Minutes')),
                DropdownMenuItem(
                  value: '10 Minutes',
                  child: Text('10 Minutes'),
                ),
                DropdownMenuItem(
                  value: '15 Minutes',
                  child: Text('15 Minutes'),
                ),
                DropdownMenuItem(
                  value: '30 Minutes',
                  child: Text('30 Minutes'),
                ),
              ],
              onChanged: (v) => setState(() => _timeout = v!),
            ),
          ),
        ],
      ),
    );
  }
}

class _SecurityCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Widget trailing;

  const _SecurityCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryFixed,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleMd.copyWith(fontSize: 14),
                ),
                Text(
                  description,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
