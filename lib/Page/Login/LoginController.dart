import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/Page/NavigationDrawer/NaviDrawerController.dart';
import '/GlobalController.dart';
import '/Page/reuseWidget.dart';
import 'package:http/http.dart' as http;

import 'LoginUI.dart';

/// If api return type
///  0 : account without Verification
///  1 : account with Verification ON

class LoginController extends GetxController {
  RxBool isShowPass = true.obs;
  RxString statusLogin = ''.obs;
  RxBool checkBoxTrust = true.obs;
  late TextEditingController textEditingControllerLogin = TextEditingController(),
      textEditingControllerPassword = TextEditingController(),
      textEditingCode = TextEditingController();
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
    checkBoxTrust.close();
    this.dispose();
  }

  Future<void> loginFunction() async {
    statusLogin.value = '';
    setDialog();
    if (textEditingControllerLogin.text.length < 6 || textEditingControllerPassword.text.length < 6) {
      statusLogin.value = 'statusLoginInvalid'.tr;
      Get.back();
      return;
    }

    if (GlobalController.i.dataCsrfLogin == null && GlobalController.i.xfCsrfLogin == null  || GlobalController.i.xfCsrfLogin == 'xf_user=deleted') {
      await NaviDrawerController.i.logout();
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
      if (getMyData['type'] == 0) {
        statusLogin.value = 'statusLoginOK'.tr;
        await saveAccountCookieToFile(getMyData['xf_user'], getMyData['xf_session'], getMyData['date_expire']);
      } else {
        statusLogin.value = 'Two-step verification';
        if (Get.isDialogOpen == true) Get.back();
        data['xf_session'] = getMyData['xf_session'];
        await promptCodeProvider((provider) {
          promptCodeProviderLogin(provider);
        });
      }
    }
  }

  saveAccountCookieToFile(String xfUser, String session, String dataExpire) async {
    await GlobalController.i.userStorage.write("userLoggedIn", true);
    await GlobalController.i.userStorage.write("xf_user", xfUser);
    await GlobalController.i.userStorage.write("xf_session", session);
    await GlobalController.i.userStorage.write("date_expire", dataExpire);
    await GlobalController.i.setDataUser();
    await NaviDrawerController.i.getUserProfile();
    await saveAccountToList(xfUser, session, dataExpire);
    await Future.delayed(Duration(milliseconds: 3000), () async {
      if (Get.isDialogOpen == true) Get.back();
      if (Get.isBottomSheetOpen == true) Get.back();
      if (Get.isDialogOpen == true) Get.back();
      Get.back();
    });
  }

  saveAccountToList(String user, String session, String dataExp) async {
    accountList = GlobalController.i.userStorage.read('accountList') ?? [];

    for (int i = 0; i < accountList.length; i++) {
      if (accountList.elementAt(i)['nameUser'] == (GlobalController.i.userStorage.read('nameUser') ?? 'NoData')) {
        accountList.removeAt(i);
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

    GlobalController.i.userStorage.write('accountList', accountList);
  }

  login(String login, String pass, String token, String cookie, String userAgent) async {
    var headers = {
      'content-type': 'application/json; charset=UTF-8',
      'host': 'vozloginapinode.herokuapp.com',
    };
    var body = {"login": login, "password": pass, "remember": "1", "_xfToken": token, "userAgent": 'AndroidIosMobileDevices', "cookie": cookie};

    final response = await GlobalController.i.getHttpPost(true, headers, jsonEncode(body), 'http://10.0.0.55:3000/api/vozlogin');
    return response;
  }

  promptCodeProviderLogin(int provider) async {
    if (provider == 1) {
      //totp
      data['provider'] = 'totp';
      if (Get.isDialogOpen == true) Get.back();
      await loginVerificationLogic();
    } else if (provider == 2) {
      //email
      setDialog();
      data['provider'] = 'email';
      await sendEmailVerification().then((value) async {
        if (Get.isDialogOpen == true) Get.back();
        if (value != 200) {
          setDialogError('Cant send connect to server to send code via EMAIL');
        } else {
          if (Get.isDialogOpen == true) Get.back();
          await loginVerificationLogic();
        }
      });
    } else if (provider == 3) {
      //backup
      data['provider'] = 'backup';
      if (Get.isDialogOpen == true) Get.back();
      await loginVerificationLogic();
    }
  }

  Future<int> sendEmailVerification() async {
    var header = {'cookie': '${GlobalController.i.xfCsrfLogin}; ${data['xf_session']};'};

    final response = await http.get(Uri.parse('https://voz.vn/login/two-step?provider=email'), headers: header).catchError((err) {
      setDialogError('Server down or No connection\n\n Details: $err');
    });
    return response.statusCode;
  }

  loginVerificationLogic() async {
    textEditingCode.clear();
    await loginVerification(textEditingControllerLogin.text, data['provider'], textEditingCode, () async {
      setDialog();
      await loginVerifyCode(checkBoxTrust.value, data['provider'], textEditingCode.text, data['xf_session'], GlobalController.i.xfCsrfLogin,
          GlobalController.i.dataCsrfLogin);
    });
  }

  loginVerifyCode(bool trust, String provider, String code, String session, String csrf, String token) async {
    var headers = {
      'content-type': 'application/json; charset=UTF-8',
      'host': 'vozloginapinode.herokuapp.com',
    };

    var body = {
      '_xfToken': token,
      '_xfResponseType': 'json',
      'code': code,
      'trust': trust == true ? '1' : '0',
      'confirm': '1',
      'provider': provider,
      'remember': '1',
      'xf_session': session,
      'xf_csrf': csrf
    };

    final response = await http.post(Uri.parse('http://10.0.0.55:3000/api/vozverification'), headers: headers, body: jsonEncode(body));
    final jsonRes = jsonDecode(response.body);
    print('return success verification');
    if (response.statusCode == 200) {
      await saveAccountCookieToFile(jsonRes['xf_user'], jsonRes['xf_session'], jsonRes['date_expire']);
    } else {
      if (Get.isDialogOpen == true) Get.back();
      setDialogError(jsonRes['error']);
    }
  }
}

/*
Ip testing
http://10.0.0.55:3000/

Real link
https://vozloginapinode.herokuapp.com/api/vozlogin
 */
