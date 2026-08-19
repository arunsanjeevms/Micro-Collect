import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Printer Settings — matches Stitch's screen. There's no real Bluetooth
/// printer integration in this build, so connection state is local UI
/// state and "Test Print"/"Connect" surface a SnackBar rather than
/// pretending to talk to hardware.
class PrinterSettingsScreen extends StatefulWidget {
  const PrinterSettingsScreen({super.key});

  @override
  State<PrinterSettingsScreen> createState() => _PrinterSettingsScreenState();
}

class _PrinterSettingsScreenState extends State<PrinterSettingsScreen> {
  bool _bluetoothOn = true;
  String _paperSize = '58mm';
  bool _autoPrint = true;

  void _notAvailable(String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$action isn\'t available in this preview yet')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Printer Settings')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              children: [
                Icon(Icons.bluetooth_rounded, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Bluetooth Status',
                    style: AppTypography.titleMd.copyWith(fontSize: 14),
                  ),
                ),
                Switch(
                  value: _bluetoothOn,
                  onChanged: (v) => setState(() => _bluetoothOn = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Connected Printer',
                  style: AppTypography.titleLg.copyWith(
                    color: AppColors.primary,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Paper Size',
                  style: AppTypography.labelMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: ['58mm', '80mm'].map((size) {
                      final selected = _paperSize == size;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _paperSize = size),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: selected ? AppColors.white : null,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: selected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.black.withValues(
                                          alpha: 0.06,
                                        ),
                                        blurRadius: 4,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                size,
                                style: AppTypography.labelMd.copyWith(
                                  color: selected
                                      ? AppColors.primary
                                      : AppColors.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Auto Print Receipt',
                        style: AppTypography.bodyMd.copyWith(fontSize: 14),
                      ),
                    ),
                    Switch(
                      value: _autoPrint,
                      onChanged: (v) => setState(() => _autoPrint = v),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _notAvailable('Test print'),
                        icon: const Icon(Icons.print_outlined, size: 18),
                        label: const Text('Test Print'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => setState(() => _bluetoothOn = false),
                        icon: const Icon(Icons.link_off_rounded, size: 18),
                        label: const Text('Disconnect'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'AVAILABLE DEVICES',
                style: AppTypography.labelSm.copyWith(
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 1.2,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh_rounded, size: 20),
                onPressed: () => _notAvailable('Scanning'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final name in ['RPP02N-Printer', 'Epson TM-P20'])
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.print_outlined,
                      color: AppColors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        name,
                        style: AppTypography.bodyMd.copyWith(fontSize: 13),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _notAvailable('Connecting'),
                      child: const Text('Connect'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
