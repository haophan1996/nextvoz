import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:expandable/expandable.dart';
import 'package:vozforums/Page/NavigationDrawer/NaviDrawerController.dart';
import 'package:vozforums/Page/NavigationDrawer/NaviDrawerUI.dart';
import 'package:vozforums/Page/pageLoadNext.dart';
import 'package:vozforums/GlobalController.dart';
import 'package:vozforums/Page/pageNavigation.dart';
import 'package:vozforums/Page/reuseWidget.dart';
import 'package:vozforums/Page/View/ViewController.dart';
import 'package:extended_image/extended_image.dart';
import 'package:photo_view/photo_view.dart';

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
          Obx(() => GlobalController.i.percentDownload.value == -1.0 ? Container() : percentBar()),
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
              return Padding(
                padding: EdgeInsets.only(bottom: 2),
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 5, left: 5),
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
                                  Text(controller.htmlData.elementAt(index)['userPostDate'],
                                      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 13)),
                                  Text(controller.htmlData.elementAt(index)['orderPost'],
                                      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 13)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: Theme.of(context).dividerColor,
                        indent: 10,
                        thickness: 1,
                      ),
                      Html(
                        data: controller.htmlData.elementAt(index)['postContent'],
                        shrinkWrap: true,
                        customRender: {
                          "img": (renderContext, child) {
                            if (renderContext.tree.element!.attributes['src']!.contains("/styles/next/xenforo")) {
                              return Image.asset(GlobalController.i.getEmoji(renderContext.tree.element!.attributes['src'].toString()));
                            } else if (renderContext.tree.element!.attributes['src']!.contains("twemoji.maxcdn.com")) {
                              return Text(
                                renderContext.tree.element!.attributes['alt']!,
                                style: TextStyle(fontSize: 25),
                              );
                            } else if (renderContext.tree.element!.attributes['data-url']!.contains(".gif") == false) {
                              return ExtendedImage.network(
                                renderContext.tree.element!.attributes['src'].toString(),
                                cache: true,
                                clearMemoryCacheIfFailed: true,
                              );
                            } else
                              return Text("data");
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
                                          "Quote: " +
                                              renderContext.tree.element!
                                                  .getElementsByClassName("bbCodeBlock-title")
                                                  .map((e) => e.getElementsByTagName("a")[0].innerHtml)
                                                  .toString(),
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
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
                            print(context.tree.attributes['src'].toString());
                            print("To do: iframe ViewUI");
                            controller.getYoutubeID(context.tree.attributes['src'].toString());
                            return Text("ascsacas");
                          }
                        },
                        style: {
                          "table": Style(backgroundColor: Theme.of(context).cardColor),
                          "body": Style(
                            fontSize: FontSize(17.0),
                          ),
                          "span": Style(color: Theme.of(context).primaryColor),
                          "blockquote": Style(width: double.infinity)
                            ..margin = EdgeInsets.only(left: 5.0, right: 5.0, bottom: 10.0)
                            ..display = Display.BLOCK,
                        },
                        onLinkTap: (String? url, RenderContext context, Map<String, String> attributes, dom.Element? element) {
                          if (url?.isNotEmpty == true && url!.contains("/goto/post") && url != "no") {
                            //print("https://voz.vn" + url);
                          }
                        },
                        onImageTap: (String? url, RenderContext renderContext, Map<String, String> attributes, dom.Element? element) async {
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
                        //tagsList: Html.tags..remove("value"),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
