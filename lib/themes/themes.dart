import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.indigo,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.indigo,
    foregroundColor: Colors.white,
  ),
  colorScheme: ColorScheme.light(
    primary: Colors.indigo,
    secondary: Colors.blueAccent,
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color.fromARGB(255, 16, 35, 57), // Dark bluish
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 16, 35, 57),
    foregroundColor: Colors.white,
  ),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF415A77), // bluish tone
    secondary: Color(0xFF1E88E5),
    tertiary: Color(0xFF42A5F5),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white70),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF1E88E5),
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF1E88E5),
      foregroundColor: Colors.white,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(20),
      ),
    ),
  ),
  cardTheme: CardThemeData(color: Color(0xFF415A77)),
);
