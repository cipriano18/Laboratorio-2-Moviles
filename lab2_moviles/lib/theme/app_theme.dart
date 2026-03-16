import 'package:flutter/material.dart';

class AppTheme {
  // ── Paleta ─────────────────────────────────────────────────────────────────
  static const Color background = Color(0xFFF0FFF4); // Menta pálido
  static const Color primary = Color(0xFF4EAC7F); // Verde esmeralda
  static const Color secondary = Color(0xFF92C794); // Verde suave
  static const Color accent = Color(0xFFB2DB70); // Verde lima

  // ── Tema principal ─────────────────────────────────────────────────────────
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,

      colorScheme: ColorScheme.light(
        primary: primary,
        onPrimary: Colors.white,
        secondary: secondary,
        onSecondary: Colors.white,
        tertiary: accent,
        onTertiary: Colors.black87,
        surface: Colors.white,
        onSurface: Colors.black87,
        surfaceContainer: background,
      ),

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),

      // Cards
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // FAB
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),

      // Botones elevados (Guardar en el dialog)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),

      // TextField
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: primary, width: 2),
        ),
        labelStyle: const TextStyle(color: primary),
      ),

      // PopupMenu
      popupMenuTheme: const PopupMenuThemeData(color: Colors.white),
    );
  }
}
