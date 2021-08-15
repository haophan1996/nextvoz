import 'package:get/get.dart';
import '../../GlobalController.dart';
import '/Page/View/ViewController.dart';

class ViewBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    GlobalController.i.sessionTag.add(DateTime.now().toString());
    Get.lazyPut<ViewController>(() => ViewController(), tag: GlobalController.i.sessionTag.last);
  }

}