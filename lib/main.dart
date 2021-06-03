import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vozforums/Page/home/homeBinding.dart';
import 'package:vozforums/theme.dart';
import 'GlobalController.dart';
import 'Page/home/homeUI.dart';

void main() {
  Get.put<GlobalController>(GlobalController());
  runApp(MyPage());
}

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      //enableLog: true,
      initialBinding: HomeBinding(),
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fade,
      popGesture: Get.isPopGestureEnable,
      theme: Themes().lightTheme,
      darkTheme: Themes().darkTheme,
      home: HomePageUI(),
    );
  }
}
