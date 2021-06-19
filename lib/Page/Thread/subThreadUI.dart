import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vozforums/GlobalController.dart';
import 'package:vozforums/Page/NavigationDrawer/NaviDrawerController.dart';
import 'package:vozforums/Page/NavigationDrawer/NaviDrawerUI.dart';
import 'package:vozforums/Page/pageLoadNext.dart';
import 'package:vozforums/Page/pageNavigation.dart';
import 'package:vozforums/Page/Thread/subThreadController.dart';
import '../reuseWidget.dart';

class ThreadUI extends GetView<ThreadController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: NaviDrawerUI(),
      endDrawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.2,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: preferredSize(context, controller.theme),
      body: Stack(
        children: <Widget>[
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
                          index,
                          controller.myThreadList.elementAt(index)['themeTitle'],
                          controller.myThreadList.elementAt(index)['title'],
                          controller.myThreadList.elementAt(index)['replies'],
                          controller.myThreadList.elementAt(index)['date'],
                          controller.myThreadList.elementAt(index)['authorName'],
                          () => controller.navigateToThread(
                              controller.myThreadList.elementAt(index)['title'], controller.myThreadList.elementAt(index)['linkThread']),
                          () {
                            NaviDrawerController.i.shortcuts.add({
                              'title' : controller.myThreadList.elementAt(index)['title'],
                              'link' : controller.myThreadList.elementAt(index)['linkThread']
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
          GetBuilder<ThreadController>(builder: (controller) {
            return pageNavigation(
                context,
                controller.itemScrollController,
                controller.currentPage,
                controller.totalPage,
                (index) => controller.setPageOnClick(index),
                () => {controller.setPageOnClick(controller.totalPage.toString())},
                () => controller.setPageOnClick("1"));
          })
        ],
      ),
    );
  }
}
