import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vozforums/GlobalController.dart';
import 'package:vozforums/Page/home/homeController.dart';
import 'package:vozforums/Page/reuseWidget.dart';

class HomePageUI extends GetView<HomeController> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: preferredSize("   theNEXTvoz", GlobalController.i.heightAppbar),
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
                          (index != 0)
                              ? (controller.myHomePage.elementAt(index - 1)["header"] != controller.myHomePage.elementAt(index)["header"]
                                  ? theme(controller.myHomePage.elementAt(index)["header"])
                                  : Container())
                              : theme(controller.myHomePage.elementAt(index)["header"]),
                          InkWell(
                            focusColor: Colors.red,
                            hoverColor: Colors.red,
                            highlightColor: Colors.red,
                            splashColor: Colors.red,
                            splashFactory: InkRipple.splashFactory,
                            onTap: () {
                                      controller.navigateToThread(
                                          controller.myHomePage.elementAt(index)["subHeader"], controller.myHomePage.elementAt(index)["linkSubHeader"]);
                            },
                            child: blockItem(context, index, "", controller.myHomePage.elementAt(index)["subHeader"], "header21", "header22", "header3"),
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
