import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:get/get.dart';
import 'package:vozforums/GlobalController.dart';
import '../reuseWidget.dart';
import 'SettingsController.dart';

class SettingsUI extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: preferredSize(context, 'setPage'.tr),
      body: Container(
        color: Theme.of(context).backgroundColor,
        padding: EdgeInsets.only(top: 20, left: 50, right: 50),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'lang'.tr,
                  style: TextStyle(fontSize: 20),
                ),
                Spacer(),
                FlutterReactionButton(
                  onReactionChanged: (reaction, i) async {
                    await controller.setLang(i);
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
                  style: TextStyle(fontSize: 20),
                ),
                Obx(
                  () => Expanded(child: Slider(
                      divisions: 25,
                      label: controller.fontSizeView.string,
                      value: controller.fontSizeView.value,
                      max: 40.0,
                      min: 15.0,
                      onChanged: (value) {
                        controller.fontSizeView.value = value;
                      }),)
                )
              ],
            ),
            Text(
              'fontSizeViewMess'.tr,
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
