import 'dart:ui';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/Page/NavigationDrawer/NaviDrawerController.dart';
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
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          'theNEXTvoz',
          style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).secondaryHeaderColor),
        ),
      ),
      body: GetBuilder<HomeController>(builder: (controller) {
        return controller.loadingStatus == 'loading'
            ? loading()
            : controller.loadingStatus == 'loadFailed'
                ? loadFailed()
                : loadSucceeded(context);
      }),
    );
  }

  Widget loading() => Stack(
        children: [
          GetBuilder<HomeController>(
              id: 'download',
              builder: (controller) {
                return LinearProgressIndicator(
                  value: controller.percentDownload,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0CF301)),
                  backgroundColor: Get.theme.backgroundColor,
                );
              }),
        ],
      );

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
    return Stack(
      children: [
        GetBuilder<HomeController>(
          builder: (controller) {
            return ListView.builder(
              padding: EdgeInsets.only(bottom: 40),
              shrinkWrap: false,
              itemCount: controller.myHomePage.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    (index != 0)
                        ? (controller.myHomePage.elementAt(index - 1)["header"] != controller.myHomePage.elementAt(index)["header"]
                            ? theme(controller.myHomePage.elementAt(index)["header"], context)
                            : SizedBox())
                        : theme(controller.myHomePage.elementAt(index)["header"], context),
                    blockItem(
                        context,
                        null,
                        FontWeight.bold,
                        index,
                        (index != controller.myHomePage.length - 1 &&
                                controller.myHomePage.elementAt(index)["header"] == controller.myHomePage.elementAt(index + 1)["header"])
                            ? Theme.of(context).secondaryHeaderColor
                            : Colors.transparent,
                        Color(0xfff3168b0),
                        "",
                        controller.myHomePage.elementAt(index)["subHeader"],
                        controller.myHomePage.elementAt(index)["threads"],
                        controller.myHomePage.elementAt(index)["messages"],
                        '',
                        () => controller.navigateToThread(
                            controller.myHomePage.elementAt(index)["subHeader"], controller.myHomePage.elementAt(index)["linkSubHeader"]), () {
                      if (Get.isSnackbarOpen == true) Get.back();

                      if (GlobalController.i.userStorage.read('defaultsPage_title') == controller.myHomePage.elementAt(index)['subHeader'] &&
                          GlobalController.i.userStorage.read('defaultsPage') == true) {
                        GlobalController.i.userStorage.write('defaultsPage', false);
                        Get.snackbar('Alert', 'Removed Defaults Page', forwardAnimationCurve: Curves.decelerate, colorText: Colors.redAccent);
                      } else {
                        GlobalController.i.userStorage.write('defaultsPage', true);
                        GlobalController.i.userStorage.write('defaultsPage_title', controller.myHomePage.elementAt(index)['subHeader']);
                        GlobalController.i.userStorage.write('defaultsPage_link', controller.myHomePage.elementAt(index)['linkSubHeader']);
                        Get.snackbar('Alert', 'Default Page: ' + controller.myHomePage.elementAt(index)['subHeader'],
                            forwardAnimationCurve: Curves.decelerate, colorText: Colors.blueAccent);
                      }
                    })
                  ],
                );
              },
            );
          },
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                  color: Get.theme.canvasColor, //Colors.black38,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: customCupertinoButton(
                Alignment.center,
                EdgeInsets.only(left: 10, right: 10),
                GetBuilder<GlobalController>(
                    id: 'Notification',
                    builder: (controller) {
                      return Text(
                        controller.isLogged == false ? 'guestUser'.tr : NaviDrawerController.i.data['nameUser'] ?? 'null',
                        style: TextStyle(
                            color: controller.alertNotifications != 0 || controller.inboxNotifications != 0 ? Colors.redAccent : Colors.blue,
                            fontFamily: 'BeVietNam'),
                      );
                    }),
                () => Get.bottomSheet(controlCenter()),
              ),
            ),
          ),
        )
      ],
    );
  }
}

theme(String theme, BuildContext context) {
  return Container(
    color: Color(0xfff3168b0),
    child: ListTile(
      title: Text(
        theme,
        style: TextStyle(
            color: Colors.grey.shade200,
            fontWeight: FontWeight.bold,
            fontFamily: 'BeVietNam',
            fontSize: Theme.of(context).textTheme.headline6!.fontSize),
      ),
    ),
  );
}
