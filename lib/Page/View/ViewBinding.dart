import 'package:get/get.dart';
import 'package:vozforums/Page/View/ViewController.dart';

class ViewBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<ViewController>(() => ViewController());
  }

}