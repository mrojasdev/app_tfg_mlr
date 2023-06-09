import 'package:flutter/material.dart';

class AppThemes {

  static const Color primary = Colors.blueGrey;


  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: primary,
    appBarTheme: const AppBarTheme(
      color: primary,
      elevation: 0,
    ),

  );
}