import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';

class Themes {
  final lightTheme = ThemeData.light().copyWith(
    primaryColor: Colors.black, // Title
    backgroundColor: Colors.grey.shade100,
    secondaryHeaderColor: Color(0xFFE5E3E3),
    accentColor: Colors.black,  // In block quote
    cardColor: Colors.grey.shade400,
    hintColor: Color(0xff5c7099),
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(
        color: Colors.black
      ),
      centerTitle: false,
      titleSpacing: -2,
      brightness: Brightness.light,
      color: Colors.grey.shade100,
      //elevation: 3,
      backwardsCompatibility: false,
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold,),
      systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.grey.shade100, statusBarIconBrightness: Brightness.dark),
    ),
  );

  final darkTheme = ThemeData.dark().copyWith(
    primaryColor: Colors.grey.shade300, // Title
    backgroundColor: Colors.black,
    secondaryHeaderColor: Color(0xFF424242),
    accentColor: Colors.white54,  // In block quote
    cardColor: Colors.grey.shade900,
    hintColor: Color(0xff223447),
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(
          color: Colors.white
      ),
      brightness: Brightness.dark,
      color: Colors.black,
      elevation: 0,
      backwardsCompatibility: false,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.black, statusBarIconBrightness: Brightness.light),
    ),
  );
}
