import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nextvoz/Routes/routes.dart';
import '/GlobalController.dart';
import '/Page/NavigationDrawer/NaviDrawerController.dart';
import '/Page/Profile/UserProfile/UserProfileController.dart';
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
                'shortcuts',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
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
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: Colors.black),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NaviDrawerController.i.data['avatarUser'] == "no"
                          ? Image.asset(
                              "assets/NoAvata.png",
                              height: 48,
                              width: 48,
                            ).image
                          : NaviDrawerController.i.data['avatarUser'].length > 5
                              ? CachedNetworkImageProvider((NaviDrawerController.i.data['avatarUser']))
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
                  GlobalController.i.sessionTag.add('profile${DateTime.now().toString()}');
                  Get.lazyPut<UserProfileController>(() => UserProfileController(), tag: GlobalController.i.sessionTag.last);
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
                  Icons.refresh,
                  color: Get.theme.primaryColor,
                ),
                onPressed: () async {
                  setDialog();
                  //await NaviDrawerController.i.getUserProfile();
                  Get.back();
                },
              ), //Refresh user data
              CupertinoButton(
                  padding: EdgeInsets.only(right: 10, top: 10),
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
                    Get.toNamed(Routes.Login, preventDuplicates: false);
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
