import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rich_editor/rich_editor.dart';
import 'PostStatusController.dart';

class PostStatusUI extends GetView<PostStatusController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close_rounded),
          onPressed: () => Get.back(),
        ),
        title: Text('createPost'.tr),
        actions: [
          PopupMenuButton(
            child: IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: null,
            ),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text('Post'),
                  value: 0,
                ),
                PopupMenuItem(
                  child: Text('Clear content'),
                  value: 1,
                ),
                PopupMenuItem(
                  child: Text('Hide keyboard'),
                  value: 2,
                ),
                PopupMenuItem(
                  child: Text('Show Keyboard'),
                  value: 3,
                ),
              ];
            },
            onSelected: (val) async {
              switch (val) {
                case 0:
                  controller.post(context);
                  break;
                case 1:
                  await controller.keyEditor.currentState?.clear();
                  break;
                case 2:
                  await controller.keyEditor.currentState?.unFocus();
                  break;
                case 3:
                  await controller.keyEditor.currentState?.focus();
                  break;
              }
            },
          ),
        ],
      ),
      body: RichEditor(
        key: controller.keyEditor,
        // value: '''<p>hey</p>''', // initial HTML data
        value: '''${Get.arguments[3] ??= ''}''', // initial HTML data
        getBottomSheetEmoji: () async {
          await controller.keyEditor.currentState?.unFocus();
          Get.bottomSheet(Container(
            constraints: BoxConstraints.expand(),
            child: PageView(
              controller: controller.paneControllerPost,
              children: [
                Container(constraints: BoxConstraints.expand(),color: Colors.blue,),
                Container(constraints: BoxConstraints.expand(),color: Colors.yellow,),
                Container(constraints: BoxConstraints.expand(),color: Colors.black,),
                Container(constraints: BoxConstraints.expand(),color: Colors.red,),
                Container(constraints: BoxConstraints.expand(),color: Colors.pink,),
              ],
            ),
          ));
        },
        editorOptions: RichEditorOptions(
          placeholder: '''Start typing''',
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          baseFontFamily: 'sans-serif',
          barPosition: BarPosition.BOTTOM,
        ),
      ),
    );
  }
}
