import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vozforums/Page/View/ViewController.dart';
import '../../GlobalController.dart';
import 'package:http/http.dart' as http;
import '../reuseWidget.dart';

class NaviDrawerController extends GetxController {
  static NaviDrawerController get i => Get.find();
  double heightAppbar = 45;
  TextEditingController textEditingControllerLogin = TextEditingController();
  TextEditingController textEditingControllerPassword = TextEditingController();

  RxString nameUser = ''.obs;
  RxString titleUser = ''.obs;
  RxString avatarUser = ''.obs;
  RxString linkUser = ''.obs;
  String statusLogin = '';
  List shortcuts = [];

  Future<void> loginFunction(BuildContext context) async {
    statusLogin = '';
    setDialog(context, 'popMess'.tr, 'popMess2'.tr);
    if (textEditingControllerLogin.text.length < 6 || textEditingControllerPassword.text.length <6){
      statusLogin = 'statusLoginInvalid'.tr;
      update();
      Get.back();
      return;
    }

    final getMyData = await login(textEditingControllerLogin.text, textEditingControllerPassword.text, GlobalController.i.dataCsrfLogin,
        GlobalController.i.xfCsrfLogin, textEditingControllerLogin.text);

    if (getMyData == 'none') {
      await Future.delayed(Duration(milliseconds: 3000), () async {
        Get.back();
      });
      statusLogin = 'statusLoginFail'.tr;
      update();
    } else {
      statusLogin = 'statusLoginOK'.tr;
      update();
      statusLogin = '';
      await GlobalController.i.userStorage.remove('userLoggedIn');
      await GlobalController.i.userStorage.remove('xf_user');
      await GlobalController.i.userStorage.remove('xf_session');
      await GlobalController.i.userStorage.remove('date_expire');

      await GlobalController.i.userStorage.write("userLoggedIn", true);
      await GlobalController.i.userStorage.write("xf_user", getMyData['xf_user']);
      await GlobalController.i.userStorage.write("xf_session", getMyData['xf_session']);
      await GlobalController.i.userStorage.write("date_expire", getMyData['date_expire']);
      await GlobalController.i.setDataUser();
      await getUserProfile();
      await Future.delayed(Duration(milliseconds: 3000), () async {
        Get.back();
        Get.back();
      });

    }
  }

  getUserProfile() async{
    await GlobalController.i.getBody(GlobalController.i.url, false).then((res) async {
      GlobalController.i.inboxNotifications = res.getElementsByClassName('p-navgroup-link--conversations').length > 0
          ? int.parse(res.getElementsByClassName('p-navgroup-link--conversations')[0].attributes['data-badge'].toString())
          : 0;
      GlobalController.i.alertNotifications = res.getElementsByClassName('p-navgroup-link--alerts').length > 0
          ? int.parse(res.getElementsByClassName('p-navgroup-link--alerts')[0].attributes['data-badge'].toString())
          : 0;      GlobalController.i.update();
      String linkProfile = res.getElementsByTagName('form')[1].attributes['action']!.split('/post')[0];
      linkUser.value = linkProfile;
       await GlobalController.i.getBody(GlobalController.i.url+linkProfile, false).then((value) {
        nameUser.value = value.documentElement!.getElementsByClassName(' is-stroked')[0].getElementsByTagName('span')[0].innerHtml;
        titleUser.value = value.documentElement!.getElementsByClassName('userTitle')[0].innerHtml;
        if (value.documentElement!.getElementsByClassName('avatar avatar--l').map((e)=>e.innerHtml).first.contains('span') == true){
          avatarUser.value = 'no';
        } else {
          avatarUser.value = value.documentElement!.getElementsByClassName('avatarWrapper')[0].getElementsByTagName('img')[0].attributes['src'].toString();
        }
      });
    }).then((value) async {
      await GlobalController.i.userStorage.write("linkUser", linkUser.value);
      await GlobalController.i.userStorage.write("nameUser", nameUser.value);
      await GlobalController.i.userStorage.write("titleUser", titleUser.value);
      await GlobalController.i.userStorage.write("avatarUser", avatarUser.value);
    });

  }

  login(String login, String pass, String token, String cookie, String userAgent) async {
    var headers = {
      'content-type': 'application/json; charset=UTF-8',
      'host': 'vozloginapinode.herokuapp.com',
    };
    var map = {"login": login, "password": pass, "remember": "1", "_xfToken": token, "userAgent": userAgent, "cookie": cookie};

    final response = await http.post(Uri.parse("https://vozloginapinode.herokuapp.com/api/vozlogin"), headers: headers, body: jsonEncode(map));

    if (response.statusCode != 200) {
      return "none";
    } else {
      return jsonDecode(response.body);
    }
  }

  logout() async{
    GlobalController.i.dio.options.headers['cookie'] = '';
    GlobalController.i.isLogged.value = false;
    nameUser.value = '';
    titleUser.value = '';
    avatarUser.value = '';
    linkUser.value = '';
    await GlobalController.i.userStorage.remove("userLoggedIn");
    await GlobalController.i.userStorage.remove("xf_user");
    await GlobalController.i.userStorage.remove("xf_session");
    await GlobalController.i.userStorage.remove("date_expire");
  }

  navigateToThread(String title, String link, String prefix) {
    Future.delayed(Duration(milliseconds: 100), () async {
      Get.back();
      GlobalController.i.tagView.add(title);
      Get.lazyPut<ViewController>(() => ViewController(), tag: title);
      Get.toNamed("/ViewPage", arguments: [title, link, prefix, 0], preventDuplicates: false);
    });
  }

  navigateToSetting(){
    Get.back();
    Get.toNamed('/Settings');
  }
}
