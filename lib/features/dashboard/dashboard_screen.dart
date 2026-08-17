import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/stat_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MicroCollect'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            Text(
              'Good Morning, Arun',
              style: AppTypography.headlineLgMobile.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'System Online & Synced',
                  style: AppTypography.bodyMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Hero Glass Card
            GlassCard(
              color: AppColors.primaryFixed,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TODAY\'S COLLECTION',
                          style: AppTypography.labelMd.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          '₹24,850',
                          style: AppTypography.displayLg.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primaryContainer, width: 4),
                    ),
                    child: Center(
                      child: Text(
                        '82.8%',
                        style: AppTypography.titleMd.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Stats Grid
            StatCard(
              label: 'Today\'s Due',
              value: '₹32,500',
              icon: Icons.calendar_today,
              accentColor: AppColors.primary,
            ),
            const SizedBox(height: AppSpacing.md),
            StatCard(
              label: 'Pending',
              value: '₹7,650',
              icon: Icons.pending_actions,
              accentColor: AppColors.warning,
            ),
            const SizedBox(height: AppSpacing.md),
            StatCard(
              label: 'Overdue',
              value: '₹4,200',
              icon: Icons.warning,
              accentColor: AppColors.error,
            ),
          ],
        ),
      ),
    );
  }
}
