import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/validators.dart';
import '../../data/repositories/borrower_repository.dart';
import 'providers/borrower_providers.dart';

const _stepTitles = [
  'Basic Info',
  'Contact & Address',
  'KYC & Nominee',
  'Documents & Signature',
  'Review & Submit',
];

/// Add Borrower Screen — 5-step registration wizard, matching Stitch's
/// "Customer Registration" flow. Only the fields BorrowerDraft accepts
/// (name, mobile, aadhaar, village, address, pinCode) are persisted; the
/// remaining KYC/nominee/document/signature fields are collected for the
/// wizard's UI completeness but have nowhere to live until a backend
/// defines that shape.
class AddBorrowerScreen extends ConsumerStatefulWidget {
  const AddBorrowerScreen({super.key});

  @override
  ConsumerState<AddBorrowerScreen> createState() => _AddBorrowerScreenState();
}

class _AddBorrowerScreenState extends ConsumerState<AddBorrowerScreen> {
  final _pageController = PageController();
  final _step1Key = GlobalKey<FormState>();
  final _step2Key = GlobalKey<FormState>();
  int _step = 0;

  final _fullNameController = TextEditingController();
  final _guardianNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _aadhaarController = TextEditingController();
  final _addressController = TextEditingController();
  final _villageController = TextEditingController();
  final _pinCodeController = TextEditingController();
  final _nomineeNameController = TextEditingController();
  final _nomineeRelationController = TextEditingController();

  String _gender = 'Female';
  DateTime? _dob;
  bool _signatureCaptured = false;

  @override
  void dispose() {
    _pageController.dispose();
    _fullNameController.dispose();
    _guardianNameController.dispose();
    _mobileController.dispose();
    _aadhaarController.dispose();
    _addressController.dispose();
    _villageController.dispose();
    _pinCodeController.dispose();
    _nomineeNameController.dispose();
    _nomineeRelationController.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    setState(() => _step = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _handleNext() {
    if (_step == 0 && !(_step1Key.currentState?.validate() ?? false)) return;
    if (_step == 1 && !(_step2Key.currentState?.validate() ?? false)) return;
    if (_step == 3 && !_signatureCaptured) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please capture a signature to continue')),
      );
      return;
    }
    if (_step < _stepTitles.length - 1) _goToStep(_step + 1);
  }

  void _handleBack() {
    if (_step > 0) {
      _goToStep(_step - 1);
    } else {
      context.pop();
    }
  }

