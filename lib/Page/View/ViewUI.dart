import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/Page/NavigationDrawer/NaviDrawerUI.dart';
import '/Page/pageNavigation.dart';
import '/Page/reuseWidget.dart';
import '/Page/View/ViewController.dart';
import '/GlobalController.dart';

class ViewUI extends StatelessWidget {
  final controller = Get.find<ViewController>(tag: GlobalController.i.sessionTag.last);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: NaviDrawerUI(),
      endDrawerEnableOpenDragGesture: true,
      appBar: preferredSize(context, controller.data['subHeader'], controller.data['subTypeHeader']),
      backgroundColor: Theme.of(context).backgroundColor,
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
              if (controller.currentPage + 1 > controller.totalPage) {
                HapticFeedback.lightImpact();
              } else {
                controller.update(['lastItemList']);
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
        child: GetBuilder<ViewController>(
          id: 'firstLoading',
          tag: GlobalController.i.sessionTag.last,
          builder: (controller) {
            return controller.htmlData.length != 0
                ? loadSuccess()
                : controller.data['loading'] == 'error'
                    ? loadFailed()
                    : loading();
          },
        ),
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
      postContent(),
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
            () => controller.reply('', false),
            GetBuilder<ViewController>(
              tag: GlobalController.i.sessionTag.last,
              builder: (controller) {
                return Text('${controller.currentPage.toString()} of ${controller.totalPage.toString()}');
              },
            )),
      )
    ]);
  }

  Widget loadFailed() {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
                text: 'Oops! We ran into some problems.\n', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16)),
            TextSpan(text: 'The requested thread could not be found.', style: TextStyle(color: Get.theme.primaryColor, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget postContent() {
    return CupertinoScrollbar(
        controller: controller.listViewScrollController,
        child: GetBuilder<ViewController>(
          tag: GlobalController.i.sessionTag.last,
          builder: (controller) {
            return ListView.builder(
              cacheExtent: 999999999,
              physics: BouncingScrollPhysics(),
              //scrollDirection: Axis.vertical,
              clipBehavior: Clip.none,
              controller: controller.listViewScrollController,
              itemCount: controller.htmlData.length,
              itemBuilder: (context, index) {
                return controller.htmlData.length == index + 1
                    ? GetBuilder<ViewController>(
                        id: 'lastItemList',
                        tag: GlobalController.i.sessionTag.last,
                        builder: (controller) {
                          return loadingBottom(controller.isScroll);
                        })
                    : viewContent(index, controller);
              },
            );
          },
        ));
  }
}
