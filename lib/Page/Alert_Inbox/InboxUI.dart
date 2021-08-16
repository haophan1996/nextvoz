import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/Routes/routes.dart';
import '/GlobalController.dart';
import '/Page/Alert_Inbox/InboxController.dart';
import '/Page/reuseWidget.dart';

class InboxUI extends GetView<InboxController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarOnly('Inbox', [
        IconButton(icon: Icon(Icons.refresh), onPressed: () async => await controller.refreshList()),
        IconButton(icon: Icon(Icons.open_in_new), onPressed: () async => {})
      ]),
      backgroundColor: Theme.of(context).backgroundColor,
      body: GetBuilder<InboxController>(
        builder: (_) {
          return GlobalController.i.inboxList.length != 0
              ? ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: GlobalController.i.inboxList.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 0.5, color: Theme.of(context).primaryColor, style: BorderStyle.solid),
                    )),
                child: itemList(index),
              );
            },
          )
              : loading();
        },
      ),
    );
  }

  Widget loading() => Stack(
    children: [
      GetBuilder<InboxController>(
          id: 'download',
          builder: (controller) {
            return LinearProgressIndicator(
              value: controller.percentDownload,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0CF301)),
              backgroundColor: Get.theme.backgroundColor,
            );
          }),
    ],
  );

  Widget itemList(int index) {
    return Container(
      color: GlobalController.i.inboxList.elementAt(index)['isUnread'] == 'true' ? Get.theme.canvasColor : Colors.transparent,
      child: CupertinoButton(
        padding: EdgeInsets.only(bottom: 10, top: 10, left: 5, right: 5),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 5),
              child: displayAvatar(
                  50,
                  GlobalController.i.inboxList.elementAt(index)['avatarColor1'],
                  GlobalController.i.inboxList.elementAt(index)['avatarColor2'],
                  GlobalController.i.inboxList.elementAt(index)['conservationWith'],
                  GlobalController.i.inboxList.elementAt(index)['avatarLink']),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: GlobalController.i.inboxList.elementAt(index)['title'] + ' \u2022 ', style: TextStyle(color: Colors.blue)),
                  TextSpan(text: GlobalController.i.inboxList.elementAt(index)['latestRep'] + ' \u2022 ', style: TextStyle(color: Colors.redAccent)),
                  TextSpan(text: GlobalController.i.inboxList.elementAt(index)['latestDay'] + '\n', style: TextStyle(color: Colors.grey.shade600)),
                  TextSpan(
                      text: GlobalController.i.inboxList.elementAt(index)['conservationWith'] + '\n', style: TextStyle(color: Colors.grey.shade600)),
                  TextSpan(text: GlobalController.i.inboxList.elementAt(index)['repAndParty'], style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            ),
          ],
        ),
        onPressed: () {
          if (GlobalController.i.inboxList.elementAt(index)['isUnread'] == 'true') {
            GlobalController.i.inboxList.elementAt(index)['isUnread'] = 'false';
            GlobalController.i.update();
          }
          Get.toNamed(Routes.View,
              arguments: [GlobalController.i.inboxList.elementAt(index)['title'], GlobalController.i.inboxList.elementAt(index)['linkInbox'], '', 1]);
        },
      ),
    );
  }
}
