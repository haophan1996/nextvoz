import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:expandable/expandable.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:loader_skeleton/loader_skeleton.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import '/GlobalController.dart';
import '/Page/NavigationDrawer/NaviDrawerController.dart';
import '/Page/View/ViewController.dart';
import 'Profile/UserProfile/UserProfileController.dart';
import 'package:cached_network_image/cached_network_image.dart';

///  * Global appbar
PreferredSize preferredSize(BuildContext context, String title, String prefix) => PreferredSize(
      preferredSize: Size.fromHeight(NaviDrawerController.i.heightAppbar),
      child: /* Obx(()=>*/ AppBar(
        automaticallyImplyLeading: false,
        title: customTitle(FontWeight.normal, Get.theme.primaryColor, 2, prefix, title),
        leading: (ModalRoute.of(context)?.canPop ?? false) ? BackButton() : null,
        bottom: PreferredSize(
          child: GetBuilder<GlobalController>(
            builder: (controller) {
              return LinearProgressIndicator(
                value: controller.percentDownload,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0CF301)),
                backgroundColor: Theme.of(context).backgroundColor,
              );
            },
          ),
          preferredSize: Size.fromHeight(4.0),
        ),
      ),
    );

/// * Appbar only for PostStatus and Pop
PreferredSize appBarOnly(String title, List<Widget> action) {
  return PreferredSize(
    preferredSize: Size.fromHeight(NaviDrawerController.i.heightAppbar),
    child: AppBar(
      automaticallyImplyLeading: false,
      title: Text(title.tr),
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
Widget blockItem(BuildContext context, FontWeight themeTitleWeight, FontWeight titleWeight, int index, String header11, String header12,
        String header21, String header22, String header3, Function onTap, Function onLongPress) =>
    Padding(
      padding: EdgeInsets.only(top: 1, left: 8, right: 8),
      child: InkWell(
        splashFactory: InkRipple.splashFactory,
        onTap: () => onTap(),
        onLongPress: () => onLongPress(),
        child: Ink(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 0.5, color: Theme.of(context).primaryColor),
            ),
          ),
          padding: EdgeInsets.only(top: 4, bottom: 5),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    customTitle(titleWeight, Get.theme.primaryColor, null, header11, header12),
                    Text(
                      "$header21 \u2022 $header22",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Text(
                      header3,
                      style: TextStyle(color: Colors.grey /**/),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
                //flex: 1,
              ),
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

Widget customTitle(FontWeight titleWeight, Color titleColor, int? maxLines, String header11, String header12) {
  return RichText(
    maxLines: maxLines,
    overflow: maxLines == 1 || maxLines == 2 ? TextOverflow.ellipsis : TextOverflow.clip,
    textAlign: maxLines == 2 ? TextAlign.center : TextAlign.start,
    text: customTitleChild(titleWeight, titleColor, header11, header12),
  );
}

TextSpan customTitleChild(FontWeight titleWeight, Color titleColor, String header11, String header12) {
  return TextSpan(children: [
    WidgetSpan(
      child: Container(
        padding: EdgeInsets.only(left: header11 == '' ? 0 : 4, right: header11 == '' ? 0 : 4),
        decoration: BoxDecoration(color: GlobalController.i.mapColor[header11], borderRadius: BorderRadius.all(Radius.circular(6))),
        child: Text(
          header11,
          style: TextStyle(
            fontSize: 14,
            fontWeight: titleWeight,
            color: GlobalController.i.mapInvertColor[GlobalController.i.getColorInvert(header11)],
          ),
        ),
      ),
    ),
    TextSpan(
      text: header12,
      style: TextStyle(color: titleColor /*Get.theme.primaryColor*/, fontSize: 15, fontWeight: titleWeight),
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
                  if (GlobalController.i.alertList.isEmpty || GlobalController.i.alertNotifications != 0) {
                    GlobalController.i.alertList.clear();
                    await GlobalController.i.getAlert();
                  }
                  await Get.toNamed('/Alerts', preventDuplicates: false);
                  //await Get.to(()=> Popup(), preventDuplicates: false, arguments: [0]);
                }),
            GetBuilder<GlobalController>(builder: (controller) {
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
            CupertinoButton(
                child: Icon(
                  Icons.mail_outline,
                  color: Get.theme.primaryColor,
                ),
                onPressed: () async {
                  if (GlobalController.i.inboxList.isEmpty == true || GlobalController.i.inboxNotifications != 0) {
                    GlobalController.i.inboxList.clear();
                    await GlobalController.i.getInboxAlert();
                  }
                  await Get.toNamed('/AlertsInbox', preventDuplicates: false);
                }),
            GetBuilder<GlobalController>(builder: (controller) {
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
        CupertinoButton(
            child: Icon(
              Icons.settings,
              color: Get.theme.primaryColor,
            ),
            onPressed: () => NaviDrawerController.i.navigateToSetting()),
      ],
    );

Widget textDrawer(Color color, double? fontSize, String text, FontWeight fontWeight) =>
    Text(text, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: color, fontWeight: fontWeight, fontSize: fontSize));

Widget popUpWaiting(String one, String two) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CupertinoActivityIndicator(),
        SizedBox(
          height: 20,
        ),
        DefaultTextStyle(
          style: TextStyle(color: Get.theme.primaryColor),
          child: Text(one + '\n' + two),
        ),
      ],
    );

Widget inputCustom(TextEditingController controller, bool obscureText, String hint, Function onEditingComplete) {
  return TextField(
    onEditingComplete: () async => await onEditingComplete(),
    textInputAction: TextInputAction.next,
    controller: controller,
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

setDialog(String textF, String textS) => Get.defaultDialog(
    barrierDismissible: false,
    radius: 6,
    backgroundColor: Get.theme.canvasColor.withOpacity(0.8),
    content: popUpWaiting(textF, textS),
    title: 'status'.tr);

setDialogError(String text) => Get.defaultDialog(
      content: Text(text, textAlign: TextAlign.center),
      textConfirm: 'Ok',
      title: 'Error',
      confirmTextColor: Colors.white,
      onConfirm: () => Get.back(),
      buttonColor: Colors.red,
      backgroundColor: Get.theme.canvasColor,
    );

Widget loadingShimmer() {
  return Get.isDarkMode == false
      ? CardListSkeleton(
          isCircularImage: true,
          isBottomLinesActive: true,
          length: 5,
        )
      : DarkCardListSkeleton(
          isCircularImage: true,
          isBottomLinesActive: true,
          length: 5,
        );
}

Widget buildFlagsPreviewIcon(String path, String text) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          Text(
            text.tr,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w300,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 7.5),
          Image.asset(path, height: 30),
        ],
      ),
    );

Widget buildIcon(String path, String text) => Row(
      children: [
        Image.asset(
          path,
          height: 17,
          width: 17,
        ),
        Text(' ' + text.tr)
      ],
    );

Widget reactionChild(ViewController controller, int index) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 50,
        height: 50,
        child: Stack(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: controller.reactionList.elementAt(index)['rAvatar'] == 'no'
                        ? Image.asset(
                            "assets/NoAvata.png",
                          ).image
                        : CachedNetworkImageProvider(
                            GlobalController.i.url + controller.reactionList.elementAt(index)['rAvatar'],
                          )),
                //ExtendedNetworkImageProvider(GlobalController.i.url + controller.reactionList.elementAt(index)['rAvatar'], cache: true)),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: AssetImage('assets/reaction/${controller.reactionList.elementAt(index)['rReactIcon']}.png'))),
              ),
            )
          ],
        ),
      ),
      Expanded(
          child: Padding(
        padding: EdgeInsets.only(left: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.reactionList.elementAt(index)['rName'],
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFD6E00)),
            ),
            Text(controller.reactionList.elementAt(index)['rTitle']),
            Text(
                'Mess: ${controller.reactionList.elementAt(index)['rMessage']} • React score: ${controller.reactionList.elementAt(index)['rMessage2']} • Points: ${controller.reactionList.elementAt(index)['rMessage3']}'),
            Text(controller.reactionList.elementAt(index)['rTime']),
            Divider()
          ],
        ),
      ))
    ],
  );
}

