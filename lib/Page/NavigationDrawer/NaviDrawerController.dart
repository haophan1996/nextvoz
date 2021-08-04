import 'package:get/get.dart';
import 'package:nextvoz/Routes/routes.dart';
import '/Page/View/ViewController.dart';
import '/GlobalController.dart';
import '/Page/reuseWidget.dart';

class NaviDrawerController extends GetxController {
  static NaviDrawerController get i => Get.find();
  double heightAppbar = 45;
  List shortcuts = [];
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
      GlobalController.i.sessionTag.add(title);
      Get.lazyPut<ViewController>(() => ViewController(), tag: title);
      Get.toNamed(Routes.View, arguments: [title, link, prefix, 0], preventDuplicates: false);
    });
  }

  navigateToSetting() {
    Get.toNamed(Routes.Settings, preventDuplicates: false);
  }
}
