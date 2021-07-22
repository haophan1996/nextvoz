import 'package:get/get.dart';
import 'package:vozforums/Page/PostStatus/PostStatusController.dart';

class PostStatusBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    //Get.put(PostStatusController());
    Get.lazyPut<PostStatusController>(() => PostStatusController());
  }

}