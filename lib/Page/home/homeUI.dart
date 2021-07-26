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
        GetPlatform.isAndroid ? Get.height * (-0.09) : -100,
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
        Container(
          constraints: BoxConstraints.expand(),
          padding: EdgeInsets.only(left: 6, right: 6),
          child: Column(
            children: [
              Obx(
                () => GlobalController.i.isLogged.value == false ? login(context) : logged(context),
              ),
              whatNew(context),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Container(
                  width: Get.width,
                  decoration: BoxDecoration(color: Theme.of(context).backgroundColor, borderRadius: BorderRadius.all(Radius.circular(6))),
                  height: MediaQuery.of(context).size.height * 0.06, //0.066,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 15),
                        child: Text(
                          'Frequently asked questions\n',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, foreground: Paint()..shader = linearGradient),
                        ),
                      ),
                      Expanded(
                          child: Text('1. Tại sao app bị lỗi khi vào một sô trang nhất định\nNếu bạn gặp trường hợp này,'
                              ' hay report cho lập trinh viên biết bạn đang gặp lỗi ở trang nào và sẻ được support nhanh nhất có thể ', maxLines: 3,
                            textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                    ],
                  ),
                ),
              ),
            ],
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
