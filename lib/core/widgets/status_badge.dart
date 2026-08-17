import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Status types for loans, payments, installments
enum StatusType {
  paid,
  pending,
  overdue,
  active,
  closed,
  disbursed,
  processing,
  failed,
  cancelled,
  partial,
  advance,
}

/// Reusable status badge with color + text label
/// Follows accessibility: color + text indicator, never color alone
class StatusBadge extends StatelessWidget {
  final StatusType status;
  final String? customLabel;
  final bool compact;

  const StatusBadge({
    super.key,
    required this.status,
    this.customLabel,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getConfig();
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 10,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(compact ? 4 : 6),
        border: Border.all(color: config.borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: compact ? 5 : 6,
            height: compact ? 5 : 6,
            decoration: BoxDecoration(
              color: config.dotColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: compact ? 4 : 6),
          Text(
            customLabel ?? config.label,
            style: (compact ? AppTypography.labelSm : AppTypography.labelMd)
                .copyWith(
              color: config.textColor,
              fontSize: compact ? 10 : 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _getConfig() {
    switch (status) {
      case StatusType.paid:
        return _StatusConfig(
          label: 'PAID',
          dotColor: AppColors.success,
          textColor: AppColors.success,
          backgroundColor: AppColors.successLight,
          borderColor: AppColors.success.withValues(alpha: 0.2),
        );
      case StatusType.pending:
        return _StatusConfig(
          label: 'PENDING',
          dotColor: AppColors.warning,
          textColor: AppColors.warning,
          backgroundColor: AppColors.warningLight,
          borderColor: AppColors.warning.withValues(alpha: 0.2),
        );
      case StatusType.overdue:
        return _StatusConfig(
          label: 'OVERDUE',
          dotColor: AppColors.danger,
          textColor: AppColors.danger,
          backgroundColor: AppColors.dangerLight,
          borderColor: AppColors.danger.withValues(alpha: 0.2),
        );
      case StatusType.active:
        return _StatusConfig(
          label: 'ACTIVE',
          dotColor: AppColors.success,
          textColor: AppColors.success,
          backgroundColor: AppColors.successLight,
          borderColor: AppColors.success.withValues(alpha: 0.2),
        );
      case StatusType.closed:
        return _StatusConfig(
          label: 'CLOSED',
          dotColor: AppColors.onSurfaceVariant,
          textColor: AppColors.onSurfaceVariant,
          backgroundColor: AppColors.surfaceContainer,
          borderColor: AppColors.outlineVariant,
        );
      case StatusType.disbursed:
        return _StatusConfig(
          label: 'DISBURSED',
          dotColor: AppColors.info,
          textColor: AppColors.info,
          backgroundColor: AppColors.infoLight,
          borderColor: AppColors.info.withValues(alpha: 0.2),
        );
      case StatusType.processing:
        return _StatusConfig(
          label: 'PROCESSING',
          dotColor: AppColors.info,
          textColor: AppColors.info,
          backgroundColor: AppColors.infoLight,
          borderColor: AppColors.info.withValues(alpha: 0.2),
        );
      case StatusType.failed:
        return _StatusConfig(
          label: 'FAILED',
          dotColor: AppColors.error,
          textColor: AppColors.error,
          backgroundColor: AppColors.errorContainer,
          borderColor: AppColors.error.withValues(alpha: 0.2),
        );
      case StatusType.cancelled:
        return _StatusConfig(
          label: 'CANCELLED',
          dotColor: AppColors.onSurfaceVariant,
          textColor: AppColors.onSurfaceVariant,
          backgroundColor: AppColors.surfaceContainer,
          borderColor: AppColors.outlineVariant,
        );
      case StatusType.partial:
        return _StatusConfig(
          label: 'PARTIAL',
          dotColor: AppColors.warning,
          textColor: AppColors.warning,
          backgroundColor: AppColors.warningLight,
          borderColor: AppColors.warning.withValues(alpha: 0.2),
        );
      case StatusType.advance:
        return _StatusConfig(
          label: 'ADVANCE',
          dotColor: AppColors.info,
          textColor: AppColors.info,
          backgroundColor: AppColors.infoLight,
          borderColor: AppColors.info.withValues(alpha: 0.2),
        );
    }
  }
}

class _StatusConfig {
  final String label;
  final Color dotColor;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;

  const _StatusConfig({
    required this.label,
    required this.dotColor,
    required this.textColor,
    required this.backgroundColor,
    required this.borderColor,
  });
}
