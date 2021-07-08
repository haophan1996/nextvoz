import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:vozforums/Page/reuseWidget.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../GlobalController.dart';

Widget pageNavigation(BuildContext context, ItemScrollController scrollController, int currentPage, int totalPage, Function(String item) onCall,
    Function lastPage, Function firstPage, Function reply) {
  return Padding(
    padding: EdgeInsets.only(top: 1, bottom: 10),
    child: Container(
      decoration: BoxDecoration(color: Theme.of(context).backgroundColor, borderRadius: BorderRadius.all(Radius.circular(6))),
      height: MediaQuery.of(context).size.height * 0.06, //0.066,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(Icons.reply_outlined, color: Theme.of(context).primaryColor,),
              onPressed: ()=> reply(),
            ),
          ),
          GetBuilder<GlobalController>(builder: (controller) {
            return Align(
              alignment: Alignment.centerRight,
              child: Image.asset(
                'assets/${controller.alertNotifications != 0 || controller.inboxNotifications != 0 ? 'alerts' : 'reaction/nil'}.png',
                width: 10,
              ),
            );
          }),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                alignment: Alignment.center,
                splashColor: Colors.green,
                iconSize: 25,
                icon: Icon(Icons.arrow_back_ios_rounded),
                onPressed: () {
                  setDialog(context, 'popMess'.tr, 'loading3'.tr);
                  firstPage();
                },
              ),
              SizedBox(
                width: Get.width * 0.4,
                height: 36,
                child: ScrollablePositionedList.builder(
                  itemScrollController: scrollController,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: totalPage,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(left: index == 0 ? 100 : 2, right: index == totalPage - 1 ? 120 : 0),
                      //left: index == 0 ? 100 : 2, right: index == totalPage - 1 ? 120 : 0
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
                  alignment: Alignment.center,
                  splashColor: Colors.green,
                  iconSize: 25,
                  icon: Icon(Icons.arrow_forward_ios_rounded),
                  onPressed: () {
                    setDialog(context, 'popMess'.tr, 'loading3'.tr);
                    lastPage();
                  }),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget slidingUp(double maxHeight, PanelController panelController, Widget bodyWidget, Widget panelWidget) {
  RxDouble tramsSlide = 0.0.obs;
  return SlidingUpPanel(
    onPanelClosed: () {
      print('close');
    },
    onPanelOpened: () {
      print('open');
    },
    onPanelSlide: (value) {
      tramsSlide.value = value;
    },
    boxShadow: <BoxShadow>[],
    controller: panelController,
    parallaxEnabled: true,
    parallaxOffset: .5,
    minHeight: Get.height * 0.08,
    maxHeight: maxHeight,
    //Get.height * 0.5,
    backdropEnabled: true,
    backdropTapClosesPanel: true,
    //backdropColor: Colors.transparent,
    color: Colors.transparent,
    panel: panelWidget,
    body: bodyWidget,
  );
}

Widget whatNew(BuildContext context) => Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(6)), color: Theme.of(context).backgroundColor),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 15),
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
                    child: Text(
                      'What\'s new',
                      maxLines: 1,
                    ),
                    onPressed: () {}),
              ),
              Expanded(
                child: CupertinoButton(
                    child: Text(
                      'New posts',
                      maxLines: 1,
                    ),
                    onPressed: () {}),
              ),
              Expanded(
                child: CupertinoButton(
                    child: Text(
                      'New profile posts',
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
              CupertinoButton(child: Text('Your news feed'), onPressed: () {}),
              CupertinoButton(child: Text('Latest activity'), onPressed: () {})
            ],
          )
        ],
      ),
    );
