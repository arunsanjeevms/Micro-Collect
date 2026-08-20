import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/errors/app_exception.dart';
import '../../core/models/area.dart';
import '../../core/models/employee.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/avatar_color.dart';
import '../../core/widgets/async_value_view.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../../data/repositories/employee_repository.dart';
import 'providers/area_providers.dart';
import 'providers/employee_providers.dart';

/// Employee List — matches Stitch's "Employee List" screen, backed by
/// backend/src/services/employeeService.js (or MockDatabase in mock mode)
/// on both ends.
class EmployeeListScreen extends ConsumerStatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  ConsumerState<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends ConsumerState<EmployeeListScreen> {
  EmployeeStatus? _filter;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final employeesAsync = ref.watch(employeesProvider);
    // Keeps the autoDispose delete controller alive across its async
    // submit() call - a bare ref.read() would let it get torn down before
    // the write completes.
    ref.watch(deleteEmployeeControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Employees')),
      body: AsyncValueView<List<Employee>>(
        value: employeesAsync,
        onRetry: () => ref.invalidate(employeesProvider),
        isEmpty: (list) => list.isEmpty,
        empty: EmptyStateWidget(
          icon: Icons.groups_outlined,
          title: 'No employees yet',
          description: 'Add your first field officer or staff member.',
          actionLabel: 'Add Employee',
          onAction: () => _showEditor(context),
        ),
        data: (employees) {
          final query = _searchController.text.toLowerCase();
          final visible = employees.where((e) {
            if (_filter != null && e.status != _filter) return false;
            if (query.isEmpty) return true;
            return e.name.toLowerCase().contains(query) ||
                e.id.toLowerCase().contains(query);
          }).toList();

          return Column(
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
                            selected: _filter == EmployeeStatus.active,
                            onTap: () =>
                                setState(() => _filter = EmployeeStatus.active),
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: 'On Field',
                            selected: _filter == EmployeeStatus.onField,
                            onTap: () => setState(
                              () => _filter = EmployeeStatus.onField,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: 'Office',
                            selected: _filter == EmployeeStatus.office,
                            onTap: () =>
                                setState(() => _filter = EmployeeStatus.office),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: visible.isEmpty
                    ? EmptyStateWidget(
                        icon: Icons.filter_alt_off_outlined,
                        title: 'No matching employees',
                        description: 'Try a different search or filter.',
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.marginMobile,
                        ),
                        itemCount: visible.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: _EmployeeCard(
                            employee: visible[index],
                            onEdit: () =>
                                _showEditor(context, existing: visible[index]),
                            onDelete: () => _delete(context, visible[index]),
                          ),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEditor(context),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Future<void> _delete(BuildContext context, Employee employee) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete employee?'),
        content: Text('This removes "${employee.name}" permanently.'),
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
        .read(deleteEmployeeControllerProvider.notifier)
        .submit(employee.id);
    if (!context.mounted) return;
    if (!ok) {
      final error = ref.read(deleteEmployeeControllerProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error is AppException ? error.message : 'Something went wrong',
          ),
        ),
      );
    }
  }

  Future<void> _showEditor(BuildContext context, {Employee? existing}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _EmployeeEditorSheet(existing: existing),
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
  final Employee employee;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _EmployeeCard({
    required this.employee,
    required this.onEdit,
    required this.onDelete,
  });

  (Color, String) get _statusStyle {
    switch (employee.status) {
      case EmployeeStatus.active:
        return (AppColors.success, 'Active');
      case EmployeeStatus.onField:
        return (AppColors.warning, 'On Field');
      case EmployeeStatus.office:
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
                    Expanded(
                      child: Text(
                        '${employee.id} · ${employee.areaName ?? 'No area'} · $label',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'edit') onEdit();
              if (v == 'delete') onDelete();
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit')),
              PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmployeeEditorSheet extends ConsumerStatefulWidget {
  final Employee? existing;

  const _EmployeeEditorSheet({this.existing});

  @override
  ConsumerState<_EmployeeEditorSheet> createState() =>
      _EmployeeEditorSheetState();
}

class _EmployeeEditorSheetState extends ConsumerState<_EmployeeEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _mobileController;
  String? _areaId;
  late EmployeeStatus _status;
  bool _isSubmitting = false;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existing?.name);
    _mobileController = TextEditingController(text: widget.existing?.mobile);
    _areaId = widget.existing?.areaId;
    _status = widget.existing?.status ?? EmployeeStatus.active;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSubmitting = true);

    final Employee? result;
    if (_isEditing) {
      result = await ref
          .read(updateEmployeeControllerProvider.notifier)
          .submit(
            widget.existing!.id,
            EmployeePatch(
              name: _nameController.text.trim(),
              mobile: _mobileController.text.trim(),
              areaId: _areaId,
              status: _status,
            ),
          );
    } else {
      result = await ref
          .read(createEmployeeControllerProvider.notifier)
          .submit(
            EmployeeDraft(
              name: _nameController.text.trim(),
              mobile: _mobileController.text.trim(),
              areaId: _areaId,
              status: _status,
            ),
          );
    }

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (result == null) {
      final error = _isEditing
          ? ref.read(updateEmployeeControllerProvider).error
          : ref.read(createEmployeeControllerProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error is AppException ? error.message : 'Could not save employee',
          ),
        ),
      );
      return;
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final areasAsync = ref.watch(areasProvider);
    // Keeps the autoDispose controller alive across the async submit()
    // call below - a bare ref.read() would let it get torn down before
    // the write completes.
    ref.watch(createEmployeeControllerProvider);
    ref.watch(updateEmployeeControllerProvider);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isEditing ? 'Edit Employee' : 'New Employee',
                style: AppTypography.titleLg,
              ),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                validator: (v) => (v == null || v.trim().length < 2)
                    ? 'Name is required'
                    : null,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                validator: (v) => RegExp(r'^[6-9]\d{9}$').hasMatch(v ?? '')
                    ? null
                    : 'Enter a valid 10-digit mobile number',
                decoration: const InputDecoration(
                  labelText: 'Mobile Number',
                  counterText: '',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              areasAsync.when(
                data: (areas) => DropdownButtonFormField<String?>(
                  initialValue: _areaId,
                  decoration: const InputDecoration(labelText: 'Area'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('No area')),
                    ...areas.map(
                      (Area a) =>
                          DropdownMenuItem(value: a.id, child: Text(a.name)),
                    ),
                  ],
                  onChanged: (v) => setState(() => _areaId = v),
                ),
                loading: () => const LinearProgressIndicator(),
                error: (_, _) => const Text('Could not load areas'),
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<EmployeeStatus>(
                initialValue: _status,
                decoration: const InputDecoration(labelText: 'Status'),
                items: const [
                  DropdownMenuItem(
                    value: EmployeeStatus.active,
                    child: Text('Active'),
                  ),
                  DropdownMenuItem(
                    value: EmployeeStatus.onField,
                    child: Text('On Field'),
                  ),
                  DropdownMenuItem(
                    value: EmployeeStatus.office,
                    child: Text('Office'),
                  ),
                ],
                onChanged: (v) => setState(() => _status = v!),
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          ),
                        )
                      : Text(_isEditing ? 'Save Changes' : 'Create Employee'),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
