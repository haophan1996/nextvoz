import 'package:get/get.dart';
import 'package:the_next_voz/Page/Login/AccountList/AccountListController.dart';
import '../../../GlobalController.dart';

class AccountListBindings extends Bindings{
  @override
  void dependencies() {
    GlobalController.i.sessionTag.add(DateTime.now().toString());
    Get.put(AccountListController(), tag: GlobalController.i.sessionTag.last);
  }

}