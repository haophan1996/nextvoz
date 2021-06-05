import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vozforums/GlobalController.dart';

///  * Global appbar
PreferredSize preferredSize(String text, double size) {
  return PreferredSize(
    preferredSize: Size.fromHeight(size),
    child: AppBar(
      title: Text(text, maxLines: 2),
    ),
  );
}

/// * [header11] - [header12] black/white color depends on Dark/light mode.
/// * [header21] - [header22] grey color default.
/// * [header3] orange color default.
Widget blockItem(BuildContext context, int index, String header11, String header12, String header21, String header22, String header3) {
  return Padding(
    padding: EdgeInsets.only(top: 1),
    child: Ink(
      color: Theme.of(context).dividerColor,
      width: double.infinity,
      padding: EdgeInsets.only(left: 10, top: 4, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RichText(
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
            style: TextStyle(color: Colors.orange),
          )
        ],
      ),
    ),
  );
}



