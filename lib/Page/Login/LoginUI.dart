import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_next_voz/Page/NavigationDrawer/NaviDrawerController.dart';
import 'package:the_next_voz/Routes/pages.dart';
import '/Page/reuseWidget.dart';
import '/GlobalController.dart';
import 'LoginController.dart';

class LoginUI extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: appBarOnly('', []),
      body: Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 5, bottom: 5),
              child: TextField(
                controller: controller.textEditingControllerLogin,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    labelText: 'loginAccount'.tr,
                    labelStyle: TextStyle(color: Get.theme.primaryColor.withOpacity(0.7)),
                    fillColor: Get.theme.canvasColor,
                    filled: true,
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Get.theme.primaryColor, width: 1)),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent))),
              ),
            ),
            Obx(() => TextField(
                  controller: controller.textEditingControllerPassword,
                  obscureText: controller.isShowPass.value,
                  onSubmitted: (_) async => await controller.loginFunction(),
                  decoration: InputDecoration(
                      suffix: InkWell(
                        focusNode: FocusNode(skipTraversal: true),
                        onTap: () => {controller.isShowPass.value == true ? controller.isShowPass.value = false : controller.isShowPass.value = true},
                        child: Text(
                          controller.isShowPass.value == true ? 'hide'.tr : 'show'.tr,
                          style: TextStyle(color: Get.theme.primaryColor),
                        ),
                      ),
                      labelText: 'loginPassword'.tr,
                      labelStyle: TextStyle(color: Get.theme.primaryColor.withOpacity(0.7)),
                      fillColor: Get.theme.canvasColor,
                      filled: true,
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Get.theme.primaryColor, width: 1)),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent))),
                )),
            Obx(() => Text(
                  controller.statusLogin.value,
                  style: TextStyle(color: Colors.red),
                )),
            customCupertinoButton(Alignment.center, EdgeInsets.only(top: 5, bottom: 5), Text('forgotPass'.tr), () async {
              await GlobalController.i.launchURL('https://voz.vn/lost-password/');
            }),
            customCupertinoButton(
                Alignment.center,
                EdgeInsets.zero,
                Container(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.all(Radius.circular(6))),
                    child: Text('login'.tr)), () async {
              //setDialog();
              await controller.loginFunction();
              //await controller.loginVerification();
              //controller.promptCodeProvider();
            }),
            Text('or'.tr),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: customCupertinoButton(
                Alignment.center,
                EdgeInsets.zero,
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  decoration: BoxDecoration(color: Color(0xFFF7a8db1), borderRadius: BorderRadius.all(Radius.circular(6))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_outline,
                        color: Colors.white,
                      ),
                      Text(
                        '\t\tWebView Login',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
                () async {
                  var result = await Get.toNamed(Routes.BrowserLogin);
                  if (result[0] == 'ok') {
                    setDialog();
                    await GlobalController.i.setDataUser();
                    await NaviDrawerController.i.getUserProfile();

                    controller.data['xf_user'] = GlobalController.i.userStorage.read('xf_user') ?? '';
                    controller.data['xf_session'] = GlobalController.i.userStorage.read('xf_session') ?? '';
                    controller.data['date_expire'] = GlobalController.i.userStorage.read('date_expire') ?? '';
                    if (controller.data['xf_user'] != '' && controller.data['xf_session'] != '' && controller.data['date_expire'] != '') {
                      await controller.saveAccountToList(controller.data['xf_user'], controller.data['xf_session'], controller.data['date_expire']);
                    }

                    Get.back();
                    Get.back();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}




