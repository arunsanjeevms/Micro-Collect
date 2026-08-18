import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/utils/validators.dart';

/// Add Borrower Screen — validated form for new borrower registration
class AddBorrowerScreen extends StatefulWidget {
  const AddBorrowerScreen({super.key});

  @override
  State<AddBorrowerScreen> createState() => _AddBorrowerScreenState();
}

class _AddBorrowerScreenState extends State<AddBorrowerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _aadhaarController = TextEditingController();
  final _addressController = TextEditingController();
  final _villageController = TextEditingController();
  final _pinCodeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _aadhaarController.dispose();
    _addressController.dispose();
    _villageController.dispose();
    _pinCodeController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      // Show success and pop
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
              Text('${_nameController.text} added successfully'),
            ],
          ),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Borrower')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
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
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_add_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'New Borrower Registration',
                            style: AppTypography.titleMd.copyWith(
                              color: AppColors.primary,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Fill in the details to register a new borrower',
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // ─── Personal Information ──────────────────────────
              _SectionHeader(
                icon: Icons.person_outline_rounded,
                title: 'Personal Information',
              ),
              const SizedBox(height: AppSpacing.md),

              TextFormField(
                controller: _nameController,
                validator: AppValidators.name,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Full Name *',
                  hintText: 'Enter borrower\'s full name',
                  prefixIcon: Icon(Icons.person_outlined, size: 20),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

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

              // ─── Address ───────────────────────────────────────
              _SectionHeader(
                icon: Icons.location_on_outlined,
                title: 'Address Details',
              ),
              const SizedBox(height: AppSpacing.md),

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
              const SizedBox(height: AppSpacing.xxl),

              // Submit
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _handleSubmit,
                  icon: const Icon(Icons.check_rounded, size: 20),
                  label: const Text('Register Borrower'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                  ),
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

// ─── Section Header ──────────────────────────────────────────────
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
