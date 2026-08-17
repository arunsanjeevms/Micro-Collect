import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// MicroCollect Typography System — Poppins exclusive
/// Derived from Stitch Design System
class AppTypography {
  AppTypography._();

  static TextStyle get displayLg => GoogleFonts.poppins(
        fontSize: 48,
        fontWeight: FontWeight.w800,
        height: 1.2,
        letterSpacing: -0.96,
      );

  static TextStyle get headlineLg => GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.25,
      );

  static TextStyle get headlineLgMobile => GoogleFonts.poppins(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        height: 1.3,
      );

  static TextStyle get headlineMd => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.35,
      );

  static TextStyle get titleLg => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  static TextStyle get titleMd => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.5,
      );

  static TextStyle get bodyLg => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 1.6,
      );

  static TextStyle get bodyMd => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.6,
      );

  static TextStyle get bodySm => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get labelLg => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.4,
      );

  static TextStyle get labelMd => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
        letterSpacing: 0.28,
      );

  static TextStyle get labelSm => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        height: 1.4,
        letterSpacing: 0.6,
      );

  /// Financial value style — used for ₹ amounts that dominate visually
  static TextStyle get financialLg => GoogleFonts.poppins(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        height: 1.2,
        letterSpacing: -0.72,
      );

  static TextStyle get financialMd => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.3,
      );

  static TextStyle get financialSm => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );
}
