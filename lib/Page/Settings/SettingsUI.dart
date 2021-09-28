import 'package:flutter/services.dart';
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
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: preferredSize(context, 'setPage'.tr, '', []),
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.only(top: 20, left: 10, right: 10),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                myContainer(Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        'lang'.tr,
                        style: TextStyle(
                            fontFamily: 'BeVietNam', fontWeight: FontWeight.bold, fontSize: Theme.of(context).textTheme.bodyText1!.fontSize),
                      ),
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
                )), //Lang
                myContainer(Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        'darkMode'.tr,
                        style: TextStyle(
                            fontFamily: 'BeVietNam', fontWeight: FontWeight.bold, fontSize: Theme.of(context).textTheme.bodyText1!.fontSize),
                      ),
                    ),
                    Spacer(),
                    FlutterReactionButton(
                      onReactionChanged: (reaction, i) {
                        controller.darkModeIndex = i;
                      },
                      reactions: controller.darkMode,
                      initialReaction: controller.darkMode[GlobalController.i.userStorage.read('darkMode') ?? 0],
                      boxRadius: 10,
                      boxAlignment: AlignmentDirectional.bottomEnd,
                    ),
                  ],
                )), //Darkmode
                Obx(() => myContainer(Row(
                      children: [
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: 'fontSizeView'.tr,
                                style: TextStyle(
                                    fontFamily: 'BeVietNam',
                                    color: Get.theme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Theme.of(context).textTheme.bodyText1!.fontSize)),
                            TextSpan(
                                text: '\n${controller.fontSizeView.value.toInt()}'.tr,
                                style: TextStyle(color: Colors.grey, fontSize: Theme.of(context).textTheme.bodyText1!.fontSize))
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
                    ))), //fontSize
                myContainer(Row(
                  children: [
                    GetBuilder<SettingsController>(
                        id: 'updateAppSignatureName',
                        builder: (controller) {
                          return customCupertinoButton(
                              Alignment.center,
                              EdgeInsets.zero,
                              RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: 'appSignature'.tr,
                                      style: TextStyle(
                                          fontFamily: 'BeVietNam',
                                          color: Get.theme.primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: Theme.of(context).textTheme.bodyText1!.fontSize)),
                                  TextSpan(
                                      text: '\n${GlobalController.i.userStorage.read('appSignatureDevice') ?? 'Device'}'.tr,
                                      style: TextStyle(
                                        fontFamily: 'BeVietNam',
                                        color: Colors.blueAccent,
                                      ))
                                ]),
                              ), () {
                            controller.textEditingController.text = GlobalController.i.userStorage.read('appSignatureDevice');
                            Get.defaultDialog(
                                content: Column(
                              children: [
                                inputCustom(TextInputType.text, controller.textEditingController, false, 'Signature', () {}),
                                SizedBox(
                                  height: 10,
                                ),
                                Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: customCupertinoButton(Alignment.center, EdgeInsets.zero, Text(' Cancel'), () => Get.back()),
                                    ),
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: customCupertinoButton(Alignment.center, EdgeInsets.zero, Text('Reset'), () async {
                                        await controller.getDeviceName();
                                        Get.back();
                                      }),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: customCupertinoButton(
                                          Alignment.center, EdgeInsets.zero, Text('   OK'), () async => await controller.setDeviceName()),
                                    ),
                                  ],
                                )
                              ],
                            ));
                          });
                        }),
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
                    Text(
                      'showImage'.tr,
                      style: TextStyle(fontFamily: 'BeVietNam', fontWeight: FontWeight.bold, fontSize: Theme.of(context).textTheme.bodyText1!.fontSize),
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
                      'scrollToMyRepAfterPost'.tr,
                      style: TextStyle(fontFamily: 'BeVietNam', fontWeight: FontWeight.bold, fontSize: Theme.of(context).textTheme.bodyText1!.fontSize),
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
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: 'defaultsPage'.tr,
                            style: TextStyle(fontFamily: 'BeVietNam', color: Get.theme.primaryColor, fontWeight: FontWeight.bold, fontSize: Theme.of(context).textTheme.bodyText1!.fontSize)),
                        TextSpan(
                            text: '\n${GlobalController.i.userStorage.read('defaultsPage_title') ?? 'Home'}'.tr,
                            style: TextStyle(
                              color: Colors.grey, fontSize: Theme.of(context).textTheme.bodyText1!.fontSize
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
                )), //default launch page
                myContainer(Row(
                  children: [
                    Text(
                      'viewSwipeLeftRight'.tr,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: Theme.of(context).textTheme.bodyText1!.fontSize),
                    ),
                    Spacer(),
                    GetBuilder<SettingsController>(
                        id: 'updateSwitchSwipeLeftRight',
                        builder: (controller) {
                          return CupertinoSwitch(
                              value: controller.switchSwipeLeftRight,
                              onChanged: (value) {
                                controller.switchSwipeLeftRight = value;
                                controller.update(['updateSwitchSwipeLeftRight']);
                              });
                        })
                  ],
                )), //swipe right/left
                myContainer(GetBuilder<SettingsController>(
                  id: 'iconSizeBottom',
                  builder: (controller) {
                    return Row(
                      children: [
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: 'iconBottomBarSize'.tr,
                                style: TextStyle(fontFamily: 'BeVietNam', color: Get.theme.primaryColor, fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: '\n${controller.sizeIconBottomBar}'.tr,
                                style: TextStyle(
                                  fontFamily: 'BeVietNam',
                                  color: Colors.grey,
                                ))
                          ]),
                        ),
                        Expanded(
                          child: Slider(
                              label: controller.sizeIconBottomBar.toString(),
                              value: controller.sizeIconBottomBar.toDouble(),
                              max: 50.0,
                              min: 20.0,
                              onChanged: (value) {
                                controller.sizeIconBottomBar = value.toInt();
                                controller.update(['iconSizeBottom']);
                              }),
                        )
                      ],
                    );
                  },
                )),
                myContainer(GetBuilder<SettingsController>(
                  id: 'heightBottom',
                  builder: (controller) {
                    return Row(
                      children: [
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: 'heightBottom'.tr,
                                style: TextStyle(fontFamily: 'BeVietNam', color: Get.theme.primaryColor, fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: '\n${controller.heightBottomBar.round()}'.tr,
                                style: TextStyle(
                                  fontFamily: 'BeVietNam',
                                  color: Colors.grey,
                                ))
                          ]),
                        ),
                        Expanded(
                          child: Slider(
                              label: controller.heightBottomBar.toString(),
                              value: controller.heightBottomBar.toDouble(),
                              max: 30.0,
                              min: 0.0,
                              onChanged: (value) {
                                controller.heightBottomBar = value.toInt();
                                controller.update(['heightBottom']);
                              }),
                        )
                      ],
                    );
                  },
                )),
                CupertinoButton(
                    child: Text('Save'),
                    onPressed: () {
                      controller.saveButton();
                    }),
              ],
            ),
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
