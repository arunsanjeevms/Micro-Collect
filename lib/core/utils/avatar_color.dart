import 'package:flutter/material.dart';

/// Deterministic avatar background colour, keyed off an entity's numeric id
/// suffix (e.g. B003 -> index 3) so the same id always renders the same colour.
Color avatarColorForId(String id) {
  const colors = [
    Color(0xFF065F46),
    Color(0xFF855300),
    Color(0xFF393768),
    Color(0xFF059669),
    Color(0xFF2563EB),
    Color(0xFFD97706),
    Color(0xFF0D9488),
    Color(0xFF6366F1),
  ];
  final index = int.tryParse(id.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
  return colors[index % colors.length];
}
