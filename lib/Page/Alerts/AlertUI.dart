import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/GlobalController.dart';
import '/Page/Profile/UserProfile/UserProfileController.dart';
import '/Page/View/ViewController.dart';
import '/Page/reuseWidget.dart';
import '/Page/Alerts/AlertsController.dart';

class AlertsUI extends GetView<AlertsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarOnly('Alerts', [IconButton(icon: Icon(Icons.refresh), onPressed: () async => controller.refreshList())]),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(7)),
          color: Theme.of(context).backgroundColor.withOpacity(0.9),
        ),
        child: GetBuilder<GlobalController>(
          builder: (globalController) {
            return globalController.alertList.length != 0
                ? ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: globalController.alertList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        decoration: BoxDecoration(
                            color: globalController.alertList.elementAt(index)['unread'] == 'true' ? Get.theme.canvasColor : Colors.transparent,
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
    return CupertinoButton(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: globalController.alertList.elementAt(index)['username'], style: TextStyle(color: Colors.blue)),
            TextSpan(text: globalController.alertList.elementAt(index)['status'], style: TextStyle(color: Get.theme.primaryColor)),
            //TextSpan(text: globalController.alertList.elementAt(index)['threadName'], style: TextStyle(color: Colors.blue)),
            customTitleChild(FontWeight.normal, Colors.blue, globalController.alertList.elementAt(index)['prefix'],
                globalController.alertList.elementAt(index)['threadName']),
            globalController.alertList.elementAt(index)['reaction'] == ''
                ? TextSpan()
                : TextSpan(
                    text: 'with ${globalController.alertList.elementAt(index)['reaction'] == '1' ? 'Ưng ' : 'Gạch '}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: globalController.alertList.elementAt(index)['reaction'] == '1' ? Colors.pinkAccent : Colors.red)),
            globalController.alertList.elementAt(index)['reaction'] == ''
                ? TextSpan()
                : WidgetSpan(
                    child: Image.asset(
                      'assets/reaction/${globalController.alertList.elementAt(index)['reaction']}.png',
                      width: 18,
                    ),
                  ),
            TextSpan(text: '\n' + globalController.alertList.elementAt(index)['time'], style: TextStyle(color: Get.theme.secondaryHeaderColor))
          ],
        ),
      ),
      onPressed: () {
        if (globalController.alertList.elementAt(index)['unread'] == 'true') {
          globalController.alertList.elementAt(index)['unread'] = 'false';
          globalController.update();
        }
        if (globalController.alertList.elementAt(index)['link'].contains('/u/', 0) == true) {
          GlobalController.i.sessionTag.add('profile${DateTime.now().toString()}');
          Get.lazyPut<UserProfileController>(() => UserProfileController(), tag: GlobalController.i.sessionTag.last);
          Get.toNamed('/UserProfile', arguments: [globalController.alertList.elementAt(index)['link']], preventDuplicates: false);
        } else if (globalController.alertList.elementAt(index)['link'].contains('/profile-posts/', 0) == true) {
          // Go to status
          print('status');
        } else {
          GlobalController.i.sessionTag.add(globalController.alertList.elementAt(index)['threadName']);
          Get.lazyPut<ViewController>(() => ViewController(), tag: GlobalController.i.sessionTag.last);
          Get.toNamed("/ViewPage", arguments: [
            globalController.alertList.elementAt(index)['threadName'],
            globalController.alertList.elementAt(index)['link'],
            globalController.alertList.elementAt(index)['prefix'],
            globalController.alertList.elementAt(index)['link'].toString().contains('conversations/messages') ? 1 : 0
          ]);
        }
      },
    );
  }
}
