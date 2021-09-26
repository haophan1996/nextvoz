import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/Page/NavigationDrawer/NaviDrawerController.dart';
import '/GlobalController.dart';
import '/Page/reuseWidget.dart';

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
      if (getMyData['type'] == 0) {
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
      } else {
        if (Get.isDialogOpen == true) Get.back();
        data['xf_session'] = getMyData['xf_session'];
        await loginVerification();
      }
    }
  }

  loginVerification() async {
    await Get.bottomSheet(
        Container(
          height: Get.height * 0.8,
          decoration: BoxDecoration(
            color: Get.theme.backgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('\t\tTwo-step verification required', style: TextStyle(fontSize: Get.textTheme.headline6!.fontSize, fontWeight: FontWeight.bold)),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(text: 'Logging in as: ', style: TextStyle(color: Get.theme.primaryColor)),
                  TextSpan(text: textEditingControllerLogin.text, style: TextStyle(color: Get.theme.primaryColor, fontWeight: FontWeight.bold)),
                ])),
              ),
              Container(
                height: 80,
                padding: EdgeInsets.all(10),
                child: TextField(
                    controller: textEditingCode,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Verification code',
                        labelStyle: TextStyle(color: Get.theme.primaryColor.withOpacity(0.7)),
                        fillColor: Get.theme.canvasColor,
                        filled: true,
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Get.theme.primaryColor, width: 1)),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)))),
              ),
              Obx(
                () => CheckboxListTile(
                    contentPadding: EdgeInsets.only(left: Get.width / 4),
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text('trust this device'),
                    value: checkBoxTrust.value,
                    onChanged: (value) => checkBoxTrust.value = value!),
              ),
              Container(
                width: Get.width * 0.5,
                height: Get.textTheme.headline5!.fontSize! + 10.0,
                decoration: BoxDecoration(color: Color(0xfff5c7099), borderRadius: BorderRadius.all(Radius.circular(5))),
                child: customCupertinoButton(
                    Alignment.center,
                    EdgeInsets.fromLTRB(5, 2, 5, 2),
                    Text(
                      'Code via App',
                      style: TextStyle(color: Colors.white),
                    ), () {

                  loginVerifyCode(checkBoxTrust.value, 'totp',textEditingCode.text, data['xf_session'], GlobalController.i.xfCsrfLogin,
                      GlobalController.i.dataCsrfLogin);
                }),
              ), //Code via app
              Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  width: Get.width * 0.5,
                  height: Get.textTheme.headline5!.fontSize! + 10.0,
                  decoration: BoxDecoration(color: Color(0xfff5c7099), borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: customCupertinoButton(
                      Alignment.center,
                      EdgeInsets.fromLTRB(5, 2, 5, 2),
                      Text(
                        'Code via Email',
                        style: TextStyle(color: Colors.white),
                      ), () {

                    loginVerifyCode(checkBoxTrust.value, 'email',textEditingCode.text, data['xf_session'], GlobalController.i.xfCsrfLogin,
                        GlobalController.i.dataCsrfLogin);
                  }),
                ),
              ), //Code via email
              Container(
                width: Get.width * 0.5,
                height: Get.textTheme.headline5!.fontSize! + 10.0,
                decoration: BoxDecoration(color: Color(0xfff5c7099), borderRadius: BorderRadius.all(Radius.circular(5))),
                child: customCupertinoButton(
                    Alignment.center,
                    EdgeInsets.fromLTRB(5, 2, 5, 2),
                    Text(
                      'Code via Backup Code',
                      style: TextStyle(color: Colors.white),
                    ), () {

                  loginVerifyCode(checkBoxTrust.value, 'backup', textEditingCode.text, data['xf_session'], GlobalController.i.xfCsrfLogin,
                      GlobalController.i.dataCsrfLogin);
                }),
              ), //Code via backup
              Text('Nếu bạn đã sử dụng TÀI KHOẢN ĐĂNG NHẬP này băng email, thì bạn nên xem email và chọn CODE VIA EMAIL, và ngươc lại')
            ],
          ),
        ),
        enableDrag: false,
        isScrollControlled: true);
  }

  saveAccountToList(String user, String session, String dataExp) async {
    accountList = GlobalController.i.userStorage.read('accountList') ?? [];

    for (int i = 0; i < accountList.length; i++) {
      if (accountList.elementAt(i)['nameUser'] == (GlobalController.i.userStorage.read('nameUser') ?? 'NoData')) {
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

    final response = await GlobalController.i.getHttpPost(true, headers, jsonEncode(body), 'http://10.0.0.55:3000/api/vozlogin');
    return response;
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

    final response = await GlobalController.i.getHttpPost(true, headers, jsonEncode(body), 'http://10.0.0.55:3000/api/vozverification').then((value) {
      print(value);
    });
  }
}

/*
Ip testing
http://10.0.0.55:3000/

Real link
https://vozloginapinode.herokuapp.com/api/vozlogin
 */
