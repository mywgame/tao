import 'package:flutter/material.dart';
import 'package:tao_boost/core/theme/app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: AppColors.background,
      cardColor: AppColors.card,
      primaryColor: AppColors.primary,
      
      colorScheme: const ColorScheme.dark().copyWith(
        primary: AppColors.primary,
        surface: AppColors.card,
        error: Colors.redAccent,
      ),

      // 📱 ऐप बार से const हटा दिया भाई ताकि एरर न आए
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white, size: 20),
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
          letterSpacing: 1.5,
        ),
      ),

      // 📝 टेक्स्ट थीम से भी const साफ़
      textTheme: TextTheme(
        bodyLarge: const TextStyle(color: Colors.white, fontSize: 16),
        bodyMedium: TextStyle(color: AppColors.textMuted, fontSize: 14),
      ),
    );
  }
}