import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pixel_colors.dart';

class AppTheme {
  static ThemeData get pixelTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: PixelColors.primary,
      scaffoldBackgroundColor: PixelColors.background,
      textTheme: GoogleFonts.pressStart2pTextTheme().apply(
        bodyColor: PixelColors.text,
        displayColor: PixelColors.text,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: PixelColors.primary,
          foregroundColor: PixelColors.text,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
            side: const BorderSide(color: PixelColors.border, width: 4),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: const TextStyle(fontSize: 14),
        ),
      ),
      cardTheme: const CardTheme(
        color: PixelColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: PixelColors.border, width: 4),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: PixelColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: PixelColors.border, width: 4),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: PixelColors.border, width: 4),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: PixelColors.primary, width: 4),
        ),
        labelStyle: TextStyle(color: PixelColors.text, fontSize: 12),
      ),
    );
  }
}
