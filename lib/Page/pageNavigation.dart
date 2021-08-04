import 'package:get/get.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/Page/reuseWidget.dart';
import '/GlobalController.dart';
import 'NavigationDrawer/NaviDrawerUI.dart';

Widget pageNavigation(Function(String index) gotoPage, Function reply, Widget child) {
  return FittedBox(
    child: Container(
      color: Get.theme.backgroundColor.withOpacity(0.7),
      width: Get.width,
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                child: Icon(
                  Icons.reply_outlined,
                  color: Get.theme.primaryColor,
                ),
                onPressed: () {
                  if (GlobalController.i.isLogged == false) {
                    setDialogError('You must be logged-in to do that.');
                  } else
                    reply();
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  customCupertinoButton(Alignment.center, EdgeInsets.zero, Icon(Icons.arrow_back, color: Get.theme.primaryColor), () {
                    gotoPage('F');
                  }),
                  customCupertinoButton(Alignment.center, EdgeInsets.zero, Icon(Icons.arrow_back_ios_rounded, color: Get.theme.primaryColor), () {
                    gotoPage('P');
                  }),
                  child,
                  customCupertinoButton(Alignment.center, EdgeInsets.zero, Icon(Icons.arrow_forward_ios_rounded, color: Get.theme.primaryColor), () {
                    gotoPage('N');
                  }),
                  customCupertinoButton(Alignment.center, EdgeInsets.zero, Icon(Icons.arrow_forward, color: Get.theme.primaryColor), () {
                    gotoPage('L');
                  }),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: GetBuilder<GlobalController>(
                  id: 'Notification',
                  builder: (controller) {
                    return CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Icon(
                        Icons.more_rounded,
                        color: controller.inboxNotifications != 0 || controller.alertNotifications != 0 ? Colors.red : Get.theme.primaryColor,
                      ),
                      onPressed: () {
                        Get.bottomSheet(userInformation());
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget userInformation() {
  return SafeArea(child: Container(
    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(6)), color: Colors.grey.shade700),
    padding: EdgeInsets.only(left: 5, right: 5, top: 5),
    child: SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GetBuilder<GlobalController>(
              id: 'Notification',
              builder: (controller) {
                return controller.isLogged == false ? login() : logged();
              }),
          whatNew(),
        ],
      ),
    ),
  ));
}

Widget whatNew() => Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(6)), color: Get.theme.backgroundColor),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              'Latest',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, foreground: Paint()..shader = linearGradient),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Text(
                      'What\'s new',
                      maxLines: 1,
                    ),
                    onPressed: () {}),
              ),
              Expanded(
                child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Text(
                      'New posts',
                      maxLines: 1,
                    ),
                    onPressed: () {}),
              ),
              Expanded(
                child: CupertinoButton(
                    //padding: EdgeInsets.zero,
                    child: Text(
                      'New profile posts',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    onPressed: () {}),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: CupertinoButton(padding: EdgeInsets.zero, child: Text('Your news feed'), onPressed: () {}),
              ),
              Expanded(child: CupertinoButton(padding: EdgeInsets.zero, child: Text('Latest activity'), onPressed: () {}))
            ],
          ),
        ],
      ),
    );
