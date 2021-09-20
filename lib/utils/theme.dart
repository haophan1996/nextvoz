import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class Themes {
  final lightTheme = ThemeData.light().copyWith(
    primaryColor: Colors.black,
    backgroundColor: Color(0xfffebeced),//Colors.grey.shade100,
    canvasColor: Color(0xFFEEE3E3),
    shadowColor: Colors.grey.shade300,
    cardColor: Colors.grey.shade300,
    dividerColor: Colors.grey,
    secondaryHeaderColor: Colors.grey.shade700,
    appBarTheme: AppBarTheme(
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.grey.shade900),
      centerTitle: true,
      titleSpacing: -2,
      color: Color(0xfffebeced),
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 16),
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Color(0xfffebeced),
          systemNavigationBarColor: Colors.blue,
          systemNavigationBarDividerColor: Colors.blue,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemNavigationBarIconBrightness: Brightness.light,
      ),
    ),
  );

  final darkTheme = ThemeData.dark().copyWith(
    primaryColor: Colors.grey.shade400,
    backgroundColor: Colors.black,
    cardColor: Color(0xFF171616),
    canvasColor: Color(0xFF343030),
    shadowColor: Colors.grey.shade900,
    dividerColor: Colors.grey,
    secondaryHeaderColor: Colors.white70,
    appBarTheme: AppBarTheme(
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.grey.shade400),
      centerTitle: true,
      color: Colors.black,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.white,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.light,
        systemStatusBarContrastEnforced: false),
    ),
  );
}
