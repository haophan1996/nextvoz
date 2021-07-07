import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vozforums/GlobalController.dart';
import 'package:vozforums/Page/NavigationDrawer/NaviDrawerController.dart';
import 'package:vozforums/Page/NavigationDrawer/NaviDrawerUI.dart';
import 'package:vozforums/Page/pageLoadNext.dart';
import 'package:vozforums/Page/pageNavigation.dart';
import 'package:vozforums/Page/Thread/ThreadController.dart';
import '../reuseWidget.dart';

class ThreadUI extends GetView<ThreadController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: preferredSize(context, controller.theme, ''),
      body: slidingUp(
        controller.panelController,
        GetBuilder<ThreadController>(builder: (controller) {
          return pageNavigation(
              context,
              controller.itemScrollController,
              controller.currentPage,
              controller.totalPage,
              (index) => controller.setPageOnClick(index),
              () => {controller.setPageOnClick(controller.totalPage.toString())},
              () => controller.setPageOnClick("1"));
        }),
        Column(
          children: [
            Expanded(
              child: Container(
                color: Theme.of(context).backgroundColor,
                constraints: BoxConstraints.expand(),
              ),
            )
          ],
        ),
        GetBuilder<ThreadController>(builder: (controller) {
          return refreshIndicatorConfiguration(
            Scrollbar(
              child: SmartRefresher(
                enablePullDown: false,
                enablePullUp: true,
                onLoading: () {
                  controller.setPageOnClick((controller.currentPage + 1).toString());
                },
                controller: controller.refreshController,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  controller: controller.listViewScrollController,
                  cacheExtent: 500,
                  itemCount: controller.myThreadList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return blockItem(
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
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
