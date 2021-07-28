import 'package:get/get.dart';
import '/Page/Thread/ThreadController.dart';

class ThreadBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<ThreadController>(() => ThreadController());
  }

}