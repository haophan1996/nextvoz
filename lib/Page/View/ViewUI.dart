import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vozforums/Page/NavigationDrawer/NaviDrawerUI.dart';
import 'package:vozforums/Page/pageLoadNext.dart';
import 'package:vozforums/Page/pageNavigation.dart';
import 'package:vozforums/Page/reuseWidget.dart';
import 'package:vozforums/Page/View/ViewController.dart';
import '../../GlobalController.dart';

class ViewUI extends StatelessWidget with WidgetsBindingObserver {
  final controller = Get.find<ViewController>(tag: GlobalController.i.tagView.last);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: NaviDrawerUI(),
      appBar: preferredSize(context, controller.data['subHeader']),
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: GetBuilder<ViewController>(
              tag: GlobalController.i.tagView.last,
              builder: (controller) {
                return postContent(context, controller);
              },
            ),
          ),
          GetBuilder<ViewController>(
              tag: GlobalController.i.tagView.last,
              builder: (controller) {
                return pageNavigation(
                  context,
                  controller.itemScrollController,
                  controller.currentPage.value,
                  controller.totalPage.value,
                  (index) => controller.setPageOnClick(index),
                  () => controller.setPageOnClick(controller.totalPage.toString()),
                  () => controller.setPageOnClick("1"),
                );
              })
        ],
      ),
    );
  }

  postContent(BuildContext context, ViewController controller) {
    return refreshIndicatorConfiguration(
      Scrollbar(
        child: SmartRefresher(
          enablePullDown: false,
          enablePullUp: true,
          controller: controller.refreshController,
          onLoading: () {
            controller.setPageOnClick((controller.currentPage.value + 1).toString());
          },
          child: ListView.builder(
            cacheExtent: 99999,
            shrinkWrap: true,
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
