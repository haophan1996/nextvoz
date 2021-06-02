import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vozforums/Page/pageLoadNext.dart';
import 'package:vozforums/Page/utilities.dart';
import 'package:vozforums/Page/pageNavigation.dart';
import 'package:vozforums/Page/subThread/subThreadController.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class ThreadUI extends GetView<ThreadController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MorphingAppBar(
        title: Text(
          controller.theme,
          style: TextStyle(color: Colors.black),
        ),
      ),
      // appBar: AppBar(
      //   iconTheme: IconThemeData(color: Colors.black),
      //   elevation: 0.0,
      //   backgroundColor: Colors.transparent,
      //   title: Text(
      //     controller.theme,
      //     style: TextStyle(color: Colors.black),
      //   ),
      // ),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Container(
              child: Obx(
                () => controller.myThreadList.length == 0
                    ? CupertinoActivityIndicator()
                    : PageLoad().refreshIndicatorConfiguration(
                        Scrollbar(
                          child: SmartRefresher(
                            enablePullDown: false,
                            enablePullUp: true,
                            onLoading: () {
                              controller.setPageOnClick((controller.currentPage.value + 1).toString());
                            },
                            controller: controller.refreshController,
                            child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                controller: controller.listViewScrollController,
                                cacheExtent: 500,
                                itemCount: controller.myThreadList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    enableFeedback: true,
                                    onTap: () {
                                      // controller.itemScrollController.scrollTo(index: 30, duration: Duration(seconds: 2), alignment: 0.735);
                                      controller.navigateToThread(
                                          controller.myThreadList.elementAt(index)['title'], controller.myThreadList.elementAt(index)['linkThread']);
                                    },
                                    child: Container(
                                      //color: Colors.white,
                                      width: double.infinity,
                                      padding: EdgeInsets.all(5),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          RichText(
                                            text: TextSpan(children: <TextSpan>[
                                              TextSpan(
                                                text: controller.myThreadList.elementAt(index)["themeTitle"],
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: UtilitiesController.i.mapInvertColor[
                                                        UtilitiesController.i.getColorInvert(controller.myThreadList.elementAt(index)['themeTitle'])],
                                                    backgroundColor:
                                                        UtilitiesController.i.mapColor[controller.myThreadList.elementAt(index)['themeTitle']]),
                                              ),
                                              TextSpan(
                                                text: controller.myThreadList.elementAt(index)["title"],
                                                style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                                              )
                                            ]),
                                          ),
                                          Text(
                                            "Replies ${controller.myThreadList.elementAt(index)['replies']} \u2022 ${controller.myThreadList.elementAt(index)['date']}",
                                            style: TextStyle(color: Colors.grey, fontSize: 12),
                                          ),
                                          Text(
                                            controller.myThreadList.elementAt(index)['authorName'],
                                            style: TextStyle(color: Colors.orange),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ),
              ),
            ),
          ),
          Obx(() => PageHelp().pageNavigation(context, controller.itemScrollController, controller.itemPositionsListener, controller.pages,
              controller.currentPage.value, (index) => controller.setPageOnClick(index)))
        ],
      ),
    );
  }
}
