import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../GlobalController.dart';

class NaviDrawerController extends GetxController{
  static NaviDrawerController get i => Get.find();
  double heightAppbar = 45;
  RxString title = "".obs;
  RxString statusLogin = ''.obs;
  TextEditingController textEditingControllerLogin = TextEditingController();
  TextEditingController textEditingControllerPassword = TextEditingController();


  Future<void> loginFunction() async {
    final getMyData = await GlobalController.i.login(
        textEditingControllerLogin.text,
        textEditingControllerPassword.text,
        GlobalController.i.dataCsrf,
        GlobalController.i.xfCsrf,
        textEditingControllerLogin.text);

     print(getMyData['xf_user']);
     print(getMyData);
     print(getMyData['xf_session']);


    if (getMyData == 'none') {
      statusLogin.value = "Incorrect id or password";
    } else {
      statusLogin.value = "Success";
      GlobalController.i.userStorage.remove('userLoggedIn');
      GlobalController.i.userStorage.remove('xf_user');
      GlobalController.i.userStorage.remove('xf_session');
      GlobalController.i.userStorage.remove('date_expire');

      GlobalController.i.userStorage.write("userLoggedIn", true);
      GlobalController.i.userStorage.write("xf_user", getMyData['xf_user']);
      GlobalController.i.userStorage.write("xf_session", getMyData['xf_session']);
      GlobalController.i.userStorage.write("date_expire", getMyData['date_expire']);


    }
     print(statusLogin);

  }
}