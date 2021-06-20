import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:get/get.dart';


Widget refreshIndicatorConfiguration(Widget widget) {
  return RefreshConfiguration(
      footerTriggerDistance: -80,
      footerBuilder: () => ClassicFooter(
        loadingText: 'loading'.tr,
        loadingIcon: CupertinoActivityIndicator(),
        idleText: 'pullUp'.tr,
        canLoadingText: 'pullRes'.tr,
        // height: 75, android
        height: 105,
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
