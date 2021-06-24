import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class Themes {
  final lightTheme = ThemeData.light().copyWith(
    primaryColor: Colors.black, // Title
    backgroundColor: Colors.white,//Color(0xFFE2DEDE),//Colors.grey.shade100,
    canvasColor: Color(0xFFEEE3E3),
    cardColor: Colors.grey.shade400,
    hintColor: Color(0xff5c7099),
    dividerColor: Colors.grey,
    secondaryHeaderColor: Colors.grey.shade700,
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(
        color: Colors.black
      ),
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
    primaryColor: Colors.grey.shade300, // Title
    backgroundColor: Colors.black,
    cardColor: Colors.grey.shade900,
    canvasColor: Color(0xFF343030),
    hintColor: Color(0xff223447),
    dividerColor: Colors.grey,
    secondaryHeaderColor: Colors.white70,
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(
          color: Colors.white
      ),
      centerTitle: true,
      brightness: Brightness.dark,
      color: Colors.black,
      backwardsCompatibility: false,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 16,),
      systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.black, statusBarIconBrightness: Brightness.light),
    ),
  );
}
