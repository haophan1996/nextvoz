import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image/network.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:interactiveviewer_gallery/interactiveviewer_gallery.dart';
import '/Routes/pages.dart';
import '/utils/color.dart';
import 'package:extended_image/extended_image.dart';
import '/GlobalController.dart';
import '/Page/NavigationDrawer/NaviDrawerController.dart';
import '/Page/View/ViewController.dart';

///  * Global appbar
PreferredSize preferredSize(BuildContext context, String title, String prefix, List<Widget> action) => PreferredSize(
      preferredSize: Size.fromHeight(GlobalController.i.heightAppbar),
      child: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: customTitle(FontWeight.bold, Color(0xfff3168b0), 2, prefix, title, null),
        leading: (ModalRoute.of(context)?.canPop ?? false) ? BackButton() : null,
        actions: action,
      ),
    );

/// * Appbar only for PostStatus and Pop
PreferredSize appBarOnly(String title, List<Widget> action) {
  return PreferredSize(
    preferredSize: Size.fromHeight(GlobalController.i.heightAppbar),
    child: AppBar(
      automaticallyImplyLeading: false,
      title: Text(title.tr, style: TextStyle(fontWeight: FontWeight.bold)),
      leading: IconButton(
        icon: Icon(Icons.close_rounded),
        onPressed: () => Get.back(),
      ),
      actions: action,
    ),
  );
}

/// * [header11] - [header12] black/white color depends on Dark/light mode.
/// * [header21] - [header22] grey color default.
/// * [header3] orange color default.
Widget blockItem(BuildContext context, bool? isLock, FontWeight titleWeight, int index, Color divider, Color title, String header11, String header12,
        String header21, String header22, String header3, Function onTap, Function onLongPress) =>
    Padding(
      padding: EdgeInsets.only(left: 0, right: 5),
      child: InkWell(
        splashFactory: InkRipple.splashFactory,
        onTap: () => onTap(),
        onLongPress: () => onLongPress(),
        child: Ink(
          width: double.infinity,
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: divider, width: 0.2))),
          padding: EdgeInsets.fromLTRB(10, 5, 5, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              customTitle(titleWeight, title /*Color(0xfff3168b0)*/, null, header11, header12, isLock),
              Text("$header21 \u2022 $header22 ${header3 == '' ? '' : '\u2022'} $header3",
                  style: TextStyle(color: Colors.grey, fontSize: Theme.of(context).textTheme.bodyText2!.fontSize)),
            ],
          ),
        ),
      ),
    );

Widget customCupertinoButton(Alignment alignment, EdgeInsets edgeInsets, Widget child, Function onTap) => CupertinoButton(
      alignment: alignment,
      padding: edgeInsets,
      child: child,
      onPressed: () => onTap(),
    );

Widget buttonToolHtml(IconData iconData, String message, Function onPressed) => customCupertinoButton(
    Alignment.center,
    EdgeInsets.zero,
    Tooltip(
      message: message,
      preferBelow: false,
      child: Icon(iconData, color: Get.theme.primaryColor),
    ),
    () => onPressed());

setNavigateToPageOnInput(Function(int) callback) async {
  await Get.bottomSheet(Container(
    decoration: BoxDecoration(
      color: Get.theme.shadowColor,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(6),
        topRight: Radius.circular(6),
      ),
    ),
    padding: EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        customCupertinoButton(Alignment.center, EdgeInsets.zero, Text('Back'), () => Get.back()),
        Container(
          height: 80,
          padding: EdgeInsets.all(10),
          child: TextField(
              onEditingComplete: () {
                Get.back();
                if (GlobalController.i.inputNavigatePage.text.length != 0) {
                  callback(int.parse(GlobalController.i.inputNavigatePage.text));
                  GlobalController.i.inputNavigatePage.clear();
                }
              },
              autofocus: true,
              controller: GlobalController.i.inputNavigatePage,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: 'Go to page',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Get.theme.primaryColor, fontSize: Get.textTheme.headline6!.fontSize),
                  fillColor: Get.theme.canvasColor,
                  filled: true,
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Get.theme.primaryColor, width: 1)),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)))),
        ),
        Container(
          alignment: Alignment.center,
          child: customCupertinoButton(Alignment.center, EdgeInsets.zero, Text('OK'), () {
            Get.back();
            if (GlobalController.i.inputNavigatePage.text.length != 0) {
              callback(int.parse(GlobalController.i.inputNavigatePage.text));
              GlobalController.i.inputNavigatePage.clear();
            }
          }),
        )
      ],
    ),
  ));
}

