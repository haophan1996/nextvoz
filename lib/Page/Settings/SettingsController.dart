import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:get/get_utils/get_utils.dart';
import '/GlobalController.dart';
import '/Page/reuseWidget.dart';
import 'package:device_info_plus/device_info_plus.dart';

class SettingsController extends GetxController {
  RxDouble fontSizeView = 15.0.obs;
  RxBool switchValuePost = true.obs, switchImage = true.obs, switchSignature = true.obs, switchDefaultsPage = true.obs;
  bool switchSwipeLeftRight = false, memberSignature = false;
  late double sizeIconBottomBarDouble;
  var langIndex, darkModeIndex;
  int sizeIconBottomBar = 0;
      int heightBottomBar = 0;
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
    sizeIconBottomBarDouble = GlobalController.i.userStorage.read('sizeIconBottomBar') ?? 35.0;
    sizeIconBottomBar = sizeIconBottomBarDouble.toInt();
    heightBottomBar = GlobalController.i.userStorage.read('heightBottomBar') ?? (GetPlatform.isAndroid ? 0 : 20);
    darkModeIndex =  GlobalController.i.userStorage.read('darkMode') ?? 0;
    langIndex = GlobalController.i.userStorage.read('lang') ?? 1;
    fontSizeView.value = (GlobalController.i.userStorage.read('fontSizeView') ?? Get.textTheme.bodyText1!.fontSize)!;
    switchValuePost.value = GlobalController.i.userStorage.read('scrollToMyRepAfterPost') ?? true;
    switchImage.value = GlobalController.i.userStorage.read('showImage') ?? true;
    switchSignature.value = GlobalController.i.userStorage.read('signature') ?? true;
    memberSignature = GlobalController.i.userStorage.read('memberSignature') ?? false;
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

    if (GlobalController.i.userStorage.read('sizeIconBottomBar') != sizeIconBottomBar){
      await GlobalController.i.userStorage.write('sizeIconBottomBar', sizeIconBottomBar.toDouble());
    }

    if (GlobalController.i.userStorage.read('heightBottomBar') != heightBottomBar){
      await GlobalController.i.userStorage.write('heightBottomBar', heightBottomBar);
    }

    await GlobalController.i.userStorage.write('scrollToMyRepAfterPost', switchValuePost.value);
    await GlobalController.i.userStorage.write('showImage', switchImage.value);
    await GlobalController.i.userStorage.write('defaultsPage', switchDefaultsPage.value);
    await GlobalController.i.userStorage.write('signature', switchSignature.value);
    await GlobalController.i.userStorage.write('switchSwipeLeftRight', switchSwipeLeftRight);
    await GlobalController.i.userStorage.write('memberSignature', memberSignature);
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
