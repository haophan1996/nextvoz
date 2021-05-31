import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:get/get.dart';
import 'package:vozforums/Page/subThread/subThreadController.dart';
import '../utilities.dart';

class ThreadUI extends GetView<ThreadController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          controller.theme,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Obx(
                () => controller.myThreadList.length == 0
                    ? CupertinoActivityIndicator()
                    : ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: controller.myThreadList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            enableFeedback: true,
                            onTap: () {
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
                                            backgroundColor: UtilitiesController.i.mapColor[controller.myThreadList.elementAt(index)['themeTitle']]),
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
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Obx(
                    () => ScrollablePositionedList.builder(
                      itemScrollController: controller.itemScrollController,
                      itemPositionsListener: controller.itemPositionsListener,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.pages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: InkWell(
                              onTap: () {
                                Get.defaultDialog(content: CircularProgressIndicator(), barrierDismissible: false, title: "Loading...");
                                if (int.parse(controller.pages[index]) != controller.currentPage.value) {
                                  controller.setPageOnClick(controller.pages[index]);
                                }
                              },
                              child: Obx(
                                () => Container(
                                  padding: EdgeInsets.only(right: 2, left: 2),
                                  decoration: BoxDecoration(border: Border.all(width: 1), shape: BoxShape.rectangle),
                                  alignment: Alignment.center,
                                  child: Text(
                                    controller.pages[index],
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: int.parse(controller.pages[index]) == controller.currentPage.value ? Colors.red : Colors.black
                                        //controller.currentPage.value-1 == index ? Colors.red : Colors.black
                                        ),
                                  ),
                                ),
                              ),
                            ));
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
