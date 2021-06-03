import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vozforums/Page/ThreadView/ViewController.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:vozforums/Page/pageLoadNext.dart';
import '../../GlobalController.dart';
import '../pageNavigation.dart';
import '../reuseWidget.dart';

class ViewUI extends GetView<ViewController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: preferredSize(controller.subHeader, 50),
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: postContent(context),
          ),
          Obx(() => pageNavigation(context, controller.itemScrollController, controller.currentPage.value, controller.totalPage.value,
              (index) => controller.setPageOnClick(index)))
        ],
      ),
    );
  }

  postContent(BuildContext context) {
    return Obx(
      () => refreshIndicatorConfiguration(
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
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              controller: controller.listViewScrollController,
              itemCount: controller.htmlData.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            color: Theme.of(context).secondaryHeaderColor,
                            child: Stack(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: controller.htmlData.elementAt(index)["userAvatar"] == "no"
                                                  ? Image.asset("assets/NoAvata.png").image
                                                  : CachedNetworkImageProvider(controller.htmlData.elementAt(index)["userAvatar"])),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10, left: 10),
                                      child: RichText(
                                        text: TextSpan(children: <TextSpan>[
                                          TextSpan(
                                              text: controller.htmlData.elementAt(index)['userName'] + "\n",
                                              style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
                                          TextSpan(
                                              text: controller.htmlData.elementAt(index)['userTitle'],
                                              style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 13)),
                                        ]),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10),
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
                            )),
                        Html(
                          data: controller.htmlData.elementAt(index)['postContent'],
                          customRender: {
                            "img": (RenderContext context, Widget child) {
                              if (context.tree.element!.attributes['src']!.contains("/styles/next/xenforo")) {
                                return Image.asset(GlobalController.i.getEmoji(context.tree.element!.attributes['src'].toString()));
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
                                            "Quote: " +
                                                renderContext.tree.element!
                                                    .getElementsByClassName("bbCodeBlock-title")
                                                    .map((e) => e.getElementsByTagName("a")[0].innerHtml)
                                                    .toString(),
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).secondaryHeaderColor,
                                            borderRadius: BorderRadius.all(Radius.circular(5)),
                                          ),
                                        ),
                                      ),
                                      collapsed: ExpandableButton(
                                        child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).cardColor,
                                              borderRadius: BorderRadius.all(Radius.circular(5)),
                                            ),
                                            child: child),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            "table": (context, child) {
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.all(10),
                                physics: BouncingScrollPhysics(),
                                child: (context.tree as TableLayoutElement).toWidget(context),
                              );
                            },
                            "iframe": (RenderContext context, Widget child) {
                              print(context.tree.attributes['src'].toString());
                              print("To do: iframe ViewUI");
                              return Container();
                              // return Image.network(
                              //   "https://img.youtube.com/vi/$s/0.jpg",
                              // );
                            }
                          },
                          style: {
                            "table": Style(backgroundColor: Colors.grey.shade200),
                            "body": Style(
                              fontSize: FontSize(17.0),
                            ),
                            "blockquote": Style(color: Theme.of(context).accentColor, width: double.infinity)
                              ..margin = EdgeInsets.only(left: 5.0, right: 5.0, bottom: 10.0)
                              ..display = Display.BLOCK,
                          },
                          onLinkTap: (String? url, RenderContext context, Map<String, String> attributes, dom.Element? element) {
                            controller.write(controller.htmlData.elementAt(2)['postContent']);
                            if (url?.isNotEmpty == true && url!.contains("/goto/post") && url != "no") {
                              //print("https://voz.vn" + url);
                            } //else
                            //print(url);
                          },
                          customImageRenders: {
                            networkSourceMatcher(): (context, attributes, element) {
                              if (attributes['src'].toString().contains("twemoji.maxcdn.com")){
                                return Text(attributes['alt'].toString(), style: TextStyle(fontSize: 25),);
                               // return Text(attributes['src'].toString(), style: TextStyle(fontSize: 30, color: Colors.red),);
                              } else {
                                return GestureDetector(
                                  onTap: () {
                                    Get.defaultDialog(
                                      content: Expanded(
                                        child: CachedNetworkImage(
                                          imageUrl: attributes['src'].toString(),
                                          placeholder: (context, url) => CircularProgressIndicator(),
                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                        ),
                                      ),
                                    );
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl: attributes['src'].toString(),
                                    placeholder: (context, url) => CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                  ),
                                );
                              }


                            },
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
      ),
    );
  }
}
