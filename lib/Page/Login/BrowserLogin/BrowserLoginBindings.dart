import 'package:get/get.dart';
import 'BrowserLoginController.dart';

class BrowserLoginBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(BrowserLoginController());
  }

}