  Future<void> _handleSubmit() async {
    final borrower = await ref
        .read(createBorrowerControllerProvider.notifier)
        .submit(
          BorrowerDraft(
            name: _fullNameController.text.trim(),
            mobile: _mobileController.text.trim(),
            aadhaar: _aadhaarController.text.trim(),
            village: _villageController.text.trim(),
            address: _addressController.text.trim(),
            pinCode: _pinCodeController.text.trim(),
          ),
        );
    if (!mounted) return;

    final error = ref.read(createBorrowerControllerProvider).error;
    if (error != null || borrower == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not register borrower: ${error ?? 'unknown error'}',
          ),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: AppColors.successLight,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text('${borrower.name} registered successfully'),
          ],
        ),
        backgroundColor: AppColors.success,
      ),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = ref.watch(
      createBorrowerControllerProvider.select((s) => s.isLoading),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Borrower'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: _handleBack,
        ),
      ),
      body: Column(
        children: [
          _StepHeader(step: _step, total: _stepTitles.length),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildBasicInfo(),
                _buildContactAddress(),
                _buildKycNominee(),
                _buildDocumentsSignature(),
                _buildReviewSubmit(),
              ],
            ),
          ),
          _BottomBar(
            step: _step,
            totalSteps: _stepTitles.length,
            isSubmitting: isSubmitting,
            onNext: _handleNext,
            onSubmit: _handleSubmit,
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      child: Form(
        key: _step1Key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.outlineVariant,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Icon(
                      Icons.add_a_photo_outlined,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Customer Photo (Optional)',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            TextFormField(
              controller: _fullNameController,
              validator: AppValidators.name,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Full Name *',
                hintText: 'Enter legal name',
                prefixIcon: Icon(Icons.person_outlined, size: 20),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _guardianNameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Father / Husband Name',
                hintText: "Enter relative's name",
                prefixIcon: Icon(Icons.family_restroom_outlined, size: 20),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Gender',
              style: AppTypography.labelMd.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: ['Female', 'Male', 'Other'].map((g) {
                final isSelected = _gender == g;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(g),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _gender = g),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Date of Birth',
              style: AppTypography.labelMd.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            InkWell(
              onTap: () async {
                final now = DateTime.now();
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime(now.year - 30),
                  firstDate: DateTime(now.year - 100),
                  lastDate: DateTime(now.year - 18),
                );
                if (picked != null) setState(() => _dob = picked);
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.calendar_today_outlined, size: 20),
                ),
                child: Text(
                  _dob == null
                      ? 'Select date of birth'
                      : '${_dob!.day}/${_dob!.month}/${_dob!.year}',
                  style: AppTypography.bodyMd.copyWith(
                    color: _dob == null
                        ? AppColors.onSurfaceVariant
                        : AppColors.onSurface,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactAddress() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      child: Form(
        key: _step2Key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _mobileController,
              validator: AppValidators.mobile,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              decoration: const InputDecoration(
                labelText: 'Mobile Number *',
                hintText: '10-digit mobile number',
                prefixIcon: Icon(Icons.phone_outlined, size: 20),
                prefixText: '+91 ',
                counterText: '',
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _aadhaarController,
              validator: AppValidators.aadhaar,
              keyboardType: TextInputType.number,
              maxLength: 12,
              decoration: const InputDecoration(
                labelText: 'Aadhaar Number *',
                hintText: '12-digit Aadhaar number',
                prefixIcon: Icon(Icons.credit_card_outlined, size: 20),
                counterText: '',
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            TextFormField(
              controller: _addressController,
              validator: (v) => AppValidators.required(v, 'Address'),
              textCapitalization: TextCapitalization.words,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Address *',
                hintText: 'House number, street, area',
                prefixIcon: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Icon(Icons.home_outlined, size: 20),
                ),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _villageController,
                    validator: (v) => AppValidators.required(v, 'Village'),
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Village / Town *',
                      hintText: 'Village name',
                      prefixIcon: Icon(
                        Icons.holiday_village_outlined,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: TextFormField(
                    controller: _pinCodeController,
                    validator: AppValidators.pinCode,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: const InputDecoration(
                      labelText: 'PIN Code *',
                      hintText: '507001',
                      counterText: '',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKycNominee() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(icon: Icons.badge_outlined, title: 'KYC Verification'),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.infoLight.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.verified_outlined, size: 18, color: AppColors.info),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Aadhaar ${_aadhaarController.text.isEmpty ? '' : AppFormatters.maskAadhaar(_aadhaarController.text)} will be used as the primary KYC document.',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.info,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _SectionHeader(
            icon: Icons.people_outline_rounded,
            title: 'Nominee Details',
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _nomineeNameController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Nominee Name',
              hintText: "Enter nominee's full name",
              prefixIcon: Icon(Icons.person_outline_rounded, size: 20),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _nomineeRelationController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Relationship',
              hintText: 'e.g. Spouse, Son, Daughter',
              prefixIcon: Icon(Icons.diversity_3_outlined, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsSignature() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            icon: Icons.folder_outlined,
            title: 'Supporting Documents',
          ),
          const SizedBox(height: AppSpacing.md),
          const _DocumentUploadTile(label: 'Photo ID Proof'),
          const SizedBox(height: AppSpacing.sm),
          const _DocumentUploadTile(label: 'Address Proof'),
          const SizedBox(height: AppSpacing.xl),
          _SectionHeader(
            icon: Icons.draw_outlined,
            title: 'Customer Signature',
          ),
          const SizedBox(height: AppSpacing.md),
          InkWell(
            onTap: () => setState(() => _signatureCaptured = true),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: _signatureCaptured
                    ? AppColors.successLight.withValues(alpha: 0.3)
                    : AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _signatureCaptured
                      ? AppColors.success
                      : AppColors.outlineVariant,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _signatureCaptured
                          ? Icons.check_circle_rounded
                          : Icons.draw_outlined,
                      size: 32,
                      color: _signatureCaptured
                          ? AppColors.success
                          : AppColors.onSurfaceVariant,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _signatureCaptured
                          ? 'Signature captured'
                          : 'Tap to sign here',
                      style: AppTypography.bodyMd.copyWith(
                        color: _signatureCaptured
                            ? AppColors.success
                            : AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewSubmit() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryFixed.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.15),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.fact_check_outlined, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Review the details below before registering this borrower.',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _ReviewSection(
            title: 'Basic Info',
            onEdit: () => _goToStep(0),
            rows: {
              'Full Name': _fullNameController.text,
              if (_guardianNameController.text.isNotEmpty)
                'Guardian': _guardianNameController.text,
              'Gender': _gender,
              if (_dob != null)
                'DOB': '${_dob!.day}/${_dob!.month}/${_dob!.year}',
            },
          ),
          const SizedBox(height: AppSpacing.md),
          _ReviewSection(
            title: 'Contact & Address',
            onEdit: () => _goToStep(1),
            rows: {
              'Mobile': _mobileController.text,
              'Aadhaar': _aadhaarController.text,
              'Address': _addressController.text,
              'Village': _villageController.text,
              'PIN Code': _pinCodeController.text,
            },
          ),
          if (_nomineeNameController.text.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            _ReviewSection(
              title: 'Nominee',
              onEdit: () => _goToStep(2),
              rows: {
                'Name': _nomineeNameController.text,
                if (_nomineeRelationController.text.isNotEmpty)
                  'Relation': _nomineeRelationController.text,
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _StepHeader extends StatelessWidget {
  final int step;
  final int total;

  const _StepHeader({required this.step, required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.marginMobile,
        AppSpacing.sm,
        AppSpacing.marginMobile,
        AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _stepTitles[step],
                style: AppTypography.titleMd.copyWith(color: AppColors.primary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Step ${step + 1} of $total',
                  style: AppTypography.labelSm.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (step + 1) / total,
              minHeight: 6,
              backgroundColor: AppColors.surfaceContainer,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final int step;
  final int totalSteps;
  final bool isSubmitting;
  final VoidCallback onNext;
  final VoidCallback onSubmit;

  const _BottomBar({
    required this.step,
    required this.totalSteps,
    required this.isSubmitting,
    required this.onNext,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final isLastStep = step == totalSteps - 1;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: const Border(
          top: BorderSide(color: AppColors.outlineVariant, width: 0.5),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: isSubmitting ? null : (isLastStep ? onSubmit : onNext),
          icon: isSubmitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.white,
                  ),
                )
              : Icon(
                  isLastStep
                      ? Icons.check_rounded
                      : Icons.arrow_forward_rounded,
                  size: 20,
                ),
          label: Text(
            isSubmitting
                ? 'Registering...'
                : (isLastStep ? 'Register Borrower' : 'Next'),
          ),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

class _DocumentUploadTile extends StatefulWidget {
  final String label;

  const _DocumentUploadTile({required this.label});

  @override
  State<_DocumentUploadTile> createState() => _DocumentUploadTileState();
}

class _DocumentUploadTileState extends State<_DocumentUploadTile> {
  bool _uploaded = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() => _uploaded = true),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _uploaded
              ? AppColors.successLight.withValues(alpha: 0.3)
              : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _uploaded ? AppColors.success : AppColors.outlineVariant,
          ),
        ),
        child: Row(
          children: [
            Icon(
              _uploaded
                  ? Icons.check_circle_rounded
                  : Icons.upload_file_outlined,
              color: _uploaded ? AppColors.success : AppColors.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _uploaded ? '${widget.label} uploaded' : widget.label,
                style: AppTypography.bodyMd.copyWith(
                  color: _uploaded ? AppColors.success : AppColors.onSurface,
                ),
              ),
            ),
            if (!_uploaded)
              Text(
                'Upload',
                style: AppTypography.labelMd.copyWith(color: AppColors.primary),
              ),
          ],
        ),
      ),
    );
  }
}

class _ReviewSection extends StatelessWidget {
  final String title;
  final Map<String, String> rows;
  final VoidCallback onEdit;

  const _ReviewSection({
    required this.title,
    required this.rows,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTypography.titleMd.copyWith(fontSize: 14)),
              TextButton(onPressed: onEdit, child: const Text('Edit')),
            ],
          ),
          const Divider(height: 16),
          for (final entry in rows.entries)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.key,
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      entry.value,
                      style: AppTypography.bodySm.copyWith(fontSize: 12),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
