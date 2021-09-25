import 'dart:io';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../../../GlobalController.dart';

class BrowserLoginController extends GetxController {
  List<Map> data = [];
  String xf_user = '', xf_session = '';
  InAppWebViewController? inAppWebViewController;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    getData();
  }

  @override
  onClose() async {
    super.onClose();
    inAppWebViewController = null;
  }

  getData() async {
    Directory appDocDir = (await getApplicationDocumentsDirectory()).parent;
    File file = File(appDocDir.absolute.path + '/app_webview/Default/Cookies');
    if (await file.exists() == false) return;
    var db = await openDatabase(appDocDir.absolute.path + '/app_webview/Default/Cookies');
    data = await db.rawQuery('SELECT name,value FROM "cookies" where HOST_KEY = "voz.vn"');
    for (int i = 0; i < data.length; i++) {
      if (data[i]['name'] == 'xf_user' && data[i]['value'] != null) {
        xf_user = data[i]['value'];
      } else if (data[i]['name'] == 'xf_session' && data[i]['value'] != null) {
        xf_session = data[i]['value'];
      }
    }

    if (xf_user != '' && xf_session != '') {
      await GlobalController.i.userStorage.write("userLoggedIn", true);
      await GlobalController.i.userStorage.write("xf_user", xf_user);
      await GlobalController.i.userStorage.write("xf_session", xf_session);
      await GlobalController.i.userStorage.write("date_expire", '24-Sep-2022 03:08:21 GMT');
      if(Get.isDialogOpen ==true) Get.back();
      Get.back(result: ['ok']);
    }
  }
}
