import 'package:flutter/material.dart';

/// AppColors - Centralized color palette for the app
/// Follows Material Design color system with semantic naming
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFFFF951A);
  static const Color secondary = Color.fromARGB(255, 49, 49, 49);

  // Background Colors
  static const Color background = Color(0xFFF9F6F2);
  static const Color white = Colors.white;
  static const Color scaffoldBackground = Color(0xFFF9F9F9);
  static const Color lightOrange = Color(0xFFFFECCC);
  static const Color cardBackground = Color(0xFFFFF7EB);

  // Grey Scale
  static const Color grey = Color(0xFF9E9E9E);
  static const Color grey50 = Color(0xFF9E9E9E);
  static const Color grey100 = Color(0xFFFAFAFA);
  static const Color grey200 = Color(0xFF9A9A9A);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFF505050);
  static const Color grey500 = Color.fromARGB(255, 56, 56, 56);
  static const Color lightGrey = Color(0xFFE0E0E0);

  // Semantic Colors
  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);

  // Text Colors
  static const Color textBody = Color(0xFF432C10);
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color textDisabled = Color(0xFFBDBDBD);

  // UI Element Colors
  static const Color divider = Color(0xFFBDBDBD);
  static const Color border = Color(0xFFE9E9E9);

  // Shimmer Colors
  static const Color baseColor = Color(0xFFE0E0E0);
  static const Color highlightColor = Color(0xFFF5F5F5);
}
