import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '/Page/NavigationDrawer/NaviDrawerUI.dart';
import '/Page/pageNavigation.dart';
import '/Page/reuseWidget.dart';
import '/Page/View/ViewController.dart';
import '/GlobalController.dart';
import '../pageLoadNext.dart';

class ViewUI extends StatelessWidget {
  final controller = Get.find<ViewController>(tag: GlobalController.i.sessionTag.last);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: NaviDrawerUI(),
      endDrawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.2,
      appBar: preferredSize(context, controller.data['subHeader'], controller.data['subTypeHeader']),
      backgroundColor: Theme.of(context).backgroundColor,
      body: GetBuilder<ViewController>(
        id: 'firstLoading',
        tag: GlobalController.i.sessionTag.last,
        builder: (controller) {
          return controller.htmlData.length == 0 ? loading() : loadSuccess();
        },
      ),
    );
  }

  Widget loading() {
    return GetBuilder<ViewController>(
        id: 'download',
        tag: GlobalController.i.sessionTag.last,
        builder: (controller) {
          return LinearProgressIndicator(
            value: controller.percentDownload,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0CF301)),
            backgroundColor: Get.theme.backgroundColor,
          );
        });
  }

  Widget loadSuccess() {
    return Stack(children: [
      SafeArea(child: refreshIndicatorConfiguration(postContent())),
      loading(),
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
        },
                () => controller.currentPage == 0 ? setDialogError('Wait') : controller.reply('', false),
            GetBuilder<ViewController>(
              tag: GlobalController.i.sessionTag.last,
              builder: (controller) {
                return Text('${controller.currentPage.toString()} of ${controller.totalPage.toString()}');
              },
            )),
      )
    ]);
  }

  Widget postContent() {
    return GetBuilder<ViewController>(
      tag: GlobalController.i.sessionTag.last,
      builder: (controller) {
        return SmartRefresher(
          enablePullDown: false,
          enablePullUp: true,
          controller: controller.refreshController,
          onLoading: () {
            if (controller.currentPage + 1 > controller.totalPage) {
              HapticFeedback.lightImpact();
              controller.refreshController.loadComplete();
            } else {
              if (controller.totalPage != 0 && controller.currentPage != 0) {
                controller.setPageOnClick(controller.currentPage + 1);
              }
            }
          },
          child: ListView.builder(
            cacheExtent: 999999999,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            controller: controller.listViewScrollController,
            itemCount: controller.htmlData.length,
            itemBuilder: (context, index) {
              return viewContent(index, controller);
            },
          ),
        );
      },
    );
  }
}
