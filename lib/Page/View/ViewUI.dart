import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '/Page/NavigationDrawer/NaviDrawerUI.dart';
import '/Page/pageNavigation.dart';
import '/Page/reuseWidget.dart';
import '/Page/View/ViewController.dart';
import '/GlobalController.dart';
import '../pageLoadNext.dart';

class ViewUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: NaviDrawerUI(),
      endDrawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.2,
      appBar: preferredSize(context, Get.find<ViewController>(tag: GlobalController.i.sessionTag.last).data['subHeader'],
          Get.find<ViewController>(tag: GlobalController.i.sessionTag.last).data['subTypeHeader']),
      backgroundColor: Theme.of(context).backgroundColor,
      body: slidingUp(
        GetPlatform.isAndroid ? Get.height * (0.02) : 0,
        Get.find<ViewController>(tag: GlobalController.i.sessionTag.last).panelController,
        GetBuilder<ViewController>(
          tag: GlobalController.i.sessionTag.last,
          builder: (controller) {
            return postContent(context, controller);
          },
        ),
        Container(
          child: Column(
            children: [
              GetBuilder<ViewController>(
                tag: GlobalController.i.sessionTag.last,
                builder: (controller) {
                  return pageNavigation(
                    controller.currentPage,
                    controller.totalPage,
                    (index) {
                      if (index > controller.totalPage || index < 1) {
                        HapticFeedback.lightImpact();
                        if (index == 0) index = 1;
                        if (index > controller.totalPage) index -= 1;
                      }
                      if (controller.totalPage != 0 && controller.currentPage != 0) {
                        setDialog('popMess'.tr, 'loading3'.tr);
                        controller.setPageOnClick(index);
                      }
                    },
                    () => controller.reply('', false),
                  );
                },
              ),
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
                    GetBuilder<GlobalController>(builder: (controller) {
                      return controller.isLogged == false ? login(context) : logged(context);
                    }),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(child: whatNew(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget postContent(BuildContext context, ViewController controller) {
    return refreshIndicatorConfiguration(
      Scrollbar(
        controller: controller.listViewScrollController,
        child: SmartRefresher(
          enablePullDown: false,
          enablePullUp: true,
          controller: controller.refreshController,
          onLoading: () {
            if (controller.currentPage + 1 > controller.totalPage) {
              HapticFeedback.lightImpact();
            }
            if (controller.totalPage != 0 && controller.currentPage != 0) {
              controller.setPageOnClick(controller.currentPage + 1);
            }
          },
          child: ListView.builder(
            cacheExtent: 999999999999999,
            padding: EdgeInsets.only(top: 2),
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            controller: controller.listViewScrollController,
            itemCount: controller.htmlData.length,
            itemBuilder: (context, index) {
              return viewContent(context, index, controller);
            },
          ),
        ),
      ),
    );
  }
}
