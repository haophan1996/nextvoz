import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rich_editor/rich_editor.dart';
import 'package:vozforums/GlobalController.dart';
import 'package:vozforums/Page/reuseWidget.dart';
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
        value: '''<p>hey</p>''', // initial HTML data
        //value: '''${Get.arguments[3] ??= ''}''', // initial HTML data
        getBottomSheetEmoji: () async {
          await controller.keyEditor.currentState?.unFocus();
          Get.bottomSheet(
            Container(
              color: Theme.of(context).backgroundColor,
              constraints: BoxConstraints.expand(),
              alignment: Alignment.topCenter,
              child: DefaultTabController(
                initialIndex: controller.currentTab,
                length: 3,
                child: Column(
                  children: [
                    TabBar(
                      tabs: [
                        text(
                          'Smilies Popo',
                          TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        text(
                          'Smilies Popo',
                          TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        text(
                          'Gif',
                          TextStyle(color: Theme.of(context).primaryColor),
                        )
                      ],
                      onTap: (index) => controller.currentTab = index,
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
                              itemCount: GlobalController.i.smallVozEmoji.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Image.asset('assets/${GlobalController.i.smallVozEmoji.elementAt(index)['dir']}');
                              }),
                          GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
                            itemCount: GlobalController.i.bigVozEmoji.length,
                            itemBuilder: (BuildContext context, int index) {
                              return CupertinoButton(
                                  child: Image.asset('assets/${GlobalController.i.bigVozEmoji.elementAt(index)['dir']}'),
                                  onPressed: () async {
                                    await controller.keyEditor.currentState!.javascriptExecutor
                                        .insertHtml(' ' + GlobalController.i.bigVozEmoji.elementAt(index)['symbol'].toString() + ' ');
                                    await controller.keyEditor.currentState?.unFocus();
                                  });
                            },
                          ),
                          Text('c')
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
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
