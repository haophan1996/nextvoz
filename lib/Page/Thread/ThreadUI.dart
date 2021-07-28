import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '/GlobalController.dart';
import '/Page/reuseWidget.dart';
import '/Page/pageLoadNext.dart';
import '/Page/pageNavigation.dart';
import '/Page/NavigationDrawer/NaviDrawerController.dart';
import '/Page/NavigationDrawer/NaviDrawerUI.dart';
import '/Page/Thread/ThreadController.dart';

class ThreadUI extends GetView<ThreadController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: NaviDrawerUI(),
      endDrawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.2,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: preferredSize(context, controller.theme, ''),
      body: slidingUp(
        GetPlatform.isAndroid ? Get.height * (0.02) : 0,
        controller.panelController,
        GetBuilder<ThreadController>(builder: (controller) {
          return refreshIndicatorConfiguration(
            Scrollbar(
              child: SmartRefresher(
                enablePullDown: false,
                enablePullUp: true,
                onLoading: () {
                  if (controller.currentPage+1 > controller.totalPage){
                    HapticFeedback.lightImpact();
                  }
                  if (controller.totalPage != 0 && controller.currentPage != 0) {
                    controller.setPageOnClick(controller.currentPage + 1);
                  }
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
        Container(
          padding: EdgeInsets.only(left: 6, right: 6),
          //color: Colors.blue,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GetBuilder<ThreadController>(builder: (controller) {
                return pageNavigation(controller.currentPage, controller.totalPage, (index) {
                  if (index > controller.totalPage || index < 1){
                    HapticFeedback.lightImpact();
                    if (index==0) index =1;
                    if(index>controller.totalPage) index-=1;
                  }
                  if (controller.totalPage!= 0 && controller.currentPage != 0){
                    setDialog('popMess'.tr, 'loading3'.tr);
                    controller.setPageOnClick(index);
                  }
                }, () {
                  print('reply ');
                });
              }),
              Container(
                padding: EdgeInsets.only(top: 5),
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(6)), color: Theme.of(context).backgroundColor),
                child: Column(
                  children: [
                    Container(
                      child: Text(
                        'TheNextVoz - Account',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, foreground: Paint()..shader = linearGradient),
                      ),
                    ),
                    Obx(
                      () => GlobalController.i.isLogged.value == false ? login(context) : logged(context),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(child: whatNew(context)),
              //SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }
}
