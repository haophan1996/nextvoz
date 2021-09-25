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
    setDialog();
    GlobalController.i.alertList.clear();
    GlobalController.i.inboxList.clear();
    await GlobalController.i.userStorage.write("userLoggedIn", true);
    await GlobalController.i.userStorage.write("xf_user", accountList.elementAt(index)['xf_user']);
    await GlobalController.i.userStorage.write("xf_session", accountList.elementAt(index)['xf_session']);
    await GlobalController.i.userStorage.write("date_expire", accountList.elementAt(index)['date_expire']);
    await GlobalController.i.setDataUser();
    await NaviDrawerController.i.getUserProfile();
    if (Get.isDialogOpen == true){
      Get.offAllNamed(Routes.Home);
    }
  }

  removeAccount(int index) {
    accountList.removeAt(index);
    update(['list']);
  }
}