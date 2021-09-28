import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rich_editor/rich_editor.dart';
import 'package:flutter_html/flutter_html.dart';
import '/utils/emoji.dart';
import '/Page/reuseWidget.dart';
import '../PostStatusController.dart';

class PostStatusUI extends GetView<PostStatusController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarOnly(
            controller.data['isEditPost'] == true ? 'editPost'.tr : 'createPost'.tr,
            [
              // PopupMenuButton(
              //   child: IconButton(
              //     icon: Icon(Icons.more_vert),
              //     onPressed: null,
              //   ),
              //   itemBuilder: (context) {
              //     return [
              //       PopupMenuItem(
              //         child: Text(controller.data['isEditPost'] == true ? 'Save' : 'Post'),
              //         value: 0,
              //       ),
              //       PopupMenuItem(
              //         child: Text('Clear content'),
              //         value: 1,
              //       ),
              //       PopupMenuItem(
              //         child: Text('Hide keyboard'),
              //         value: 2,
              //       ),
              //       PopupMenuItem(
              //         child: Text('Show Keyboard'),
              //         value: 3,
              //       ),
              //       PopupMenuItem(
              //         child: Text('View Code'),
              //         value: 4,
              //       ),
              //     ];
              //   },
              //   onSelected: (val) async {
              //     switch (val) {
              //       case 0:
              //         controller.data['isEditPost'] == true ? await controller.editPost() : await controller.post();
              //         break;
              //       case 1:
              //         await controller.keyEditor.currentState?.clear();
              //         await controller.keyEditor.currentState?.setHtml('</p>');
              //         break;
              //       case 2:
              //         await SystemChannels.textInput.invokeMethod('TextInput.hide'); //controller.keyEditor.currentState?.unFocus();
              //         break;
              //       case 3:
              //         await controller.keyEditor.currentState!.focus(); //controller.keyEditor.currentState?.focus();
              //         break;
              //       case 4:
              //         String? html = await controller.keyEditor.currentState?.getHtml();
              //         print(html);
              //         break;
              //     }
              //   },
              // )
            ]),
        body: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 0.5, color: Theme.of(context).primaryColor)),
                ),
                child: RichEditor(
                  key: controller.keyEditor,
                  value: '''${controller.data['value']}''',
                  editorOptions: RichEditorOptions(
                    //backgroundColor: Theme.of(context).backgroundColor,
                    baseTextColor: Theme.of(context).primaryColor,
                    placeholder: '''Start typing''',
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    baseFontFamily: 'sans-serif',
                    barPosition: BarPosition.CUSTOM,
                  ),
                  getEditLink: (List<dynamic> args) async {
                    print(args.length);
                    controller.link.text = args[0];
                    controller.label.text = args[1];
                    await Get.defaultDialog(title: 'Insert Link', content: insertLink(context, controller, () => controller.editLink(args)));
                    args[0] = controller.link.text;
                    args[1] = controller.label.text;
                    controller.label.clear();
                    controller.link.clear();
                    return args;
                  },
                ),
                height: controller.heightEditor),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Container(
                decoration: BoxDecoration(color: Color(0xfff5c7099), borderRadius: BorderRadius.all(Radius.circular(5))),
                child: customCupertinoButton(
                    Alignment.center,
                    EdgeInsets.fromLTRB(5, 2, 5, 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.open_in_new, color: Colors.white,),
                        Text(
                          '\t\t'+(controller.data['isEditPost'] == true ? 'editPost'.tr : 'createPost'.tr),
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                        () async {
                          controller.data['isEditPost'] == true ? await controller.editPost() : await controller.post();
                    }),
              ),
            ),
            Spacer(),
            Container(
              height: controller.heightToolbar,
              child: ListView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: [
                  buttonToolHtml(Icons.keyboard_hide_outlined, 'Keyboard Show/Hide', () => controller.keyboard()),
                  buttonToolHtml(Icons.format_bold_outlined, 'Bold', () => controller.bold()),
                  buttonToolHtml(Icons.format_italic_outlined, 'Italic', () => controller.italic()),
                  buttonToolHtml(Icons.format_quote_outlined, 'Blockquote', () => controller.blockquote()),
                  buttonToolHtml(Icons.link_outlined, 'Insert Link', () {
                    Get.defaultDialog(title: 'Insert Link', content: insertLink(context, controller, () => controller.insertLink()));
                  }),
                  buttonToolHtml(Icons.emoji_emotions_outlined, 'Emoji', () => Get.bottomSheet(emoji(context, controller))),
                  buttonToolHtml(Icons.image_outlined, 'Insert Image', () {
                    Get.bottomSheet(insertImage(context, controller));
                  }),
                  buttonToolHtml(
                      Icons.video_collection_outlined, 'Insert Youtube', () => Get.defaultDialog(content: insertYoutube(context, controller))),
                  buttonToolHtml(Icons.undo_outlined, 'Undo', () => controller.undo()),
                  buttonToolHtml(Icons.redo_outlined, 'Redo', () => controller.redo()),
                  buttonToolHtml(Icons.format_underline_outlined, 'UnderLine', () => controller.underline()),
                  buttonToolHtml(Icons.format_strikethrough_outlined, 'Strike through', () => controller.strikeThrough()),
                  buttonToolHtml(Icons.format_clear_outlined, 'Clear Format', () => controller.clearFormat()),
                  buttonToolHtml(Icons.text_format_outlined, 'Font Format', () {
                    Get.defaultDialog(content: fontFormat(controller));
                  }),
                  //buttonToolHtml(Icons.font_download_outlined, 'Font Face', () {}),
                  buttonToolHtml(Icons.format_size_outlined, 'Font Size', () {
                    Get.defaultDialog(content: fontSize(context, controller));
                  }),
                  buttonToolHtml(Icons.format_color_text_outlined, 'Text Color', () {
                    Get.defaultDialog(content: textColor(controller));
                  }),
                  //buttonToolHtml(Icons.format_color_fill_outlined, 'Background Color', () {}),
                  buttonToolHtml(Icons.format_indent_decrease_outlined, 'Decrease Indent', () => controller.indentDes()),
                  buttonToolHtml(Icons.format_align_left_outlined, 'Align Left', () => controller.alignLeft()),
                  buttonToolHtml(Icons.format_align_center_outlined, 'Align Center', () => controller.alignCenter()),
                  buttonToolHtml(Icons.format_align_right_outlined, 'Align Right', () => controller.alignRight()),
                  buttonToolHtml(Icons.format_align_justify_outlined, 'Justify', () => controller.alignFull()),
                  buttonToolHtml(Icons.format_list_bulleted_outlined, 'Bullet List', () => controller.bulletList()),
                  buttonToolHtml(Icons.format_list_numbered_outlined, 'Number List', () => controller.numList())
                  //buttonToolHtml(Icons.check_box_outlined, 'Checkbox', () {}),
                ],
              ),
            ),
          ],
        ));
  }
}

