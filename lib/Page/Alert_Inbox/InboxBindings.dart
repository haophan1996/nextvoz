import 'package:get/get.dart';
import '/Page/Alert_Inbox/InboxController.dart';

class InboxBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    //Get.lazyPut<InboxController>(() => InboxController());
    Get.put(InboxController());
  }
}
