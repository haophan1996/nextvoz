import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Page/home/homeUI.dart';
import 'Page/home/homeController.dart';

void main() {
  Get.lazyPut<HomeController>(() => HomeController());
  runApp(MyPage());
}


class MyPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: HomePageUI(),
    );
  }

}
