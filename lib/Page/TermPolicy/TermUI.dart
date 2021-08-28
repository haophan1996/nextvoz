import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import '../../GlobalController.dart';
import '/Routes/pages.dart';
import 'TermController.dart';

class TermUI extends GetView<TermController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Term'),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          Container(
            height: Get.height * 0.75,
            child: SingleChildScrollView(
              child: Html(
                data: controller.texts,
                style: {
                  "code": Style(color: Colors.blue),
                  "table": Style(backgroundColor: Get.theme.cardColor),
                  "body": Style(
                      fontSize: FontSize(GlobalController.i.userStorage.read('fontSizeView') ?? Get.textTheme.button!.fontSize),
                      padding: EdgeInsets.zero,
                      margin: EdgeInsets.only(left: 3, right: 3)),
                  "div": Style(display: Display.INLINE, margin: EdgeInsets.zero),
                  "blockquote": Style(
                      padding: EdgeInsets.all(5),
                      width: double.infinity,
                      backgroundColor: Get.theme.cardColor,
                      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 5),
                      display: Display.BLOCK)
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () async {
                    if (GetPlatform.isAndroid) {
                      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                    } else {
                      await MethodChannel('minimize_app').invokeMethod('minimize_app#minimize').catchError((error) => print("Error: $error"));
                    }
                  },
                  child: Text('Decline')),
              TextButton(
                  onPressed: () async {
                    await GlobalController.i.userStorage.write('isTermAccept', true);
                    Get.offAllNamed(Routes.Home);
                  },
                  child: Text('Accept'))
            ],
          )
        ],
      ),
    );
  }
}
