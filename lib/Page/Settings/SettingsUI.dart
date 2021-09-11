import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import '/GlobalController.dart';
import '/Page/reuseWidget.dart';
import '/Page/Settings/SettingsController.dart';

class SettingsUI extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: preferredSize(context, 'setPage'.tr, ''),
      body: Container(
        color: Theme.of(context).backgroundColor,
        padding: EdgeInsets.only(top: 20, left: 10, right: 10),
        child: SafeArea(
          child: Column(
            children: [
              myContainer(Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'lang'.tr,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  FlutterReactionButton(
                    onReactionChanged: (reaction, i) {
                      controller.langIndex = i;
                      //await controller.setLang(i);
                    },
                    reactions: controller.flagsReactions,
                    initialReaction: controller.flagsReactions[controller.getLang()],
                    boxRadius: 10,
                    boxAlignment: AlignmentDirectional.bottomEnd,
                  ),
                ],
              )),
              Obx(() => myContainer(Row(
                    children: [
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(text: 'fontSizeView'.tr, style: TextStyle(color: Get.theme.primaryColor, fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: '\n${controller.fontSizeView.value.toInt()}'.tr,
                              style: TextStyle(
                                color: Colors.grey,
                              ))
                        ]),
                      ),
                      Expanded(
                        child: Slider(
                            divisions: 30,
                            label: controller.fontSizeView.string,
                            value: controller.fontSizeView.value,
                            max: 40.0,
                            min: 10.0,
                            onChanged: (value) {
                              controller.fontSizeView.value = value;
                            }),
                      )
                    ],
                  ))), //fontsize
              myContainer(Row(
                children: [
                  Text(
                    'scrollToMyRepAfterPost'.tr,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Obx(
                    () => CupertinoSwitch(
                      value: controller.switchValuePost.value,
                      onChanged: (value) {
                        controller.switchValuePost.value = value;
                      },
                    ),
                  )
                ],
              )), //scroll post
              myContainer(Row(
                children: [
                  Text(
                    'showImage'.tr,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Obx(
                    () => CupertinoSwitch(
                      value: controller.switchImage.value,
                      onChanged: (value) {
                        controller.switchImage.value = value;
                      },
                    ),
                  )
                ],
              )), //show images
              myContainer(Row(
                children: [
                  Text(
                    'appSignature'.tr,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Obx(
                    () => CupertinoSwitch(
                      value: controller.switchSignature.value,
                      onChanged: (value) {
                        controller.switchSignature.value = value;
                      },
                    ),
                  )
                ],
              )), //app signature
              myContainer(Row(
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(text: 'defaultsPage'.tr, style: TextStyle(color: Get.theme.primaryColor, fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: '\n${GlobalController.i.userStorage.read('defaultsPage_title') ?? 'Home'}'.tr,
                          style: TextStyle(
                            color: Colors.grey,
                          ))
                    ]),
                  ),
                  Spacer(),
                  Obx(
                    () => CupertinoSwitch(
                      value: controller.switchDefaultsPage.value,
                      onChanged: (value) {
                        controller.switchDefaultsPage.value = value;
                      },
                    ),
                  )
                ],
              )), //app signature
              myContainer(Row(
                children: [
                  Text(
                    'viewSwipeLeftRight'.tr,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  GetBuilder<SettingsController>(builder: (controller) {
                    return CupertinoSwitch(
                        value: controller.switchSwipeLeftRight,
                        onChanged: (value) {
                          controller.switchSwipeLeftRight = value;
                          controller.update();
                        });
                  })
                ],
              )), //app signature
              CupertinoButton(
                  child: Text('Save'),
                  onPressed: () {
                    controller.saveButton();
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget myContainer(Widget child) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: Container(
        child: child,
        decoration: BoxDecoration(color: Get.theme.shadowColor, borderRadius: BorderRadius.all(Radius.circular(6))),
        padding: EdgeInsets.all(5),
      ),
    );
  }
}
