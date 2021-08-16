import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/Routes/pages.dart';
import '/GlobalController.dart';
import '/Page/reuseWidget.dart';
import '/Page/Alerts/AlertsController.dart';

class AlertsUI extends GetView<AlertsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarOnly('Alerts', [IconButton(icon: Icon(Icons.refresh), onPressed: () async => controller.refreshList())]),
      backgroundColor: Theme.of(context).backgroundColor,
      body: GetBuilder<AlertsController>(
        id: 'loadingState',
        builder: (controller) {
          return controller.data['loadingStatus'] == 'loading' ? loading() : ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: GlobalController.i.alertList.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                decoration: BoxDecoration(
                    color: GlobalController.i.alertList.elementAt(index)['unread'] == 'true' ? Get.theme.canvasColor : Colors.transparent,
                    border: Border(
                      bottom: BorderSide(width: 0.5, color: Theme.of(context).primaryColor),
                    )),
                child: itemList(index),
              );
            },
          );
        },
      ),
    );

  }
  Widget loading() => Stack(
    children: [
      GetBuilder<AlertsController>(
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
    return CupertinoButton(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: GlobalController.i.alertList.elementAt(index)['username'], style: TextStyle(color: Colors.blue)),
            TextSpan(text: GlobalController.i.alertList.elementAt(index)['status'], style: TextStyle(color: Get.theme.primaryColor)),
            customTitleChild(FontWeight.normal, Colors.blue, GlobalController.i.alertList.elementAt(index)['prefix'],
                GlobalController.i.alertList.elementAt(index)['threadName']),
            GlobalController.i.alertList.elementAt(index)['reaction'] == ''
                ? TextSpan()
                : TextSpan(
                text: 'with ${GlobalController.i.alertList.elementAt(index)['reaction'] == '1' ? 'Ưng ' : 'Gạch '}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: GlobalController.i.alertList.elementAt(index)['reaction'] == '1' ? Colors.pinkAccent : Colors.red)),
            GlobalController.i.alertList.elementAt(index)['reaction'] == ''
                ? TextSpan()
                : WidgetSpan(
              child: Image.asset(
                'assets/reaction/${GlobalController.i.alertList.elementAt(index)['reaction']}.png',
                width: 18,
              ),
            ),
            TextSpan(text: '\n' + GlobalController.i.alertList.elementAt(index)['time'], style: TextStyle(color: Get.theme.secondaryHeaderColor))
          ],
        ),
      ),
      onPressed: () {
        if (GlobalController.i.alertList.elementAt(index)['unread'] == 'true') {
          GlobalController.i.alertList.elementAt(index)['unread'] = 'false';
          controller.update(['loadingState']);
        }
        if (GlobalController.i.alertList.elementAt(index)['link'].contains('/u/', 0) == true) {
          Get.toNamed(Routes.Profile, arguments: [GlobalController.i.alertList.elementAt(index)['link']], preventDuplicates: false);
        } else if (GlobalController.i.alertList.elementAt(index)['link'].contains('/profile-posts/', 0) == true) {
          // Go to status
          print('status');
        } else {
          Get.toNamed(Routes.View, arguments: [
            GlobalController.i.alertList.elementAt(index)['threadName'],
            GlobalController.i.alertList.elementAt(index)['link'],
            GlobalController.i.alertList.elementAt(index)['prefix'],
            GlobalController.i.alertList.elementAt(index)['link'].toString().contains('conversations/messages') ? 1 : 0
          ]);
        }
      },
    );
  }

}
