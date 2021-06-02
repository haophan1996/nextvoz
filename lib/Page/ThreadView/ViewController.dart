import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'dart:io';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ViewController extends GetxController {
  final String _url = "https://voz.vn";
  final String _pageLink = "page-";
  late String fullUrl;
  String theme = '';
  var response;
  List htmlData = [].obs;
  late dom.Document doc;
  late String _postContent;
  late String _userPostDate;
  late String _userName;
  late String _userAvatar;
  late String _userTitle;
  late String _userLink;
  late String _orderPost;
  late var _user;
  int lengthHtmlDataList = 0;

  final RefreshController refreshController = RefreshController(initialRefresh: false);
  final ScrollController listViewScrollController = ScrollController();
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  RxList pages = [].obs;
  RxInt currentPage = 0.obs;
  RxInt totalPage = 0.obs;
  final int loadItems = 50;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    theme = Get.arguments[0];
    response = await http.get(Uri.parse(fullUrl = _url + Get.arguments[1]));
    doc = parser.parse(response.body);
    //response = await http.get(Uri.parse("https://voz.vn/t/nhung-kenh-youtube-dang-xem-nhat-mua-cach-ly-xa-hoi.23758/page-5"));
    test();

    if (totalPage.value == 0) {
      pages.add("1");
    } else {
      if (totalPage.value > 20) {
        pages = List.generate(20, (index) => "${index + 1}").obs;
      } else {
        pages = List.generate(totalPage.value, (index) => "${index + 1}").obs;
      }
    }

    itemPositionsListener.itemPositions.addListener(() {
      if (itemPositionsListener.itemPositions.value.last.index > (pages.length - 10)) {
        int loadMore = totalPage.value - pages.length;
        if (loadMore < loadItems) {
          loadMore = totalPage.value;
        } else {
          loadMore = pages.length + loadItems;
        }
        for (int i = pages.length + 1; i <= loadMore; i++) {
          pages.add(i.toString());
        }
      }
    });
  }

  test() async {
    lengthHtmlDataList = htmlData.length;
    getPageStatus();
    doc.getElementsByClassName("message message--post js-post js-inlineModContainer").forEach((element) {
      _postContent = element.getElementsByClassName("message-body js-selectToQuote").map((e) => e.outerHtml).first;
      _userPostDate = element.getElementsByClassName("u-concealed").map((e) => e.getElementsByTagName("time")[0].innerHtml).first;

      _user = element.getElementsByClassName("message-cell message-cell--user");
      _userLink = _user.map((e) => e.getElementsByTagName("a")[1].attributes['href']).first!;
      _userTitle = _user.map((e) => e.getElementsByClassName("userTitle message-userTitle")[0].innerHtml).first;
      if (_user.map((e) => e.getElementsByTagName("img").length).toString() == "(1)") {
        _userAvatar = _user.map((e) => e.getElementsByTagName("img")[0].attributes['src']).first!;
      } else {
        _userAvatar = "no";
      }

      _userName = _user.map((e) => e.getElementsByTagName("a")[1].innerHtml).first;
      if (_userName.contains("span")) {
        _userName = _user.map((e) => e.getElementsByTagName("span")[0].innerHtml).first;
      }

      _orderPost = element
          .getElementsByClassName("message-attribution-opposite message-attribution-opposite--list")
          .map((e) => e.getElementsByTagName("a")[1].innerHtml)
          .first
          .trim()
          .replaceAll("#", "");

      htmlData.add({
        "postContent": _removeTag(_postContent),
        "userPostDate": _userPostDate,
        "userName": _userName,
        "userLink": _userLink,
        "userTitle": _userTitle,
        "userAvatar": (_userAvatar == "no" || _userAvatar.contains("https://")) ? _userAvatar : _url + _userAvatar,
        "orderPost": _orderPost,
      });
    });
    if (Get.isDialogOpen == true || refreshController.isLoading) {
      if(Get.isDialogOpen == true)Get.back();
      htmlData.removeRange(0, lengthHtmlDataList);
    }
  }

  getPageStatus() {
    if (doc.getElementsByClassName("block-outer-main").length == 0) {
      currentPage.value = 1;
      totalPage.value = 1;
    } else {
      doc.getElementsByClassName("block-outer-main").forEach((element) {
        var lastP = element.getElementsByClassName("pageNavSimple");
        var crawlPage;
        if (lastP.map((e) => e.getElementsByTagName("a")[0].innerHtml).first.trim().length > 50) {
          crawlPage = lastP.map((e) => e.getElementsByTagName("a")[2].innerHtml).first.trim();
        } else {
          crawlPage = lastP.map((e) => e.getElementsByTagName("a")[0].innerHtml).first.trim();
        }
        currentPage.value = int.parse(crawlPage.replaceAll(RegExp(r'[^0-9]\S*'), ""));
        totalPage.value = int.parse(crawlPage.replaceAll(RegExp(r'\S*[^0-9]'), ""));
      });
    }
  }

  getYoutubeID(String s) {
    return YoutubePlayer.convertUrlToId(s);
  }

  _removeTag(String content) {
    return content.replaceAll(
        RegExp(r'<div class="bbCodeBlock-expandLink js-expandLink"><a role="button" tabindex="0">Click to expand...</a></div>'), "");
  }

  setPageOnClick(String toPage) async {
    doc.remove();
    response = null;
    if (int.parse(toPage) > totalPage.value) {
      Get.defaultDialog(
          title: "Alert",
          content: Text("No More Page"),
          confirm: TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                "Touch anywhere to dismiss",
                style: TextStyle(fontSize: 13, color: Colors.black),
              ))
      );
      refreshController.loadComplete();
    } else{
      response = await http.get(Uri.parse(fullUrl + _pageLink + toPage));
      doc = parser.parse(response.body);
      await test();
      refreshController.loadComplete();
      itemScrollController.scrollTo(index: int.parse(toPage)+1, duration: Duration(microseconds: 500), alignment: 0.735);
      listViewScrollController.jumpTo(-10.0);
    }
  }

  write(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/my_file.txt');
    await file.writeAsString(text);
    print('${directory.path}/my_file.txt');
    print(File('${directory.path}/my_file.txt').toString());
  }
}
