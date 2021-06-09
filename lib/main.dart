import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vozforums/Page/View/ViewBinding.dart';
import 'package:vozforums/Page/View/ViewUI.dart';
import 'package:vozforums/Page/home/homeBinding.dart';
import 'package:vozforums/Page/Thread/subThreadBinding.dart';
import 'package:vozforums/Page/Thread/subThreadUI.dart';
import 'package:vozforums/theme.dart';
import 'GlobalController.dart';
import 'Page/NavigationDrawer/NaviDrawerController.dart';
import 'Page/home/homeUI.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put<GlobalController>(GlobalController());
  Get.put<NaviDrawerController>(NaviDrawerController(), permanent: true);
  runApp(MyPage());
}

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      transitionDuration: Duration(milliseconds: 200),
      theme: Themes().lightTheme,
      darkTheme: Themes().darkTheme,
      initialRoute: "/HomePage",
      getPages: [
        GetPage(name: "/HomePage", page: ()=> HomePageUI(), popGesture: true, binding: HomeBinding(), maintainState: false),
        GetPage(name: "/ThreadPage", page: ()=> ThreadUI(), popGesture: true, binding: ThreadBinding(), maintainState: false),
        GetPage(name: "/ViewPage", page: ()=> ViewUI(), popGesture: true, binding: ViewBinding(), maintainState: false),
      ],
    );
  }
}
