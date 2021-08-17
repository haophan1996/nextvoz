import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:theNEXTvoz/GlobalController.dart';
import 'package:theNEXTvoz/Page/Profile/AlertPlus/AlertPlusController.dart';
import '../../reuseWidget.dart';

class AlertPlusUI extends GetView<AlertPlusController> {
  @override
  // TODO: implement tag
  String? get tag => GlobalController.i.sessionTag.last;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarOnly(controller.data['userName'].toString() + controller.data['type'].toString().tr, []),
      backgroundColor: Theme.of(context).backgroundColor,
      body: NotificationListener(
        onNotification: (Notification notification) {
          if (notification is ScrollUpdateNotification && controller.data['isScroll'] != 'Release') {
            if (((notification).metrics.pixels > (notification).metrics.maxScrollExtent + GlobalController.i.overScroll) &&
                (notification).dragDetails != null &&
                controller.data['isScroll'] != 'Holding') {
              ///detect user overScroll
              controller.data['isScroll'] = "Holding";
              controller.update(['lastItemList']);
            } else if (((notification).metrics.pixels > (notification).metrics.maxScrollExtent + GlobalController.i.overScroll) &&
                (notification).dragDetails == null &&
                controller.data['isScroll'] != 'Release') {
              ///User overScroll and release finger
              controller.data['isScroll'] = 'Release';
              controller.update(['lastItemList']);
              controller.performType();
            }
          }
          if (notification is ScrollEndNotification && controller.data['isScroll'] != 'idle') {
            if (controller.data['isScroll'] != 'Release') {
              ///return to idle
              controller.data['isScroll'] = 'idle';
              controller.update(['lastItemList']);
            }
          }
          return false;
        },
        child: GetBuilder<AlertPlusController>(
          tag: tag,
          id: 'firstLoading',
          builder: (controller) {
            return controller.data['loading'] == 'firstLoading' ? loading() : loadingSuccess();
          },
        ),
      ),
    );
  }

  Widget loading() {
    return GetBuilder<AlertPlusController>(
        id: 'download',
        tag: tag,
        builder: (controller) {
          return LinearProgressIndicator(
            value: controller.data['percentDownload'],
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0CF301)),
            backgroundColor: Colors.transparent,
          );
        });
  }

  Widget loadingSuccess() => Stack(
        children: [
          GetBuilder<AlertPlusController>(
              tag: tag,
              id: 'listview',
              builder: (controller) {
                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: controller.htmlData.length + 1,
                  itemBuilder: (context, index) {
                    return controller.htmlData.length == index
                        ? GetBuilder<AlertPlusController>(
                            tag: tag,
                            id: 'lastItemList',
                            builder: (controller) {
                              return loadingBottom(controller.data['isScroll'], 30);
                            })
                        : itemView(
                            controller.htmlData.elementAt(index)['username'],
                            controller.htmlData.elementAt(index)['action'],
                            controller.htmlData.elementAt(index)['userNamePost'],
                            controller.htmlData.elementAt(index)['inThread'],
                            controller.htmlData.elementAt(index)['thread'],
                            controller.htmlData.elementAt(index)['reaction'],
                            controller.htmlData.elementAt(index)['content'],
                            controller.htmlData.elementAt(index)['time'],
                            controller.htmlData.elementAt(index)['firstIndex'],
                            controller.htmlData.elementAt(index)['link'],
                            index);
                  },
                );
              }),
          loading(),
        ],
      );

  Widget itemView(String userName, String action, String userNamePost, String inThread, String thread, String reaction, String content, String time,
      bool dataIndex, String link, int index) {
    return Padding(
      padding: EdgeInsets.only(left: 5, right: 5, bottom: 5, top: dataIndex == true ? 10 : 0),
      child: CupertinoButton(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(5),
          color: dataIndex == true ? Get.theme.secondaryHeaderColor.withOpacity(0.4) : Get.theme.shadowColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              userNamePost == ''
                  ? textNoIcon(userName, action, thread, inThread, reaction)
                  : withIcon(userName, action, userNamePost, inThread, thread, reaction),
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(text: content + (content.length > 0 ? '\n' : ''), style: TextStyle(color: Get.theme.primaryColor.withOpacity(0.7))),
                    TextSpan(text: time, style: TextStyle(color: Get.theme.primaryColor, fontWeight: FontWeight.bold)),
                  ]),
                ),
              ),
            ],
          ),
          onPressed: () async {
            await controller.navigateView(link);
          }),
    );
  }

  Widget textNoIcon(String userName, String action, String thread, String inThread, String reaction) => RichText(
        text: TextSpan(children: [
          TextSpan(text: userName + ' ', style: TextStyle(color: Colors.blue)),
          TextSpan(text: action + ' ', style: TextStyle(color: Get.theme.primaryColor)),
          TextSpan(text: thread + '', style: TextStyle(color: Colors.blue)),
          TextSpan(text: inThread + ' ', style: TextStyle(color: Get.theme.primaryColor)),
          reaction == '' ? TextSpan() : iconTit(reaction),
          TextSpan(
            text: reaction == '' ? '' : reaction,
            style: TextStyle(color: reaction.contains('Ưng') ? Colors.pinkAccent : Colors.red),
          ),
        ]),
      );

  Widget withIcon(String userName, String action, String userNamePost, String inThread, String thread, String reaction) => RichText(
        text: TextSpan(children: [
          TextSpan(text: userName + ' ', style: TextStyle(color: Colors.blue)),
          TextSpan(text: action + ' ', style: TextStyle(color: Get.theme.primaryColor)),
          TextSpan(text: userNamePost + ' ', style: TextStyle(color: Colors.blue)),
          TextSpan(text: inThread + ' ', style: TextStyle(color: Get.theme.primaryColor)),
          TextSpan(text: thread + ' ', style: TextStyle(color: Colors.blue)),
          TextSpan(text: 'with ', style: TextStyle(color: Get.theme.primaryColor)),
          iconTit(reaction),
          TextSpan(
            text: reaction.contains('Ưng') ? ' Ưng' : ' Gạch',
            style: TextStyle(color: reaction.contains('Ưng') ? Colors.pinkAccent : Colors.red),
          ),
        ]),
      );

  WidgetSpan iconTit(String reaction) => WidgetSpan(
        child: Image.asset(
          'assets/reaction/' + (reaction.contains('Ưng') ? '1' : '2') + '.png',
          width: 18,
        ),
      );
}
