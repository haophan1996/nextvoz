import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:expandable/expandable.dart';
import 'package:vozforums/Page/NavigationDrawer/NaviDrawerUI.dart';
import 'package:vozforums/Page/pageLoadNext.dart';
import 'package:vozforums/GlobalController.dart';
import 'package:vozforums/Page/pageNavigation.dart';
import 'package:vozforums/Page/reuseWidget.dart';
import 'package:vozforums/Page/View/ViewController.dart';
import 'package:extended_image/extended_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ViewUI extends GetView<ViewController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: NaviDrawerUI(),
      appBar: preferredSize(context, controller.subHeader),
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Obx(() => postContent(context)),
          ),
          Obx(
            () => pageNavigation(
              context,
              controller.itemScrollController,
              controller.currentPage.value,
              controller.totalPage.value,
              (index) => controller.setPageOnClick(index),
              () => controller.setPageOnClick(controller.totalPage.toString()),
              () => controller.setPageOnClick("1"),
            ),
          ),
        ],
      ),
    );
  }

  postContent(BuildContext context) {
    return refreshIndicatorConfiguration(
      Scrollbar(
        child: SmartRefresher(
          enablePullDown: false,
          enablePullUp: true,
          controller: controller.refreshController,
          onLoading: () {
            controller.setPageOnClick((controller.currentPage.value + 1).toString());
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
              return Container(
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
                                    text(controller.htmlData.elementAt(index)['userPostDate'],
                                        TextStyle(color: Theme.of(context).primaryColor, fontSize: 13)),
                                    controller.htmlData.elementAt(index)['newPost'] == false
                                        ? text(controller.htmlData.elementAt(index)['orderPost'],
                                            TextStyle(color: Theme.of(context).primaryColor, fontSize: 13))
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
                          } else if (renderContext.tree.element!.attributes['data-url']!.contains(".gif") == false) {
                            return InkWell(
                              onTap: () {
                                print('hey tap image');
                              },
                              child: ExtendedImage.network(
                                renderContext.tree.element!.attributes['src'].toString(),
                                cache: true,
                                clearMemoryCacheIfFailed: true,
                              ),
                            );
                          } else
                            return Image.network(renderContext.tree.element!.attributes['src'].toString());
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
                          return SingleChildScrollView(
                            scrollDirection: (context.tree.element!.getElementsByTagName("tr").length > 2) ? Axis.horizontal : Axis.vertical,
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
                      onImageTap: (String? url, RenderContext renderContext, Map<String, String> attributes, dom.Element? element) async {
                        print("tap");
                        Get.dialog(
                          Dismissible(
                            direction: DismissDirection.vertical,
                            onDismissed: (v) {
                              if (Get.isDialogOpen == true) {
                                Get.back(canPop: true);
                              }
                            },
                            key: const Key("value"),
                            child: PhotoView(
                              imageProvider: Image.file(await controller.getImage(url!)).image,
                            ),
                          ),
                          useSafeArea: true,
                          useRootNavigator: true,
                          transitionDuration: Duration(milliseconds: 2),
                        );
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Row(
                        children: [
                          controller.htmlData.elementAt(index)['commentImage'].toString() != 'no'
                              ? Image.asset('assets/reaction/' + controller.htmlData.elementAt(index)['commentImage'][0] + '.png',
                                  width: 22, height: 22)
                              : Container(),
                          controller.htmlData.elementAt(index)['commentImage'].toString().length > 1 &&
                                  controller.htmlData.elementAt(index)['commentImage'].toString() != 'no'
                              ? Image.asset('assets/reaction/' + controller.htmlData.elementAt(index)['commentImage'][1] + '.png',
                                  width: 22, height: 22)
                              : Container(),
                          Expanded(
                              child: Text(controller.htmlData.elementAt(index)['commentName'],
                                  style: TextStyle(color: Colors.blue), overflow: TextOverflow.ellipsis, maxLines: 1)),
                          FlutterReactionButton(
                            onReactionChanged: (reaction, i) {
                              if (GlobalController.i.isLogged.value == false) {
                                Get.snackbar('error'.tr, 'popMess4'.tr, snackPosition: SnackPosition.BOTTOM, isDismissible: true);
                                controller.htmlData.refresh();
                              } else {
                                if (controller.htmlData.elementAt(index)['commentByMe'] != i) {
                                  if (i == 0) {
                                    controller.reactionPost(index, controller.htmlData.elementAt(index)['postID'],
                                        controller.htmlData.elementAt(index)['commentByMe'], context);
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
            },
          ),
        ),
      ),
    );
  }
}
