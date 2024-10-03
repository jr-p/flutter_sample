import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: Colors.pink,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(
      headlineMedium: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
    )
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    primaryColor: Colors.pink,
    scaffoldBackgroundColor: Colors.black,
    textTheme: TextTheme(
      headlineMedium: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
    ),
  );
}