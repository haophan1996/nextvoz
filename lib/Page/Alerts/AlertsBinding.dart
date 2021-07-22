import 'package:get/get.dart';
import 'package:vozforums/Page/Alerts/AlertsController.dart';

class PopBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    //Get.lazyPut<PopController>(() => PopController());
    Get.put(AlertsController());
  }
}