Widget customTitle(
  FontWeight titleWeight,
  Color titleColor,
  int? maxLines,
  String header11,
  String header12,
  bool? isLock,
) {
  return RichText(
    maxLines: maxLines,
    overflow: maxLines == 1 || maxLines == 2 ? TextOverflow.ellipsis : TextOverflow.clip,
    textAlign: maxLines == 2 ? TextAlign.center : TextAlign.start,
    text: (header11 == '' && isLock == false && titleColor != Colors.red)
        ? customTitleChildNoPrefixNoLock(titleWeight, titleColor, header12)
        : customTitleChild(titleWeight, titleColor, header11, header12, isLock),
  );
}

TextSpan customTitleChild(
  FontWeight titleWeight,
  Color titleColor,
  String header11,
  String header12,
  bool? isLock,
) {
  return TextSpan(children: [
    WidgetSpan(
        child: Container(
          padding: EdgeInsets.only(right: 5),
          child: isLock == true
              ? Icon(
                  Icons.lock_outline,
                  size: Get.textTheme.bodyText1!.fontSize,
                )
              : titleColor == Colors.red
                  ? Icon(
                      Icons.push_pin,
                      size: Get.textTheme.bodyText1!.fontSize,
                    )
                  : null,
        ),
        alignment: PlaceholderAlignment.middle),
    WidgetSpan(
        child: Container(
          padding: EdgeInsets.only(left: header11 == '' ? 0 : 4, right: header11 == '' ? 0 : 4),
          decoration: BoxDecoration(color: mapColor[header11], borderRadius: BorderRadius.all(Radius.circular(6))),
          child: Text(
            header11,
            style: TextStyle(
              fontSize: header11 == '' ? 0 : Get.textTheme.bodyText2!.fontSize!,
              color: getColorInvert(header11),
            ),
          ),
        ),
        alignment: PlaceholderAlignment.bottom),
    TextSpan(
      text: header12,
      style: TextStyle(color: titleColor, fontFamily: 'BeVietNam', fontSize: Get.textTheme.bodyText1!.fontSize, fontWeight: titleWeight),
    )
  ]);
}

TextSpan customTitleChildNoPrefixNoLock(
  FontWeight titleWeight,
  Color titleColor,
  String header12,
) {
  return TextSpan(children: [
    TextSpan(
      text: header12,
      style: TextStyle(color: titleColor, fontFamily: 'BeVietNam', fontSize: Get.textTheme.bodyText1!.fontSize, fontWeight: titleWeight),
    )
  ]);
}

Widget settings() => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            CupertinoButton(
                child: Icon(
                  Icons.notifications_none_outlined,
                  color: Get.theme.primaryColor,
                ),
                onPressed: () async {
                  await Get.toNamed(Routes.Alerts, preventDuplicates: false);
                }),
            GetBuilder<GlobalController>(
                id: 'alertNotification',
                builder: (controller) {
                  return Positioned(
                    right: 0,
                    top: 3,
                    child: Container(
                      width: 30,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: controller.alertNotifications == 0 ? Colors.transparent : Colors.red),
                      child: Center(
                        child: Text(controller.alertNotifications == 0 ? '' : controller.alertNotifications.toString()),
                      ),
                    ),
                  );
                })
          ],
        ),
        Stack(
          children: [
            customCupertinoButton(
                Alignment.center,
                EdgeInsets.zero,
                Icon(
                  Icons.mail_outline,
                  color: Get.theme.primaryColor,
                ),
                () async => await Get.toNamed(Routes.Conversation, preventDuplicates: false)),
            GetBuilder<GlobalController>(
                id: 'inboxNotification',
                builder: (controller) {
                  return Positioned(
                    right: 0,
                    top: 3,
                    child: Container(
                      width: 30,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: controller.inboxNotifications == 0 ? Colors.transparent : Colors.red),
                      child: Center(
                        child: Text(controller.inboxNotifications == 0 ? '' : controller.inboxNotifications.toString()),
                      ),
                    ),
                  );
                })
          ],
        ),
        customCupertinoButton(
            Alignment.center,
            EdgeInsets.zero,
            Icon(
              Icons.settings,
              color: Get.theme.primaryColor,
            ),
            () => NaviDrawerController.i.navigateToSetting())
      ],
    );

Widget textDrawer(Color color, double? fontSize, String text, FontWeight fontWeight) =>
    Text(text, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: color, fontWeight: fontWeight, fontSize: fontSize));

