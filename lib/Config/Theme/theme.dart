import 'package:flutter/material.dart';

ThemeData customTheme = ThemeData().copyWith(
  scaffoldBackgroundColor: Colors.white,
  appBarTheme:
      AppBarTheme(backgroundColor: Colors.white, scrolledUnderElevation: 0),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(),
    contentPadding: EdgeInsets.all(10),
  ),
  searchBarTheme: SearchBarThemeData(
    elevation: WidgetStatePropertyAll(0),
    backgroundColor: WidgetStatePropertyAll(
      Color(0XFFE6E6E6),
    ),
    side: WidgetStatePropertyAll(
      BorderSide(color: Colors.black, width: .5),
    ),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    ),
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: Colors.white,
  ),
  primaryColor: AppColors.primaryColor,
  colorScheme: const ColorScheme.light(
    primary: AppColors.primaryColor,
    secondary: AppColors.primaryColor,
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: AppColors.primaryColor,
  ),
  dividerTheme: const DividerThemeData(
    color: AppColors.primaryColor,
    thickness: 2,
    indent: 250,
    endIndent: 250,
  ),
  cardTheme: CardThemeData(
    color: Color(0XFFE6E6E6),
  ),
);

class AppColors {
  static const Color primaryColor = Color(0xFFEC6453);
  static const Color backgroundColor = Colors.white;
  static const Color textColor = Colors.black;
  static Color errorColor = Colors.red[400]!;
}

final EdgeInsets contentPadding = EdgeInsets.symmetric(horizontal: 10);

final customInputDecoration = InputDecoration(
  fillColor: Color(0XFFE6E6E6),
  filled: true,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
  ),
);
