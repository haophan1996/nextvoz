import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:get/get.dart';
import 'package:vozforums/GlobalController.dart';
import '../reuseWidget.dart';

class SettingsController extends GetxController{
  late int lang;

  @override
  Future<void> onInit() async{
    // TODO: implement onInit
    super.onInit();

    if (GlobalController.i.userStorage.read('lang')==null){
      await GlobalController.i.userStorage.write('lang', 0);
      lang = 0;
    } else {
      lang = GlobalController.i.userStorage.read('lang');
    }
  }


  setLang(int i) async{
    await GlobalController.i.userStorage.write('lang', i);
  }

  final flagsReactions = [
    Reaction(
      previewIcon: builFlagsdPreviewIcon('assets/languages/en.png', 'English'),
      icon: buildIcon('assets/languages/en.png'),
    ),
    Reaction(
      previewIcon: builFlagsdPreviewIcon('assets/languages/vn.png', 'Tiếng Việt'),
      icon: buildIcon('assets/languages/vn.png'),
    ),
  ];
}


