import 'package:get/get.dart';
import '../../../GlobalController.dart';
import 'UserProfileController.dart';

class UserProfileBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    GlobalController.i.sessionTag.add(DateTime.now().toString());
    Get.lazyPut<UserProfileController>(() => UserProfileController(), tag: GlobalController.i.sessionTag.last);
  }
}
