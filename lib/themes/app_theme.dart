// lib/themes/app_theme.dart
// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._(); // Construtor privado para evitar a criação de instâncias

  static final ThemeData lightTheme = ThemeData(
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(
      bodyText1: TextStyle(color: Colors.black),
      bodyText2: TextStyle(color: Colors.black54),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.blue,
      textTheme: ButtonTextTheme.primary,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: Colors.teal,
    scaffoldBackgroundColor: Colors.grey[900],
    textTheme: TextTheme(
      bodyText1: TextStyle(color: Colors.white),
      bodyText2: TextStyle(color: Colors.white60),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.teal,
      textTheme: ButtonTextTheme.primary,
    ),
  );
}