Widget inputCustom(TextInputType keyboardType, TextEditingController controller, bool obscureText, String hint, Function onEditingComplete) {
  return TextField(
    onEditingComplete: () async => await onEditingComplete(),
    textInputAction: TextInputAction.next,
    controller: controller,
    keyboardType: keyboardType,
    style: TextStyle(fontSize: 18, color: Get.theme.primaryColor),
    obscureText: obscureText,
    autocorrect: false,
    enableSuggestions: false,
    decoration: InputDecoration(
      labelText: hint.tr,
      labelStyle: TextStyle(color: Get.theme.primaryColor.withOpacity(0.7)),
      border: OutlineInputBorder(
        borderSide: BorderSide(width: 1),
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
    ),
  );
}

setDialog() => Get.dialog(CupertinoActivityIndicator(), barrierDismissible: false);

setDialogError(String text) => Get.defaultDialog(
      content: Text(text, textAlign: TextAlign.center),
      textConfirm: 'Ok',
      title: 'Error',
      confirmTextColor: Colors.white,
      onConfirm: () => Get.back(),
      buttonColor: Colors.red,
      backgroundColor: Get.theme.canvasColor,
    );

Widget loadFailed(String message, Function onRefresh) {
  return Column(
    children: [
      RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(text: 'Page could not be loaded\n', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16)),
            TextSpan(text: message, style: TextStyle(color: Get.theme.primaryColor, fontSize: 16)),
          ],
        ),
      ),
      customCupertinoButton(
          Alignment.center,
          EdgeInsets.fromLTRB(10, 0, 10, 0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.refresh_outlined),
              Text('\t\tRefresh '),
              Text(
                '\u{1F611} ',
                style: TextStyle(fontSize: Get.textTheme.headline5!.fontSize),
              ),
            ],
          ),
          () async => onRefresh())
    ],
  );
}

Widget buildFlagsPreviewIcon(String path, String text) => Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          Text(
            text.tr,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          Image.asset(path, height: 30),
        ],
      ),
    );

Widget buildIcon(String path, String text) => Row(
      children: [
        Image.asset(
          path,
          height: 20,
          width: 20,
        ),
        Text(
          text.tr,
          style: TextStyle(color: Colors.blue, fontSize: Get.textTheme.bodyText2!.fontSize),
        )
      ],
    );

Widget reactionChild(Map reactionMap) {
  return Padding(
    padding: EdgeInsets.all(5),
    child: CupertinoButton(
      padding: EdgeInsets.zero,
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(color: Get.theme.shadowColor, borderRadius: BorderRadius.all(Radius.circular(6))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: Stack(
                children: [
                  displayAvatar(40, reactionMap['avatarColor1'], reactionMap['avatarColor2'], reactionMap['rName'], reactionMap['rAvatar']),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: ExtendedImage.asset(
                      'assets/reaction/${reactionMap['rReactIcon']}.png',
                      width: 23,
                      height: 23,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 5),
                child: RichText(
                  text: TextSpan(style: TextStyle(height: 1.2), children: [
                    TextSpan(
                      text: reactionMap['rName'] + '\n',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    TextSpan(text: reactionMap['rTitle'] + '\n', style: TextStyle(color: Get.theme.primaryColor)),
                    TextSpan(text: reactionMap['rTime'], style: TextStyle(color: Colors.grey))
                  ]),
                ),
              ),
            )
          ],
        ),
      ),
      onPressed: () {
        Get.toNamed(Routes.Profile, arguments: [reactionMap['rLink']], preventDuplicates: false);
      },
    ),
  );
}

Widget listReactionUI(ViewController controller) {
  return DraggableScrollableSheet(
    expand: false,
    initialChildSize: 1,
    minChildSize: 0.4,
    builder: (_, dragController) => Container(
      padding: EdgeInsets.only(left: 5, top: 5),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
      ),
      child: GetBuilder<ViewController>(
        id: 'reactionState',
        tag: GlobalController.i.sessionTag.last,
        builder: (controller) {
          return controller.reactionList.length == 0
              ? CupertinoActivityIndicator()
              : controller.reactionList[0] == null
                  ? Text('No reaction')
                  : ListView.builder(
                      controller: dragController,
                      physics: BouncingScrollPhysics(),
                      itemCount: controller.reactionList.length,
                      itemBuilder: (context, index) {
                        return reactionChild(controller.reactionList.elementAt(index));
                      });
        },
      ),
    ),
  );
}

