import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../ScrollToHideWidget.dart';
import '../SliverPersistent.dart';
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(),
      ),
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
        child: SafeArea(
          child: CustomScrollView(
            controller: controller.listViewScrollController,
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                leading: BackButton(),
                title: Text(
                  controller.data['theme'] ?? 'sa',
                  style: TextStyle(fontFamily: 'BeVietNam', color: Theme.of(context).primaryColor),
                ),
                actions: [IconButton(onPressed: () async => await controller.onRefresh(), icon: Icon(Icons.refresh))],
                floating: false,
              ),
              SliverPersistentHeader(
                delegate: SectionHeaderDelegate(
                    "Section B",
                    tagI,
                    GetBuilder<ThreadController>(
                        tag: tag,
                        id: 'download',
                        builder: (controller) {
                          return LinearProgressIndicator(
                            value: controller.data['percentDownload'],
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0CF301)),
                            backgroundColor: Colors.transparent,
                          );
                        })),
                pinned: true,
              ),
              GetBuilder<ThreadController>(
                  tag: tag,
                  id: 'FirstLoading',
                  builder: (controller) {
                    return controller.data['loading'] == 'error'
                        ? loadFailed(
                            'The requested page could not be loaded\n \u2022 Check your internet connection and try again\n \u2022 Certain browser extensions, such as ad blockers, may block pages unexpectedly. Disable these and try again'
                            '\n \u2022 VOZ may be temporarily unavailable. Please check back later.',
                            () async => await controller.onRefresh())
                        : controller.data['loading'] == 'firstLoading'
                            ? SliverFillRemaining()
                            : loadingSuccess();
                  })
            ],
          ),
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
                    Icon(Icons.textsms_outlined,
                        color: Theme.of(context).primaryColor, size: GlobalController.i.userStorage.read('sizeIconBottomBar') ?? 30.0), () {
                  if (controller.data['ableToPost'] == true && controller.data['theme'] != 'posts'.tr) {
                    controller.navigateToCreatePost();
                  } else {
                    setDialogError('Unable to create thread or Forums did not allow to post thread');
                  }
                }),
              ),
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
                ),
              ),
              Expanded(
                child: customCupertinoButton(
                    Alignment.center,
                    EdgeInsets.zero,
                    GetBuilder<ThreadController>(
                        tag: tag,
                        id: 'updatePageNum',
                        builder: (controller) {
                          return Text(
                            '${controller.data['currentPage'] ?? ''} / ${controller.data['totalPage'] ?? ''}',
                            style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: Get.theme.textTheme.bodyText2!.fontSize),
                          );
                        }),
                    () {
                      setNavigateToPageOnInput((value) {
                        setDialog();
                        controller.setPageOnClick(value);
                      });
                    }),
              ),
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
                ),
              ),
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
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
      // floatingActionButtonLocation:
      // FloatingActionButtonLocation.miniEndDocked,
      // floatingActionButton: Padding(
      //   padding: EdgeInsets.only(bottom: 50),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.end,
      //     children: [
      //       Container(
      //         child: GetBuilder<GlobalController>(
      //           id: 'alertNotification',
      //           builder: (controller){
      //             return controller.alertNotifications != 0 ? FloatingActionButton(
      //               mini: true,
      //               onPressed: (){},
      //               child: Icon(Icons.notifications_none_outlined, color: Colors.red,),
      //             ) : Text('');
      //           },
      //         ),
      //       ),
      //       Container(
      //         child: GetBuilder<GlobalController>(
      //           id: 'inboxNotification',
      //           builder: (controller){
      //             return controller.inboxNotifications != 0 ? FloatingActionButton(
      //               mini: true,
      //               onPressed: (){},
      //               child: Icon(Icons.mail_outline, color: Colors.red,),
      //             ) : Text('');
      //           },
      //         ),
      //       ),
      //     ],
      //   ),
      // )
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

  Widget loadingSuccess() => GetBuilder<ThreadController>(
      tag: tag,
      builder: (controller) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return controller.myThreadList.length == index
                  ? GetBuilder<ThreadController>(
                      tag: tag,
                      id: 'lastItemList',
                      builder: (controller) {
                        return loadingBottom(controller.data['isScroll'], 70);
                      })
                  : blockItem(
                      context,
                  controller.myThreadList.elementAt(index)['lockReply'],
                      controller.myThreadList.elementAt(index)['isRead'] == true ? FontWeight.bold : FontWeight.normal,
                      index,
                      index != controller.myThreadList.length - 1 ? Theme.of(context).secondaryHeaderColor : Colors.transparent,
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
            // Builds 1000 ListTiles
            childCount: controller.myThreadList.length + 1,
          ),
        );
      });
}
