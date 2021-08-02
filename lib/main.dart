import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/Page/Alert_Inbox/InboxBindings.dart';
import '/Page/Alert_Inbox/InboxUI.dart';
import 'Utils/theme.dart';
import 'Utils/languages.dart';
import '/Page/home/homeUI.dart';
import '/GlobalController.dart';
import '/Page/View/ViewUI.dart';
import '/Page/Alerts/AlertUI.dart';
import '/Page/Thread/ThreadUI.dart';
import '/Page/home/homeBinding.dart';
import '/Page/Settings/SettingsUI.dart';
import '/Page/Alerts/AlertsBinding.dart';
import '/Page/Thread/ThreadBinding.dart';
import '/Page/youtubeView/ViewYoutube.dart';
import '/Page/PostStatus/PostStatusUI.dart';
import '/Page/Settings/SettingsBinding.dart';
import '/Page/youtubeView/YoutubeBinding.dart';
import '/Page/PostStatus/PostStatusBindings.dart';
import '/Page/NavigationDrawer/NaviDrawerController.dart';
import '/Page/Profile/UserProfile/UserProfileUI.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put<GlobalController>(GlobalController());
  Get.put<NaviDrawerController>(NaviDrawerController(), permanent: true);
  await GetStorage.init().then((value) async {
    await GlobalController.i.checkUserSetting();
    await GlobalController.i.setDataUser();
    await GlobalController.i.setAccountUser();
  });
  runApp(MyPage());
}

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      transitionDuration: Duration(milliseconds: 200),
      translations: Language(),
      locale: GlobalController.i.langList.elementAt(GlobalController.i.userStorage.read('lang')),
      theme: Themes().lightTheme,
      darkTheme: Themes().darkTheme,
      initialRoute: "/HomePage",

      getPages: [
        GetPage(name: "/HomePage", page: () => HomePageUI(), popGesture: true, binding: HomeBinding(), maintainState: false),
        GetPage(
            name: "/ThreadPage",
            page: () => ThreadUI(),
            popGesture: true,
            binding: ThreadBinding(),
            gestureWidth: (context) {
              return context.width * 0.8;
            },
            maintainState: false),
        GetPage(
            name: "/ViewPage",
            page: () => ViewUI(),
            transition: Transition.rightToLeft,
            transitionDuration: Duration(milliseconds: 200),
            popGesture: true,
            maintainState: false),
        GetPage(name: '/Alerts', page: () => AlertsUI(), binding: PopBinding(), gestureWidth: (context) => context.width, popGesture: true),
        GetPage(
            name: '/AlertsInbox', page: () => InboxUI(), binding: InboxBindings(), gestureWidth: (context) => context.width, popGesture: true),
        GetPage(
            name: "/UserProfile",
            page: () => UserProfileUI(),
            gestureWidth: (context) => context.width,
            popGesture: true /*, binding: UserProfileBinding()*/,
            maintainState: false),
        GetPage(name: '/Youtube', page: () => YoutubeView(), binding: YoutubeBinding(), popGesture: true),
        GetPage(
            name: "/PostStatus",
            page: () => PostStatusUI(),
            popGesture: false,
            binding: PostStatusBindings(),
            transition: Transition.downToUp,
            transitionDuration: Duration(milliseconds: 200),
            maintainState: false),
        GetPage(
            name: "/Settings",
            page: () => SettingsUI(),
            popGesture: true,
            binding: SettingsBinding(),
            transition: Transition.rightToLeft,
            transitionDuration: Duration(milliseconds: 200),
            maintainState: false),
      ],
    );
  }
}