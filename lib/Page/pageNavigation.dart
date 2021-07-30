import 'package:get/get.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '/Page/reuseWidget.dart';
import '/GlobalController.dart';

Widget pageNavigation(int currentPage, int totalPage, Function(int index) gotoPage, Function reply) {
  return Stack(
    children: [
      Align(
        alignment: Alignment.topLeft,
        child: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(
            Icons.reply_outlined,
            color: Get.theme.primaryColor,
          ),
          onPressed: () {
            if (GlobalController.i.isLogged == false) {
              setDialogError('You must be logged-in to do that.');
            } else
              reply();
          },
        ),
      ),
      GetBuilder<GlobalController>(builder: (controller) {
        return Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.only(right: 5),
            child: Image.asset(
              'assets/${controller.alertNotifications != 0 || controller.inboxNotifications != 0 ? 'alerts' : 'reaction/nil'}.png',
              width: 10,
            ),
          ),
        );
      }),
      Align(alignment: Alignment.topCenter,child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          customCupertinoButton(Alignment.center, EdgeInsets.zero, Icon(Icons.arrow_back, color: Get.theme.primaryColor), () {
            gotoPage(1);
          }),
          customCupertinoButton(Alignment.center, EdgeInsets.zero, Icon(Icons.arrow_back_ios_rounded, color: Get.theme.primaryColor), () {
            gotoPage(currentPage -= 1);
          }),
          Text(
            '${currentPage.toString()} of ${totalPage.toString()}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          customCupertinoButton(Alignment.center, EdgeInsets.zero, Icon(Icons.arrow_forward_ios_rounded, color: Get.theme.primaryColor), () {
            gotoPage(currentPage += 1);
          }),
          customCupertinoButton(Alignment.center, EdgeInsets.zero, Icon(Icons.arrow_forward, color: Get.theme.primaryColor), () {
            gotoPage(totalPage);
          }),
        ],
      ),)
    ],
  );
}

Widget slidingUp(double maxHeight, PanelController panelController, Widget bodyWidget, Widget panelWidget) {
  return SlidingUpPanel(
    boxShadow: <BoxShadow>[],
    controller: panelController,
    parallaxEnabled: true,
    parallaxOffset: .5,
    minHeight: Get.height * 0.08,
    maxHeight: Get.height / 2,
    padding: EdgeInsets.only(left: 5, right: 5),
    backdropEnabled: true,
    backdropTapClosesPanel: true,
    backdropColor: Colors.grey.shade700,
    color: Colors.transparent,
    panel: panelWidget,
    //snapPoint: 0.2,
    body: bodyWidget,
  );
}

Widget whatNew(BuildContext context) => Container(
      //constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(6)), color: Theme.of(context).backgroundColor),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              'Latest',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, foreground: Paint()..shader = linearGradient),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Text(
                      'What\'s new',
                      maxLines: 1,
                    ),
                    onPressed: () {}),
              ),
              Expanded(
                child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Text(
                      'New posts',
                      maxLines: 1,
                    ),
                    onPressed: () {}),
              ),
              Expanded(
                child: CupertinoButton(
                    //padding: EdgeInsets.zero,
                    child: Text(
                      'New profile posts',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    onPressed: () {}),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: CupertinoButton(padding: EdgeInsets.zero, child: Text('Your news feed'), onPressed: () {}),
              ),
              Expanded(child: CupertinoButton(padding: EdgeInsets.zero, child: Text('Latest activity'), onPressed: () {}))
            ],
          ),
        ],
      ),
    );
