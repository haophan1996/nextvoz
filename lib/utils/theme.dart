import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../GlobalController.dart';

class Themes {
  final lightTheme = ThemeData.light().copyWith(
    primaryColor: Colors.black,
    backgroundColor: Color(0xfffebeced),//Colors.grey.shade100,
    canvasColor: Color(0xFFEEE3E3),
    shadowColor: Colors.grey.shade300,
    cardColor: Colors.grey.shade300,
    textTheme: TextTheme(
      headline1: TextStyle(fontFamily: 'BeVietNam', color: Colors.black),
      headline2: TextStyle(fontFamily: 'BeVietNam', color: Colors.black),
      headline3: TextStyle(fontFamily: 'BeVietNam', color: Colors.black),
      headline4: TextStyle(fontFamily: 'BeVietNam', color: Colors.black),
      headline5: TextStyle(fontFamily: 'BeVietNam', color: Colors.black),
      headline6: TextStyle(fontFamily: 'BeVietNam', color: Colors.black),
      subtitle1: TextStyle(fontFamily: 'BeVietNam', color: Colors.black),
      subtitle2: TextStyle(fontFamily: 'BeVietNam', color: Colors.black),
      caption: TextStyle(fontFamily: 'BeVietNam', color: Colors.black),
      button: TextStyle(fontFamily: 'BeVietNam', color: Colors.black),
      overline: TextStyle(fontFamily: 'BeVietNam', color: Colors.black),
      bodyText1:TextStyle(fontFamily: 'BeVietNam', color: Colors.black,fontSize: GlobalController.i.userStorage.read('fontSizeView') ?? 16.0), // 16
      bodyText2: TextStyle(fontFamily: 'BeVietNam', color: Colors.black,fontSize: (GlobalController.i.userStorage.read('fontSizeView') ?? 16.0)! -2.0), //14
    ),
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
    textTheme: TextTheme(
      headline1: TextStyle(fontFamily: 'BeVietNam', color: Colors.grey.shade400),
      headline2: TextStyle(fontFamily: 'BeVietNam', color: Colors.grey.shade400),
      headline3: TextStyle(fontFamily: 'BeVietNam', color: Colors.grey.shade400),
      headline4: TextStyle(fontFamily: 'BeVietNam', color: Colors.grey.shade400),
      headline5: TextStyle(fontFamily: 'BeVietNam', color: Colors.grey.shade400),
      headline6: TextStyle(fontFamily: 'BeVietNam', color: Colors.grey.shade400),
      subtitle1: TextStyle(fontFamily: 'BeVietNam', color: Colors.grey.shade400),
      subtitle2: TextStyle(fontFamily: 'BeVietNam', color: Colors.grey.shade400),
      caption: TextStyle(fontFamily: 'BeVietNam', color: Colors.grey.shade400),
      button: TextStyle(fontFamily: 'BeVietNam', color: Colors.grey.shade400),
      overline: TextStyle(fontFamily: 'BeVietNam', color: Colors.grey.shade400),
      bodyText1:TextStyle(fontFamily: 'BeVietNam', color: Colors.grey.shade400,fontSize: GlobalController.i.userStorage.read('fontSizeView') ?? 16.0),
      bodyText2: TextStyle(fontFamily: 'BeVietNam', color: Colors.grey.shade400,fontSize: (GlobalController.i.userStorage.read('fontSizeView') ?? 16.0)! -2.0),
    ),
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
