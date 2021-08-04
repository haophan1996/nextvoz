import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

Widget refreshIndicatorConfiguration(Widget widget) {
  return Container(
    width: double.infinity,
    //padding: EdgeInsets.only(bottom: Get.height * 0.14),
    child: RefreshConfiguration(
        footerTriggerDistance: -80,
        footerBuilder: () => ClassicFooter(
          loadingText: 'loading'.tr,
          loadingIcon: CupertinoActivityIndicator(),
          idleText: 'pullUp'.tr,
          canLoadingText: 'pullRes'.tr,
          height:70,
          outerBuilder: (child) {
            return Container(
              child: Align(
                alignment: Alignment.topCenter,
                child: child,
              ),
            );
          },
        ),
        child: widget),
  );
}
