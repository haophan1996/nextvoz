import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

Widget pageNavigation(BuildContext context, ItemScrollController scrollController, int currentPage, int totalPage, Function(String item) onCall) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: Padding(
      padding: EdgeInsets.all(7),
      child: Container(
        decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.all(Radius.circular(6))),
        height: MediaQuery.of(context).size.height * 0.05,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 30,
              width: MediaQuery.of(context).size.width * 0.52,
              child: ScrollablePositionedList.builder(
                itemScrollController: scrollController,
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: totalPage,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: index == totalPage - 1 ? 100 : 5, left: index == 0 ? 100 : 0),
                    child: InkWell(
                      onTap: () {
                        if (index + 1 != currentPage) {
                          Get.defaultDialog(content: CircularProgressIndicator(), barrierDismissible: false, title: "Loading...");
                          onCall((index + 1).toString());
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(right: 2, left: 2),
                        constraints: BoxConstraints(minWidth: 26, minHeight: 30),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.lightBlueAccent),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        alignment: Alignment.center,
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(fontSize: 18, color: (index + 1) == currentPage ? Colors.pink : Theme.of(context).primaryColor
                              //controller.currentPage.value-1 == index ? Colors.red : Colors.black
                              ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
