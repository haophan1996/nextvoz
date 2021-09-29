import 'dart:io';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../../../GlobalController.dart';

class BrowserLoginController extends GetxController {
  List<Map> data = [];
  String cookie = '', html = '';
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
    this.dispose();
  }

  getData() async {
    Directory appDocDir = (await getApplicationDocumentsDirectory()).parent;
    print(appDocDir.path);
    File file = File(appDocDir.absolute.path + '/app_webview/Default/Cookies');
    if (await file.exists() == false) return;
    var db = await openDatabase(appDocDir.absolute.path + '/app_webview/Default/Cookies');
    data = await db.rawQuery('SELECT name,value FROM "cookies" where HOST_KEY = "voz.vn"');
    for (int i = 0; i < data.length; i++) {
      if (data[i]['name'] == 'xf_user' && data[i]['value'] != null) {
        cookie += data[i]['name'] + '=' + data[i]['value'] + '; ';
      }  if (data[i]['name'] == 'xf_session' && data[i]['value'] != null) {
        cookie += data[i]['name'] + '=' + data[i]['value'] + '; ';
      } else if (data[i]['name'] == 'xf_tfa_trust' && data[i]['value'] != null) {
        cookie += data[i]['name'] + '=' + data[i]['value'] + '; ';
      }
    }
    if (cookie != '') {
      await GlobalController.i.userStorage.write("userLoggedIn", true);
      await GlobalController.i.userStorage.write("userLoginCookie", cookie);
      if(Get.isDialogOpen ==true) Get.back();
      Get.back(result: ['ok']);
    }
  }
}
