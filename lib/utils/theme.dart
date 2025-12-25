import 'package:flutter/material.dart';
import 'constants.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppConstants.primaryColor,
    scaffoldBackgroundColor: AppConstants.backgroundColor,
    colorScheme: const ColorScheme.dark(
      primary: AppConstants.primaryColor,
      secondary: AppConstants.primaryColor,
      surface: AppConstants.surfaceColor,
      background: AppConstants.backgroundColor,
      error: AppConstants.errorColor,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: AppConstants.textPrimaryColor,
      onBackground: AppConstants.textPrimaryColor,
      onError: Colors.white,
    ),
    cardTheme: const CardThemeData(
      color: AppConstants.cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppConstants.surfaceColor,
      foregroundColor: AppConstants.textPrimaryColor,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppConstants.surfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: AppConstants.textSecondaryColor),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: AppConstants.textPrimaryColor,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: AppConstants.textPrimaryColor,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: AppConstants.textPrimaryColor,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: AppConstants.textSecondaryColor,
        fontSize: 14,
      ),
    ),
  );
}