import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_next_voz/utils/color.dart';
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
          return controller.data['loadingStatus'] == 'loading' ? loading() : alertList();
        },
      ),
    );
  }

  Widget alertList()=> ListView.builder(
      itemCount: GlobalController.i.alertList.length,
      itemBuilder: (context, index) {
        return CupertinoButton(child: Container(
          decoration: BoxDecoration(
              color: GlobalController.i.alertList.elementAt(index)['unread'] == 'true' ? Get.theme.canvasColor : Colors.transparent,
              border: Border(
                bottom: BorderSide(width: 0.5, color: Theme.of(context).primaryColor),
              )),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: displayAvatar(
                    35,
                    GlobalController.i.alertList.elementAt(index)['avatarColor1'],
                    GlobalController.i.alertList.elementAt(index)['avatarColor2'],
                    GlobalController.i.alertList.elementAt(index)['username'],
                    GlobalController.i.alertList.elementAt(index)['avatarLink']),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: GlobalController.i.alertList.elementAt(index)['username'],
                          style: TextStyle(
                              fontFamily: 'BeVietNam', fontSize: Theme.of(context).textTheme.bodyText1!.fontSize, color: Colors.blue)),
                      TextSpan(
                          text: GlobalController.i.alertList.elementAt(index)['phase1'],
                          style: TextStyle(fontFamily: 'BeVietNam', fontSize: Theme.of(context).textTheme.bodyText1!.fontSize)),
                      TextSpan(
                          text: GlobalController.i.alertList.elementAt(index)['title2'],
                          style: TextStyle(
                              fontFamily: 'BeVietNam', fontSize: Theme.of(context).textTheme.bodyText1!.fontSize, color: Colors.blue)),
                      TextSpan(
                          text: GlobalController.i.alertList.elementAt(index)['phase'],
                          style: TextStyle(
                              fontFamily: 'BeVietNam', fontSize: Theme.of(context).textTheme.bodyText1!.fontSize)),
                      GlobalController.i.alertList.elementAt(index)['prefixTitle'] != ''
                          ? WidgetSpan(
                        child: Container(
                          padding: EdgeInsets.only(left: 2, right: 2),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(6)),
                              color: mapColor[GlobalController.i.alertList.elementAt(index)['prefixTitle']]),
                          child: Text(
                            GlobalController.i.alertList.elementAt(index)['prefixTitle'],
                            style: TextStyle(
                                fontFamily: 'BeVietNam',
                                fontSize: Theme.of(context).textTheme.bodyText1!.fontSize,
                                color: getColorInvert(GlobalController.i.alertList.elementAt(index)['prefixTitle'])),
                          ),
                        ),
                      )
                          : TextSpan(),
                      TextSpan(
                          text: GlobalController.i.alertList.elementAt(index)['title'],
                          style: TextStyle(
                              fontFamily: 'BeVietNam', fontSize: Theme.of(context).textTheme.bodyText1!.fontSize, color: Colors.blue)),
                      TextSpan(
                          text: GlobalController.i.alertList.elementAt(index)['phase2'],
                          style: TextStyle(fontSize: Theme.of(context).textTheme.bodyText1!.fontSize, fontFamily: 'BeVietNam')),
                      GlobalController.i.alertList.elementAt(index)['hasReact'] == true
                          ? WidgetSpan(
                          child: Image.asset(
                            'assets/reaction/${GlobalController.i.alertList.elementAt(0)['react']}',
                            width: Theme.of(context).textTheme.headline6!.fontSize,
                          ))
                          : TextSpan(),
                      TextSpan(
                          text: GlobalController.i.alertList.elementAt(index)['time'].toString(), style: TextStyle(fontFamily: 'BeVietNam')),
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ), onPressed: (){
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
              GlobalController.i.alertList.elementAt(index)['title'],
              GlobalController.i.alertList.elementAt(index)['link'],
              GlobalController.i.alertList.elementAt(index)['prefixTitle'],
              GlobalController.i.alertList.elementAt(index)['link'].toString().contains('conversations/messages') ? 1 : 0
            ]);
          }
        }, padding: EdgeInsets.zero,);
      });

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
}
