import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vozforums/Page/Alert_Inbox/InboxBindings.dart';
import 'package:vozforums/Page/Alert_Inbox/InboxUI.dart';
import 'package:vozforums/theme.dart';
import 'package:vozforums/Page/languages.dart';
import 'package:vozforums/Page/home/homeUI.dart';
import 'package:vozforums/GlobalController.dart';
import 'package:vozforums/Page/View/ViewUI.dart';
import 'package:vozforums/Page/Alerts/AlertUI.dart';
import 'package:vozforums/Page/Thread/ThreadUI.dart';
import 'package:vozforums/Page/home/homeBinding.dart';
import 'package:vozforums/Page/Settings/SettingsUI.dart';
import 'package:vozforums/Page/Alerts/AlertsBinding.dart';
import 'package:vozforums/Page/Thread/ThreadBinding.dart';
import 'package:vozforums/Page/youtubeView/ViewYoutube.dart';
import 'package:vozforums/Page/PostStatus/PostStatusUI.dart';
import 'package:vozforums/Page/Settings/SettingsBinding.dart';
import 'package:vozforums/Page/youtubeView/YoutubeBinding.dart';
import 'package:vozforums/Page/PostStatus/PostStatusBindings.dart';
import 'package:vozforums/Page/NavigationDrawer/NaviDrawerController.dart';
import 'Page/Profile/UserProfile/UserProfileUI.dart';

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
            gestureWidth: (context) => context.width * 0.8,
            popGesture: true,
            //binding: ViewBinding(),
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
            popGesture: true,
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
