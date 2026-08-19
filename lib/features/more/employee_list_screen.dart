import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/avatar_color.dart';
import '../../core/utils/formatters.dart';

enum _EmployeeStatus { active, onField, office }

class _Employee {
  final String id;
  final String name;
  final String area;
  final double todayCollection;
  final _EmployeeStatus status;

  const _Employee({
    required this.id,
    required this.name,
    required this.area,
    required this.todayCollection,
    required this.status,
  });
}

// Illustrative roster only - there is no Employee domain model or backend
// yet, so this list is fixed demo content rather than something a write
// path could ever change.
const _employees = [
  _Employee(
    id: 'EMP-082',
    name: 'Arun Kumar',
    area: 'Namakkal',
    todayCollection: 24850,
    status: _EmployeeStatus.active,
  ),
  _Employee(
    id: 'EMP-045',
    name: 'Priya Sharma',
    area: 'Salem Area',
    todayCollection: 18200,
    status: _EmployeeStatus.active,
  ),
  _Employee(
    id: 'EMP-112',
    name: 'Rajesh Verma',
    area: 'Erode',
    todayCollection: 9450,
    status: _EmployeeStatus.onField,
  ),
  _Employee(
    id: 'EMP-099',
    name: 'Karthik S.',
    area: 'Tirupur',
    todayCollection: 0,
    status: _EmployeeStatus.office,
  ),
];

/// Employee List — matches Stitch's "Employee List" screen. Demo roster
/// only: there is no Employee domain model in this app yet.
class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  _EmployeeStatus? _filter;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.toLowerCase();
    final visible = _employees.where((e) {
      if (_filter != null && e.status != _filter) return false;
      if (query.isEmpty) return true;
      return e.name.toLowerCase().contains(query) ||
          e.id.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Employees')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: 'Search by name or ID',
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _FilterChip(
                        label: 'All Staff',
                        selected: _filter == null,
                        onTap: () => setState(() => _filter = null),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Active',
                        selected: _filter == _EmployeeStatus.active,
                        onTap: () =>
                            setState(() => _filter = _EmployeeStatus.active),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'On Field',
                        selected: _filter == _EmployeeStatus.onField,
                        onTap: () =>
                            setState(() => _filter = _EmployeeStatus.onField),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Office',
                        selected: _filter == _EmployeeStatus.office,
                        onTap: () =>
                            setState(() => _filter = _EmployeeStatus.office),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.marginMobile,
              ),
              itemCount: visible.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: _EmployeeCard(employee: visible[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.outlineVariant,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTypography.labelMd.copyWith(
            color: selected ? AppColors.white : AppColors.onSurfaceVariant,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _EmployeeCard extends StatelessWidget {
  final _Employee employee;

  const _EmployeeCard({required this.employee});

  (Color, String) get _statusStyle {
    switch (employee.status) {
      case _EmployeeStatus.active:
        return (AppColors.success, 'Active');
      case _EmployeeStatus.onField:
        return (AppColors.warning, 'On Field');
      case _EmployeeStatus.office:
        return (AppColors.onSurfaceVariant, 'Office');
    }
  }

  @override
  Widget build(BuildContext context) {
    final (dotColor, label) = _statusStyle;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: avatarColorForId(employee.id),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                employee.name.split(' ').map((w) => w[0]).take(2).join(),
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee.name,
                  style: AppTypography.titleMd.copyWith(fontSize: 14),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${employee.id} · ${employee.area} · $label',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "TODAY'S COL.",
                style: AppTypography.labelSm.copyWith(
                  color: AppColors.outline,
                  fontSize: 9,
                ),
              ),
              Text(
                AppFormatters.currency(employee.todayCollection),
                style: AppTypography.titleMd.copyWith(
                  color: AppColors.primary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
