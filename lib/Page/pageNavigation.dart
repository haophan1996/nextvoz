import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:vozforums/Page/reuseWidget.dart';

Widget pageNavigation(BuildContext context, ItemScrollController scrollController, int currentPage, int totalPage, Function(String item) onCall,
    Function lastPage, Function firstPage) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: Card(
      margin: EdgeInsets.only(bottom: 0),
      color: Theme.of(context).cardColor.withOpacity(0.8), //Colors.black.withOpacity(0.8),//Theme.of(context).cardColor,
      elevation: 20,
      child: Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.066,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  splashColor: Colors.green,
                  onPressed: () async {
                  },
                  icon: Icon(
                    Icons.more_vert_rounded,
                  ),
                  iconSize: 25,
                ),
                IconButton(
                  splashColor: Colors.green,
                  iconSize: 25,
                  icon: Icon(Icons.arrow_back_ios_rounded),
                  onPressed: () {
                    setDialog(context, 'popMess'.tr, 'loading3'.tr);
                    firstPage();
                  },
                ),
                Expanded(child: Container(
                  height: 36,
                  width: MediaQuery.of(context).size.width * 0.52,
                  child: ScrollablePositionedList.builder(
                    itemScrollController: scrollController,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: totalPage,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(left: index == 0 ? 100 : 0),
                        child: InkWell(
                          onTap: () {
                            if (index + 1 != currentPage) {
                              setDialog(context, 'popMess'.tr, 'loading3'.tr);
                              onCall((index + 1).toString());
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.only(right: 2, left: 2),
                            constraints: BoxConstraints(minWidth: 33, minHeight: 35),
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
                                  color: (index + 1) == currentPage ? Colors.pink : Theme.of(context).primaryColor
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )),
                IconButton(
                    splashColor: Colors.green,
                    iconSize: 25,
                    icon: Icon(Icons.arrow_forward_ios_rounded),
                    onPressed: () {
                      setDialog(context, 'popMess'.tr, 'loading3'.tr);
                      lastPage();
                    }),
                IconButton(
                  splashColor: Colors.green,
                  icon: Icon(
                    Icons.message_outlined,
                  ),
                  onPressed: () {},
                  iconSize: 25,
                )
              ],
            ),
          )),
    ),
  );
}
