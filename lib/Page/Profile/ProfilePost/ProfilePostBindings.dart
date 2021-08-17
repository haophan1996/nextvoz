import 'package:get/get.dart';
import '/GlobalController.dart';
import '/Page/Profile/ProfilePost/ProfilePostController.dart';

class ProfilePostBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    GlobalController.i.sessionTag.add(DateTime.now().toString());
    Get.lazyPut<ProfilePostController>(() => ProfilePostController(), tag: GlobalController.i.sessionTag.last);
  }
}
