import 'package:get/get.dart';
import 'package:theNEXTvoz/GlobalController.dart';
import 'package:theNEXTvoz/Page/Profile/AlertPlus/AlertPlusController.dart';

class AlertPlusBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    GlobalController.i.sessionTag.add(DateTime.now().toString());
    Get.lazyPut<AlertPlusController>(() => AlertPlusController(), tag: GlobalController.i.sessionTag.last);
  }
}
