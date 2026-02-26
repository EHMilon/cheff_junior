import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    brightness: Brightness.light,
    fontFamily: GoogleFonts.baloo2().fontFamily,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.error,
    ),
    textTheme: GoogleFonts.baloo2TextTheme(
      TextTheme(
        headlineLarge: GoogleFonts.baloo2(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF8C4F08),
          height: 1.20,
          letterSpacing: -1.44,
        ),
        titleMedium: TextStyle(fontSize: 16, color: AppColors.textBody),
        bodyMedium: TextStyle(fontSize: 14, color: AppColors.textBody),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        textStyle: GoogleFonts.baloo2(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.lightGrey),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.lightGrey),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary),
      ),
      hintStyle: TextStyle(color: AppColors.textHint),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: Color(0xFF1E1E1E),
    brightness: Brightness.dark,
    fontFamily: GoogleFonts.baloo2().fontFamily,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      secondary: Colors.white,
      error: AppColors.error,
    ),
    textTheme: GoogleFonts.baloo2TextTheme(ThemeData.dark().textTheme),
  );
}
