import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class Themes {
  final lightTheme = ThemeData.light().copyWith(
    primaryColor: Colors.black, // Title
    backgroundColor: Color(0xFFE2DEDE),//Colors.grey.shade100,
    cardColor: Colors.grey.shade400,
    hintColor: Color(0xff5c7099),
    dividerColor: Colors.grey,
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(
        color: Colors.black
      ),
      centerTitle: true,
      titleSpacing: -2,
      brightness: Brightness.light,
      color: Color(0xFFE2DEDE),
      backwardsCompatibility: false,
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 16),
      systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Color(0xFFE2DEDE), statusBarIconBrightness: Brightness.dark),
    ),
  );

  final darkTheme = ThemeData.dark().copyWith(
    primaryColor: Colors.grey.shade300, // Title
    backgroundColor: Colors.black,
    cardColor: Colors.grey.shade900,
    hintColor: Color(0xff223447),
    dividerColor: Colors.grey,
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
