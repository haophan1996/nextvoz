import 'package:get/get.dart';
import '/Page/Login/LoginController.dart';

class LoginBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }

}