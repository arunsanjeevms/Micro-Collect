import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class _Scheme {
  final String code;
  final String name;
  final bool active;
  final String principalRange;
  final String tenureRange;
  final String frequency;

  const _Scheme({
    required this.code,
    required this.name,
    required this.active,
    required this.principalRange,
    required this.tenureRange,
    required this.frequency,
  });
}

// Illustrative scheme templates only - the loan creation flow lets an
// officer pick any principal/tenure/frequency directly, so there is no
// LoanScheme domain model backing these presets yet.
const _schemes = [
  _Scheme(
    code: 'WML-01',
    name: 'Weekly Micro Loan',
    active: true,
    principalRange: '₹2,000 - ₹50,000',
    tenureRange: '20-50 Weeks',
    frequency: 'Weekly',
  ),
  _Scheme(
    code: 'MSL-02',
    name: 'Monthly SME Loan',
    active: true,
    principalRange: '₹50,000 - ₹5,00,000',
    tenureRange: '6-36 Months',
    frequency: 'Monthly',
  ),
  _Scheme(
    code: 'DVL-03',
    name: 'Daily Vendor Loan',
    active: true,
    principalRange: '₹1,000 - ₹10,000',
    tenureRange: '30-90 Days',
    frequency: 'Daily',
  ),
];

/// Loan Schemes — matches Stitch's "Loan Schemes" screen. Demo templates
/// only: there is no LoanScheme domain model in this app yet.
class LoanSchemesScreen extends StatelessWidget {
  const LoanSchemesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loan Schemes')),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        itemCount: _schemes.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: _SchemeCard(scheme: _schemes[index]),
        ),
      ),
    );
  }
}

class _SchemeCard extends StatelessWidget {
  final _Scheme scheme;

  const _SchemeCard({required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scheme.name,
                      style: AppTypography.titleLg.copyWith(fontSize: 16),
                    ),
                    Text(
                      scheme.code,
                      style: AppTypography.labelSm.copyWith(
                        color: AppColors.outline,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  scheme.active ? 'Active' : 'Inactive',
                  style: AppTypography.labelSm.copyWith(
                    color: AppColors.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SchemeRow(
            icon: Icons.account_balance_outlined,
            label: 'Principal',
            value: scheme.principalRange,
          ),
          const Divider(height: 20),
          _SchemeRow(
            icon: Icons.calendar_month_outlined,
            label: 'Tenure',
            value: scheme.tenureRange,
          ),
          const Divider(height: 20),
          _SchemeRow(
            icon: Icons.update_rounded,
            label: 'Frequency',
            value: scheme.frequency,
          ),
        ],
      ),
    );
  }
}

class _SchemeRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SchemeRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppColors.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTypography.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
          ],
        ),
        Text(value, style: AppTypography.titleMd.copyWith(fontSize: 13)),
      ],
    );
  }
}
