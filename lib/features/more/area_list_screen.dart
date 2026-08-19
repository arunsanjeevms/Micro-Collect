import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';

class _Area {
  final String code;
  final String name;
  final bool active;
  final int customers;
  final int activeLoans;
  final double outstanding;

  const _Area({
    required this.code,
    required this.name,
    required this.active,
    required this.customers,
    required this.activeLoans,
    required this.outstanding,
  });
}

// Illustrative service areas only - there is no Area domain model or
// backend yet, so this list is fixed demo content.
const _areas = [
  _Area(
    code: 'NM-01',
    name: 'Namakkal Central',
    active: true,
    customers: 124,
    activeLoans: 88,
    outstanding: 420000,
  ),
  _Area(
    code: 'NM-02',
    name: 'Salem Road',
    active: true,
    customers: 96,
    activeLoans: 61,
    outstanding: 285000,
  ),
  _Area(
    code: 'NM-03',
    name: 'Tiruchengode Bypass',
    active: false,
    customers: 40,
    activeLoans: 12,
    outstanding: 65000,
  ),
];

/// Area List — matches Stitch's "Area List" screen. Demo roster only:
/// there is no Area domain model in this app yet.
class AreaListScreen extends StatelessWidget {
  const AreaListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Areas')),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        itemCount: _areas.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: _AreaCard(area: _areas[index]),
        ),
      ),
    );
  }
}

class _AreaCard extends StatelessWidget {
  final _Area area;

  const _AreaCard({required this.area});

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
                      area.name,
                      style: AppTypography.titleLg.copyWith(fontSize: 16),
                    ),
                    Text(
                      area.code,
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
                  color: area.active
                      ? AppColors.successLight
                      : AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  area.active ? 'Active' : 'Inactive',
                  style: AppTypography.labelSm.copyWith(
                    color: area.active
                        ? AppColors.success
                        : AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatColumn(
                  label: 'Customers',
                  value: '${area.customers}',
                ),
              ),
              Expanded(
                child: _StatColumn(
                  label: 'Active Loans',
                  value: '${area.activeLoans}',
                ),
              ),
              Expanded(
                child: _StatColumn(
                  label: 'Outstanding',
                  value: AppFormatters.currency(area.outstanding),
                  alignEnd: true,
                  valueColor: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  final bool alignEnd;
  final Color? valueColor;

  const _StatColumn({
    required this.label,
    required this.value,
    this.alignEnd = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelSm.copyWith(
            color: AppColors.outline,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.titleMd.copyWith(
            color: valueColor ?? AppColors.onSurface,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
