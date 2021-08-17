import 'package:get/get.dart';
import 'package:theNEXTvoz/GlobalController.dart';

class UserFollIgrController extends GetxController{

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    GlobalController.i.sessionTag.removeLast();
  }
}