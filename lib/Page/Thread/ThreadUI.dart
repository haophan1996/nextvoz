import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../pageNavigation.dart';
import '/GlobalController.dart';
import '/Page/reuseWidget.dart';
import '/Page/NavigationDrawer/NaviDrawerController.dart';
import '/Page/NavigationDrawer/NaviDrawerUI.dart';
import '/Page/Thread/ThreadController.dart';

class ThreadUI extends GetView<ThreadController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: NaviDrawerUI(),
      endDrawerEnableOpenDragGesture: true,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: preferredSize(context, controller.theme, ''),
      body: NotificationListener(
        onNotification: (Notification notification) {
          if (notification is ScrollUpdateNotification && controller.isScroll != 'Release') {
            if (((notification).metrics.pixels > (notification).metrics.maxScrollExtent + GlobalController.i.overScroll) &&
                (notification).dragDetails != null &&
                controller.isScroll != 'Holding') {
              ///detect user overScroll
              controller.isScroll = "Holding";
              controller.update(['lastItemList']);
            } else if (((notification).metrics.pixels > (notification).metrics.maxScrollExtent + GlobalController.i.overScroll) &&
                (notification).dragDetails == null &&
                controller.isScroll != 'Release') {
              ///User overScroll and release finger
              controller.isScroll = 'Release';
              controller.update(['lastItemList']);
              if (controller.currentPage + 1 > controller.totalPage) {
                HapticFeedback.lightImpact();
              } else {
                controller.setPageOnClick(controller.currentPage + 1);
              }
            }
          }
          if (notification is ScrollEndNotification && controller.isScroll != 'idle') {
            if (controller.isScroll != 'Release' || (controller.currentPage + 1) > controller.totalPage) {
              ///return to idle
              controller.isScroll = 'idle';
              controller.update(['lastItemList']);
            }
          }
          return false;
        },
        child: Stack(
          children: [
            GetBuilder<ThreadController>(builder: (controller) {
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                controller: controller.listViewScrollController,
                itemCount: controller.myThreadList.length,
                itemBuilder: (BuildContext context, int index) {
                  return controller.myThreadList.length == index + 1
                      ? GetBuilder<ThreadController>(
                          id: 'lastItemList',
                          builder: (controller) {
                            return loadingBottom(controller.isScroll);
                          })
                      : blockItem(
                          context,
                          controller.myThreadList.elementAt(index)['isRead'] == true ? FontWeight.bold : FontWeight.normal,
                          controller.myThreadList.elementAt(index)['isRead'] == true ? FontWeight.bold : FontWeight.normal,
                          index,
                          controller.myThreadList.elementAt(index)['prefix'],
                          controller.myThreadList.elementAt(index)['title'],
                          controller.myThreadList.elementAt(index)['replies'],
                          controller.myThreadList.elementAt(index)['date'],
                          controller.myThreadList.elementAt(index)['authorName'],
                          () => controller.navigateToThread(index), () {
                          NaviDrawerController.i.shortcuts.insert(0, {
                            'title': controller.myThreadList.elementAt(index)['title'],
                            'typeTitle': controller.myThreadList.elementAt(index)['prefix'],
                            'link': controller.myThreadList.elementAt(index)['link']
                          });
                          NaviDrawerController.i.update();
                          GlobalController.i.userStorage.write('shortcut', NaviDrawerController.i.shortcuts);
                        });
                },
              );
            }),
            GetBuilder<ThreadController>(
                id: 'download',
                builder: (controller) {
                  return LinearProgressIndicator(
                    value: controller.percentDownload,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0CF301)),
                    backgroundColor: Theme.of(context).backgroundColor,
                  );
                }),
            Align(
              alignment: Alignment.bottomCenter,
              child: pageNavigation((String symbol) {
                setDialog();
                switch (symbol) {
                  case 'F':
                    controller.setPageOnClick(1);
                    break;
                  case 'P':
                    controller.setPageOnClick(controller.currentPage - 1);
                    break;
                  case 'N':
                    controller.setPageOnClick(controller.currentPage + 1);
                    break;
                  case 'L':
                    controller.setPageOnClick(controller.totalPage);
                    break;
                }
              }, () {
                print('reply');
              }, GetBuilder<ThreadController>(builder: (controller) {
                return Text('${controller.currentPage.toString()} of ${controller.totalPage.toString()}');
              })),
            )
          ],
        ),
      ),
    );
  }
}
