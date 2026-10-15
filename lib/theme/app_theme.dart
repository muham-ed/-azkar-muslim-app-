import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Brand Colors
  static const Color primaryGreen = Color(0xFF0D2818);
  static const Color accentGold = Color(0xFFD4AF37);
  static const Color emeraldLight = Color(0xFF1B3B2B);
  
  // Light Theme Palette
  static const Color lightBg = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCardBg = Color(0xFFF4F6F4);
  static const Color lightTextPrimary = Color(0xFF1A1D1F);
  static const Color lightTextSecondary = Color(0xFF535862);
  
  // Dark Theme Palette
  static const Color darkBg = Color(0xFF121417);
  static const Color darkSurface = Color(0xFF1B1E23);
  static const Color darkCardBg = Color(0xFF242830);
  static const Color darkTextPrimary = Color(0xFFF9FAFB);
  static const Color darkTextSecondary = Color(0xFF98A2B3);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryGreen,
        primary: AppColors.primaryGreen,
        secondary: AppColors.accentGold,
        surface: AppColors.lightSurface,
        brightness: Brightness.light,
      ),
      textTheme: GoogleFonts.cairoTextTheme(ThemeData.light().textTheme).apply(
        bodyColor: AppColors.lightTextPrimary,
        displayColor: AppColors.lightTextPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryGreen,
        primary: AppColors.primaryGreen,
        secondary: AppColors.accentGold,
        surface: AppColors.darkSurface,
        brightness: Brightness.dark,
      ),
      textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: AppColors.darkTextPrimary,
        displayColor: AppColors.darkTextPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.accentGold,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.accentGold),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 3,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
