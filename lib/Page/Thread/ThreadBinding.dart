import 'package:get/get.dart';
import '../../GlobalController.dart';
import '/Page/Thread/ThreadController.dart';

class ThreadBinding extends Bindings{
  @override
  void dependencies() {
    GlobalController.i.sessionTag.add(DateTime.now().toString());
    Get.lazyPut<ThreadController>(() => ThreadController(), tag: GlobalController.i.sessionTag.last);
  }

}