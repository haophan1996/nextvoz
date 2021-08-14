import 'package:get/get.dart';
import 'package:nextvoz/Page/Search/SearchResult/SearchResultController.dart';
import '../../../GlobalController.dart';

class SearchResultBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    GlobalController.i.sessionTag.add(DateTime.now().toString());
    Get.put(SearchResultController(), tag: GlobalController.i.sessionTag.last);
  }

}