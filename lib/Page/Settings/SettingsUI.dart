import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:get/get.dart';
import '../reuseWidget.dart';
import 'SettingsController.dart';

class SettingsUI extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: preferredSize(context, 'setPage'.tr,''),
      body: Container(
        color: Theme.of(context).backgroundColor,
        padding: EdgeInsets.only(top: 20, left: 50, right: 50),
        child: SafeArea(
          child: Column(
            children: [
              Row(
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
              ),
              Row(
                children: [
                  Text(
                    'fontSizeView'.tr,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Obx(() => Expanded(
                        child: Slider(
                            divisions: 25,
                            label: controller.fontSizeView.string,
                            value: controller.fontSizeView.value,
                            max: 40.0,
                            min: 15.0,
                            onChanged: (value) {
                              controller.fontSizeView.value = value;
                            }),
                      ))
                ],
              ),
              Row(
                children: [
                  Text(
                    'scrollToMyRepAfterPost'.tr,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Obx(()=> CupertinoSwitch(
                    value: controller.switchValuePost.value,
                    onChanged: (value) {
                      controller.switchValuePost.value = value;
                    },
                  ),)
                ],
              ),
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
}
