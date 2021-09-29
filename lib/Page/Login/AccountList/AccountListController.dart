import 'package:get/get.dart';
import 'package:the_next_voz/GlobalController.dart';
import 'package:the_next_voz/Page/NavigationDrawer/NaviDrawerController.dart';
import 'package:the_next_voz/Page/reuseWidget.dart';
import 'package:the_next_voz/Routes/pages.dart';

class AccountListController extends GetxController{

  List accountList = [];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    accountList = GlobalController.i.userStorage.read('accountList') ?? [];
  }

  @override
  void onClose() {
    super.onClose();
    GlobalController.i.sessionTag.removeLast();
    GlobalController.i.userStorage.write('accountList', accountList);
  }

  onSelectAccount(int index) async{
    if (accountList.elementAt(index)['userLoginCookie'] == null){
      accountList.removeAt(index);
      setDialogError('Đây là cookie của ứng dụng version 8 trở xuống, hiện tại không hổ trợ');
    } else {
      setDialog();
      GlobalController.i.alertList.clear();
      GlobalController.i.inboxList.clear();
      await GlobalController.i.userStorage.write("userLoggedIn", true);
      await GlobalController.i.userStorage.write("userLoginCookie", accountList.elementAt(index)['userLoginCookie']);
      await GlobalController.i.setDataUser();
      await NaviDrawerController.i.getUserProfile();
      if (Get.isDialogOpen == true){
        Get.offAllNamed(Routes.Home);
      }
    }

  }

  removeAccount(int index) {
    accountList.removeAt(index);
    update(['list']);
  }
}