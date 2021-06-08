import 'package:get/get.dart';
import 'package:vozforums/Page/Thread/subThreadController.dart';

class ThreadBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<ThreadController>(() => ThreadController());
  }

}