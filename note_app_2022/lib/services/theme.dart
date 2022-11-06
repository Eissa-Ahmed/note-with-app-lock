import 'package:flutter/material.dart';

import 'colorsManager.dart';

ThemeData lightTheme = ThemeData(
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  hoverColor: Colors.transparent,
  primaryColor: Colors.black,
  primaryColorLight: Colors.grey,
  fontFamily: "JosefinSans",
  scaffoldBackgroundColor: Colors.white,
  primarySwatch: ColorsManager.primarySwatch,
  iconTheme: const IconThemeData(color: Colors.black),
  appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      elevation: 0),
  inputDecorationTheme: const InputDecorationTheme(
    border: InputBorder.none,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      color: Colors.grey,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    titleSmall: TextStyle(
      color: Colors.grey,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    displayLarge: TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    displayMedium: TextStyle(
      color: Colors.black,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
  ),
);

ThemeData darkTheme = ThemeData(
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  hoverColor: Colors.transparent,
  primaryColorLight: Colors.grey,
  primaryColor: Colors.white,
  fontFamily: "JosefinSans",
  scaffoldBackgroundColor: const Color(0xFF001021),
  primarySwatch: ColorsManager.primarySwatch,
  iconTheme: const IconThemeData(color: Colors.white),
  appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF001021),
      iconTheme: IconThemeData(color: Colors.white),
      elevation: 0),
  inputDecorationTheme: const InputDecorationTheme(
    border: InputBorder.none,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      color: Colors.grey,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    titleSmall: TextStyle(
      color: Colors.grey,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    displayLarge: TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    displayMedium: TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
  ),
);
