import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class PageHelp {
  pageNavigation(BuildContext context, ItemScrollController scrollController, ItemPositionsListener scrollListener, List pageList, int currentPage,
      Function(String item) onCall) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.all(7),
        child: Container(
          decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.all(Radius.circular(6))),
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
                  itemPositionsListener: scrollListener,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: pageList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: index == pageList.length-1 ? 100 : 5, left: index == 0 ? 100 : 0),
                      child: InkWell(
                        onTap: () {
                          if (index+1 != currentPage){
                            Get.defaultDialog(content: CircularProgressIndicator(), barrierDismissible: false, title: "Loading...");
                            onCall(pageList[index]);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.only(right: 2, left: 2),
                          constraints: BoxConstraints(minWidth: 26, minHeight: 30),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1), shape: BoxShape.rectangle, borderRadius: BorderRadius.all(Radius.circular(5))),
                          alignment: Alignment.center,
                          child: Text(
                            pageList[index],
                            style: TextStyle(fontSize: 18, color: int.parse(pageList[index]) == currentPage ? Colors.red : Colors.black
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
}