Widget onTapUser(ViewController controller, int index) {
  return Padding(
    padding: EdgeInsets.only(bottom: 30),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CupertinoButton(
            child: Container(
              width: Get.width,
              child: Text('Start conversation'),
            ),
            onPressed: () async {
              await Get.toNamed(Routes.CreatePost, arguments: [
                GlobalController.i.xfCsrfPost,
                GlobalController.i.token,
                'link',
                '',
                '',
                '2',
                '',
                controller.htmlData.elementAt(index)['userName']
              ]);
            }),
        CupertinoButton(
            child: Container(
              width: Get.width,
              child: Text('View Profile'),
            ),
            onPressed: () async {
              if (Get.isBottomSheetOpen == true) Get.back();
              Get.toNamed(Routes.Profile, arguments: [controller.htmlData.elementAt(index)['userLink']], preventDuplicates: false);
            }),
        CupertinoButton(
            child: Container(
              width: Get.width,
              child: Text('Report'),
            ),
            onPressed: () {}),
      ],
    ),
  );
}

Widget onTapMine(ViewController controller, int index) {
  return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CupertinoButton(
              child: Container(
                width: Get.width,
                child: Text('Edit'),
              ),
              onPressed: () async {
                if (Get.isBottomSheetOpen == true) Get.back();
                controller.editRep(index);
              }),
          controller.htmlData.elementAt(index)['orderPost'] == ''
              ? Text('')
              : CupertinoButton(
                  child: Container(
                    width: Get.width,
                    child: Text('Delete'),
                  ),
                  onPressed: () {
                    if (Get.isBottomSheetOpen == true) Get.back();
                    Get.defaultDialog(
                      title: 'Delete post',
                      content: Container(
                          width: Get.width,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              inputCustom(TextInputType.text, controller.input, false, 'Reason for deletion',
                                  () => controller.deletePost(controller.input.text, index)),
                              dialogButtonYesNo(() {
                                controller.deletePost(controller.input.text, index);
                              })
                            ],
                          )),
                    );
                  })
        ],
      ));
}

Widget dialogButtonYesNo(Function onDone) => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CupertinoButton(child: Text('Cancel'), onPressed: () => Get.back()),
        CupertinoButton(
            child: Text('Done'),
            onPressed: () {
              onDone();
            }),
      ],
    );

