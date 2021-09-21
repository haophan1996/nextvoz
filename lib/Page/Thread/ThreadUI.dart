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
  final String tagI = GlobalController.i.sessionTag.last;

  @override
  String? get tag => tagI;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: NaviDrawerUI(),
      endDrawerEnableOpenDragGesture: true,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: preferredSize(context, controller.data['theme'], ''),
      body: NotificationListener(
        onNotification: (Notification notification) {
          if (notification is ScrollUpdateNotification && controller.data['isScroll'] != 'Release') {
            if (((notification).metrics.pixels > (notification).metrics.maxScrollExtent + GlobalController.i.overScroll) &&
                (notification).dragDetails != null &&
                controller.data['isScroll'] != 'Holding') {
              ///detect user overScroll
              controller.data['isScroll'] = "Holding";
              controller.update(['lastItemList']);
            } else if (((notification).metrics.pixels > (notification).metrics.maxScrollExtent + GlobalController.i.overScroll) &&
                (notification).dragDetails == null &&
                controller.data['isScroll'] != 'Release') {
              ///User overScroll and release finger
              controller.data['isScroll'] = 'Release';
              controller.update(['lastItemList']);
              if (controller.data['currentPage'] + 1 > controller.data['totalPage']) {
                HapticFeedback.lightImpact();
              } else {
                controller.setPageOnClick(controller.data['currentPage'] + 1);
              }
            }
          }
          if (notification is ScrollEndNotification && controller.data['isScroll'] != 'idle') {
            if (controller.data['isScroll'] != 'Release' || (controller.data['currentPage'] + 1) > controller.data['totalPage']) {
              ///return to idle
              controller.data['isScroll'] = 'idle';
              controller.update(['lastItemList']);
            }
          }
          return false;
        },
        child: GetBuilder<ThreadController>(
            tag: tag,
            id: 'FirstLoading',
            builder: (controller) {
              return controller.data['loading'] == 'error'
                  ? loadFailed(
                      'The requested page could not be loaded\n \u2022 Check your internet connection and try again\n \u2022 Certain browser extensions, such as ad blockers, may block pages unexpectedly. Disable these and try again'
                      '\n \u2022 VOZ may be temporarily unavailable. Please check back later.',
                      () async => await controller.onRefresh())
                  : controller.data['loading'] == 'firstLoading'
                      ? download()
                      : loadingSuccess();
            }),
      ),
    );
  }

  Widget download() => GetBuilder<ThreadController>(
      tag: tag,
      id: 'download',
      builder: (controller) {
        return LinearProgressIndicator(
          value: controller.data['percentDownload'],
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0CF301)),
          backgroundColor: Colors.transparent,
        );
      });

  Widget loadingSuccess() => Stack(
        children: [
          GetBuilder<ThreadController>(
              tag: tag,
              builder: (controller) {
                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  controller: controller.listViewScrollController,
                  itemCount: controller.myThreadList.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    return controller.myThreadList.length == index
                        ? GetBuilder<ThreadController>(
                            tag: tag,
                            id: 'lastItemList',
                            builder: (controller) {
                              return loadingBottom(controller.data['isScroll'], 70);
                            })
                        : blockItem(
                            context,
                            controller.myThreadList.elementAt(index)['isRead'] == true ? FontWeight.bold : FontWeight.normal,
                            index,
                            index != controller.myThreadList.length-1 ? Theme.of(context).secondaryHeaderColor : Colors.transparent,
                            controller.myThreadList.elementAt(index)['sticky'] == true ? Colors.red : Color(0xfff3168b0),
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
          download(),
          Align(
            alignment: Alignment.bottomCenter,
            child: pageNavigation((String symbol) {
              if (controller.data['isScroll'] == 'Release') return;
              setDialog();
              switch (symbol) {
                case 'F':
                  controller.setPageOnClick(1);
                  break;
                case 'P':
                  controller.setPageOnClick(controller.data['currentPage'] - 1);
                  break;
                case 'N':
                  controller.setPageOnClick(controller.data['currentPage'] + 1);
                  break;
                case 'L':
                  controller.setPageOnClick(controller.data['totalPage']);
                  break;
              }
            }, () {
              if (controller.data['ableToPost'] == true && controller.data['theme'] != 'posts'.tr ){
                controller.navigateToCreatePost();
              } else {
                setDialogError('Unable to create thread or Forums did not allow to post thread');
              }
            },
                GetBuilder<ThreadController>(
                    tag: tag,
                    builder: (controller) {
                      return Text('${controller.data['currentPage'] ?? ''} of ${controller.data['totalPage'] ?? ''}');
                    })),
          )
        ],
      );
}
