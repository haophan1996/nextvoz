import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:vozforums/Page/reuseWidget.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

Widget pageNavigation(BuildContext context, ItemScrollController scrollController, int currentPage, int totalPage, Function(String item) onCall,
    Function lastPage, Function firstPage) {
  return Card(
    color: Theme.of(context).cardColor.withOpacity(0.8), //Colors.black.withOpacity(0.8),//Theme.of(context).cardColor,
    elevation: 0,
    child: Padding(
        padding: EdgeInsets.only(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.066,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                splashColor: Colors.green,
                iconSize: 25,
                icon: Icon(Icons.arrow_back_ios_rounded),
                onPressed: () {
                  setDialog(context, 'popMess'.tr, 'loading3'.tr);
                  firstPage();
                },
              ),
              SizedBox(
                width: Get.width * 0.6,
                height: 36,
                child: ScrollablePositionedList.builder(
                  itemScrollController: scrollController,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: totalPage,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(left: index == 0 ? 100 : 2, right: index == totalPage - 1 ? 120 : 0), //left: index == 0 ? 100 : 2, right: index == totalPage - 1 ? 120 : 0
                      child: InkWell(
                        onTap: () {
                          if (index + 1 != currentPage) {
                            setDialog(context, 'popMess'.tr, 'loading3'.tr);
                            onCall((index + 1).toString());
                          }
                        },
                        child: Container(
                          height: 50,
                          constraints: BoxConstraints(minWidth: 33, minHeight: 45),
                          decoration: BoxDecoration(
                              color: (index + 1) == currentPage ? Theme.of(context).primaryColor : Colors.transparent,
                              border: Border.all(width: 2, color: (index + 1) == currentPage ? Colors.red : Colors.greenAccent),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(Radius.circular(5))),
                          alignment: Alignment.center,
                          child: text(
                            (index + 1).toString(),
                            TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: (index + 1) == currentPage ? Colors.pink : Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              IconButton(
                  splashColor: Colors.green,
                  iconSize: 25,
                  icon: Icon(Icons.arrow_forward_ios_rounded),
                  onPressed: () {
                    setDialog(context, 'popMess'.tr, 'loading3'.tr);
                    lastPage();
                  }),
            ],
          ),
        )),
  );
}

Widget slidingUp(Widget collapsedWidget, Widget panelWidget, Widget bodyWidget) {
  return SlidingUpPanel(
    parallaxEnabled: true,
    parallaxOffset: .5,
    minHeight: Get.height * 0.08,
    maxHeight: Get.height * 0.8,
    backdropColor: Colors.transparent,
    color: Colors.transparent,
    collapsed: Align(alignment: Alignment.topCenter,child: collapsedWidget,),
    panel: panelWidget,
    body: bodyWidget,
  );
}
