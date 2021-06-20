import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vozforums/GlobalController.dart';
import 'package:vozforums/Page/NavigationDrawer/NaviDrawerController.dart';

///  * Global appbar
PreferredSize preferredSize(BuildContext context, String title) {
  return PreferredSize(
    preferredSize: Size.fromHeight(NaviDrawerController.i.heightAppbar),
    child: /* Obx(()=>*/ AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      leading: (ModalRoute.of(context)?.canPop ?? false) ? BackButton() : null,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.notifications,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      ],
      bottom: PreferredSize(
        child: GetBuilder<GlobalController>(
          builder: (controller) {
            return LinearProgressIndicator(
              value: controller.percentDownload,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0CF301)),
              backgroundColor: Theme.of(context).backgroundColor,
            );
          },
        ),
        // child: Obx(
        //   () => LinearProgressIndicator(
        //     value: GlobalController.i.percentDownload.value,
        //     valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0CF301)),
        //     backgroundColor: Theme.of(context).backgroundColor,
        //   ),
        // ),
        preferredSize: Size.fromHeight(4.0),
      ),
    ),
  );
}

/// * [header11] - [header12] black/white color depends on Dark/light mode.
/// * [header21] - [header22] grey color default.
/// * [header3] orange color default.
Widget blockItem(BuildContext context, int index, String header11, String header12, String header21, String header22, String header3, Function onTap,
    Function onLongPress) {
  return Padding(
    padding: EdgeInsets.only(top: 1, left: 8),
    child: InkWell(
      focusColor: Colors.red,
      hoverColor: Colors.red,
      highlightColor: Colors.red,
      splashColor: Colors.red,
      splashFactory: InkRipple.splashFactory,
      onTap: () => onTap(),
      onLongPress: () => onLongPress(),
      child: Ink(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 0.5, color: Theme.of(context).primaryColor),
          ),
        ),
        padding: EdgeInsets.only(top: 4, bottom: 5),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RichText(
                    overflow: TextOverflow.clip,
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                        text: header11,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: GlobalController.i.mapInvertColor[GlobalController.i.getColorInvert(header11)],
                            backgroundColor: GlobalController.i.mapColor[header11]),
                      ),
                      TextSpan(
                        text: header12,
                        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15, fontWeight: FontWeight.bold),
                      )
                    ]),
                  ),
                  Text(
                    "$header21 \u2022 $header22",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    header3,
                    style: TextStyle(color: Color(0xFFFD6E00)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
              flex: 1,
            ),
            Icon(
              Icons.arrow_forward_ios_outlined,
              color: Colors.grey,
              size: 18,
            )
          ],
        ),
      ),
    ),
  );
}

Widget settings(BuildContext context){
  return TextButton.icon(
    onPressed: ()=> NaviDrawerController.i.navigateToSetting(),
    icon: Icon(Icons.settings),
    label: Text(
      'Settings',
      style: TextStyle(color: Theme.of(context).primaryColor),
    ),
  );
}

Widget textDrawer(Color color, double fontSize, String text, FontWeight fontWeight) {
  return Text(text, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: color,fontWeight: fontWeight,fontSize: fontSize));
}

Widget popUpWaiting(BuildContext context, String one, String two) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      CupertinoActivityIndicator(),
      SizedBox(
        height: 20,
      ),
      DefaultTextStyle(
        style: TextStyle(color: Theme.of(context).primaryColor),
        child: AnimatedTextKit(
          repeatForever: true,
          isRepeatingAnimation: true,
          animatedTexts: [WavyAnimatedText(one), WavyAnimatedText(two)],
        ),
      ),
    ],
  );
}

setDialog(BuildContext context, String textF, String textS) {
  return Get.defaultDialog(
      barrierDismissible: false,
      radius: 6,
      backgroundColor: Theme.of(context).hintColor.withOpacity(0.8),
      content: popUpWaiting(context, textF, textS),
      title: 'Message');
}

Widget builFlagsdPreviewIcon(String path, String text) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w300,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 7.5),
          Image.asset(path, height: 30),
        ],
      ),
    );

Widget buildIcon(String path) => Image.asset(
      path,
      height: 25,
      width: 25,
    );
