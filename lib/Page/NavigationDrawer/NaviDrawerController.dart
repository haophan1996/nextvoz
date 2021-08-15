import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:nextvoz/Routes/routes.dart';
import '/Page/View/ViewController.dart';
import '/GlobalController.dart';
import '/Page/reuseWidget.dart';

class NaviDrawerController extends GetxController {
  static NaviDrawerController get i => Get.find();
  List shortcuts = [];
  var dio = Dio();
  Map<String, dynamic> data = {};


  logout() async {
    setDialog();
    GlobalController.i.xfUser = '';
    GlobalController.i.isLogged = false;
    GlobalController.i.inboxNotifications = 0;
    GlobalController.i.alertNotifications = 0;
    GlobalController.i.alertList.clear();
    GlobalController.i.inboxList.clear();
    data.clear();
    await GlobalController.i.userStorage.remove("userLoggedIn");
    await GlobalController.i.userStorage.remove("xf_user");
    await GlobalController.i.userStorage.remove("xf_session");
    await GlobalController.i.userStorage.remove("date_expire");
    update();
    GlobalController.i.update(['Notification'], true);
    if(Get.isDialogOpen==true) Get.back();
  }

  navigateToThread(String title, String link, String prefix) {
    Future.delayed(Duration(milliseconds: 100), () async {
      Get.back();
      Get.toNamed(Routes.View, arguments: [title, link, prefix, 0], preventDuplicates: false);
    });
  }

  navigateToSetting() {
    Get.toNamed(Routes.Settings, preventDuplicates: false);
  }


  Future<void> getUserProfile() async {
    await GlobalController.i.getBody(() {}, (download) {}, dio, GlobalController.i.url, false).then((res) async {
      GlobalController.i.token = res!.getElementsByTagName('html')[0].attributes['data-csrf'];
      if (res.getElementsByTagName('html')[0].attributes['data-logged-in'] == 'true') {
        GlobalController.i.controlNotification(
            int.parse(res.getElementsByClassName('p-navgroup-link--alerts')[0].attributes['data-badge'].toString()),
            int.parse(res.getElementsByClassName('p-navgroup-link--conversations')[0].attributes['data-badge'].toString()),
            res.getElementsByTagName('html')[0].attributes['data-logged-in'].toString());
      } else
        GlobalController.i.controlNotification(0, 0, 'false');

      String linkProfile = res.getElementsByTagName('form')[1].attributes['action']!.split('/post')[0];
      data['linkUser'] = linkProfile;
      await GlobalController.i.getBody(() {}, (download) {}, dio, GlobalController.i.url + linkProfile, false).then((value) {
        data['nameUser'] = value!.documentElement!.getElementsByClassName(' is-stroked')[0].getElementsByTagName('span')[0].innerHtml;
        data['titleUser'] = value.documentElement!.getElementsByClassName('userTitle')[0].innerHtml;


        var avatar = value.getElementsByClassName('avatar avatar--l').first;
        if (avatar.getElementsByTagName('img').length > 0) {
          data['avatarUser'] = avatar.attributes['href'].toString();
          if (data['avatarUser'].contains('https')== false){
            data['avatarUser'] = GlobalController.i.url + data['avatarUser'];
          }
          data['avatarColor1'] = '0x00000000';
          data['avatarColor2'] = '0x00000000';
        } else {
          data['avatarUser'] = 'no';
          data['avatarColor1'] = '0xFFF' + avatar.attributes['style'].toString().split('#')[1].split(';')[0];
          data['avatarColor2'] = '0xFFF' + avatar.attributes['style'].toString().split('#')[2];
        }

      });
    }).then((value) async {
      await GlobalController.i.userStorage.write("linkUser", data['linkUser']);
      await GlobalController.i.userStorage.write("nameUser", data['nameUser']);
      await GlobalController.i.userStorage.write("titleUser", data['titleUser']);
      await GlobalController.i.userStorage.write("avatarUser", data['avatarUser']);
      await GlobalController.i.userStorage.write("avatarColor1", data['avatarColor1']);
      await GlobalController.i.userStorage.write("avatarColor2", data['avatarColor2']);
      NaviDrawerController.i.data['linkUser'] = data['linkUser'];
      NaviDrawerController.i.data['nameUser'] = data['nameUser'];
      NaviDrawerController.i.data['titleUser'] = data['titleUser'];
      NaviDrawerController.i.data['avatarUser'] = data['avatarUser'];
      NaviDrawerController.i.data['avatarColor1'] = data['avatarColor1'];
      NaviDrawerController.i.data['avatarColor2'] = data['avatarColor2'];
      GlobalController.i.update(['Notification'], true);
    });
  }
}
