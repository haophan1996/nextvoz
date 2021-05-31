import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:get/get.dart';
import 'package:vozforums/Page/ThreadView/ViewController.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';

import '../utilities.dart';

class ViewUI extends GetView<ViewController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          controller.theme,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.8,
            child: postContent(context),
          ),
          TextButton(
              onPressed: () {
                controller.test2();
              },
              child: Text("Test meeeeeeeeeeeeeeeeeee")),
        ],
      ),
    );
  }

  postContent(BuildContext context) {
    return Obx(
      () => ListView.builder(
        cacheExtent: 99999,
        scrollDirection: Axis.vertical,
        itemCount: controller.htmlData.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 2),
            child: Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Html(
                    data: controller.htmlData.elementAt(index),
                    // style: {
                    //   "blockquote": Style(
                    //     backgroundColor: Colors.grey.shade400,
                    //     padding: EdgeInsets.all(10),
                    //   ),
                    // },
                    customRender: {
                      "img": (RenderContext context, Widget child) {
                        if (context.tree.element!.attributes['src']!.contains("/styles/next/xenforo")) {
                          return Image.asset(UtilitiesController.i.getEmoji(context.tree.element!.attributes['src'].toString()));
                        }
                      },
                      "blockquote": (context, child) {
                        // print(context.tree.element!.getElementsByClassName("bbCodeBlock-title").map((e) => e.getElementsByTagName("a")[0].innerHtml));
                        return ExpandableNotifier(
                          child: Column(
                            children: <Widget>[
                              Expandable(
                                collapsed: ExpandableButton(
                                  child: Container(
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
                                expanded: ExpandableButton(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade400,
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
                    },
                    onLinkTap: (String? url, RenderContext context, Map<String, String> attributes, dom.Element? element) {
                      if (url?.isNotEmpty == true && url!.contains("/goto/post")) {
                        print("https://voz.vn" + url);
                      } else
                        print(url);
                    },
                    customImageRenders: {
                      networkSourceMatcher(): (context, attributes, element) {
                        return GestureDetector(
                          onTap: () {
                            Get.defaultDialog(
                              content: CachedNetworkImage(
                                imageUrl: attributes['src'].toString(),
                                placeholder: (context, url) => CircularProgressIndicator(),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ),
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
    );
  }
}
