import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color navyPrimary = Color(0xFF2D3A6D);
  static const Color orangeSecondary = Color(0xFFFF9800);
  static const Color creamBackground = Color(0xFFFFFBF0);
  static const Color tealAccent = Color(0xFF009688);
  static const Color darkGrey = Color(0xFF333333);
  static const Color white = Colors.white;
}

class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.navyPrimary,
        primary: AppColors.navyPrimary,
        secondary: AppColors.orangeSecondary,
        surface: AppColors.white,
        background: AppColors.creamBackground,
      ),
      scaffoldBackgroundColor: AppColors.creamBackground,
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        titleLarge: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: AppColors.darkGrey,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          color: AppColors.darkGrey,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.orangeSecondary,
          foregroundColor: AppColors.white,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFF001219),
      cardTheme: CardThemeData(
        color: const Color(0xFF00222D),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
