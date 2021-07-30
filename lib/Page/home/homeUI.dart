import 'dart:ui';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/Page/NavigationDrawer/NaviDrawerUI.dart';
import '/Page/home/homeController.dart';
import '/Page/pageNavigation.dart';
import '/Page/reuseWidget.dart';
import '/GlobalController.dart';

class HomePageUI extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: NaviDrawerUI(),
      endDrawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.2,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: preferredSize(context, "theNEXTvoz", ''),
      body: GetBuilder<HomeController>(builder: (controller) {
        return controller.loadingStatus == 'loading'
            ? loadingShimmer()
            : controller.loadingStatus == 'loadFailed'
                ? loadFailed()
                : loadSucceeded(context);
      }),
    );
  }

  Widget loadFailed() {
    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(text: 'Page could not be loaded\n', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16)),
              TextSpan(
                  text:
                      'The requested page could not be loaded\n \u2022 Check your internet connection and try again\n \u2022 Certain browser extensions, such as ad blockers, may block pages unexpectedly. Disable these and try again\n \u2022 VOZ may be temporarily unavailable. Please check back later.',
                  style: TextStyle(color: Get.theme.primaryColor, fontSize: 16)),
            ],
          ),
        ),
        customCupertinoButton(
            Alignment.center,
            EdgeInsets.fromLTRB(10, 0, 10, 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh_outlined),
                Text('\t\tRefresh '),
                Text(
                  '\u{1F611} ',
                  style: TextStyle(fontSize: Get.textTheme.headline5!.fontSize),
                ),
              ],
            ),
            () async => controller.onRefresh())
      ],
    );
  }

  Widget loadSucceeded(BuildContext context) {
    return slidingUp(
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

            GetBuilder<GlobalController>(builder: (controller){
              return controller.isLogged == false ? login() : logged();
            }),
            whatNew(),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(color: Theme.of(context).backgroundColor, borderRadius: BorderRadius.all(Radius.circular(6))),
                //height: MediaQuery.of(context).size.height * 0.06, //0.066,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 15),
                      child: Text(
                        'Frequently asked questions\n',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, foreground: Paint()..shader = linearGradient),
                      ),
                    ),
                    Text(
                      '1. Tại sao app bị lỗi khi vào một sô trang nhất định\nNếu bạn gặp trường hợp này,'
                          ' hay report cho lập trinh viên biết bạn đang gặp lỗi ở trang nào và sẻ được support nhanh nhất có thể ',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade,
                    ),
                  ],
                ),
              ),
            ),
          ],
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
