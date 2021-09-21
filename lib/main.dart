import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/Routes/pages.dart';
import '/Utils/theme.dart';
import '/Utils/languages.dart';
import '/GlobalController.dart';
import '/Page/NavigationDrawer/NaviDrawerController.dart';

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
      themeMode: ThemeMode.values[GlobalController.i.userStorage.read('darkMode') ?? 0],
      initialRoute: GlobalController.i.userStorage.read('isTermAccept') != true ? Routes.Term : AppPage.INITIAL,
      getPages: AppPage.pages,
    );
  }
}
