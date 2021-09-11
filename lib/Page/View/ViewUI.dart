import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_next_voz/Page/View/swipe.dart';
import 'package:the_next_voz/Routes/pages.dart';
import '/Page/NavigationDrawer/NaviDrawerUI.dart';
import '/Page/pageNavigation.dart';
import '/Page/reuseWidget.dart';
import '/Page/View/ViewController.dart';
import '/GlobalController.dart';
// import 'package:swipe_to_action/swipe_to_action.dart';

class ViewUI extends GetView<ViewController> {
  final tagI = GlobalController.i.sessionTag.last;

  @override
  // TODO: implement tag
  String? get tag => tagI;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: NaviDrawerUI(),
      endDrawerEnableOpenDragGesture: true,
      appBar: preferredSize(context, controller.data['subHeader'], controller.data['subTypeHeader']),
      backgroundColor: Theme.of(context).backgroundColor,
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
                controller.data['isScroll'] != 'Release' &&
                Get.currentRoute == Routes.View) {
              ///User overScroll and release finger
              controller.data['isScroll'] = 'Release';
              if (controller.data['currentPage'] + 1 > controller.data['totalPage']) {
                HapticFeedback.lightImpact();
              } else {
                controller.update(['lastItemList']);
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
        child: GetBuilder<ViewController>(
          id: 'firstLoading',
          tag: tag,
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
        tag: tag,
        builder: (controller) {
          return LinearProgressIndicator(
            value: controller.data['percentDownload'],
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0CF301)),
            backgroundColor: Colors.transparent,
          );
        });
  }

  Widget loadSuccess() {
    return Stack(children: [
      GlobalController.i.userStorage.read('switchSwipeLeftRight') ?? false == true ? enableSwipe() : postContent(),
      loading(),
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
        },
            () => controller.reply('', false),
            GetBuilder<ViewController>(
              tag: tag,
              builder: (controller) {
                return Text('${controller.data['currentPage'].toString()} of ${controller.data['totalPage'].toString()}');
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
    return GetBuilder<ViewController>(
      tag: tag,
      builder: (controller) {
        return ListView.builder(
          cacheExtent: 999999999,
          physics: BouncingScrollPhysics(),
          clipBehavior: Clip.none,
          controller: controller.listViewScrollController,
          itemCount: controller.htmlData.length + 1,
          itemBuilder: (context, index) {
            return controller.htmlData.length == index
                ? GetBuilder<ViewController>(
                    id: 'lastItemList',
                    tag: tag,
                    builder: (controller) {
                      return loadingBottom(controller.data['isScroll'], 70);
                    })
                : viewContent(index, controller);
          },
        );
      },
    );
  }

  Widget enableSwipe() {
    return Swipeable(
      background: Container(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Icon(Icons.keyboard_arrow_left),
            GetBuilder<ViewController>(tag: tag, builder: (controller) => Text((controller.data['currentPage'] - 1).toString()))
          ],
        ),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GetBuilder<ViewController>(tag: tag, builder: (controller) => Text((controller.data['currentPage'] + 1).toString())),
            Icon(Icons.keyboard_arrow_right)
          ],
        ),
      ),
      key: ValueKey(''),
      child: postContent(),
      onSwipe: (SwipeDirection direction, double dragExtend) {
        if (controller.data['isScroll'] != 'Release') {
          if (direction == SwipeDirection.startToEnd) {
            if (controller.data['currentPage'] - 1 == 0) {
              HapticFeedback.lightImpact();
            } else {
              controller.data['isScroll'] = 'Release';
              controller.setPageOnClick(controller.data['currentPage'] - 1);
            }
          } else {
            if (controller.data['currentPage'] + 1 > controller.data['totalPage']) {
              HapticFeedback.lightImpact();
            } else {
              controller.data['isScroll'] = 'Release';
              controller.setPageOnClick(controller.data['currentPage'] + 1);
            }
          }
        }
      },
    );
  }
}
