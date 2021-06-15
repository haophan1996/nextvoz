import 'package:get/get.dart';
import 'UserProfileController.dart';

class UserProfileBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<UserProfileController>(() => UserProfileController());
  }
}
