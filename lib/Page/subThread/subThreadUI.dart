import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vozforums/Page/subThread/subThreadController.dart';

class ThreadUI extends GetView<ThreadController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            controller.theme,
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Center(
          child: Obx(
            () => controller.myThreadList.length == 0
                ? CupertinoActivityIndicator()
                : ListView.builder(
                    itemCount: controller.myThreadList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        enableFeedback: true,
                        onTap: () {
                          controller.myThread();
                        },
                        child: Container(
                          //color: Colors.white,
                          width: double.infinity,
                          padding: EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: controller.myThreadList
                                          .elementAt(index)["themeTitle"],
                                      style: TextStyle(color: Colors.black, backgroundColor: controller.colors[controller.getColors(index)])),
                                  TextSpan(
                                    text: controller.myThreadList
                                        .elementAt(index)["title"],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ]),
                              ),
                              Text(
                                "Replies ${controller.myThreadList.elementAt(index)['replies']} \u2022 ${controller.myThreadList.elementAt(index)['date']}",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                              Text(
                                controller.myThreadList
                                    .elementAt(index)['authorName'],
                                style: TextStyle(color: Colors.orange),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
          ),
        ));
  }
}
