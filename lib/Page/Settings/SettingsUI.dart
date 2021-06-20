import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:get/get.dart';
import '../reuseWidget.dart';
import 'SettingsController.dart';

class SettingsUI extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: preferredSize(context, 'Settings'),
      body: Container(
        color: Theme.of(context).backgroundColor,
        padding: EdgeInsets.only(top: 20, left: 50, right: 50),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Language:    ',
                  style: TextStyle(fontSize: 20),
                ),
                Spacer(),
                FlutterReactionButton(
                  onReactionChanged: (reaction, i) async {
                    await controller.setLang(i);
                  },
                  reactions: controller.flagsReactions,
                  initialReaction: controller.flagsReactions[controller.lang],
                  boxRadius: 10,
                  boxAlignment: AlignmentDirectional.bottomEnd,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
