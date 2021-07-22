import 'package:get/get.dart';
import 'package:vozforums/Page/Settings/SettingsController.dart';

class SettingsBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<SettingsController>(() => SettingsController());
  }

}