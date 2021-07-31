import 'package:get/get.dart';
import '/Page/home/homeController.dart';

class HomeBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<HomeController>(HomeController(),permanent: false);
  }

}