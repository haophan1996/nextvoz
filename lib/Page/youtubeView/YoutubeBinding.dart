import 'package:get/get.dart';
import '/Page/youtubeView/YoutubeController.dart';

class YoutubeBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<YoutubeController>(() => YoutubeController());
  }
}
