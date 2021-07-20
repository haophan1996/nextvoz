import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:expandable/expandable.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vozforums/GlobalController.dart';
import 'package:vozforums/Page/NavigationDrawer/NaviDrawerController.dart';
import 'package:vozforums/Page/View/ViewController.dart';
import 'package:html/dom.dart' as dom;
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:vozforums/Page/pageLoadNext.dart';

///  * Global appbar
PreferredSize preferredSize(BuildContext context, String title, String prefix) => PreferredSize(
      preferredSize: Size.fromHeight(NaviDrawerController.i.heightAppbar),
      child: /* Obx(()=>*/ AppBar(
        automaticallyImplyLeading: false,
        title: customTitle(context, FontWeight.normal, 2, prefix, title),
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

/// * [header11] - [header12] black/white color depends on Dark/light mode.
/// * [header21] - [header22] grey color default.
/// * [header3] orange color default.
Widget blockItem(BuildContext context, FontWeight themeTitleWeight, FontWeight titleWeight, int index, String header11, String header12,
        String header21, String header22, String header3, Function onTap, Function onLongPress) =>
    Padding(
      padding: EdgeInsets.only(top: 1, left: 8),
      child: InkWell(
        focusColor: Colors.red,
        hoverColor: Colors.red,
        highlightColor: Colors.red,
        splashColor: Colors.red,
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
                    customTitle(context, titleWeight, null, header11, header12),
                    Text(
                      "$header21 \u2022 $header22",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Text(
                      header3,
                      style: TextStyle(color: Color(0xFFFD6E00)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
                flex: 1,
              ),
              Icon(
                Icons.arrow_forward_ios_outlined,
                color: Colors.grey,
                size: 18,
              )
            ],
          ),
        ),
      ),
    );

Widget buttonToolHtml(IconData iconData ,String message ,Function onPressed) => CupertinoButton(
    padding: EdgeInsets.zero,
    child: Tooltip(
      message: message,
      preferBelow: false,
      child: Icon(iconData, color: Get.theme.primaryColor),
    ),
    onPressed: ()=> onPressed());

Widget customTitle(BuildContext context, FontWeight titleWeight, int? maxLines, String header11, String header12) {
  return RichText(
    maxLines: maxLines,
    overflow: maxLines == 1 || maxLines == 2 ? TextOverflow.ellipsis : TextOverflow.clip,
    textAlign: maxLines == 2 ? TextAlign.center : TextAlign.start,
    text: TextSpan(children: [
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
        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15, fontWeight: titleWeight),
      )
    ]),
  );
}

Widget settings(BuildContext context) => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            CupertinoButton(
                child: Icon(
                  Icons.notifications_none_outlined,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () async {
                  if (GlobalController.i.alertList.isEmpty || GlobalController.i.alertNotifications != 0) {
                    GlobalController.i.alertList.clear();
                    await GlobalController.i.getAlert();
                  }
                  await Get.toNamed('/Pop', preventDuplicates: false);
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
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {}),
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
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () => NaviDrawerController.i.navigateToSetting()),
      ],
    );

Widget textDrawer(Color color, double fontSize, String text, FontWeight fontWeight) =>
    Text(text, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: color, fontWeight: fontWeight, fontSize: fontSize));

Widget popUpWaiting( String one, String two) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CupertinoActivityIndicator(),
        SizedBox(
          height: 20,
        ),
        DefaultTextStyle(
          style: TextStyle(color: Get.theme.primaryColor),
          child: AnimatedTextKit(
            repeatForever: true,
            isRepeatingAnimation: true,
            animatedTexts: [WavyAnimatedText(one), WavyAnimatedText(two)],
          ),
        ),
      ],
    );