Widget viewContent(int index, ViewController controller) => Column(
      key: controller.formKeyList.elementAt(index),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Material(
          color: Get.theme.shadowColor,
          child: InkWell(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5),
                  child: displayAvatar(40, controller.htmlData.elementAt(index)["avatarColor1"], controller.htmlData.elementAt(index)["avatarColor2"],
                      controller.htmlData.elementAt(index)["userName"], controller.htmlData.elementAt(index)["userAvatar"]),
                ),
                RichText(
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: controller.htmlData.elementAt(index)['userName'] + "\n",
                        style: TextStyle(
                            color: controller.htmlData.elementAt(index)['newPost'] == true ? Color(0xFFFD6E00) : Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: Get.textTheme.bodyText2!.fontSize)),
                    TextSpan(
                        text: controller.htmlData.elementAt(index)['userTitle'],
                        style: TextStyle(color: Get.theme.primaryColor, fontSize: Get.textTheme.bodyText2!.fontSize)),
                  ]),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text('${controller.htmlData.elementAt(index)['userPostDate']}\n ${controller.htmlData.elementAt(index)['orderPost']}',
                        textAlign: TextAlign.right, style: TextStyle(color: Get.theme.primaryColor, fontSize: Get.textTheme.bodyText2!.fontSize)),
                  ),
                ),
              ],
            ),
            onTap: () => Get.bottomSheet(
                Card(
                  color: Get.theme.canvasColor,
                  child: controller.htmlData.elementAt(index)['userName'] == NaviDrawerController.i.data['nameUser']
                      ? onTapMine(controller, index)
                      : onTapUser(controller, index),
                ),
                ignoreSafeArea: false),
            onLongPress: () {
              GlobalController.i
                  .getHttp(true, {'cookie': '${controller.data['xfCsrfPost']}; ${GlobalController.i.userLoginCookie}'},
                      '${GlobalController.i.url + controller.htmlData.elementAt(index)['userLink']}?tooltip=true&_xfToken=${GlobalController.i.token}&_xfResponseType=json')
                  .then((value) {
                if (value['status'] == 'ok') {
                  controller.data['memberTooltip'] = GlobalController.i.performTooltipMember(value['html']['content']);
                  Get.defaultDialog(
                    radius: 6,
                    contentPadding: EdgeInsets.zero,
                    content: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: displayAvatar(
                                  50,
                                  controller.htmlData.elementAt(index)["avatarColor1"],
                                  controller.htmlData.elementAt(index)["avatarColor2"],
                                  controller.htmlData.elementAt(index)["userName"],
                                  controller.htmlData.elementAt(index)["userAvatar"]),
                            ),
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: controller.data['memberTooltip']['username'],
                                  style: TextStyle(fontSize: Get.textTheme.bodyText1!.fontSize! + 2, color: Colors.blue),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Get.toNamed(Routes.Profile,
                                          arguments: [controller.htmlData.elementAt(index)['userLink']], preventDuplicates: false);
                                    }),
                              TextSpan(
                                  text: controller.data['memberTooltip']['userTitle'],
                                  style: TextStyle(color: Get.theme.primaryColor, fontSize: Get.textTheme.bodyText1!.fontSize)),
                              TextSpan(
                                  text: controller.data['memberTooltip']['joined'],
                                  style: TextStyle(color: Get.theme.primaryColor, fontSize: Get.textTheme.bodyText1!.fontSize))
                            ]))
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: RichText(
                            text: TextSpan(children: [
                              TextSpan(text: 'Messages: ', style: TextStyle(color: Colors.grey)),
                              TextSpan(text: controller.data['memberTooltip']['message'].toString(), style: TextStyle(color: Get.theme.primaryColor)),
                              TextSpan(text: 'Reaction score: ', style: TextStyle(color: Colors.grey)),
                              TextSpan(text: controller.data['memberTooltip']['reaction'], style: TextStyle(color: Get.theme.primaryColor)),
                              TextSpan(text: 'Points: ', style: TextStyle(color: Colors.grey)),
                              TextSpan(text: controller.data['memberTooltip']['point'], style: TextStyle(color: Get.theme.primaryColor)),
                            ]),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            customCupertinoButton(Alignment.center, EdgeInsets.only(left: 20, right: 20), Text('Follow'), () {}),
                            customCupertinoButton(Alignment.center, EdgeInsets.only(left: 20, right: 20), Text('Ignore'), () {}),
                          ],
                        )
                      ],
                    ),
                    title: 'Member Profile',
                  );
                  print(controller.data['memberTooltip']['username']);
                }
              });
            },
          ),
        ),
        customHtml(controller.htmlData.elementAt(index)['postContent'], controller.imageList, (postID, url) async {
          controller.data['index'] = controller.findIndex(postID);
          if (controller.data['index'] == -1) {
            controller.data['fullURL2'] = url;
            await controller.scrollToIndex(-1, 0);
            await controller.scrollToIndex(16, 1);
          } else {
            await controller.scrollToIndex(controller.findIndex(postID), 0);
          }
        }),
        //Divider(),
        Padding(
          padding: EdgeInsets.fromLTRB(5, 7, 5, 7),
          child: GetBuilder<ViewController>(
            tag: GlobalController.i.sessionTag.last,
            id: index.toString(),
            builder: (controller) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: RichText(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        text: TextSpan(children: [
                          WidgetSpan(
                              child: Image.asset(
                                controller.htmlData.elementAt(index)['commentImage'] != ''
                                    ? 'assets/reaction/' + controller.htmlData.elementAt(index)['commentImage'][0] + '.png'
                                    : 'assets/reaction/nil.png',
                                width: controller.htmlData.elementAt(index)['commentImage'] != '' ? 16 : 0,
                                height: controller.htmlData.elementAt(index)['commentImage'] != '' ? 16 : 0,
                              ),
                              alignment: PlaceholderAlignment.middle),
                          WidgetSpan(
                              child: Image.asset(
                                controller.htmlData.elementAt(index)['commentImage'].length > 1
                                    ? 'assets/reaction/' + controller.htmlData.elementAt(index)['commentImage'][1] + '.png'
                                    : 'assets/reaction/nil.png',
                                width: controller.htmlData.elementAt(index)['commentImage'].length > 1 ? 16 : 0,
                                height: controller.htmlData.elementAt(index)['commentImage'].length > 1 ? 16 : 0,
                              ),
                              alignment: PlaceholderAlignment.middle),
                          TextSpan(
                              text: '\t' + controller.htmlData.elementAt(index)['commentName'],
                              style: TextStyle(color: Colors.blueAccent, fontSize: Get.textTheme.bodyText2!.fontSize),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  controller.getDataReactionList(index);
                                  Get.bottomSheet(listReactionUI(controller), isScrollControlled: false, ignoreSafeArea: true);
                                }),
                        ])),
                  ),
                  FlutterReactionButton(
                    onReactionChanged: (reaction, i) {
                      if (GlobalController.i.isLogged == false) {
                        controller.update([index]);
                        setDialogError('popMess4'.tr);
                      } else {
                        if (controller.htmlData.elementAt(index)['commentByMe'] != i) {
                          if (i == 0) {
                            controller
                                .reactionPost(
                                    index, controller.htmlData.elementAt(index)['postID'], controller.htmlData.elementAt(index)['commentByMe'])
                                .then((value) {
                              if (value['status'] != 'error') {
                                controller.htmlData.elementAt(index)['commentByMe'] = 0;
                              } else {
                                setDialogError(value['mess']);
                              }
                            });
                          } else {
                            controller.reactionPost(index, controller.htmlData.elementAt(index)['postID'], i).then((value) {
                              if (value['status'] != 'error') {
                                controller.htmlData.elementAt(index)['commentByMe'] = i;
                              } else {
                                setDialogError(value['mess']);
                              }
                            });
                          }
                        }
                      }
                    },
                    reactions: controller.flagsReactions,
                    initialReaction: controller.htmlData.elementAt(index)['commentByMe'] == -1
                        ? controller.flagsReactions[0]
                        : controller.flagsReactions[controller.htmlData.elementAt(index)['commentByMe']],
                    boxRadius: 10,
                    boxAlignment: AlignmentDirectional.bottomEnd,
                  ),
                  InkWell(
                    child: Text(
                      '\t\t' + 'rep'.tr,
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    onTap: () {
                      controller.quote(index);
                    },
                  )
                ],
              );
            },
          ),
        ),
      ],
    );

