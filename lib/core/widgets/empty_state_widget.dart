import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../constants/app_spacing.dart';

/// Reusable empty state widget for list screens
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        // A parent with little vertical space to give (e.g. a list under a
        // tall summary card, once a filter empties it) would otherwise
        // overflow a fixed-size Column here instead of just scrolling.
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
              ),
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
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add, size: 18),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