Widget insertLink(BuildContext context, PostStatusController controller, Function onDone) {
  return Container(
    padding: EdgeInsets.only(left: 15, right: 15),
    width: Get.width,
    color: Colors.transparent,
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: inputCustom(TextInputType.text,controller.link, false, 'Link', () {}),
        ),
        inputCustom(TextInputType.text,controller.label, false, 'Label', () {}),
        dialogButtonYesNo(() => onDone()),
      ],
    ),
  );
}

Widget insertYoutube(BuildContext context, PostStatusController controller) {
  return Container(
      width: Get.width,
      padding: EdgeInsets.only(left: 15, right: 15),
      color: Colors.transparent,
      child: Column(children: [
        inputCustom(TextInputType.text,controller.link, false, 'Link', () async {
          await controller.getIDYt();
        }),
        dialogButtonYesNo(() async {
          await controller.getIDYt();
        }),
      ]));
}

Widget insertImage(BuildContext context, PostStatusController controller) {
  return Container(
    color: Theme.of(context).backgroundColor,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CupertinoButton(
          alignment: Alignment.centerLeft,
          child: Container(
              width: Get.width,
              child: Text(
                'Insert Link Image',
                textAlign: TextAlign.start,
              )),
          onPressed: () {
            Get.defaultDialog(
              content: Container(
                padding: EdgeInsets.only(left: 15, right: 15),
                width: Get.width,
                color: Colors.transparent,
                child: Column(
                  children: [
                    inputCustom(TextInputType.text,controller.link, false, 'Image link', () async {
                      if (controller.link.text.isURL) {
                        await controller.keyEditor.currentState!.javascriptExecutor.insertCustomImage(controller.link.text);
                        controller.link.clear();
                        Get.back();
                        Get.back();
                      }
                    }),
                    dialogButtonYesNo(() async {
                      if (controller.link.text.isURL) {
                        await controller.keyEditor.currentState!.javascriptExecutor.insertCustomImage(controller.link.text);
                        controller.link.clear();
                        Get.back();
                        Get.back();
                      }
                    }),
                  ],
                ),
              ),
            );
          },
        ),
        CupertinoButton(
          alignment: Alignment.centerLeft,
          child: Container(
            width: Get.width,
            child: Text('Upload Image'),
          ),
          onPressed: () async {
            final pickerFile = await controller.picker.pickImage(source: ImageSource.gallery, maxHeight: 1200, maxWidth: 1200, imageQuality: 50);

            if (pickerFile != null) {
              controller.image = File(pickerFile.path);
              print((await decodeImageFromList(controller.image.readAsBytesSync())).height);
              await controller.keyEditor.currentState!.javascriptExecutor.insertCustomImage(controller.image.path);
              Get.back();
            } else {
              print("No file selected");
            }
          },
        )
      ],
    ),
  );
}