Widget listReactionUI(BuildContext context, ViewController controller) {
  return DraggableScrollableSheet(
    initialChildSize: 1,
    builder: (_, dragController) => Container(
        padding: EdgeInsets.only(left: 5, top: 5),
        decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6))),
        child: Obx(() => controller.reactionList.length > 0
            ? ListView.builder(
                physics: BouncingScrollPhysics(),
                controller: dragController,
                itemCount: controller.reactionList.length,
                itemBuilder: (context, index) {
                  return reactionChild(controller, index);
                })
            : Center(
                child: Text('No reaction'),
              ))),
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
            onPressed: () {}),
        CupertinoButton(
            child: Container(
              width: Get.width,
              child: Text('Ignore'),
            ),
            onPressed: () {}),
        CupertinoButton(
            child: Container(
              width: Get.width,
              child: Text('View Profile'),
            ),
            onPressed: () async {
              if (Get.isBottomSheetOpen == true) Get.back();
              GlobalController.i.sessionTag.add('profile${DateTime.now().toString()}');
              Get.lazyPut<UserProfileController>(() => UserProfileController(), tag: GlobalController.i.sessionTag.last);
              Get.toNamed('/UserProfile', arguments: [controller.htmlData.elementAt(index)['userLink']], preventDuplicates: false);
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

Widget onTapMine(context, ViewController controller, int index) {
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
                              inputCustom(controller.input, false, 'Reason for deletion', () => controller.deletePost(controller.input.text, index)),
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

Widget viewContent(BuildContext context, int index, ViewController controller) => Container(
      //color: Get.theme.backgroundColor,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Get.theme.canvasColor)),
        color: Get.theme.backgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CupertinoButton(
              padding: EdgeInsets.zero,
              child: Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 5, left: 5, bottom: 5),
                        child: displayAvatar(
                            48,
                            controller.htmlData.elementAt(index)["avatarColor1"],
                            controller.htmlData.elementAt(index)["avatarColor2"],
                            controller.htmlData.elementAt(index)["userName"],
                            controller.htmlData.elementAt(index)["userAvatar"]),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 10),
                        child: RichText(
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                                text: controller.htmlData.elementAt(index)['userName'] + "\n",
                                style: TextStyle(
                                    color: controller.htmlData.elementAt(index)['newPost'] == true ? Color(0xFFFD6E00) : Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                            TextSpan(
                                text: controller.htmlData.elementAt(index)['userTitle'],
                                style: TextStyle(color: Get.theme.primaryColor, fontSize: 13)),
                          ]),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, right: 10),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text('${controller.htmlData.elementAt(index)['userPostDate']}\n ${controller.htmlData.elementAt(index)['orderPost']}',
                          textAlign: TextAlign.right, style: TextStyle(color: Get.theme.primaryColor, fontSize: 13)),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                Get.bottomSheet(
                    Card(
                      color: Get.theme.canvasColor,
                      child: controller.htmlData.elementAt(index)['userName'] == NaviDrawerController.i.nameUser.value
                          ? onTapMine(context, controller, index)
                          : onTapUser(controller, index),
                    ),
                    ignoreSafeArea: false);
              }),
          customHtml(controller.htmlData, index),
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: Row(
              children: [
                controller.htmlData.elementAt(index)['commentImage'].toString() != 'no'
                    ? Image.asset('assets/reaction/' + controller.htmlData.elementAt(index)['commentImage'][0] + '.png', width: 17, height: 17)
                    : Container(),
                controller.htmlData.elementAt(index)['commentImage'].toString().length > 1 &&
                        controller.htmlData.elementAt(index)['commentImage'].toString() != 'no'
                    ? Image.asset('assets/reaction/' + controller.htmlData.elementAt(index)['commentImage'][1] + '.png', width: 17, height: 17)
                    : Container(),
                Expanded(
                  child: TextButton(
                    style: ButtonStyle(alignment: Alignment.centerLeft),
                    onPressed: () {
                      controller.getDataReactionList(index);
                      Get.bottomSheet(listReactionUI(context, controller), isScrollControlled: false, ignoreSafeArea: true);
                    },
                    child: Text(controller.htmlData.elementAt(index)['commentName'],
                        style: TextStyle(color: Colors.blue), overflow: TextOverflow.ellipsis, maxLines: 1),
                  ),
                ),
                FlutterReactionButton(
                  onReactionChanged: (reaction, i) {
                    if (GlobalController.i.isLogged == false) {
                      controller.update();
                      setDialogError('popMess4'.tr);
                    } else {
                      if (controller.htmlData.elementAt(index)['commentByMe'] != i) {
                        if (i == 0) {
                          controller
                              .reactionPost(
                                  index, controller.htmlData.elementAt(index)['postID'], controller.htmlData.elementAt(index)['commentByMe'], context)
                              .then((value) {
                            if (value['status'] != 'error') {
                              controller.htmlData.elementAt(index)['commentByMe'] = 0;
                            } else {
                              setDialogError(value['mess']);
                            }
                          });
                        } else {
                          controller.reactionPost(index, controller.htmlData.elementAt(index)['postID'], i, context).then((value) {
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
                TextButton(
                    onPressed: () {
                      Future.delayed(Duration(milliseconds: 100), () {
                        // controller.reply();
                        controller.quote(index);
                      });
                    },
                    child: Text('rep'.tr))
              ],
            ),
          )
        ],
      ),
    );

Widget displayAvatar(double sizeImage, String avatarColor1, String avatarColor2, String? userName, String imageLink) {
  return Container(
      width: sizeImage,
      height: sizeImage,
      decoration: BoxDecoration(
          color: Color(
            int.parse(avatarColor1),
          ),
          shape: BoxShape.circle),
      child: Center(
        child: imageLink == 'no'
            ? Text(
                imageLink == 'no' ? userName!.toUpperCase()[0] : '',
                style:
                    TextStyle(color: Color(int.parse(avatarColor2)), fontWeight: FontWeight.bold, fontSize: Get.theme.textTheme.headline5!.fontSize),
              )
            : CachedNetworkImage(
                imageUrl: imageLink,
                fit: BoxFit.fill,
              ),
      ));
}

Widget customHtml(List htmlData, int index) {
  return Html(
    data: htmlData.elementAt(index)['postContent'],
    tagsList: Html.tags..remove('noscript')..remove(GlobalController.i.userStorage.read('showImage') == true ? '' : 'img'),
    customRender: {
      "img": (renderContext, child) {
        double? width = double.tryParse(renderContext.tree.element!.attributes['width'].toString());
        double? height = double.tryParse(renderContext.tree.element!.attributes['height'].toString());

        if (renderContext.tree.element!.attributes['src']!.contains("/styles/next/xenforo")) {
          return Image.asset(GlobalController.i.getEmoji(renderContext.tree.element!.attributes['src'].toString()));
        } else if (renderContext.tree.element!.attributes['src']!.contains("twemoji.maxcdn.com")) {
          return Text(
            renderContext.tree.element!.attributes['alt']!,
            style: TextStyle(fontSize: GlobalController.i.userStorage.read('fontSizeView')),
          );
        } else if (renderContext.tree.element!.attributes['data-url'] != null &&
            renderContext.tree.element!.attributes['data-url']!.contains(".gif")) {
        } else {
          return PinchZoomImage(
            image: CachedNetworkImage(
              imageUrl: renderContext.tree.element!.attributes['src']!.contains('data:image/', 0) == true
                  ? renderContext.tree.element!.attributes['data-src'].toString()
                  : renderContext.tree.element!.attributes['src'].toString(),
              filterQuality: FilterQuality.low,
              errorWidget: (context, url, dy) {
                return AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Container(
                    width: width != null ? width : 50,
                    height: height != null ? height : 50,
                    child: customCupertinoButton(Alignment.center, EdgeInsets.zero, Text(url), () => GlobalController.i.launchURL(url)),
                  ),
                );
              },
              placeholder: (context, c) {
                if (width != null) {
                  return Image.asset(
                    'assets/reaction/nil.png',
                    width: width,
                    height: height,
                  );
                } else {
                  return AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Container(
                      width: width != null ? width : 50,
                      height: height != null ? height : 50,
                    ),
                  );
                }
              },
            ),
            //minScale: 0.5,
            //maxScale: 3.0,
          );
        }
      },
      "blockquote": (renderContext, child) {
        return ExpandableNotifier(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expandable(
                expanded: ExpandableButton(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                        'blockQuote'.tr +
                            (renderContext.tree.element!.getElementsByClassName("bbCodeBlock-title").length > 0
                                ? renderContext.tree.element!.getElementsByClassName("bbCodeBlock-title")[0].text.trim()
                                : ""),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Get.theme.secondaryHeaderColor,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                ),
                collapsed: ExpandableButton(
                  child: Container(
                      constraints: BoxConstraints(minHeight: 30),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Get.theme.cardColor,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Center(
                        child: child,
                      )),
                ),
              ),
            ],
          ),
        );
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
                  Get.toNamed('/Youtube', arguments: [GlobalController.i.getIDYoutube(attrs['src'].toString())]);
                },
                child: Stack(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: CachedNetworkImage(
                          imageUrl: 'https://img.youtube.com/vi/$link/0.jpg',
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
                    Positioned(
                      child: Text(
                        'Nếu youtube không play được, vui lòng nhấn vô \nlink phía trên',
                        style: TextStyle(
                            fontSize: GlobalController.i.userStorage.read('fontSizeView'),
                            color: Colors.white,
                            background: Paint()..color = Colors.red),
                        maxLines: 2,
                      ),
                      top: 25,
                      left: 5,
                    ),
                  ],
                ),
              )
            ],
          );
        }

        // double? width = double.tryParse(attrs!['width'] ?? "");
        // double? height = double.tryParse(attrs['height'] ?? "");
        // return Container(
        //   width: width,
        //   height: height,
        //   child: WebView(
        //     javascriptMode: JavascriptMode.unrestricted,
        //     initialUrl: attrs['src'],
        //     navigationDelegate: (NavigationRequest request) async {
        //       if (attrs['src'] != null && attrs['src']!.contains("youtube.com/embed")) {
        //         if (!request.url.contains("youtube.com/embed")) {
        //           return NavigationDecision.prevent;
        //         } else {
        //           return NavigationDecision.navigate;
        //         }
        //       } else {
        //         return NavigationDecision.navigate;
        //       }
        //     },
        //   ),
        // );
      }
    },
    style: {
      "code": Style(color: Colors.blue),
      "table": Style(backgroundColor: Get.theme.cardColor),
      "body": Style(
        fontSize: FontSize(GlobalController.i.userStorage.read('fontSizeView')),
      ), //..margin = EdgeInsets.only(bottom: 0, left: 4, right: 3),
      "div": Style()..display = Display.INLINE,
      // "span": Style(color: Theme.of(context).primaryColor),
      "blockquote": Style(width: double.infinity)
        ..margin = EdgeInsets.only(left: 5.0, right: 5.0, bottom: 10.0)
        ..display = Display.BLOCK,
    },
    onLinkTap: (String? url, RenderContext context, Map<String, String> attributes, dom.Element? element) async {
      if (url != null) {
        if (url.contains('https://voz.vn/t/', 0)) {
          GlobalController.i.sessionTag.add('ViewController at $url');
          Get.lazyPut<ViewController>(() => ViewController(), tag: GlobalController.i.sessionTag.last);
          Get.toNamed("/ViewPage", arguments: [url.replaceFirst(GlobalController.i.url + '/t/', '', 0), url, '', 0], preventDuplicates: false);
        } else if (url.contains('https://voz.vn/u/', 0)) {
          GlobalController.i.sessionTag.add('profile${DateTime.now().toString()}');
          Get.lazyPut<UserProfileController>(() => UserProfileController(), tag: GlobalController.i.sessionTag.last);
          Get.toNamed('/UserProfile', arguments: [url.replaceFirst(GlobalController.i.url, '', 0)], preventDuplicates: false);
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

final Shader linearGradient = LinearGradient(
  colors: <Color>[Colors.red, Colors.blue],
).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
