import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vozforums/Page/NavigationDrawer/NaviDrawerUI.dart';
import 'package:vozforums/Page/pageNavigation.dart';
import 'package:vozforums/Page/reuseWidget.dart';
import 'package:vozforums/Page/View/ViewController.dart';
import 'package:vozforums/GlobalController.dart';

class ViewUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: NaviDrawerUI(),
      endDrawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.2,
      appBar: preferredSize(context, Get.find<ViewController>(tag: GlobalController.i.sessionTag.last).data['subHeader'],
          Get.find<ViewController>(tag: GlobalController.i.sessionTag.last).data['subTypeHeader']),
      backgroundColor: Theme.of(context).backgroundColor,
      body: slidingUp(
        GetPlatform.isAndroid ? Get.height * (0.02) : 0,
        Get.find<ViewController>(tag: GlobalController.i.sessionTag.last).panelController,
        GetBuilder<ViewController>(
          tag: GlobalController.i.sessionTag.last,
          builder: (controller) {
            return postContent(context, controller);
          },
        ),
        Container(
          padding: EdgeInsets.only(left: 6, right: 6),
          color: Colors.transparent,
          child: Column(
            children: [
              GetBuilder<ViewController>(
                  tag: GlobalController.i.sessionTag.last,
                  builder: (controller) {
                    return pageNavigation(
                      context,
                      controller.itemScrollController,
                      controller.currentPage,
                      controller.totalPage,
                      (index) => controller.setPageOnClick(index),
                      () => controller.setPageOnClick(controller.totalPage.toString()),
                      () => controller.setPageOnClick("1"), ()=> controller.reply('', false)
                    );
                  }),
              Container(
                padding: EdgeInsets.only(top: 5),
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(6)), color: Theme.of(context).backgroundColor),
                child: Column(
                  children: [
                    Container(
                      child: Text(
                        'TheNextVoz - Account',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, foreground: Paint()..shader = linearGradient),
                      ),
                    ),
                    Obx(
                          () => GlobalController.i.isLogged.value == false ? login(context) : logged(context),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Expanded(child: whatNew(context)),
            ],
          ),
        ),
      ),
    );
  }
}
