import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vozforums/Page/home/homeController.dart';

class HomePageUI extends GetView<HomeController> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          "theNEXTvoz",
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
                          index == 0 ? theme(controller.myHomePage.elementAt(index)["header"]) : Container(),
                          (index != 0)
                              ? (controller.myHomePage.elementAt(index - 1)["header"] != controller.myHomePage.elementAt(index)["header"]
                                  ? theme(controller.myHomePage.elementAt(index)["header"])
                                  : Container())
                              : Container(),
                          Card(
                            color: Theme.of(context).cardColor,
                            child: Container(
                              width: double.infinity,
                              child: TextButton(
                                style: TextButton.styleFrom(alignment: Alignment.centerLeft, padding: EdgeInsets.only(left: 5)),
                                onPressed: () {
                                  controller.navigateToThread(
                                      controller.myHomePage.elementAt(index)["subHeader"], controller.myHomePage.elementAt(index)["linkSubHeader"]);
                                },
                                child: Text(
                                  controller.myHomePage.elementAt(index)["subHeader"],
                                  style: TextStyle(color: Theme.of(context).primaryColor),
                                ),
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
