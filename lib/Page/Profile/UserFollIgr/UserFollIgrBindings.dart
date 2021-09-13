import 'package:get/get.dart';
import '/GlobalController.dart';
import 'UserFollIgrController.dart';

class UserFollIgrBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    GlobalController.i.sessionTag.add(DateTime.now().toString());
    Get.put(UserFollIgrController(),tag: GlobalController.i.sessionTag.last);
  }
}
