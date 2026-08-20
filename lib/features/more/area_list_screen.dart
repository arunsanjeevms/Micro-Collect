import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/errors/app_exception.dart';
import '../../core/models/area.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/async_value_view.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../../data/repositories/area_repository.dart';
import 'providers/area_providers.dart';

/// Area List — matches Stitch's "Area List" screen. customers/activeLoans/
/// outstanding are real, derived from Borrower.areaId on both backends.
class AreaListScreen extends ConsumerWidget {
  const AreaListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final areasAsync = ref.watch(areasProvider);
    // Keeps the autoDispose delete controller alive across its async
    // submit() call - a bare ref.read() would let it get torn down before
    // the write completes.
    ref.watch(deleteAreaControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Areas')),
      body: AsyncValueView<List<Area>>(
        value: areasAsync,
        onRetry: () => ref.invalidate(areasProvider),
        isEmpty: (list) => list.isEmpty,
        empty: EmptyStateWidget(
          icon: Icons.map_outlined,
          title: 'No areas yet',
          description: 'Add an area to start assigning borrowers to it.',
          actionLabel: 'Add Area',
          onAction: () => _showEditor(context),
        ),
        data: (areas) => ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          itemCount: areas.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: _AreaCard(
              area: areas[index],
              onEdit: () => _showEditor(context, existing: areas[index]),
              onDelete: () => _delete(context, ref, areas[index]),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEditor(context),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, Area area) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete area?'),
        content: Text('This removes "${area.name}" permanently.'),
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
        .read(deleteAreaControllerProvider.notifier)
        .submit(area.id);
    if (!context.mounted) return;
    if (!ok) {
      final error = ref.read(deleteAreaControllerProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error is AppException ? error.message : 'Something went wrong',
          ),
        ),
      );
    }
  }

  Future<void> _showEditor(BuildContext context, {Area? existing}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _AreaEditorSheet(existing: existing),
    );
  }
}

class _AreaCard extends StatelessWidget {
  final Area area;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AreaCard({
    required this.area,
    required this.onEdit,
    required this.onDelete,
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

class _AreaEditorSheet extends ConsumerStatefulWidget {
  final Area? existing;

  const _AreaEditorSheet({this.existing});

  @override
  ConsumerState<_AreaEditorSheet> createState() => _AreaEditorSheetState();
}

class _AreaEditorSheetState extends ConsumerState<_AreaEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late bool _active;
  bool _isSubmitting = false;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.existing?.code);
    _nameController = TextEditingController(text: widget.existing?.name);
    _active = widget.existing?.active ?? true;
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSubmitting = true);

    final Area? result;
    if (_isEditing) {
      result = await ref
          .read(updateAreaControllerProvider.notifier)
          .submit(
            widget.existing!.id,
            AreaPatch(
              code: _codeController.text.trim(),
              name: _nameController.text.trim(),
              active: _active,
            ),
          );
    } else {
      result = await ref
          .read(createAreaControllerProvider.notifier)
          .submit(
            AreaDraft(
              code: _codeController.text.trim(),
              name: _nameController.text.trim(),
              active: _active,
            ),
          );
    }

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (result == null) {
      final error = _isEditing
          ? ref.read(updateAreaControllerProvider).error
          : ref.read(createAreaControllerProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error is AppException ? error.message : 'Could not save area',
          ),
        ),
      );
      return;
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // Watching keeps the autoDispose controller alive across the async
    // submit() call below - a bare ref.read() would let it get torn down
    // before the write completes.
    ref.watch(createAreaControllerProvider);
    ref.watch(updateAreaControllerProvider);

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
                _isEditing ? 'Edit Area' : 'New Area',
                style: AppTypography.titleLg,
              ),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                controller: _codeController,
                textCapitalization: TextCapitalization.characters,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Code is required' : null,
                decoration: const InputDecoration(labelText: 'Code'),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Name is required' : null,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(child: Text('Active', style: AppTypography.bodyMd)),
                  Switch(
                    value: _active,
                    onChanged: (v) => setState(() => _active = v),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
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
                      : Text(_isEditing ? 'Save Changes' : 'Create Area'),
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
