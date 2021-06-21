import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:get/get.dart';
import 'package:vozforums/GlobalController.dart';
import '../reuseWidget.dart';

class SettingsController extends GetxController {
  RxDouble fontSizeView = 15.0.obs;
  getLang(){
    return GlobalController.i.userStorage.read('lang');
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fontSizeView.value = GlobalController.i.userStorage.read('fontSizeView');
  }

  @override
  onClose() async {
    super.onClose();
    await GlobalController.i.userStorage.write('fontSizeView', fontSizeView.value);

  }

  setLang(int i) async {
    Get.updateLocale(GlobalController.i.langList.elementAt(i));
    await GlobalController.i.userStorage.write('lang', i);
  }

  final flagsReactions = [
    Reaction(
      previewIcon: builFlagsdPreviewIcon('assets/languages/en.png', 'English'),
      icon: buildIcon('assets/languages/en.png', 'English'),
    ),
    Reaction(
      previewIcon: builFlagsdPreviewIcon('assets/languages/vn.png', 'Tiếng Việt'),
      icon: buildIcon('assets/languages/vn.png', 'Tiếng Việt'),
    ),
  ];
}
