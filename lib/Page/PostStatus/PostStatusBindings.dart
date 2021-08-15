import 'package:get/get.dart';
import '/Page/PostStatus/PostStatusController.dart';

class PostStatusBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<PostStatusController>(() => PostStatusController());
  }

}