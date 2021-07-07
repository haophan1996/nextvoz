import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:vozforums/Page/pageNavigation.dart';
import 'package:vozforums/Page/reuseWidget.dart';
import 'package:vozforums/Page/View/ViewController.dart';
import 'package:vozforums/GlobalController.dart';

class ViewUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: preferredSize(context, Get.find<ViewController>(tag: GlobalController.i.tagView.last).data['subHeader'],
          Get.find<ViewController>(tag: GlobalController.i.tagView.last).data['subTypeHeader']),
      backgroundColor: Theme.of(context).backgroundColor,
      body: slidingUp(
        Get.find<ViewController>(tag: GlobalController.i.tagView.last).panelController,
        GetBuilder<ViewController>(
            tag: GlobalController.i.tagView.last,
            builder: (controller) {
              return pageNavigation(
                context,
                controller.itemScrollController,
                controller.currentPage,
                controller.totalPage,
                (index) => controller.setPageOnClick(index),
                () => controller.setPageOnClick(controller.totalPage.toString()),
                () => controller.setPageOnClick("1"),
              );
            }),
        Container(color: Colors.black,),
        GetBuilder<ViewController>(
          tag: GlobalController.i.tagView.last,
          builder: (controller) {
            return postContent(context, controller);
          },
        ),
      ),
    );
  }
}
