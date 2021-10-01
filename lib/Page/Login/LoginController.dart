import 'dart:convert';
import 'package:dio_http/dio_http.dart';
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

    if (getMyData['status'] == 'errors') {
      statusLogin.value = getMyData['errors'];
      if (Get.isDialogOpen == true) Get.back();
    } else {
      if (getMyData['type'] == 0) {
        statusLogin.value = 'statusLoginOK'.tr;
        await saveAccountCookieToFile(getMyData['cookie']);
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

  saveAccountCookieToFile(String userLoginCookies) async {
    await GlobalController.i.userStorage.write("userLoggedIn", true);
    await GlobalController.i.userStorage.write("userLoginCookie", userLoginCookies);
    await GlobalController.i.setDataUser();
    await NaviDrawerController.i.getUserProfile();
    await saveAccountToList(userLoginCookies);
    await Future.delayed(Duration(milliseconds: 3000), () async {
      if (Get.isDialogOpen == true) Get.back();
      if (Get.isBottomSheetOpen == true) Get.back();
      if (Get.isDialogOpen == true) Get.back();
      Get.back();
    });
  }

  saveAccountToList(String userLoginCookies) async {
    accountList = GlobalController.i.userStorage.read('accountList') ?? [];

    for (int i = 0; i < accountList.length; i++) {
      if (accountList.elementAt(i)['nameUser'] == (GlobalController.i.userStorage.read('nameUser') ?? 'NoData')) {
        accountList.removeAt(i);
      }
    }
    accountList.insert(0, {
      'userLoginCookie': userLoginCookies,
      'nameUser': GlobalController.i.userStorage.read('nameUser') ?? 'NoData',
      'avatarUser': GlobalController.i.userStorage.read('avatarUser') ?? 'no',
      'avatarColor1': GlobalController.i.userStorage.read('avatarColor1') ?? '0x00000000',
      'avatarColor2': GlobalController.i.userStorage.read('avatarColor2') ?? '0x00000000'
    });

    GlobalController.i.userStorage.write('accountList', accountList);
  }

  login(String login, String pass, String token, String xfCsrfLogin, String userAgent) async {
    var headers = {
      'content-type': 'application/json; charset=UTF-8',
      'host': 'nextvozloginapi.herokuapp.com',
    };
    var body = {"login": login, "password": pass, "_xfToken": token, "userAgent": 'AndroidIosMobileDevices', "cookie": xfCsrfLogin};

    final response = await GlobalController.i.getHttpPost(true, headers, jsonEncode(body), 'https://nextvozloginapi.herokuapp.com/api/login');
    print(response);
    return response;
  }

  promptCodeProviderLogin(int provider) async {
    if (provider == 1) {
      data['provider'] = 'totp';
      if (Get.isDialogOpen == true) Get.back();
      await loginVerificationLogic();
    } else if (provider == 2) {
      setDialog();
      data['provider'] = 'email';
      await sendEmailVerification().then((value) async {
        if (Get.isDialogOpen == true) Get.back();
        if (value != 200) {
          setDialogError('Cant send connect to server to send code via EMAIL/ try again');
        } else {
          if (Get.isDialogOpen == true) Get.back();
          await loginVerificationLogic();
        }
      });
    } else if (provider == 3) {
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
      await loginVerifyCode(data['provider'], textEditingCode.text, data['xf_session'], GlobalController.i.xfCsrfLogin,
          GlobalController.i.dataCsrfLogin);
    });
  }

  loginVerifyCode(String provider, String code, String session, String csrf, String token) async {
    var headers = {
      'content-type': 'application/json; charset=UTF-8',
      'host': 'nextvozloginapi.herokuapp.com',
    };

    var body = {
      '_xfToken': token,
      'code': code,
      'provider': provider,
      'xf_session': session,
      'xf_csrf': csrf,
      'userAgent' : 'AndroidIosMobileDevices'
    };
    print('request$body');

    final response = await http.post(Uri.parse('https://nextvozloginapi.herokuapp.com/api/verification'), headers: headers, body: jsonEncode(body));

    final jsonRes = jsonDecode(response.body);

    if (response.statusCode == 200) {
      await saveAccountCookieToFile(jsonRes['cookie']);
    } else {
      if (Get.isDialogOpen == true) Get.back();
      setDialogError(jsonRes['errors']);
    }
  }
}

/*
Ip testing
http://10.0.0.55:3000/

Real link
https://vozloginapinode.herokuapp.com/api/vozlogin
 */
