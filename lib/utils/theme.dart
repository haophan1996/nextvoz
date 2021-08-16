import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class Themes {
  final lightTheme = ThemeData.light().copyWith(
    primaryColor: Colors.black,
    backgroundColor: Colors.white,
    canvasColor: Color(0xFFEEE3E3),
    shadowColor: Colors.grey.shade200,
    cardColor: Colors.grey.shade300,
    dividerColor: Colors.grey,
    secondaryHeaderColor: Colors.grey.shade700,
    appBarTheme: AppBarTheme(
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      centerTitle: true,
      titleSpacing: -2,
      brightness: Brightness.light,
      color: Colors.white,
      backwardsCompatibility: false,
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 16),
      systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.white, statusBarIconBrightness: Brightness.dark),
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
      iconTheme: IconThemeData(color: Colors.white),
      centerTitle: true,
      brightness: Brightness.dark,
      color: Colors.black,
      backwardsCompatibility: false,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.black, statusBarIconBrightness: Brightness.light),
    ),
  );
}