Widget displayAvatar(double sizeImage, String avatarColor1, String avatarColor2, String? userName, String imageLink) {
  return Container(
    width: sizeImage,
    height: sizeImage,
    alignment: Alignment.center,
    decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 2),
        color: Color(
          int.parse(avatarColor1),
        ),
        shape: BoxShape.circle),
    child: imageLink != 'no'
        ? ExtendedImage.network(
            imageLink,
            clearMemoryCacheWhenDispose: true,
            shape: BoxShape.circle,
            filterQuality: FilterQuality.low,
            fit: BoxFit.fill,
            width: sizeImage,
            height: sizeImage,
            enableLoadState: false,
            //maxBytes: 2,
          )
        : Text(
            userName!.toUpperCase()[0],
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(int.parse(avatarColor2)), fontWeight: FontWeight.bold),
          ),
  );
}

void displayGallery(List imageList, int index) {
  Get.bottomSheet(
      SafeArea(
          child: InteractiveviewerGallery(
        itemBuilder: (BuildContext context, int index, bool isFocus) {
          return Stack(
            alignment: Alignment.center,
            children: [
              ExtendedImage.network(
                imageList.elementAt(index),
                clearMemoryCacheWhenDispose: true,
                clearMemoryCacheIfFailed: true,
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  '${index + 1} of ${imageList.length}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
        sources: imageList,
        initIndex: index,
      )),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      ignoreSafeArea: false,
      enableDrag: false);
}

Widget loadingBottom(String type, double height) {
  return Container(
    alignment: Alignment.topCenter,
    height: height,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        type == 'idle'
            ? Icon(Icons.arrow_upward, color: Colors.grey)
            : type == 'Holding'
                ? Icon(Icons.sync_outlined, color: Colors.grey)
                : Icon(Icons.file_download),
        Text(
          '\t${type == 'idle' ? 'pullUp'.tr : type == 'Holding' ? 'pullRes'.tr : 'loading'.tr}',
          style: TextStyle(color: Colors.grey),
        )
      ],
    ),
  );
}

Widget customHtml(String postContent, List imageList, Function(String index, String url) onGoToPost) {
  return Html(
    data: Get.isDarkMode == true ? '''<span style="color: rgb(160,160,160)">$postContent</span>''' : postContent,
    tagsList: Html.tags
      ..remove('noscript')
      ..remove(GlobalController.i.userStorage.read('showImage') ?? true ? '' : 'img'),
    customRender: {
      'hr': (renderContext, child) {
        return Divider(
          endIndent: Get.width / 2,
        );
      },
      "img": (renderContext, child) {
        double? width = double.tryParse(renderContext.tree.element!.attributes['width'].toString());
        double? height = double.tryParse(renderContext.tree.element!.attributes['height'].toString());
        if (renderContext.tree.element!.attributes['src']!.contains("/styles/next/xenforo")) {
          return ExtendedImage.asset(
            GlobalController.i.getEmoji(renderContext.tree.element!.attributes['src'].toString()),
            clearMemoryCacheWhenDispose: true,
          );
        } else if (renderContext.tree.element!.attributes['src']!.contains("twemoji.maxcdn.com")) {
          return Text(
            renderContext.tree.element!.attributes['alt']!,
            style: TextStyle(fontSize: GlobalController.i.userStorage.read('fontSizeView')),
          );
        } else if ((renderContext.tree.element!.attributes['data-url']?.contains(".gif") == true) ||
            renderContext.tree.element!.attributes['alt']?.contains(".gif") == true) {
          imageList.add(renderContext.tree.element!.attributes['data-src'].toString().length > 4
              ? renderContext.tree.element!.attributes['data-src'].toString()
              : renderContext.tree.element!.attributes['data-url'].toString().length > 4
                  ? renderContext.tree.element!.attributes['data-url'].toString()
                  : renderContext.tree.element!.attributes['src'].toString());

          return InkWell(
            child: Image(
              image: NetworkImageWithRetry(
                renderContext.tree.element!.attributes['data-src'].toString().length > 4
                    ? renderContext.tree.element!.attributes['data-src'].toString()
                    : renderContext.tree.element!.attributes['data-url'].toString().length > 4
                        ? renderContext.tree.element!.attributes['data-url'].toString()
                        : renderContext.tree.element!.attributes['src'].toString(),
              ),
              // loadingBuilder: (context, child, loadingProgress){
              //   return Center(
              //     child: CircularProgressIndicator()
              //   );
              // } ,
            ),
            onTap: () {
              displayGallery(
                  imageList,
                  imageList.indexOf(renderContext.tree.element!.attributes['data-src'].toString().length > 4
                      ? renderContext.tree.element!.attributes['data-src'].toString()
                      : renderContext.tree.element!.attributes['data-url'].toString().length > 4
                          ? renderContext.tree.element!.attributes['data-url'].toString()
                          : renderContext.tree.element!.attributes['src'].toString()));
            },
          );
        } else {
          imageList.add(renderContext.tree.element!.attributes['data-src'].toString().length > 4
              ? renderContext.tree.element!.attributes['data-src'].toString()
              : renderContext.tree.element!.attributes['data-url'].toString().length > 4
                  ? renderContext.tree.element!.attributes['data-url'].toString()
                  : renderContext.tree.element!.attributes['src'].toString());
          return customCupertinoButton(
              Alignment.center,
              EdgeInsets.zero,
              ExtendedImage.network(
                renderContext.tree.element!.attributes['data-src'].toString().length > 4
                    ? renderContext.tree.element!.attributes['data-src'].toString()
                    : renderContext.tree.element!.attributes['data-url'].toString().length > 4
                        ? renderContext.tree.element!.attributes['data-url'].toString()
                        : renderContext.tree.element!.attributes['src'].toString(),
                clearMemoryCacheWhenDispose: true,
                cache: true,
                scale: 2,
                constraints: BoxConstraints(maxWidth: width != null ? width : Get.width * 0.8, maxHeight: height != null ? height : Get.height * 0.8),
                clearMemoryCacheIfFailed: true,
                enableMemoryCache: false,
                cacheMaxAge: Duration(days: 2),
                loadStateChanged: (states) {
                  switch (states.extendedImageLoadState) {
                    case LoadState.loading:
                      if (width != null && height != null) {
                        return AspectRatio(
                          aspectRatio: width / height,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else
                        return Container(
                          height: 100,
                          width: Get.width,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                    case LoadState.completed:
                      break;
                    case LoadState.failed:
                      if (width != null && height != null) {
                        return AspectRatio(
                          aspectRatio: width / height,
                          child: Text('Image error'),
                        );
                      } else
                        return Container(height: 50, width: 50, child: Text('Image error'));
                  }
                },
              ), () {
            displayGallery(
                imageList,
                imageList.indexOf(renderContext.tree.element!.attributes['data-src'].toString().length > 4
                    ? renderContext.tree.element!.attributes['data-src'].toString()
                    : renderContext.tree.element!.attributes['data-url'].toString().length > 4
                        ? renderContext.tree.element!.attributes['data-url'].toString()
                        : renderContext.tree.element!.attributes['src'].toString()));
          });
        }
      },
      "table": (context, child) {
        if (context.tree.element!.getElementsByTagName("td").length > 2)
          return SingleChildScrollView(
            scrollDirection:
                (context.tree.element!.getElementsByTagName("tr").length > 1) || (context.tree.element!.getElementsByTagName("a")[0].text.length > 25)
                    ? Axis.horizontal
                    : Axis.vertical,
            padding: EdgeInsets.all(2),
            physics: BouncingScrollPhysics(),
            child: (context.tree as TableLayoutElement).toWidget(context),
          );
        else
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(2),
            physics: BouncingScrollPhysics(),
            child: (context.tree as TableLayoutElement).toWidget(context),
          );
      },
      'span': (context, child) {
        if (context.tree.element!.attributes['style']?.contains('rgb(0, 0, 0)') == true ||
            context.tree.element!.attributes['style']?.contains('rgb(255, 255, 255)') == true ||
            context.tree.element!.attributes['style']?.contains('color: #000000') == true) {
          context.style.color = Get.theme.primaryColor;
        }
      },
      "iframe": (RenderContext context, Widget child) {
        final attrs = context.tree.element?.attributes;
        double? width = double.tryParse(attrs!['width'] ?? "");
        double? height = double.tryParse(attrs['height'] ?? "");
        if (attrs['src'].toString().contains('youtube') == true) {
          final link = GlobalController.i.getIDYoutube(attrs['src'].toString());
          return Column(
            children: [
              CupertinoButton(
                  minSize: 0,
                  padding: EdgeInsets.zero,
                  child: Text('https://www.youtube.com/watch?v=$link'),
                  onPressed: () async => await GlobalController.i.launchURL('https://www.youtube.com/watch?v=$link')),
              CupertinoButton(
                minSize: 0,
                padding: EdgeInsets.zero,
                onPressed: () {
                  Get.toNamed(Routes.Youtube, arguments: [GlobalController.i.getIDYoutube(attrs['src'].toString())]);
                },
                child: Stack(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: ExtendedImage.network(
                          'https://img.youtube.com/vi/$link/0.jpg',
                          width: width,
                          height: height,
                        )),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.play_circle_fill,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        }
      },
    },
    style: {
      "code": Style(color: Colors.blue),
      "table": Style(backgroundColor: Get.theme.cardColor),
      "body": Style(
          fontSize: FontSize(Get.textTheme.bodyText1!.fontSize! + 2), padding: EdgeInsets.zero, margin: EdgeInsets.only(left: 10, right: 3, top: 10)),
      "article": Style(padding: EdgeInsets.zero, margin: EdgeInsets.zero),
      "blockquote": Style(
          padding: EdgeInsets.all(5),
          width: double.infinity,
          backgroundColor: Get.theme.cardColor,
          margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 5),
          display: Display.BLOCK)
    },
    onLinkTap: (String? url, RenderContext context, Map<String, String> attributes, dom.Element? element) async {
      if (url != null) {
        if (url.contains(RegExp(r'voz.vn/t/.*?/post-'))) {
          ///Check is current page contain this post
          // final postNumber = url.split('post-')[1];
          // var i = htmlData.firstWhere((element) => element['postID'] == postNumber, orElse: () => 'noElement');
          // if (i != 'noElement') {
          //   Get.bottomSheet(
          //       Container(
          //         height: Get.height * 0.8,
          //         child: DraggableScrollableSheet(
          //           initialChildSize: 1,
          //           minChildSize: 0.85,
          //           builder: (_, controller) {
          //             return SingleChildScrollView(
          //               controller: controller,
          //               child: Container(
          //                 decoration: BoxDecoration(color: Colors.grey.shade800, borderRadius: BorderRadius.all(Radius.circular(6))),
          //                 padding: EdgeInsets.only(bottom: 20),
          //                 child: customHtml([i], 0, []),
          //               ),
          //             );
          //           },
          //         ),
          //       ),
          //       elevation: 122,
          //       isScrollControlled: true);
          // }
        } else if (url.contains('https://voz.vn/t/', 0)) {
          Get.toNamed(Routes.View, arguments: [url.replaceFirst(GlobalController.i.url + '/t/', '', 0), url, '', 0], preventDuplicates: false);
        } else if (url.contains('https://voz.vn/u/', 0)) {
          Get.toNamed(Routes.Profile, arguments: [url.replaceFirst(GlobalController.i.url, '', 0)], preventDuplicates: false);
        } else if (url.contains('/goto/post?id', 0)) {
          onGoToPost(url.split('?id=')[1], url);
        } else
          // print(url.toString().split('?id=')[1]);
          //
          //   var i =  htmlData.firstWhere((element) => element['postID'] == url.toString().split('?id=')[1]);
          //   print(htmlData.indexOf(i));
          GlobalController.i.launchURL(url);
      }
    },
  );
}
