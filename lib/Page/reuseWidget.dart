import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vozforums/GlobalController.dart';
import 'package:vozforums/Page/NavigationDrawer/NaviDrawerController.dart';
import 'package:get/get.dart';

///  * Global appbar
PreferredSize preferredSize(BuildContext context, String title) {
  return PreferredSize(
    preferredSize: Size.fromHeight(NaviDrawerController.i.heightAppbar),
    child: /* Obx(()=>*/ AppBar(
      automaticallyImplyLeading: false,
      title: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis,),
      leading: (ModalRoute.of(context)?.canPop ?? false) ? BackButton() : null,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.notifications,
            color: Colors.white,
          ),
          onPressed: () {

          },
        ),
      ],
    ),
  );
}

/// * [header11] - [header12] black/white color depends on Dark/light mode.
/// * [header21] - [header22] grey color default.
/// * [header3] orange color default.
Widget blockItem(BuildContext context, int index, String header11, String header12, String header21, String header22, String header3) {
  return Padding(
    padding: EdgeInsets.only(top: 1, left: 8),
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
  );
}

Widget percentBar() {
  return LinearProgressIndicator(
    minHeight: 5,
    value: GlobalController.i.percentDownload.value,
    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0CF301)),
    backgroundColor: Colors.white,
    semanticsValue: "ascsacsacsac",
    semanticsLabel: "asacascsac",
  );
}
