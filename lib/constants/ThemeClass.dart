import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ThemeClass{
  static ThemeData lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primaryColor: Colors.blue,
      fontFamily: 'RobotoCondensed',
      primarySwatch: Colors.teal,
      appBarTheme: AppBarTheme(
         backgroundColor: Colors.blue,
         foregroundColor: Colors.black,
      )
  );

  static ThemeData darkTheme = ThemeData(
      scaffoldBackgroundColor: HexColor("#070E1E"),
      primaryColor: Colors.blue,
      primarySwatch: Colors.grey,
      fontFamily: 'RobotoCondensed',
      appBarTheme: AppBarTheme(
        backgroundColor: HexColor("#272E38"),
        foregroundColor: Colors.white,
      )
   );
}
