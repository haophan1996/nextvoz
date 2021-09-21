import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import '/GlobalController.dart';
import '/Page/reuseWidget.dart';
import 'package:device_info_plus/device_info_plus.dart';

class SettingsController extends GetxController {
  RxDouble fontSizeView = 15.0.obs;
  RxBool switchValuePost = true.obs, switchImage = true.obs, switchSignature = true.obs, switchDefaultsPage = true.obs;
  bool switchSwipeLeftRight = false;
  var langIndex, darkModeIndex;
  late TextEditingController textEditingController = TextEditingController();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  getLang() {
    return GlobalController.i.userStorage.read('lang') ?? 1;
  }

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();

    if (GlobalController.i.userStorage.read('appSignatureDevice') == null) {
      await getDeviceName();
    }
    darkModeIndex = await GlobalController.i.userStorage.read('darkMode') ?? 0;
    langIndex = GlobalController.i.userStorage.read('lang') ?? 1;
    fontSizeView.value = (GlobalController.i.userStorage.read('fontSizeView') ?? Get.textTheme.button!.fontSize)!;
    switchValuePost.value = GlobalController.i.userStorage.read('scrollToMyRepAfterPost') ?? true;
    switchImage.value = GlobalController.i.userStorage.read('showImage') ?? true;
    switchSignature.value = GlobalController.i.userStorage.read('signature') ?? true;
    switchDefaultsPage.value = GlobalController.i.userStorage.read('defaultsPage') ?? false;
    switchSwipeLeftRight = GlobalController.i.userStorage.read('switchSwipeLeftRight') ?? false;
  }

  getDeviceName() async {
    if (GetPlatform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      await GlobalController.i.userStorage.write('appSignatureDevice', androidInfo.device);
    } else {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      await GlobalController.i.userStorage.write('appSignatureDevice', iosDeviceInfo.name);
    }
    update(['updateAppSignatureName']);
  }

  setDeviceName() async {
    await GlobalController.i.userStorage.write('appSignatureDevice', textEditingController.text);
    update(['updateAppSignatureName']);
    Get.back();
  }

  @override
  onClose() async {
    super.onClose();
    fontSizeView.close();
    switchValuePost.close();
    switchImage.close();
    switchSignature.close();
    switchDefaultsPage.close();
  }

  saveButton() async {
    if (GlobalController.i.userStorage.read('darkMode') != darkModeIndex) {
      GlobalController.i.userStorage.write('darkMode', darkModeIndex);
      Get.changeThemeMode(ThemeMode.values[darkModeIndex]);
    }

    if (GlobalController.i.userStorage.read('lang') != langIndex) {
      Get.updateLocale(GlobalController.i.langList.elementAt(langIndex));
      GlobalController.i.userStorage.write('lang', langIndex);
    }

    if (GlobalController.i.userStorage.read('fontSizeView') != fontSizeView.value) {
      await GlobalController.i.userStorage.write('fontSizeView', fontSizeView.value);
      Get.updateLocale(GlobalController.i.langList.elementAt(langIndex));
    }

    await GlobalController.i.userStorage.write('scrollToMyRepAfterPost', switchValuePost.value);
    await GlobalController.i.userStorage.write('showImage', switchImage.value);
    await GlobalController.i.userStorage.write('defaultsPage', switchDefaultsPage.value);
    await GlobalController.i.userStorage.write('signature', switchSignature.value);
    await GlobalController.i.userStorage.write('switchSwipeLeftRight', switchSwipeLeftRight);
    Get.back();
  }

  final flagsReactions = [
    Reaction(
      previewIcon: buildFlagsPreviewIcon('assets/languages/en.png', 'English'),
      icon: buildIcon('assets/reaction/nil.png', 'English'),
    ),
    Reaction(
      previewIcon: buildFlagsPreviewIcon('assets/languages/vn.png', 'Tiếng Việt'),
      icon: buildIcon('assets/reaction/nil.png', 'Tiếng Việt'),
    ),
  ];

  final darkMode = [
    Reaction(
      previewIcon: buildFlagsPreviewIcon('assets/darkmode/darkmode.png', 'Auto'),
      icon: buildIcon('assets/reaction/nil.png', 'Auto'),
    ),
    Reaction(
      previewIcon: buildFlagsPreviewIcon('assets/darkmode/light.png', 'Light'),
      icon: buildIcon('assets/reaction/nil.png', 'Light'),
    ),
    Reaction(
      previewIcon: buildFlagsPreviewIcon('assets/darkmode/dark.png', 'Dark'),
      icon: buildIcon('assets/reaction/nil.png', 'Dark'),
    ),
  ];
}