Widget inputCustom(TextEditingController controller, bool obscureText, String hint,Function onEditingComplete){
  return TextField(
    onEditingComplete: () async {
      await onEditingComplete();
    },
    textInputAction: TextInputAction.next,
    controller: controller,
    style: TextStyle(fontSize: 18, color: Get.theme.primaryColor),
    obscureText: obscureText,
    decoration: InputDecoration(
      labelText: hint.tr,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xffCED0D2), width: 1),
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

Widget buildFlagsPreviewIcon(String path, String tex) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          Text(
            tex,
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

Widget rowNew(String pathImage, Widget text) => Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 5),
          child: Image.asset(
            pathImage,
            width: 10,
          ),
        ),
        text,
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
                        : ExtendedNetworkImageProvider(GlobalController.i.url + controller.reactionList.elementAt(index)['rAvatar'], cache: true)),
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

Widget onTapUser() {
  return Column(
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
            child: Text('Follow'),
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
          onPressed: () {}),
      CupertinoButton(
          child: Container(
            width: Get.width,
            child: Text('Report'),
          ),
          onPressed: () {}),
    ],
  );
}

Widget onTapMine(ViewController controller, int index){
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      CupertinoButton(
          child: Container(
            width: Get.width,
            child: Text('Edit'),
          ),
          onPressed: ()async => controller.editRep(index)),
      CupertinoButton(
          child: Container(
            width: Get.width,
            child: Text('Delete'),
          ),
          onPressed: () {})
    ],
  );
}

