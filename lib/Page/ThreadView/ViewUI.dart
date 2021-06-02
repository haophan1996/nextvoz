import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vozforums/Page/ThreadView/ViewController.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:vozforums/Page/pageLoadNext.dart';
import '../pageNavigation.dart';
import '../utilities.dart';

class ViewUI extends GetView<ViewController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          controller.theme,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: postContent(context),
          ),
          Obx(() => PageHelp().pageNavigation(context, controller.itemScrollController, controller.itemPositionsListener, controller.pages,
              controller.currentPage.value, (index) => controller.setPageOnClick(index)))
        ],
      ),
    );
  }

  postContent(BuildContext context) {
    return Obx(
      () => PageLoad().refreshIndicatorConfiguration(
        Scrollbar(
          child: SmartRefresher(
            enablePullDown: false,
            enablePullUp: true,
            controller: controller.refreshController,
            onLoading: (){
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
                        color: Colors.white, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            color: Color(0xffE2E3E5),
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
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                                          TextSpan(
                                              text: controller.htmlData.elementAt(index)['userTitle'],
                                              style: TextStyle(color: Colors.black, fontSize: 13)),
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
                                        Text(controller.htmlData.elementAt(index)['userPostDate']),
                                        Text(
                                          "#" + controller.htmlData.elementAt(index)['orderPost'],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        Html(
                          data: controller.htmlData.elementAt(index)['postContent'],
                          style: {
                            'table': Style(backgroundColor: Colors.grey.shade200),
                            "body": Style(
                              fontSize: FontSize(17.0),
                            ),
                          },
                          customRender: {
                            "img": (RenderContext context, Widget child) {
                              if (context.tree.element!.attributes['src']!.contains("/styles/next/xenforo")) {
                                return Image.asset(UtilitiesController.i.getEmoji(context.tree.element!.attributes['src'].toString()));
                              }
                            },
                            "blockquote": (context, child) {
                              return ExpandableNotifier(
                                child: Column(
                                  children: <Widget>[
                                    Expandable(
                                      expanded: ExpandableButton(
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            "Quote: " +
                                                context.tree.element!
                                                    .getElementsByClassName("bbCodeBlock-title")
                                                    .map((e) => e.getElementsByTagName("a")[0].innerHtml)
                                                    .toString(),
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade400,
                                            borderRadius: BorderRadius.all(Radius.circular(5)),
                                          ),
                                        ),
                                      ),
                                      collapsed: ExpandableButton(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xffE7E8E9),
                                            borderRadius: BorderRadius.all(Radius.circular(5)),
                                          ),
                                          child: child,
                                        ),
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
                          onLinkTap: (String? url, RenderContext context, Map<String, String> attributes, dom.Element? element) {
                            controller.write(controller.htmlData.elementAt(4)['postContent']);
                            if (url?.isNotEmpty == true && url!.contains("/goto/post") && url != "no") {
                              //print("https://voz.vn" + url);
                            } //else
                            //print(url);
                          },
                          customImageRenders: {
                            networkSourceMatcher(): (context, attributes, element) {
                              return GestureDetector(
                                onTap: () {
                                  Get.defaultDialog(
                                    content: Expanded(
                                        child: CachedNetworkImage(
                                      imageUrl: attributes['src'].toString(),
                                      placeholder: (context, url) => CircularProgressIndicator(),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                    )),
                                  );
                                },
                                child: CachedNetworkImage(
                                  imageUrl: attributes['src'].toString(),
                                  placeholder: (context, url) => CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                ),
                              );
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
