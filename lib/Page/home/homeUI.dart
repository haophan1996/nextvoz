import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:vozforums/Page/home/homeController.dart';

class HomePageUI extends GetView<HomeController> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        title: Text(
          "Voz.vn",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 0),
          child: Obx(
            () => controller.myHomePage.length == 0
                ? CupertinoActivityIndicator()
                : ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: false,
                    itemCount: controller.myHomePage.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          index == 0
                              ? theme(controller.myHomePage
                                  .elementAt(index)["theme"])
                              : Container(),
                          (index != 0)
                              ? (controller.myHomePage
                                          .elementAt(index - 1)["theme"] !=
                                      controller.myHomePage
                                          .elementAt(index)["theme"]
                                  ? theme(controller.myHomePage
                                      .elementAt(index)["theme"])
                                  : Container())
                              : Container(),
                          Card(
                            child: Container(
                              width: double.infinity,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(left: 5)),
                                onPressed: () {
                                  controller.navigateToThread(controller.myHomePage.elementAt(index)["title"],controller.myHomePage.elementAt(index)["link"]);
                                },
                                child: Text(controller.myHomePage
                                    .elementAt(index)["title"]),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}

theme(String theme) {
  return Container(
    child: Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: Text(theme),
    ),
  );
}