Widget emoji(BuildContext context, PostStatusController controller) {
  return Container(
    color: Theme.of(context).backgroundColor.withOpacity(0.5),
    height: MediaQuery.of(context).viewInsets.bottom != 0.0
        ? Get.height - (MediaQuery.of(context).viewInsets.bottom + PostStatusController.i.heightEditor)
        : Get.height * 0.25,
    alignment: Alignment.topCenter,
    child: DefaultTabController(
      initialIndex: PostStatusController.i.currentTab,
      length: 3,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Text(
                'Smilies Popo',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              Text(
                'Smilies Popo',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              Text(
                'Gif',
                style: TextStyle(color: Theme.of(context).primaryColor),
              )
            ],
            onTap: (index) => PostStatusController.i.currentTab = index,
          ),
          Expanded(
            child: TabBarView(
              children: [
                GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6),
                    itemCount: smallVozEmoji.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CupertinoButton(
                          child: Image.asset('assets/${smallVozEmoji.elementAt(index)['dir']}'),
                          onPressed: () async {
                            controller.insertEmojiVozOnly(smallVozEmoji.elementAt(index)['dir']);
                          });
                    }),
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6),
                  itemCount: bigVozEmoji.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Image.asset('assets/${bigVozEmoji.elementAt(index)['dir']}'),
                        onPressed: () async {
                          controller.insertEmojiVozOnly(bigVozEmoji.elementAt(index)['dir']);
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
  );
}

Widget fontFormat(PostStatusController controller) {
  return Container(
    height: 200.0, // Change as per your requirement
    width: Get.width,
    child: ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: controller.formats.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          child: Html(
            data: controller.formats.elementAt(index)['title'],
            shrinkWrap: false,
            style: {
              "h1": Style()..margin = EdgeInsets.zero,
              "h2": Style()..margin = EdgeInsets.zero,
              "h3": Style()..margin = EdgeInsets.zero,
              "h4": Style()..margin = EdgeInsets.zero,
              "h5": Style()..margin = EdgeInsets.zero,
              "h6": Style()..margin = EdgeInsets.zero,
            },
          ),
          onTap: () async {
            if (controller.formats.elementAt(index)['id'] == 'p') {
              await controller.keyEditor.currentState!.javascriptExecutor.setFormattingToParagraph();
            } else if (controller.formats.elementAt(index)['id'] == 'pre') {
              await controller.keyEditor.currentState!.javascriptExecutor.setPreformat();
            } else if (controller.formats.elementAt(index)['id'] == 'blockquote') {
              await controller.keyEditor.currentState!.javascriptExecutor.setBlockQuote();
            } else {
              await controller.keyEditor.currentState!.javascriptExecutor.setHeading(int.tryParse(controller.formats.elementAt(index)['id'])!);
            }
          },
        );
      },
    ),
  );
}

Widget fontSize(BuildContext context, PostStatusController controller) {
  return Container(
    height: 200.0, // Change as per your requirement
    width: Get.width,
    child: ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: controller.formatsSize.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          child: Container(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                controller.formatsSize.elementAt(index)['title'],
                style: TextStyle(fontSize: double.parse(controller.formatsSize.elementAt(index)['size'])),
              ),
            ),
            height: 30,
          ),
          onTap: () async {
            await controller.keyEditor.currentState!.javascriptExecutor.setFontSize(int.parse(controller.formatsSize.elementAt(index)['id']));
            Get.back();
          },
        );
      },
    ),
  );
}

Widget textColor(PostStatusController controller) {
  return Container(
    height: 200,
    width: Get.width,
    child: GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
      itemBuilder: (_, index) => CupertinoButton(
        padding: EdgeInsets.zero,
        child: Container(width: 50, height: 50, color: controller.textColor.elementAt(index)),
        onPressed: () async {
          await controller.keyEditor.currentState!.javascriptExecutor.setTextColor(controller.textColor.elementAt(index));
          Get.back();
        },
      ),
      itemCount: controller.textColor.length,
    ),
  );
}
