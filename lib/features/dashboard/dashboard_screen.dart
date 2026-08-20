import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/models/collection_entry.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/stat_card.dart';
import '../collections/providers/collection_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(collectionSummaryProvider);
    final entriesAsync = ref.watch(todayCollectionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primaryContainer,
                  child: Icon(
                    Icons.person_rounded,
                    size: 18,
                    color: AppColors.white,
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: AppSpacing.sm),
            const Text('MicroCollect'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () => context.push('/more/sync'),
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
                          summaryAsync.when(
                            data: (s) =>
                                AppFormatters.currency(s.totalCollected),
                            loading: () => '...',
                            error: (_, _) => '—',
                          ),
                          style: AppTypography.displayLg.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.trending_up_rounded,
                              size: 16,
                              color: AppColors.success,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              'On track to meet daily target',
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox.expand(
                          child: CircularProgressIndicator(
                            value: summaryAsync.value == null
                                ? 0
                                : summaryAsync.value!.efficiency / 100,
                            strokeWidth: 8,
                            backgroundColor: AppColors.surfaceContainerHighest,
                            valueColor: const AlwaysStoppedAnimation(
                              AppColors.primaryContainer,
                            ),
                          ),
                        ),
                        Text(
                          summaryAsync.value == null
                              ? '—'
                              : '${summaryAsync.value!.efficiency.toStringAsFixed(1)}%',
                          style: AppTypography.titleLg.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Stats Grid
            StatCard(
              label: 'Today\'s Due',
              value: summaryAsync.when(
                data: (s) => AppFormatters.currency(s.totalDue),
                loading: () => '...',
                error: (_, _) => '—',
              ),
              icon: Icons.calendar_today,
              accentColor: AppColors.primary,
            ),
            const SizedBox(height: AppSpacing.md),
            StatCard(
              label: 'Pending',
              value: entriesAsync.when(
                data: (entries) => AppFormatters.currency(
                  _sumRemaining(entries, CollectionStatus.pending),
                ),
                loading: () => '...',
                error: (_, _) => '—',
              ),
              icon: Icons.pending_actions,
              accentColor: AppColors.warning,
            ),
            const SizedBox(height: AppSpacing.md),
            StatCard(
              label: 'Overdue',
              value: entriesAsync.when(
                data: (entries) => AppFormatters.currency(
                  _sumRemaining(entries, CollectionStatus.overdue),
                ),
                loading: () => '...',
                error: (_, _) => '—',
              ),
              icon: Icons.warning,
              accentColor: AppColors.error,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Quick Actions
            Text(
              'Quick Actions',
              style: AppTypography.titleMd.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => context.go('/collections'),
                icon: const Icon(Icons.payments_rounded),
                label: const Text('Collect Payment'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(64),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.go('/borrowers'),
                    icon: const Icon(Icons.search_rounded, size: 20),
                    label: const Text('Search Customer'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.go('/borrowers'),
                    icon: const Icon(Icons.add_circle_rounded, size: 20),
                    label: const Text('New Loan'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double _sumRemaining(List<CollectionEntry> entries, CollectionStatus status) {
    return entries
        .where((e) => e.status == status)
        .fold<double>(0, (sum, e) => sum + e.totalDue - (e.amountPaid ?? 0));
  }
}
