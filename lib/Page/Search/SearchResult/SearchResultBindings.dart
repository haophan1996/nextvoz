import 'package:get/get.dart';
import '/Page/Search/SearchResult/SearchResultController.dart';
import '../../../GlobalController.dart';

class SearchResultBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    GlobalController.i.sessionTag.add(DateTime.now().toString());
    Get.put(SearchResultController(), tag: GlobalController.i.sessionTag.last);
  }

}