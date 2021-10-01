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
                  if (result != null && result[0] == 'ok') {
                    setDialog();
                    await GlobalController.i.setDataUser();
                    await NaviDrawerController.i.getUserProfile();

                    controller.data['userLoginCookie'] = GlobalController.i.userStorage.read('userLoginCookie') ?? '';
                    if (controller.data['userLoginCookie'] != '') {
                      await controller.saveAccountToList(controller.data['userLoginCookie']);
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

loginVerification(String userName, String provider, TextEditingController input, Function callback) async {
  await Get.bottomSheet(
      SafeArea(
          child: Container(
        height: Get.height * 0.8,
        decoration: BoxDecoration(
          color: Get.theme.backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
                child: Text(
              '\t\tTwo-step verification required',
              style: TextStyle(fontSize: Get.textTheme.headline6!.fontSize, fontWeight: FontWeight.bold),
            )),
            Flexible(
                child: Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: RichText(
                  text: TextSpan(children: [
                TextSpan(text: 'Logging in as: ', style: TextStyle(color: Get.theme.primaryColor)),
                TextSpan(text: userName, style: TextStyle(color: Get.theme.primaryColor, fontWeight: FontWeight.bold)),
              ])),
            )),
            Flexible(
                child: Container(
              height: 80,
              padding: EdgeInsets.all(10),
              child: TextField(
                  controller: input,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Verification code',
                      labelStyle: TextStyle(color: Get.theme.primaryColor.withOpacity(0.7)),
                      fillColor: Get.theme.canvasColor,
                      filled: true,
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Get.theme.primaryColor, width: 1)),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)))),
            )),
            Container(
              width: Get.width * 0.5,
              height: Get.textTheme.headline5!.fontSize! + 10.0,
              decoration: BoxDecoration(color: Color(0xfff5c7099), borderRadius: BorderRadius.all(Radius.circular(5))),
              child: customCupertinoButton(
                  Alignment.center,
                  EdgeInsets.fromLTRB(5, 2, 5, 2),
                  Text(
                    provider == 'totp'
                        ? 'Code via App'
                        : provider == 'email'
                            ? 'Code via Email'
                            : 'Code via Backup Code',
                    style: TextStyle(color: Colors.white),
                  ),
                  () async => callback()),
            ), //Input code
            Padding(
              padding: EdgeInsets.only(top: 50),
              child: GetBuilder<LoginController>(
                builder: (controller) {
                  return Container(
                    width: Get.width * 0.5,
                    height: Get.textTheme.headline5!.fontSize! + 10.0,
                    decoration: BoxDecoration(color: Color(0xfff5c7099), borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: customCupertinoButton(
                        Alignment.center,
                        EdgeInsets.fromLTRB(5, 2, 5, 2),
                        Text(
                          'Back to select Code',
                          style: TextStyle(color: Colors.orange),
                        ), () {
                      Get.back();
                      promptCodeProvider((provider) {
                        controller.promptCodeProviderLogin(provider);
                      });
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      )),
      enableDrag: false,
      ignoreSafeArea: false,
      isScrollControlled: true);
}

promptCodeProvider(Function(int) callback) async {
  await Get.defaultDialog(
      title: 'Two-step verification provider',
      radius: 6,
      barrierDismissible: false,
      content: GetBuilder<LoginController>(builder: (controller) {
        return Column(
          children: [
            Text(
              'Nếu bạn đã sử dụng TÀI KHOẢN ĐĂNG NHẬP này băng email, thì bạn nên xem email và chọn CODE VIA EMAIL, và ngươc lại\n\n',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            Container(
              width: Get.width * 0.5,
              height: Get.textTheme.headline5!.fontSize! + 10.0,
              decoration: BoxDecoration(color: Color(0xfff5c7099), borderRadius: BorderRadius.all(Radius.circular(5))),
              child: customCupertinoButton(
                  Alignment.center,
                  EdgeInsets.fromLTRB(5, 2, 5, 2),
                  Text(
                    'Code via App',
                    style: TextStyle(color: Colors.white),
                  ),
                  () async => callback(1)),
            ), //Code via app
            Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                width: Get.width * 0.5,
                height: Get.textTheme.headline5!.fontSize! + 10.0,
                decoration: BoxDecoration(color: Color(0xfff5c7099), borderRadius: BorderRadius.all(Radius.circular(5))),
                child: customCupertinoButton(
                    Alignment.center,
                    EdgeInsets.fromLTRB(5, 2, 5, 2),
                    Text(
                      'Code via Email',
                      style: TextStyle(color: Colors.white),
                    ),
                    () async => callback(2)),
              ),
            ), //Code via email
            Container(
              width: Get.width * 0.5,
              height: Get.textTheme.headline5!.fontSize! + 10.0,
              decoration: BoxDecoration(color: Color(0xfff5c7099), borderRadius: BorderRadius.all(Radius.circular(5))),
              child: customCupertinoButton(
                  Alignment.center,
                  EdgeInsets.fromLTRB(5, 2, 5, 2),
                  Text(
                    'Code via Backup Code',
                    style: TextStyle(color: Colors.white),
                  ),
                  () async => callback(3)),
            ), //Code via backup,
            Padding(
              padding: EdgeInsets.only(top: 50),
              child: customCupertinoButton(Alignment.center, EdgeInsets.zero, Text('Close'), () => Get.back()),
            )
          ],
        );
      }));
}
