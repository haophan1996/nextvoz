import 'dart:ui';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vozforums/Page/NavigationDrawer/NaviDrawerUI.dart';
import 'package:vozforums/Page/home/homeController.dart';
import 'package:vozforums/Page/pageNavigation.dart';
import 'package:vozforums/Page/reuseWidget.dart';
import 'package:vozforums/GlobalController.dart';

class HomePageUI extends GetView<HomeController> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: NaviDrawerUI(),
      endDrawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.2,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: preferredSize(context, "theNEXTvoz", ''),
      body: slidingUp(
        262,
        (value) {
          controller.onSliding.value = value;
        },
        controller.panelController,
        GetBuilder<HomeController>(
          builder: (controller) {
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: Get.height * 0.21),
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
                        FontWeight.bold,
                        FontWeight.bold,
                        index,
                        "",
                        controller.myHomePage.elementAt(index)["subHeader"],
                        controller.myHomePage.elementAt(index)["threads"],
                        controller.myHomePage.elementAt(index)["messages"],
                        controller.myHomePage.elementAt(index)["title"],
                        () => controller.navigateToThread(
                            controller.myHomePage.elementAt(index)["subHeader"], controller.myHomePage.elementAt(index)["linkSubHeader"]),
                        () {})
                  ],
                );
              },
            );
          },
        ),
        Obx(
          () => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: controller.onSliding.value * 3.0, sigmaY: controller.onSliding.value * 3.0),
            child: Container(
              constraints: BoxConstraints.expand(),
              padding: EdgeInsets.only(left: 6, right: 6),
              child: Column(
                children: [GlobalController.i.isLogged.value == false ? login(context) : logged(context), whatNew(context)],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

theme(String theme, BuildContext context) {
  return Container(
    color: Theme.of(context).canvasColor,
    child: ListTile(
      title: Text(
        theme,
        style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w900),
      ),
    ),
  );
}
