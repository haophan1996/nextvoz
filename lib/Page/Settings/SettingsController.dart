import 'package:get/get.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:vozforums/GlobalController.dart';
import 'package:vozforums/Page/reuseWidget.dart';

class SettingsController extends GetxController {
  RxDouble fontSizeView = 15.0.obs;
  RxBool switchValuePost = true.obs;
  var langIndex ;
  getLang(){
    return GlobalController.i.userStorage.read('lang');
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    langIndex = GlobalController.i.userStorage.read('lang');
    fontSizeView.value = GlobalController.i.userStorage.read('fontSizeView');
    switchValuePost.value = GlobalController.i.userStorage.read('scrollToMyRepAfterPost');
  }

  @override
  onClose() async {
    super.onClose();
    fontSizeView.close();
  }
  
  saveButton() async {
    await GlobalController.i.userStorage.write('scrollToMyRepAfterPost', switchValuePost.value);
    await GlobalController.i.userStorage.write('fontSizeView', fontSizeView.value);
    Get.updateLocale(GlobalController.i.langList.elementAt(langIndex));
    await GlobalController.i.userStorage.write('lang', langIndex).then((value) => Get.back());
  }


  final flagsReactions = [
    Reaction(
      previewIcon: buildFlagsPreviewIcon('assets/languages/en.png', 'English'),
      icon: buildIcon('assets/languages/en.png', 'English'),
    ),
    Reaction(
      previewIcon: buildFlagsPreviewIcon('assets/languages/vn.png', 'Tiếng Việt'),
      icon: buildIcon('assets/languages/vn.png', 'Tiếng Việt'),
    ),
  ];
}
