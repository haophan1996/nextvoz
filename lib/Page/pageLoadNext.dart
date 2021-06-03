import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PageLoad {
  refreshIndicatorConfiguration(Widget widget) {
    return RefreshConfiguration(
        footerTriggerDistance: -80,
        footerBuilder: () => ClassicFooter(
              loadingText: "Loading",
              loadingIcon: CupertinoActivityIndicator(),
              idleText: "Pull Up To Next Page",
              canLoadingText: "Release To Load",
              height: 75,
              outerBuilder: (child) {
                return Container(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: child,
                  ),
                );
              },
            ),
        child: widget);
  }
}
