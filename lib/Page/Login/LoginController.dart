import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nextvoz/Page/NavigationDrawer/NaviDrawerController.dart';
import '../../GlobalController.dart';
import '../reuseWidget.dart';

class LoginController extends GetxController {
  RxBool isShowPass = true.obs;
  RxString statusLogin = ''.obs;
  late TextEditingController textEditingControllerLogin = TextEditingController(), textEditingControllerPassword = TextEditingController();
  var dio = Dio();
  Map<String, dynamic> data = {};

  @override
  onClose(){
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
      await GlobalController.i.getBody(() {}, (download) {}, dio, 'https://voz.vn/login/login', true).then((value) {
        GlobalController.i.dataCsrfLogin = value!.getElementsByTagName('html')[0].attributes['data-csrf'];
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
      await Future.delayed(Duration(milliseconds: 3000), () async {
        Get.back();
        Get.back();
      });
    }
  }

  login(String login, String pass, String token, String cookie, String userAgent) async {
    var headers = {
      'content-type': 'application/json; charset=UTF-8',
      'host': 'vozloginapinode.herokuapp.com',
    };
    var body = {"login": login, "password": pass, "remember": "1", "_xfToken": token, "userAgent": userAgent, "cookie": cookie};

    final response = await GlobalController.i.getHttpPost(headers, jsonEncode(body), 'https://vozloginapinode.herokuapp.com/api/vozlogin');
    return response;
  }

  // getUserProfile() async {
  //   await GlobalController.i.getBody(() {}, (download) {}, dio, GlobalController.i.url, false).then((res) async {
  //     if (res!.getElementsByTagName('html')[0].attributes['data-logged-in'] == 'true') {
  //       GlobalController.i.controlNotification(
  //           int.parse(res.getElementsByClassName('p-navgroup-link--alerts')[0].attributes['data-badge'].toString()),
  //           int.parse(res.getElementsByClassName('p-navgroup-link--conversations')[0].attributes['data-badge'].toString()),
  //           res.getElementsByTagName('html')[0].attributes['data-logged-in'].toString());
  //     } else
  //       GlobalController.i.controlNotification(0, 0, 'false');
  //
  //     String linkProfile = res.getElementsByTagName('form')[1].attributes['action']!.split('/post')[0];
  //     data['linkUser'] = linkProfile;
  //     await GlobalController.i.getBody(() {}, (download) {}, dio, GlobalController.i.url + linkProfile, false).then((value) {
  //       data['nameUser'] = value!.documentElement!.getElementsByClassName(' is-stroked')[0].getElementsByTagName('span')[0].innerHtml;
  //       data['titleUser'] = value.documentElement!.getElementsByClassName('userTitle')[0].innerHtml;
  //       if (value.documentElement!.getElementsByClassName('avatar avatar--l').map((e) => e.innerHtml).first.contains('span') == true) {
  //         data['avatarUser'] = 'no';
  //       } else {
  //         final url = GlobalController.i.url +
  //             value.documentElement!.getElementsByClassName('avatarWrapper')[0].getElementsByTagName('img')[0].attributes['src'].toString();
  //         data['avatarUser'] = url;
  //       }
  //     });
  //   }).then((value) async {
  //     await GlobalController.i.userStorage.write("linkUser", data['linkUser']);
  //     await GlobalController.i.userStorage.write("nameUser", data['nameUser']);
  //     await GlobalController.i.userStorage.write("titleUser", data['titleUser']);
  //     await GlobalController.i.userStorage.write("avatarUser", data['avatarUser']);
  //     NaviDrawerController.i.data['linkUser'] = data['linkUser'];
  //     NaviDrawerController.i.data['nameUser'] = data['nameUser'];
  //     NaviDrawerController.i.data['titleUser'] = data['titleUser'];
  //     NaviDrawerController.i.data['avatarUser'] = data['avatarUser'];
  //   });
  // }
}
