import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_skeleton/loader_skeleton.dart';
import 'package:vozforums/GlobalController.dart';
import 'package:vozforums/Page/Alert_Inbox/InboxController.dart';
import 'package:vozforums/Page/View/ViewController.dart';
import '../reuseWidget.dart';

class InboxUI extends GetView<InboxController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarOnly('Inbox',
          [IconButton(icon: Icon(Icons.refresh), onPressed: () async => await refresh()), IconButton(icon: Icon(Icons.open_in_new), onPressed: () async => {})]),
      body: Container(
        color: Get.theme.backgroundColor,
        child: GetBuilder<GlobalController>(
          builder: (globalController) {
            return globalController.inboxList.length != 0
                ? ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: globalController.inboxList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        decoration: BoxDecoration(
                            border: Border(
                          bottom: BorderSide(width: 0.5, color: Theme.of(context).primaryColor),
                        )),
                        child: itemList(globalController, index),
                      );
                    },
                  )
                : loadingShimmer();
          },
        ),
      ),
    );
  }

  Widget itemList(GlobalController globalController, int index) {
    return Container(
      color: globalController.inboxList.elementAt(index)['isUnread'] == 'true' ? Get.theme.canvasColor : Colors.transparent,
      child: CupertinoButton(
        padding: EdgeInsets.only(bottom: 10, top: 10, left: 5, right: 5),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 5),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    color: Color(
                      int.parse(globalController.inboxList.elementAt(index)['avatarColor1']),
                    ),
                    shape: BoxShape.circle),
                child: globalController.inboxList.elementAt(index)['avatarLink'] == 'no'
                    ? Center(
                  child: Text(
                    globalController.inboxList.elementAt(index)['conservationWith'].toString().toUpperCase()[0],
                    style: TextStyle(
                        color: Color(int.parse(globalController.inboxList.elementAt(index)['avatarColor2'])),
                        fontWeight: FontWeight.bold,
                        fontSize: Get.theme.textTheme.headline5!.fontSize
                    ),
                  ),
                )
                    : ExtendedImage.network(
                  globalController.inboxList.elementAt(index)['avatarLink'],
                  shape: BoxShape.circle,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: globalController.inboxList.elementAt(index)['title'] + ' \u2022 ', style: TextStyle(color: Colors.blue)),
                  TextSpan(text: globalController.inboxList.elementAt(index)['latestRep'] + ' \u2022 ', style: TextStyle(color: Colors.redAccent)),
                  TextSpan(text: globalController.inboxList.elementAt(index)['latestDay'] + '\n', style: TextStyle(color: Colors.grey.shade600)),
                  TextSpan(text: globalController.inboxList.elementAt(index)['conservationWith'] + '\n', style: TextStyle(color: Colors.grey.shade600)),
                  TextSpan(text: globalController.inboxList.elementAt(index)['repAndParty'], style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            ),
          ],
        ),
        onPressed: () {
          if (globalController.inboxList.elementAt(index)['isUnread'] == 'true'){
            globalController.inboxList.elementAt(index)['isUnread'] = 'false';
            globalController.update();
          }
          GlobalController.i.sessionTag.add(globalController.inboxList.elementAt(index)['title']+DateTime.now().toString());
          Get.lazyPut<ViewController>(() => ViewController(), tag: GlobalController.i.sessionTag.last);
          Get.toNamed("/ViewPage", arguments: [
            globalController.inboxList.elementAt(index)['title'],
            globalController.inboxList.elementAt(index)['linkInbox'],
            '',
            1
          ]);
        },
      ),
    );
  }

  refresh() async {
    GlobalController.i.inboxList.clear();
    await GlobalController.i.getInboxAlert();
  }
}
