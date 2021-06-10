import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vozforums/GlobalController.dart';
import 'package:vozforums/Page/NavigationDrawer/NaviDrawerController.dart';
import 'package:vozforums/Page/NavigationDrawer/NaviDrawerUI.dart';
import 'package:vozforums/Page/home/homeController.dart';
import 'package:vozforums/Page/reuseWidget.dart';

class HomePageUI extends GetView<HomeController> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: NaviDrawerUI(),
        endDrawerEnableOpenDragGesture: true,
        drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.2,
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: preferredSize(context, "theNEXTvoz"),
        body: Obx(
          () => controller.myHomePage.length == 0
              ? percentBar()
              : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: false,
                  itemCount: controller.myHomePage.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        (index != 0)
                            ? (controller.myHomePage.elementAt(index - 1)["header"] != controller.myHomePage.elementAt(index)["header"]
                                ? theme(controller.myHomePage.elementAt(index)["header"], context)
                                : SizedBox.shrink())
                            : theme(controller.myHomePage.elementAt(index)["header"], context),
                        blockItem(
                          context,
                          index,
                          "",
                          controller.myHomePage.elementAt(index)["subHeader"],
                          controller.myHomePage.elementAt(index)["threads"],
                          controller.myHomePage.elementAt(index)["messages"],
                          controller.myHomePage.elementAt(index)["title"],
                          () => controller.navigateToThread(
                              controller.myHomePage.elementAt(index)["subHeader"], controller.myHomePage.elementAt(index)["linkSubHeader"]),
                        )
                      ],
                    );
                  },
                ),
        ));
  }
}

theme(String theme, BuildContext context) {
  return Container(
    color: Theme.of(context).hintColor,
    child: ListTile(
      title: Text(
        theme,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
      ),
    ),
  );
}
