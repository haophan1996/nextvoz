import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/Routes/pages.dart';
import '/GlobalController.dart';
import '/Page/NavigationDrawer/NaviDrawerController.dart';
import '/Page/reuseWidget.dart';

class NaviDrawerUI extends GetView<NaviDrawerController> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: SafeArea(
          child: Column(
            children: [
              Text(
                'shortcuts'.tr,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              Expanded(
                child: GetBuilder<NaviDrawerController>(
                  builder: (controller) {
                    return controller.shortcuts.length == 0
                        ? Center(
                            child: Text('shortcutsHelper'.tr),
                          )
                        : ListView.builder(
                            itemCount: controller.shortcuts.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                               title: RichText(
                                 text: TextSpan(
                                   children: [
                                     TextSpan(text: controller.shortcuts.elementAt(index)['title'], style: TextStyle(
                                       color: Theme.of(context).primaryColor
                                     ))
                                   ]
                                 ),
                               ),
                               // title: customTitle(FontWeight.normal, Get.theme.primaryColor, 1, controller.shortcuts.elementAt(index)['typeTitle'],
                                 //   controller.shortcuts.elementAt(index)['title'], null),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget logged() {
  return Padding(
    padding: EdgeInsets.only(bottom: 5),
    child: Container(
      decoration: BoxDecoration(color: Get.theme.backgroundColor, borderRadius: BorderRadius.all(Radius.circular(6))),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 5, left: 15, right: 15),
                child: displayAvatar(40, NaviDrawerController.i.data['avatarColor1'], NaviDrawerController.i.data['avatarColor2'],
                    NaviDrawerController.i.data['nameUser'], NaviDrawerController.i.data['avatarUser']),
              ), //Show avatar
              Expanded(
                child: customCupertinoButton(
                    Alignment.centerLeft,
                    EdgeInsets.zero,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textDrawer(Color(0xFFFD6E00), Get.textTheme.headline6!.fontSize, NaviDrawerController.i.data['nameUser'], FontWeight.bold),
                        textDrawer(
                            Get.theme.primaryColor, Get.textTheme.caption!.fontSize, NaviDrawerController.i.data['titleUser'], FontWeight.normal),
                      ],
                    ), () async {
                  Get.toNamed(Routes.Profile, arguments: [NaviDrawerController.i.data['linkUser']], preventDuplicates: false);
                }),
              ), //Title and name user
              settings(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoButton(
                padding: EdgeInsets.only(right: 10, top: 10),
                child: Icon(
                  Icons.people_alt_rounded,
                  color: Get.theme.primaryColor,
                ),
                onPressed: () async {
                  if (Get.isBottomSheetOpen == true) Get.back();
                  Get.toNamed(Routes.UserFollIgr, arguments: ['follow'], preventDuplicates: false);
                },
              ), //follow
              CupertinoButton(
                padding: EdgeInsets.only(right: 10, top: 10),
                child: Icon(
                  Icons.do_disturb_off_rounded,
                  color: Get.theme.primaryColor,
                ),
                onPressed: () async {
                  if (Get.isBottomSheetOpen == true) Get.back();
                  Get.toNamed(Routes.UserFollIgr, arguments: ['ignore'], preventDuplicates: false);
                },
              ), //ignore
              CupertinoButton(
                padding: EdgeInsets.only(right: 10, top: 10),
                child: Icon(
                  Icons.refresh,
                  color: Get.theme.primaryColor,
                ),
                onPressed: () async {
                  setDialog();
                  await NaviDrawerController.i.getUserProfile();
                  Get.back();
                },
              ), //Refresh user data
              customCupertinoButton(
                  Alignment.center,
                  EdgeInsets.only(right: 10, top: 10),
                  Icon(
                    Icons.change_circle_sharp,
                    color: Get.theme.primaryColor,
                  ), () {
                if (Get.isBottomSheetOpen == true) Get.back();
                Get.toNamed(Routes.AccountLoginList);
              }),
              //Spacer(),
              CupertinoButton(
                  padding: EdgeInsets.only(right: 10, top: 10),
                  child: Icon(
                    Icons.logout_outlined,
                    color: Get.theme.primaryColor,
                  ),
                  onPressed: () async {
                    if (Get.isBottomSheetOpen == true) Get.back();
                    await NaviDrawerController.i.logout();
                  }), //logout
            ],
          )
        ],
      ),
    ),
  );
}

Widget login() {
  return Padding(
    padding: EdgeInsets.only(bottom: 10),
    child: Container(
      decoration: BoxDecoration(color: Get.theme.backgroundColor, borderRadius: BorderRadius.all(Radius.circular(6))),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text('login'.tr),
                  onTap: () {
                    if (Get.isBottomSheetOpen == true) Get.back();
                    Get.toNamed(Routes.Login);
                  },
                ),
              ),
              CupertinoButton(
                  child: Icon(Icons.settings),
                  onPressed: () {
                    if (Get.isBottomSheetOpen == true) Get.back();
                    NaviDrawerController.i.navigateToSetting();
                  })
            ],
          ),
          customCupertinoButton(Alignment.center, EdgeInsets.zero, Icon(Icons.change_circle_sharp), () {
            if (Get.isBottomSheetOpen == true) Get.back();
            Get.toNamed(Routes.AccountLoginList);
          })
        ],
      ),
    ),
  );
}
