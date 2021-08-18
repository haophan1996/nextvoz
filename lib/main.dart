import 'dart:async';

import 'package:dio/dio.dart';
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

  // var dio = Dio();
  // dio.interceptors.add(LogInterceptor());
  // // Token can be shared with different requests.
  // var token = CancelToken();
  // // In one minute, we cancel!
  // Timer(Duration(milliseconds: 500), () {
  //   token.cancel('cancelled');
  // });
  //
  // // The follow three requests with the same token.
  // var url1 = 'https://www.google.com';
  // var url2 = 'https://www.facebook.com';
  // var url3 = 'https://www.baidu.com';
  //
  // await Future.wait([
  //   dio
  //       .get(url1, cancelToken: token)
  //       .then((response) => print('${response.requestOptions.path}: succeed!'))
  //       .catchError(
  //         (e) {
  //       if (CancelToken.isCancel(e)) {
  //         print('cancellllllllllllllllllllllllllllllllllllllllllll $url1: $e');
  //       }
  //     },
  //   ),
  //   dio
  //       .get(url2, cancelToken: token)
  //       .then((response) => print('${response.requestOptions.path}: succeed!'))
  //       .catchError((e) {
  //     if (CancelToken.isCancel(e)) {
  //       print('$url2: $e');
  //     }
  //   }),
  //   dio
  //       .get(url3, cancelToken: token)
  //       .then((response) => print('${response.requestOptions.path}: succeed!'))
  //       .catchError((e) {
  //     if (CancelToken.isCancel(e)) {
  //       print('$url3: $e');
  //     }
  //     print(e);
  //   })
  // ]);




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
      themeMode: ThemeMode.system,
      initialRoute: AppPage.INITIAL,
      getPages: AppPage.pages,
    );
  }
}
