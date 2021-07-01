import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:expandable/expandable.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:get/get.dart';
import 'package:vozforums/GlobalController.dart';
import 'package:vozforums/Page/NavigationDrawer/NaviDrawerController.dart';
import 'package:vozforums/Page/View/ViewController.dart';
import 'package:vozforums/pop.dart';
import 'package:html/dom.dart' as dom;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';

///  * Global appbar
PreferredSize preferredSize(BuildContext context, String title, String prefix) => PreferredSize(
      preferredSize: Size.fromHeight(NaviDrawerController.i.heightAppbar),
      child: /* Obx(()=>*/ AppBar(
        automaticallyImplyLeading: false,
        title: customTitle(context, FontWeight.normal, 2,prefix, title),
        leading: (ModalRoute.of(context)?.canPop ?? false) ? BackButton() : null,
        actions: <Widget>[
          Stack(
            children: [
              Hero(
                flightShuttleBuilder: (
                  BuildContext flightContext,
                  Animation<double> animation,
                  HeroFlightDirection flightDirection,
                  BuildContext fromHeroContext,
                  BuildContext toHeroContext,
                ) {
                  return Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.8,
                      color: Theme.of(context).backgroundColor,
                    ),
                  );
                },
                tag: 'noti',
                child: IconButton(
                    onPressed: () async {
                      if (GlobalController.i.alertList.isEmpty) await GlobalController.i.getAlert();
                      Get.to(() => Popup(), fullscreenDialog: true, opaque: false);
                    },
                    icon: Icon(Icons.notifications)),
              ),
              GetBuilder<GlobalController>(builder: (controller) {
                return Positioned(
                  right: 0,
                  top: 3,
                  child: Container(
                    width: 30,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: controller.alertNotification == '0' ? Colors.transparent : Colors.red),
                    child: Center(
                      child: Text(controller.alertNotification == '0' ? '' : controller.alertNotification),
                    ),
                  ),
                );
              })
            ],
          )
        ],
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
                    customTitle(context, titleWeight, null,header11, header12),
                    text(
                      "$header21 \u2022 $header22",
                      TextStyle(color: Colors.grey, fontSize: 12),
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

Widget customTitle(BuildContext context, FontWeight titleWeight, int? maxLines,String header11, String header12) {
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

Widget settings(BuildContext context) => TextButton.icon(
      onPressed: () => NaviDrawerController.i.navigateToSetting(),
      icon: Icon(Icons.settings),
      label: text(
        'setPage'.tr,
        TextStyle(color: Theme.of(context).primaryColor),
      ),
    );

Widget textDrawer(Color color, double fontSize, String text, FontWeight fontWeight) =>
    Text(text, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: color, fontWeight: fontWeight, fontSize: fontSize));

Widget popUpWaiting(BuildContext context, String one, String two) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CupertinoActivityIndicator(),
        SizedBox(
          height: 20,
        ),
        DefaultTextStyle(
          style: TextStyle(color: Theme.of(context).primaryColor),
          child: AnimatedTextKit(
            repeatForever: true,
            isRepeatingAnimation: true,
            animatedTexts: [WavyAnimatedText(one), WavyAnimatedText(two)],
          ),
        ),
      ],
    );

setDialog(BuildContext context, String textF, String textS) => Get.defaultDialog(
    barrierDismissible: false,
    radius: 6,
    backgroundColor: Theme.of(context).canvasColor.withOpacity(0.8),
    content: popUpWaiting(context, textF, textS),
    title: 'status'.tr);

