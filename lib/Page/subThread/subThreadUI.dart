import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vozforums/Page/pageLoadNext.dart';
import 'package:vozforums/Page/pageNavigation.dart';
import 'package:vozforums/Page/subThread/subThreadController.dart';

import '../../GlobalController.dart';

class ThreadUI extends GetView<ThreadController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          controller.theme,
        ),
      ),
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
                                                    color: GlobalController.i.mapInvertColor[
                                                        GlobalController.i.getColorInvert(controller.myThreadList.elementAt(index)['themeTitle'])],
                                                    backgroundColor:
                                                        GlobalController.i.mapColor[controller.myThreadList.elementAt(index)['themeTitle']]),
                                              ),
                                              TextSpan(
                                                text: controller.myThreadList.elementAt(index)["title"],
                                                style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15, fontWeight: FontWeight.bold),
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
          Obx(() => PageHelp().pageNavigation(context, controller.itemScrollController, controller.currentPage.value, controller.totalPage.value,
              (index) => controller.setPageOnClick(index)))
        ],
      ),
    );
  }
}
