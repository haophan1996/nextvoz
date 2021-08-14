import 'package:get/get.dart';
import 'SearchController.dart';

class SearchBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<SearchController>(() => SearchController());
  }

}