import 'package:get/get.dart';
import 'PostStatusController.dart';

class PostStatusBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    //Get.put(PostStatusController());
    Get.lazyPut<PostStatusController>(() => PostStatusController());
  }

}