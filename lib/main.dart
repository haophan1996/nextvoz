import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nextvoz/Page/Login/LoginBindings.dart';
import 'package:nextvoz/Page/Login/LoginUI.dart';
import 'package:nextvoz/Page/Profile/UserProfile/UserProfileBinding.dart';
import 'package:nextvoz/Page/Search/Search/SearchBinding.dart';
import 'package:nextvoz/Page/View/ViewBinding.dart';
import 'package:nextvoz/Routes/routes.dart';
import '/Page/Alert_Inbox/InboxBindings.dart';
import '/Page/Alert_Inbox/InboxUI.dart';
import 'Page/Search/Search/SearchUI.dart';
import 'Page/Search/SearchResult/SearchResultBindings.dart';
import 'Page/Search/SearchResult/SearchResultUI.dart';
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
      locale: GlobalController.i.langList.elementAt(GlobalController.i.userStorage.read('lang') ?? 1),
      theme: Themes().lightTheme,
      darkTheme: Themes().darkTheme,
      initialRoute: Routes.Home,
      getPages: [
        GetPage(name: Routes.Home, page: () => HomePageUI(), popGesture: true, binding: HomeBinding(), maintainState: false),
        GetPage(
            name: Routes.Thread,
            page: () => ThreadUI(),
            popGesture: true,
            binding: ThreadBinding(),
            gestureWidth: (context) {
              return context.width * 0.8;
            },
            maintainState: false),
        GetPage(
            name: Routes.View,
            page: () => ViewUI(),
            binding: ViewBinding(),
            transition: Transition.rightToLeft,
            transitionDuration: Duration(milliseconds: 200),
            popGesture: true,
            maintainState: false),
        GetPage(
            name: Routes.Alerts,
            page: () => AlertsUI(),
            transition: Transition.topLevel,
            transitionDuration: Duration(milliseconds: 200),
            binding: PopBinding(),
            gestureWidth: (context) => context.width,
            popGesture: true),
        GetPage(
            name: Routes.Conversation,
            page: () => InboxUI(),
            transition: Transition.topLevel,
            transitionDuration: Duration(milliseconds: 200),
            binding: InboxBindings(),
            gestureWidth: (context) => context.width,
            popGesture: true),
        GetPage(
            name: Routes.Profile,
            page: () => UserProfileUI(),
            binding: UserProfileBinding(),
            gestureWidth: (context) => context.width,
            popGesture: true,
            transition: Transition.topLevel,
            transitionDuration: Duration(milliseconds: 200),
            maintainState: false),
        GetPage(name: Routes.Youtube, page: () => YoutubeView(), binding: YoutubeBinding(), popGesture: true),
        GetPage(
            name: Routes.AddReply,
            page: () => PostStatusUI(),
            popGesture: false,
            binding: PostStatusBindings(),
            transition: Transition.topLevel,
            transitionDuration: Duration(milliseconds: 200),
            maintainState: false),
        GetPage(
            name: Routes.Settings,
            page: () => SettingsUI(),
            popGesture: true,
            binding: SettingsBinding(),
            transition: Transition.topLevel,
            transitionDuration: Duration(milliseconds: 200),
            maintainState: false),
        GetPage(
          name: Routes.Login,
          page: () => LoginUI(),
          binding: LoginBindings(),
          transition: Transition.topLevel,
          transitionDuration: Duration(milliseconds: 200),
          gestureWidth: (context) => context.width,
          popGesture: true,
        ),
        GetPage(
          name: Routes.SearchPage,
          page: () => SearchUI(),
          binding: SearchBindings(),
          transition: Transition.topLevel,
          transitionDuration: Duration(milliseconds: 200),
          gestureWidth: (context) => context.width,
          popGesture: true,
        ),
        GetPage(
          name: Routes.SearchResult,
          page: () => SearchResultUI(),
          binding: SearchResultBindings(),
          transition: Transition.topLevel,
          transitionDuration: Duration(milliseconds: 200),
          gestureWidth: (context) => context.width,
          popGesture: true,
        ),
      ],
    );
  }
}
