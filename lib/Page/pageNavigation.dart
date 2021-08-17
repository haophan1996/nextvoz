import 'package:get/get.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/Routes/pages.dart';
import '/Page/reuseWidget.dart';
import '/GlobalController.dart';
import 'NavigationDrawer/NaviDrawerUI.dart';
import 'Profile/AlertPlus/AlertPlusType.dart';

Widget pageNavigation(Function(String index) gotoPage, Function reply, Widget child) {
  return FittedBox(
    child: Container(
      color: Get.theme.backgroundColor,
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
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: GetBuilder<GlobalController>(
                    id: 'Notification',
                    builder: (controller) {
                      return Icon(
                        Icons.dashboard_rounded,
                        color: controller.inboxNotifications != 0 || controller.alertNotifications != 0 ? Colors.red : Get.theme.primaryColor,
                      );
                    },
                  ),
                  onPressed: () {
                    Get.bottomSheet(
                      controlCenter(),
                    );
                  },
                )),
          ],
        ),
      ),
    ),
  );
}

Widget controlCenter() {
  return SafeArea(
      child: Container(
    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(6)), color: Colors.grey.shade700),
    padding: EdgeInsets.only(left: 5, right: 5, top: 5),
    child: SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(
              'Control Center',
              style: TextStyle(fontSize: Get.theme.textTheme.headline5!.fontSize, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          GetBuilder<GlobalController>(
              id: 'Notification',
              builder: (controller) {
                return controller.isLogged == false ? login() : logged();
              }),
          whatNew(),
          GlobalController.i.isLogged == true
              ? Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  child: search(),
                )
              : Padding(
                  padding: EdgeInsets.only(top: 5),
                ),
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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                      'posts'.tr,
                      maxLines: 1,
                    ),
                    onPressed: () {
                      if (Get.isBottomSheetOpen == true) Get.back();
                      Get.toNamed(Routes.Thread, arguments: ['New posts', 'https://voz.vn/whats-new/posts/'], preventDuplicates: false);
                    }),
              ),
              Expanded(
                child: CupertinoButton(
                    //padding: EdgeInsets.zero,
                    child: Text(
                      'Profile',
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
              GlobalController.i.isLogged == true ? Expanded(
                child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Text('News feed'),
                    onPressed: () {
                      if (Get.isBottomSheetOpen == true) Get.back();
                      Get.toNamed(Routes.AlertPlus, arguments: [{'type' : AlertPlusType.NewFeed}]);
                    }),
              ) : SizedBox(),
              Expanded(
                  child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Text(AlertPlusType.LatestActivity.tr),
                      onPressed: () {
                        if (Get.isBottomSheetOpen == true) Get.back();
                        Get.toNamed(Routes.AlertPlus, arguments: [{'type' : AlertPlusType.LatestActivity}]);
                      }))
            ],
          ),
        ],
      ),
    );

Widget search() => Container(
      width: Get.width,
      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(6)), color: Get.theme.backgroundColor),
      child: customCupertinoButton(
          Alignment.center,
          EdgeInsets.zero,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_outlined,
                color: Get.theme.primaryColor,
              ),
              Text('\t${'search'.tr}')
            ],
          ),
          () => Get.toNamed(Routes.SearchPage, preventDuplicates: false)),
    );
