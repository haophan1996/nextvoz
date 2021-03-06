import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_next_voz/Page/View/swipe.dart';
import 'package:the_next_voz/Routes/pages.dart';
import '../ScrollToHideWidget.dart';
import '../SliverPersistent.dart';
import '../pageNavigation.dart';
import '/Page/NavigationDrawer/NaviDrawerUI.dart';
import '/Page/reuseWidget.dart';
import '/Page/View/ViewController.dart';
import '/GlobalController.dart';

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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: NotificationListener(
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
                  controller.setPageOnClick(controller.data['currentPage'] + 1, true);
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
          child: GlobalController.i.userStorage.read('switchSwipeLeftRight') ?? false == true ? enableSwipe() : mainBody(),
        ),
      ),
      bottomNavigationBar: ScrollToHideWidget(
          controller: controller.listViewScrollController,
          child: BottomAppBar(
            color: Theme.of(context).backgroundColor,
            child: Padding(
              padding: EdgeInsets.only(top: GetPlatform.isAndroid ? 0 : 5),
              child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Expanded(
                    child: customCupertinoButton(
                        Alignment.center,
                        EdgeInsets.zero,
                        Icon(
                          Icons.textsms_outlined,
                          color: Theme.of(context).primaryColor,
                          size: GlobalController.i.userStorage.read('sizeIconBottomBar') ?? 30.0,
                        ),
                        () => controller.reply('', false))),
                Expanded(
                    child: Container(
                  height: 50,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => controller.navigatePage('P'),
                      onLongPress: () => controller.navigatePage('F'),
                      child: Icon(Icons.arrow_back_ios_outlined, size: GlobalController.i.userStorage.read('sizeIconBottomBar') ?? 30.0),
                    ),
                  ),
                )),
                Expanded(
                    child: customCupertinoButton(
                        Alignment.center,
                        EdgeInsets.zero,
                        GetBuilder<ViewController>(
                            tag: tag,
                            id: 'updatePageNum',
                            builder: (controller) {
                              return Text('${controller.data['currentPage'] ?? ''} / ${controller.data['totalPage'] ?? ''}',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: Get.theme.textTheme.bodyText2!.fontSize));
                            }), () {
                  setNavigateToPageOnInput((value) {
                    setDialog();
                    controller.setPageOnClick(value, true);
                  });
                })),
                Expanded(
                    child: Container(
                  height: 50,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => controller.navigatePage('N'),
                      onLongPress: () => controller.navigatePage('L'),
                      child: Icon(Icons.arrow_forward_ios_rounded, size: GlobalController.i.userStorage.read('sizeIconBottomBar') ?? 30.0),
                    ),
                  ),
                )),
                Expanded(
                    child: customCupertinoButton(
                        Alignment.center,
                        EdgeInsets.zero,
                        GetBuilder<GlobalController>(
                          id: 'Notification',
                          builder: (controller) {
                            return Icon(
                              Icons.dashboard_rounded,
                              size: GlobalController.i.userStorage.read('sizeIconBottomBar') ?? 30.0,
                              color: controller.inboxNotifications != 0 || controller.alertNotifications != 0 ? Colors.red : Get.theme.primaryColor,
                            );
                          },
                        ),
                        () => Get.bottomSheet(
                              controlCenter(),
                            ))),
              ]),
            ),
          )),
    );
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

  // SliverList customSliverList() {
  //   return SliverList(
  //       delegate: SliverChildListDelegate(List.generate(controller.htmlData.length + 1, (index) {
  //     return controller.htmlData.length == index
  //         ? GetBuilder<ViewController>(
  //             id: 'lastItemList',
  //             tag: tag,
  //             builder: (controller) {
  //               return loadingBottom(controller.data['isScroll'], 70);
  //             })
  //         : viewContent(index, controller);
  //   })));
  // }

  SliverList customSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (context, index) => controller.htmlData.length == index
              ? GetBuilder<ViewController>(
                  id: 'lastItemList',
                  tag: tag,
                  builder: (controller) {
                    return loadingBottom(controller.data['isScroll'], 70);
                  })
              : viewContent(index, controller),
          childCount: controller.htmlData.length + 1),
    );
  }

  Widget mainBody() {
    return CustomScrollView(
      cacheExtent: 999999999,
      controller: controller.listViewScrollController,
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          leading: BackButton(),
          automaticallyImplyLeading: true,
          title: Text(
            controller.data['subTypeHeader'] + controller.data['subHeader'],
            style: TextStyle(fontSize: Get.theme.textTheme.bodyText2!.fontSize, color: Get.theme.primaryColor,fontWeight: FontWeight.bold),
          ),
          floating: false,
          actions: [IconButton(onPressed: () async => await controller.onRefresh(), icon: Icon(Icons.refresh))],
        ),
        SliverPersistentHeader(
          delegate: SectionHeaderDelegate(
              "Section B",
              tagI,
              GetBuilder<ViewController>(
                  id: 'download',
                  tag: tag,
                  builder: (controller) {
                    return LinearProgressIndicator(
                      value: controller.data['percentDownload'],
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0CF301)),
                      backgroundColor: Colors.transparent,
                    );
                  })),
          pinned: true,
        ),
        GetBuilder<ViewController>(
          id: 'firstLoading',
          tag: tag,
          builder: (controller) {
            return controller.htmlData.length != 0
                ? GetBuilder<ViewController>(
                    tag: tag,
                    builder: (controller) {
                      return customSliverList();
                    })
                : controller.data['loading'] == 'error'
                    ? loadFailed()
                    : SliverFillRemaining();
          },
        )
      ],
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
      child: mainBody(),
      onSwipe: (SwipeDirection direction, double dragExtend) {
        if (controller.data['isScroll'] != 'Release') {
          if (direction == SwipeDirection.startToEnd) {
            if (controller.data['currentPage'] - 1 == 0) {
              HapticFeedback.lightImpact();
            } else {
              controller.data['isScroll'] = 'Release';
              controller.setPageOnClick(controller.data['currentPage'] - 1, true);
            }
          } else {
            if (controller.data['currentPage'] + 1 > controller.data['totalPage']) {
              HapticFeedback.lightImpact();
            } else {
              controller.data['isScroll'] = 'Release';
              controller.setPageOnClick(controller.data['currentPage'] + 1, true);
            }
          }
        }
      },
    );
  }
}
