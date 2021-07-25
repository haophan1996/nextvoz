import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vozforums/GlobalController.dart';
import 'package:vozforums/Page/NavigationDrawer/NaviDrawerController.dart';
import 'package:vozforums/Page/reuseWidget.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:extended_image/extended_image.dart';

class NaviDrawerUI extends GetView<NaviDrawerController> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Container(
          color: Theme.of(context).backgroundColor,
          child: Column(
            children: [
              Text(
                'shortcuts',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              CupertinoButton(
                  child: Container(
                    width: Get.width,
                    child: Text(
                      'FeedBack',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ),
                  onPressed: () {
                    Get.defaultDialog(
                        content: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: controller.feedBackCNameController,
                            decoration: InputDecoration(
                              hintText: 'Email của bạn',
                            ),
                          ),
                          TextField(
                            controller: controller.feedBackCTitleController,
                            decoration: InputDecoration(
                              hintText: 'Chủ đề',
                            ),
                          ),
                          Container(
                            height: 120,
                            child: TextField(
                              maxLines: 5,
                              controller: controller.feedBackContentController,
                              decoration: InputDecoration(
                                hintText: 'Diễn tã lỗi sản phẩm',
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CupertinoButton(child: Text('Hủy Bỏ'), onPressed: () => Get.back()),
                              CupertinoButton(
                                  child: Text('Gửi'),
                                  onPressed: () async {
                                    if (controller.feedBackContentController.text.length < 2 ||
                                        controller.feedBackCTitleController.text.length < 2 ||
                                        controller.feedBackCNameController.text.length < 2) {
                                      Get.snackbar('Thông Báo', 'Lỗi kí tự quá ngắn, it nhất 2 kí tự trở lên',
                                          colorText: Colors.red, backgroundColor: Colors.black);
                                    } else {
                                      GlobalController.i.sendFeedBack(context, controller.feedBackContentController.text.toString(),
                                          controller.feedBackCNameController.text.toString(), controller.feedBackCTitleController.text.toString());
                                    }
                                  }),
                            ],
                          )
                        ],
                      ),
                    ));
                  }),
              Expanded(
                child: GetBuilder<NaviDrawerController>(
                  builder: (controller) {
                    return controller.shortcuts.length == 0
                        ? Container()
                        : ListView.builder(
                            itemCount: controller.shortcuts.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                title: customTitle(FontWeight.normal, Get.theme.primaryColor, 1, controller.shortcuts.elementAt(index)['typeTitle'],
                                    controller.shortcuts.elementAt(index)['title']),
                                onTap: () {
                                  controller.navigateToThread(controller.shortcuts.elementAt(index)['title'],
                                      controller.shortcuts.elementAt(index)['link'], controller.shortcuts.elementAt(index)['typeTitle']);
                                },
                                onLongPress: () async {
                                  controller.shortcuts.removeAt(index);
                                  controller.update();
                                  await GlobalController.i.userStorage.remove('shortcut');
                                  await GlobalController.i.userStorage.write('shortcut', controller.shortcuts);
                                },
                              );
                            });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget logged(BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(bottom: 10),
    child: Container(
      decoration: BoxDecoration(color: Theme.of(context).backgroundColor, borderRadius: BorderRadius.all(Radius.circular(6))),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 5, left: 15, right: 15),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: Colors.black),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NaviDrawerController.i.avatarUser.value == "no"
                          ? Image.asset(
                              "assets/NoAvata.png",
                              height: 48,
                              width: 48,
                            ).image
                          : NaviDrawerController.i.avatarUser.value.length > 5
                              ? ExtendedNetworkImageProvider((NaviDrawerController.i.avatarUser.value), cache: true)
                              : Image.asset(
                                  "assets/NoAvata.png",
                                  height: 48,
                                  width: 48,
                                ).image,
                    ),
                  ),
                ),
              ), //Show avatar
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textDrawer(Color(0xFFFD6E00), 16, NaviDrawerController.i.nameUser.value, FontWeight.bold),
                    textDrawer(Theme.of(context).primaryColor, 13, NaviDrawerController.i.titleUser.value, FontWeight.normal),
                  ],
                ),
              ), //Title and name user
              settings(context),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoButton(
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.refresh,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () async {
                  setDialog('popMess'.tr, 'popMess3'.tr);
                  await NaviDrawerController.i.getUserProfile();
                  Get.back();
                },
              ), //Refresh user data
              CupertinoButton(
                  padding: EdgeInsets.only(right: 10),
                  child: Text('logout'.tr),
                  onPressed: () async {
                    await NaviDrawerController.i.logout();
                  }),
            ],
          )
        ],
      ),
    ),
  );
}

Widget login(BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(bottom: 10),
    child: Container(
      decoration: BoxDecoration(color: Theme.of(context).backgroundColor, borderRadius: BorderRadius.all(Radius.circular(6))),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text('login'.tr),
                  onTap: () {
                    NaviDrawerController.i.statusLogin = '';
                    NaviDrawerController.i.textEditingControllerPassword.text = '';
                    NaviDrawerController.i.textEditingControllerLogin.text = '';
                    Get.bottomSheet(
                        Container(
                          //height: Get.height - (Get.height * 0.2),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.all(
                              Radius.circular(6),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                child: Text(
                                  'loginMess'.tr,
                                  style: TextStyle(foreground: Paint()..shader = linearGradient, fontWeight: FontWeight.bold),
                                ),
                                padding: EdgeInsets.all(5),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
                                child: inputCustom(NaviDrawerController.i.textEditingControllerLogin, false, 'loginAccount', () {}),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                child: inputCustom(NaviDrawerController.i.textEditingControllerPassword, true, 'loginPassword',
                                    () async => await NaviDrawerController.i.loginFunction(context)),
                              ),
                              GetBuilder<NaviDrawerController>(builder: (controller) {
                                return Text(controller.statusLogin, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold));
                              }),
                              TextButton(
                                  child: Text('login'.tr),
                                  onPressed: () async {
                                    await NaviDrawerController.i.loginFunction(context);
                                  }),
                              SignInButton(Buttons.Google, onPressed: () {}),
                              SignInButton(Buttons.Facebook, onPressed: () {})
                            ],
                          ),
                        ),
                        isScrollControlled: true,
                        useRootNavigator: true,
                        ignoreSafeArea: false);
                  },
                ),
              ),
              CupertinoButton(child: Icon(Icons.settings), onPressed: () => NaviDrawerController.i.navigateToSetting())
            ],
          ),
          Text(
            'version 1.0',
            style: TextStyle(height: 3),
          )
        ],
      ),
    ),
  );
}
