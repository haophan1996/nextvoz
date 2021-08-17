import 'package:get/get.dart';
import 'package:theNEXTvoz/GlobalController.dart';
import 'UserFollIgrController.dart';

class UserFollIgrBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    GlobalController.i.sessionTag.add(DateTime.now().toString());
    Get.lazyPut<UserFollIgrController>(() => UserFollIgrController(), tag: GlobalController.i.sessionTag.last);
  }
}
