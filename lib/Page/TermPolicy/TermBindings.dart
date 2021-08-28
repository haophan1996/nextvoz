import 'package:get/get.dart';
import 'TermController.dart';

class TermBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(TermController());
  }

}