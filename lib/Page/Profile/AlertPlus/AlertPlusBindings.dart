import 'package:get/get.dart';
import '/GlobalController.dart';
import '/Page/Profile/AlertPlus/AlertPlusController.dart';

class AlertPlusBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    GlobalController.i.sessionTag.add(DateTime.now().toString());
    Get.lazyPut<AlertPlusController>(() => AlertPlusController(), tag: GlobalController.i.sessionTag.last);
  }
}