Widget viewContent(BuildContext context, int index, ViewController controller) => Container(
      color: Theme.of(context).backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Card(
              elevation: 5,
              color: Theme.of(context).canvasColor,
              child: Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 5, left: 5, bottom: 5),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: controller.htmlData.elementAt(index)["userAvatar"] == "no"
                                  ? Image.asset(
                                      "assets/NoAvata.png",
                                      height: 48,
                                      width: 48,
                                    ).image
                                  : ExtendedNetworkImageProvider(controller.htmlData.elementAt(index)["userAvatar"], cache: true),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 10),
                        child: RichText(
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () => Get.bottomSheet(Card(
                                    color: Theme.of(context).canvasColor,
                                    child: controller.htmlData.elementAt(index)['userName'] == NaviDrawerController.i.nameUser.value ? onTapMine(controller, index) : onTapUser(),
                                  )),
                                text: controller.htmlData.elementAt(index)['userName'] + "\n",
                                style: TextStyle(color: Color(0xFFFD6E00), fontWeight: FontWeight.bold, fontSize: 16)),
                            TextSpan(
                                text: controller.htmlData.elementAt(index)['userTitle'],
                                style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 13)),
                          ]),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, right: 10),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(controller.htmlData.elementAt(index)['userPostDate'], style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 13)),
                          controller.htmlData.elementAt(index)['newPost'] == false
                              ? Text(
                                  controller.htmlData.elementAt(index)['orderPost'], style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 13))
                              : rowNew(
                                  'assets/newPost.png',
                                  Text(controller.htmlData.elementAt(index)['orderPost'],
                                      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 13)))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Html(
            data: controller.htmlData.elementAt(index)['postContent'],
            customRender: {
              "img": (renderContext, child) {
                 // double? width = double.tryParse(renderContext.tree.element!.attributes['width'].toString());
                 // double? height = double.tryParse(renderContext.tree.element!.attributes['height'].toString());
                 //
                if (renderContext.tree.element!.attributes['src']!.contains("/styles/next/xenforo")) {
                  return Image.asset(GlobalController.i.getEmoji(renderContext.tree.element!.attributes['src'].toString()));
                } else if (renderContext.tree.element!.attributes['src']!.contains("twemoji.maxcdn.com")) {
                  return Text(
                    renderContext.tree.element!.attributes['alt']!,
                    style: TextStyle(fontSize: 25),
                  );
                } else {
                  return PinchZoomImage(
                    image: ExtendedImage.network(
                      renderContext.tree.element!.attributes['src'].toString(),
                     //width: width,
                      //height: height,
                      cache: true,
                      clearMemoryCacheIfFailed: true,
                    ),
                    zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
                    onZoomStart: () {
                      print('Zoom started');
                    },
                    onZoomEnd: () {
                      print('Zoom finished');
                    },
                  );
                }
              },
              "blockquote": (renderContext, child) {
                renderContext.tree.children.forEach((element) {
                  element.style = Style(
                    display: Display.INLINE,
                  );
                });
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
                                        ? renderContext.tree.element!
                                            .getElementsByClassName("bbCodeBlock-title")[0]
                                            .getElementsByTagName("a")[0]
                                            .innerHtml
                                            .toString()
                                        : ""),
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context).secondaryHeaderColor,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
                        ),
                        collapsed: ExpandableButton(
                          child: Container(
                              constraints: BoxConstraints(minHeight: 30),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
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
                if (context.tree.element!.getElementsByTagName("td")[0].innerHtml.length > 1)
                  return SingleChildScrollView(
                    scrollDirection: (context.tree.element!.getElementsByTagName("tr").length > 1) ||
                            (context.tree.element!.getElementsByTagName("a")[0].text.length > 25)
                        ? Axis.horizontal
                        : Axis.vertical,
                    padding: EdgeInsets.all(2),
                    physics: BouncingScrollPhysics(),
                    child: (context.tree as TableLayoutElement).toWidget(context),
                  );
              },
              "iframe": (RenderContext context, Widget child) {
                final attrs = context.tree.element?.attributes;
                final link = controller.getIDYoutube(attrs!['src'].toString());
                double? width = double.tryParse(attrs['width'] ?? "");
                double? height = double.tryParse(attrs['height'] ?? "");
                return Column(
                  children: [
                    CupertinoButton(
                        minSize: 0,
                        padding: EdgeInsets.zero,
                        child: Text('https://www.youtube.com/watch?v=$link'),
                        onPressed: () async => await controller.launchURL('https://www.youtube.com/watch?v=$link')),
                    CupertinoButton(
                      minSize: 0,
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Get.toNamed('/Youtube', arguments: [controller.getIDYoutube(attrs['src'].toString())]);
                      },
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: ExtendedImage.network(
                              'https://img.youtube.com/vi/$link/0.jpg',
                              clearMemoryCacheWhenDispose: true,
                              width: width,
                              height: height,
                            ),
                          ),
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
              "table": Style(backgroundColor: Theme.of(context).cardColor),
              "body": Style(
                fontSize: FontSize(GlobalController.i.userStorage.read('fontSizeView')),
              )..margin = EdgeInsets.only(bottom: 0, left: 4, right: 3),
             // "span": Style(color: Theme.of(context).primaryColor),
              "blockquote": Style(width: double.infinity)
                ..margin = EdgeInsets.only(left: 5.0, right: 5.0, bottom: 10.0)
                ..display = Display.BLOCK,
            },
            onLinkTap: (String? url, RenderContext context, Map<String, String> attributes, dom.Element? element) async {
              print(url);
              controller.launchURL(url!);
            },
          ),
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
                    if (GlobalController.i.isLogged.value == false) {
                      Get.snackbar('error'.tr, 'popMess4'.tr, snackPosition: SnackPosition.BOTTOM, isDismissible: true);
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

Widget postContent(BuildContext context, dynamic controller) {
  return refreshIndicatorConfiguration(
    Scrollbar(
      child: SmartRefresher(
        enablePullDown: false,
        enablePullUp: true,
        controller: controller.refreshController,
        onLoading: () {
          controller.setPageOnClick((controller.currentPage + 1).toString());
        },
        child: ListView.builder(
          cacheExtent: 99999,
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 2),
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          controller: controller.listViewScrollController,
          itemCount: controller.htmlData.length,
          itemBuilder: (context, index) {
            return viewContent(context, index, controller);
          },
        ),
      ),
    ),
  );
}

final Shader linearGradient = LinearGradient(
  colors: <Color>[Colors.red, Colors.blue],
).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
