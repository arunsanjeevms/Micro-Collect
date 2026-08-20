import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/errors/app_exception.dart';
import '../../core/models/loan_scheme.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/async_value_view.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../../data/repositories/loan_scheme_repository.dart';
import 'providers/loan_scheme_providers.dart';

/// Loan Schemes — matches Stitch's "Loan Schemes" screen, backed by
/// backend/src/services/loanSchemeService.js (or MockDatabase in mock
/// mode) on both ends.
class LoanSchemesScreen extends ConsumerWidget {
  const LoanSchemesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schemesAsync = ref.watch(loanSchemesProvider);
    // Keeps these autoDispose controllers alive across their async submit()
    // calls below - a bare ref.read() would let them get torn down before
    // the write completes.
    ref.watch(setLoanSchemeActiveControllerProvider);
    ref.watch(deleteLoanSchemeControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Loan Schemes')),
      body: AsyncValueView<List<LoanScheme>>(
        value: schemesAsync,
        onRetry: () => ref.invalidate(loanSchemesProvider),
        isEmpty: (list) => list.isEmpty,
        empty: EmptyStateWidget(
          icon: Icons.category_outlined,
          title: 'No loan schemes yet',
          description: 'Add a scheme to give officers quick presets on the New Loan form.',
          actionLabel: 'Add Scheme',
          onAction: () => _showEditor(context, ref),
        ),
        data: (schemes) => ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          itemCount: schemes.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: _SchemeCard(
              scheme: schemes[index],
              onToggleActive: () => _toggleActive(context, ref, schemes[index]),
              onDelete: () => _delete(context, ref, schemes[index]),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEditor(context, ref),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Future<void> _toggleActive(
    BuildContext context,
    WidgetRef ref,
    LoanScheme scheme,
  ) async {
    await ref
        .read(setLoanSchemeActiveControllerProvider.notifier)
        .submit(scheme.id, !scheme.active);
    final error = ref.read(setLoanSchemeActiveControllerProvider).error;
    if (error != null && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(_message(error))));
    }
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    LoanScheme scheme,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete scheme?'),
        content: Text('This removes "${scheme.name}" permanently.'),
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
        .read(deleteLoanSchemeControllerProvider.notifier)
        .submit(scheme.id);
    if (!context.mounted) return;
    if (!ok) {
      final error = ref.read(deleteLoanSchemeControllerProvider).error;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(_message(error))));
    }
  }

  String _message(Object? error) =>
      error is AppException ? error.message : 'Something went wrong';

  Future<void> _showEditor(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _SchemeEditorSheet(),
    );
  }
}

class _SchemeCard extends StatelessWidget {
  final LoanScheme scheme;
  final VoidCallback onToggleActive;
  final VoidCallback onDelete;

  const _SchemeCard({
    required this.scheme,
    required this.onToggleActive,
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
              InkWell(
                onTap: onToggleActive,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.active
                        ? AppColors.successLight
                        : AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    scheme.active ? 'Active' : 'Inactive',
                    style: AppTypography.labelSm.copyWith(
                      color: scheme.active
                          ? AppColors.success
                          : AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, size: 20),
                color: AppColors.danger,
                onPressed: onDelete,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SchemeRow(
            icon: Icons.account_balance_outlined,
            label: 'Principal',
            value:
                '₹${scheme.principalMin.toStringAsFixed(0)} - ₹${scheme.principalMax.toStringAsFixed(0)}',
          ),
          const Divider(height: 20),
          _SchemeRow(
            icon: Icons.calendar_month_outlined,
            label: 'Tenure',
            value:
                '${scheme.tenureMin}-${scheme.tenureMax} ${scheme.tenureUnit}',
          ),
          const Divider(height: 20),
          _SchemeRow(
            icon: Icons.update_rounded,
            label: 'Frequency',
            value:
                scheme.frequency[0].toUpperCase() +
                scheme.frequency.substring(1),
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

class _SchemeEditorSheet extends ConsumerStatefulWidget {
  const _SchemeEditorSheet();

  @override
  ConsumerState<_SchemeEditorSheet> createState() => _SchemeEditorSheetState();
}

class _SchemeEditorSheetState extends ConsumerState<_SchemeEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _principalMinController = TextEditingController();
  final _principalMaxController = TextEditingController();
  final _tenureMinController = TextEditingController();
  final _tenureMaxController = TextEditingController();
  String _tenureUnit = 'Months';
  String _frequency = 'monthly';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _principalMinController.dispose();
    _principalMaxController.dispose();
    _tenureMinController.dispose();
    _tenureMaxController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSubmitting = true);

    final scheme = await ref
        .read(createLoanSchemeControllerProvider.notifier)
        .submit(
          LoanSchemeDraft(
            code: _codeController.text.trim(),
            name: _nameController.text.trim(),
            principalMin: double.parse(_principalMinController.text),
            principalMax: double.parse(_principalMaxController.text),
            tenureMin: int.parse(_tenureMinController.text),
            tenureMax: int.parse(_tenureMaxController.text),
            tenureUnit: _tenureUnit,
            frequency: _frequency,
          ),
        );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (scheme == null) {
      final error = ref.read(createLoanSchemeControllerProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error is AppException ? error.message : 'Could not create scheme',
          ),
        ),
      );
      return;
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // Watching the controller keeps it alive across the async submit() call
    // below - without this, the autoDispose provider is torn down as soon
    // as ref.read() returns, before the write completes.
    ref.watch(createLoanSchemeControllerProvider);

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
              Text('New Loan Scheme', style: AppTypography.titleLg),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _codeController,
                      textCapitalization: TextCapitalization.characters,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Required' : null,
                      decoration: const InputDecoration(labelText: 'Code'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _nameController,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Required' : null,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _principalMinController,
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          double.tryParse(v ?? '') == null ? 'Invalid' : null,
                      decoration: const InputDecoration(
                        labelText: 'Min Principal',
                        prefixText: '₹',
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextFormField(
                      controller: _principalMaxController,
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          double.tryParse(v ?? '') == null ? 'Invalid' : null,
                      decoration: const InputDecoration(
                        labelText: 'Max Principal',
                        prefixText: '₹',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _tenureMinController,
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          int.tryParse(v ?? '') == null ? 'Invalid' : null,
                      decoration: const InputDecoration(
                        labelText: 'Min Tenure',
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextFormField(
                      controller: _tenureMaxController,
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          int.tryParse(v ?? '') == null ? 'Invalid' : null,
                      decoration: const InputDecoration(
                        labelText: 'Max Tenure',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _tenureUnit,
                      decoration: const InputDecoration(labelText: 'Unit'),
                      items: const ['Days', 'Weeks', 'Months']
                          .map(
                            (u) => DropdownMenuItem(value: u, child: Text(u)),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _tenureUnit = v!),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _frequency,
                      decoration: const InputDecoration(labelText: 'Frequency'),
                      items: const ['daily', 'weekly', 'monthly']
                          .map(
                            (f) => DropdownMenuItem(
                              value: f,
                              child: Text(f[0].toUpperCase() + f.substring(1)),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _frequency = v!),
                    ),
                  ),
                ],
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
                      : const Text('Create Scheme'),
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
