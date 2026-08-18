import 'package:flutter/material.dart';

import '../errors/app_exception.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../constants/app_spacing.dart';

/// Mirrors EmptyStateWidget's layout, but for a failed load: switches on the
/// sealed AppException hierarchy so every error type in core/errors gets a
/// deliberate icon and copy instead of a generic "Something went wrong".
class ErrorStateWidget extends StatelessWidget {
  final Object error;
  final VoidCallback? onRetry;

  const ErrorStateWidget({super.key, required this.error, this.onRetry});

  (IconData, String, String) get _copy {
    final err = error;
    return switch (err) {
      NetworkException() => (
        Icons.cloud_off_rounded,
        'You\'re offline',
        'Showing what\'s already on this device. Reconnect to refresh.',
      ),
      NotFoundException(:final message) => (
        Icons.search_off_rounded,
        'Not found',
        message,
      ),
      PermissionException(:final message) => (
        Icons.lock_outline_rounded,
        'Not allowed',
        message,
      ),
      PrinterException() => (
        Icons.print_disabled_rounded,
        'Printer unavailable',
        'The receipt couldn\'t be printed. You can retry from the receipt screen.',
      ),
      SyncException() => (
        Icons.sync_problem_rounded,
        'Sync failed',
        'Your data is saved on this device and will retry automatically.',
      ),
      PaymentFailedException(:final message) => (
        Icons.error_outline_rounded,
        'Payment failed',
        message,
      ),
      ValidationException(:final message) => (
        Icons.error_outline_rounded,
        'Check the details',
        message,
      ),
      // The sealed AppException hierarchy is already fully matched above;
      // this only catches a non-AppException Object (e.g. a raw Exception).
      _ => (
        Icons.error_outline_rounded,
        'Something went wrong',
        'Please try again.',
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final (icon, title, description) = _copy;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.dangerLight,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: AppColors.danger),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: AppTypography.titleLg.copyWith(color: AppColors.onSurface),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              description,
              style: AppTypography.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