Widget builFlagsdPreviewIcon(String path, String tex) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          text(
            tex,
            TextStyle(
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

Widget text(String text, TextStyle style) => Text(
      text,
      style: style,
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
                          text(controller.htmlData.elementAt(index)['userPostDate'], TextStyle(color: Theme.of(context).primaryColor, fontSize: 13)),
                          controller.htmlData.elementAt(index)['newPost'] == false
                              ? text(
                                  controller.htmlData.elementAt(index)['orderPost'], TextStyle(color: Theme.of(context).primaryColor, fontSize: 13))
                              : rowNew(
                                  'assets/newPost.png',
                                  text(controller.htmlData.elementAt(index)['orderPost'],
                                      TextStyle(color: Theme.of(context).primaryColor, fontSize: 13)))
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
                if (renderContext.tree.element!.attributes['src']!.contains("/styles/next/xenforo")) {
                  return Image.asset(GlobalController.i.getEmoji(renderContext.tree.element!.attributes['src'].toString()));
                } else if (renderContext.tree.element!.attributes['src']!.contains("twemoji.maxcdn.com")) {
                  return text(
                    renderContext.tree.element!.attributes['alt']!,
                    TextStyle(fontSize: 25),
                  );
                } else if (renderContext.tree.element!.attributes['alt']!.contains(".gif") == false) {
                  return PinchZoomImage(
                    image: ExtendedImage.network(
                      renderContext.tree.element!.attributes['src'].toString(),
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
                } else {
                  return ExtendedImage.network(
                    renderContext.tree.element!.attributes['src'].toString(),
                    imageCacheName: renderContext.tree.element!.attributes['alt']!.split('.gif')[0] + '.jpeg',
                    cache: true,
                    clearMemoryCacheIfFailed: true,
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
                            child: text(
                                'blockQuote'.tr +
                                    (renderContext.tree.element!.getElementsByClassName("bbCodeBlock-title").length > 0
                                        ? renderContext.tree.element!
                                            .getElementsByClassName("bbCodeBlock-title")[0]
                                            .getElementsByTagName("a")[0]
                                            .innerHtml
                                            .toString()
                                        : ""),
                                TextStyle(fontWeight: FontWeight.bold)),
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
                  //scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.all(2),
                  physics: BouncingScrollPhysics(),
                  child: (context.tree as TableLayoutElement).toWidget(context),
                );
              },
              "iframe": (RenderContext context, Widget child) {
                final attrs = context.tree.element?.attributes;
                double? width = double.tryParse(attrs!['width'] ?? "");
                double? height = double.tryParse(attrs['height'] ?? "");
                return Container(
                  width: width,
                  height: height,
                  child: WebView(
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: attrs['src'],
                    navigationDelegate: (NavigationRequest request) async {
                      if (attrs['src'] != null && attrs['src']!.contains("youtube.com/embed")) {
                        if (!request.url.contains("youtube.com/embed")) {
                          return NavigationDecision.prevent;
                        } else {
                          return NavigationDecision.navigate;
                        }
                      } else {
                        return NavigationDecision.navigate;
                      }
                    },
                  ),
                );
              }
            },
            style: {
              "code": Style(color: Colors.blue),
              "table": Style(backgroundColor: Theme.of(context).cardColor),
              "body": Style(
                fontSize: FontSize(GlobalController.i.userStorage.read('fontSizeView')),
              )..margin = EdgeInsets.only(bottom: 0, left: 4, right: 3),
              "span": Style(color: Theme.of(context).primaryColor),
              "blockquote": Style(width: double.infinity)
                ..margin = EdgeInsets.only(left: 5.0, right: 5.0, bottom: 10.0)
                ..display = Display.BLOCK,
            },
            onLinkTap: (String? url, RenderContext context, Map<String, String> attributes, dom.Element? element) async {
              print(url);
              controller.launchURL(url!);
              // if (url?.isNotEmpty == true && url!.contains("/goto/post") && url != "no") {
              // }
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
                          controller.reactionPost(
                              index, controller.htmlData.elementAt(index)['postID'], controller.htmlData.elementAt(index)['commentByMe'], context);
                          controller.htmlData.elementAt(index)['commentByMe'] = 0;
                        } else {
                          controller.reactionPost(index, controller.htmlData.elementAt(index)['postID'], i, context);
                          controller.htmlData.elementAt(index)['commentByMe'] = i;
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
                TextButton(onPressed: () {}, child: text('rep'.tr, TextStyle()))
              ],
            ),
          )
        ],
      ),
    );
