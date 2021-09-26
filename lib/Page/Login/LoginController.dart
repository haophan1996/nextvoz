import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '/Page/NavigationDrawer/NaviDrawerController.dart';
import '/GlobalController.dart';
import '/Page/reuseWidget.dart';

class LoginController extends GetxController {
  RxBool isShowPass = true.obs;
  RxString statusLogin = ''.obs;
  late TextEditingController textEditingControllerLogin = TextEditingController(), textEditingControllerPassword = TextEditingController();
  var dio = Dio();
  Map<String, dynamic> data = {};
  List accountList = [];

  @override
  onClose() {
    super.onClose();
    isShowPass.close();
    statusLogin.close();
    data.clear();
    dio.clear();
    dio.close(force: true);
    textEditingControllerPassword.dispose();
    textEditingControllerLogin.dispose();
  }

  Future<void> loginFunction() async {
    statusLogin.value = '';
    setDialog();
    if (textEditingControllerLogin.text.length < 6 || textEditingControllerPassword.text.length < 6) {
      statusLogin.value = 'statusLoginInvalid'.tr;
      Get.back();
      return;
    }

    if (GlobalController.i.dataCsrfLogin == null && GlobalController.i.xfCsrfLogin == null) {
      await GlobalController.i.getBodyBeta((value) {
        ///onError
      }, (download) {}, dio, 'https://voz.vn/login/login', true).then((value) {
        GlobalController.i.dataCsrfLogin = value!.getElementsByTagName('html')[0].attributes['data-csrf'];
        GlobalController.i.token = value.getElementsByTagName('html')[0].attributes['data-csrf'];
      });
    }

    final getMyData = await login(textEditingControllerLogin.text, textEditingControllerPassword.text, GlobalController.i.dataCsrfLogin,
        GlobalController.i.xfCsrfLogin, textEditingControllerLogin.text);

    if (getMyData['xf_user'] == 'incorrect password / or id') {
      await Future.delayed(Duration(milliseconds: 3000), () async {
        Get.back();
      });
      statusLogin.value = 'statusLoginFail'.tr;
    } else {
      statusLogin.value = 'statusLoginOK'.tr;
      await GlobalController.i.userStorage.write("userLoggedIn", true);
      await GlobalController.i.userStorage.write("xf_user", getMyData['xf_user']);
      await GlobalController.i.userStorage.write("xf_session", getMyData['xf_session']);
      await GlobalController.i.userStorage.write("date_expire", getMyData['date_expire']);
      await GlobalController.i.setDataUser();
      await NaviDrawerController.i.getUserProfile();
      await saveAccountToList(getMyData['xf_user'], getMyData['xf_session'], getMyData['date_expire']);
      await Future.delayed(Duration(milliseconds: 3000), () async {
        Get.back();
        Get.back();
      });
    }
  }

  saveAccountToList(String user, String session, String dataExp) async {
    accountList = GlobalController.i.userStorage.read('accountList') ?? [];

    for(int i = 0; i < accountList.length; i++){
      if (accountList.elementAt(i)['nameUser'] == (GlobalController.i.userStorage.read('nameUser') ?? 'NoData')){
        print(accountList.removeAt(i));
      }
    }
    accountList.insert(0, {
      'xf_user': user,
      'xf_session': session,
      'date_expire': dataExp,
      'nameUser': GlobalController.i.userStorage.read('nameUser') ?? 'NoData',
      'avatarUser': GlobalController.i.userStorage.read('avatarUser') ?? 'no',
      'avatarColor1': GlobalController.i.userStorage.read('avatarColor1') ?? '0x00000000',
      'avatarColor2': GlobalController.i.userStorage.read('avatarColor2') ?? '0x00000000'
    });

    GlobalController.i.userStorage.read('accountList');
    GlobalController.i.userStorage.write('accountList', accountList);
  }

  login(String login, String pass, String token, String cookie, String userAgent) async {
    var headers = {
      'content-type': 'application/json; charset=UTF-8',
      'host': 'vozloginapinode.herokuapp.com',
    };
    var body = {"login": login, "password": pass, "remember": "1", "_xfToken": token, "userAgent": 'AndroidIosMobileDevices', "cookie": cookie};

    print(body);
    final response = await GlobalController.i.getHttpPost(true, headers, jsonEncode(body), 'https://vozloginapinode.herokuapp.com/api/vozlogin');

    return response;
  }
}




/*
Ip testing
http://10.0.0.55:3000/

Real link
https://vozloginapinode.herokuapp.com/api/vozlogin
 */