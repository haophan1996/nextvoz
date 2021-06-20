import 'package:get/get.dart';

import 'SettingsController.dart';

class SettingsBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<SettingsController>(() => SettingsController());
  }

}