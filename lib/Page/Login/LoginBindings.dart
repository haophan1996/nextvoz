import 'package:get/get.dart';
import 'package:nextvoz/Page/Login/LoginController.dart';

class LoginBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }

}