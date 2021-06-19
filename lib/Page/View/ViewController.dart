import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:vozforums/GlobalController.dart';
import 'dart:io';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import '../reuseWidget.dart';

class ViewController extends GetxController {
  late String fullUrl;
  var subHeader;
  late String subLink;
  RxList htmlData = [].obs;
  var _postContent;
  var _userPostDate;
  var _userName;
  var _userAvatar;
  var _userTitle;
  var _userLink;
  var _orderPost;
  var _commentName;
  var _commentImg = '';
  var _commentByMe = 0;
  late var _user;
  int lengthHtmlDataList = 0;

  final RefreshController refreshController = RefreshController(initialRefresh: false);
  final ScrollController listViewScrollController = ScrollController();
  final ItemScrollController itemScrollController = ItemScrollController();
  RxInt currentPage = 0.obs;
  RxInt totalPage = 0.obs;
  final int loadItems = 50;
  late dom.Document res;

  @override
  Future<void> onInit() async {
    super.onInit();
    subHeader = Get.arguments[0];
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    subLink = Get.arguments[1];
    await loadUserPost(fullUrl = GlobalController.i.url + subLink);
    if (fullUrl.contains("/unread") == true) {
      fullUrl = fullUrl.split("unread")[0];
    }
  }

  @override
  onClose() {
    super.onClose();
    refreshController.dispose();
    listViewScrollController.dispose();
    currentPage.close();
    totalPage.close();
    htmlData.close();
    clearMemoryImageCache();
    GlobalController.i.percentDownload = -1.0;
  }

  getYoutubeID(String s) {
    return YoutubePlayer.convertUrlToId(s);
  }

  _removeTag(String content) {
    return content.replaceAll(
        RegExp(r'<div class="bbCodeBlock-expandLink js-expandLink"><a role="button" tabindex="0">Click to expand...</a></div>'), "");
  }

  setPageOnClick(String toPage) async {
    if (int.parse(toPage) > totalPage.value) {
      HapticFeedback.heavyImpact();
      refreshController.loadComplete();
    } else {
      GlobalController.i.percentDownload = 0.01;
      await loadUserPost(fullUrl + GlobalController.i.pageLink + toPage);
    }
  }

  Future<void> loadUserPost(String url) async {
    await GlobalController.i.getBody(url, false).then((value) async {
      lengthHtmlDataList = htmlData.length;
      GlobalController.i.dataCsrfPost = value.getElementsByTagName('html')[0].attributes['data-csrf'];
      value.getElementsByClassName("block block--messages").forEach((element) {
        var lastP = element.getElementsByClassName("pageNavSimple");
        if (lastP.length == 0) {
          currentPage.value = 1;
          totalPage.value = 1;
        } else {
          var naviPage = element.getElementsByClassName("pageNavSimple-el pageNavSimple-el--current").first.innerHtml.trim();
          currentPage.value = int.parse(naviPage.replaceAll(RegExp(r'[^0-9]\S*'), ""));
          totalPage.value = int.parse(naviPage.replaceAll(RegExp(r'\S*[^0-9]'), ""));
        }

        //Get post
        element.getElementsByClassName("message message--post js-post js-inlineModContainer").forEach((element) {
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
              .map((e) => e.getElementsByTagName("a")[GlobalController.i.isLogged.value == true ? 2 : 1].innerHtml)
              .first
              .trim();

          if (element.getElementsByClassName('reactionsBar-link').length > 0) {
            _commentName = element.getElementsByClassName('reactionsBar-link')[0].innerHtml.replaceAll(RegExp(r"<[^>]*>"), '');

            if (element.getElementsByClassName('has-reaction').length > 0) {
              if (element.getElementsByClassName('has-reaction')[0].getElementsByTagName('img')[0].attributes['title'] == 'Ưng') {
                _commentByMe = 1;
              } else
                _commentByMe = 2;
            } else
              _commentByMe = 0;

            element.getElementsByClassName('reactionSummary').forEach((element) {
              element.getElementsByClassName('reaction reaction--small').forEach((element) {
                _commentImg += element.attributes['data-reaction-id'].toString();
              });
            });
          } else {
            _commentImg = 'no';
            _commentName = '';
          }

          htmlData.add({
            "postContent": _removeTag(_postContent),
            "userPostDate": _userPostDate,
            "userName": _userName,
            "userLink": _userLink,
            "userTitle": _userTitle,
            "userAvatar": (_userAvatar == "no" || _userAvatar.contains("https://")) ? _userAvatar : GlobalController.i.url + _userAvatar,
            "orderPost": _orderPost,
            "commentName": _commentName,
            "commentImage": _commentImg,
            "postID": element.getElementsByClassName('actionBar-action actionBar-action--mq u-jsOnly js-multiQuote')[0].attributes['data-message-id'].toString(),
            'commentByMe': _commentByMe
          });
          _commentByMe = 0;
          _commentImg = '';
        });
      });

      if (Get.isDialogOpen == true || refreshController.isLoading) {
        if (Get.isDialogOpen == true) Get.back();
        htmlData.removeRange(0, lengthHtmlDataList);
        listViewScrollController.jumpTo(-10.0);
      }
      refreshController.loadComplete();
    });
    await Future.delayed(Duration(milliseconds: 50), () {
      scrollToFunc();
    });
  }

  getImage(String url) async {
    return await getCachedImageFile(url);
  }

  write(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/my_file.txt');
    await file.writeAsString(text);
    print('${directory.path}/my_file.txt');
    print(File('${directory.path}/my_file.txt').toString());
  }

  saveImage(String url) async {
    final Directory? directory = Directory("storage/emulated/0/Pictures/vozNext");
    await directory!.create();
    final File file = File((await getCachedImageFilePath(url)).toString());
    await file.copy(directory.path + "/${file.path.split("/").last}.jpg");
    print(await file.copy(directory.path + "/${file.path.split("/").last}.jpg"));
  }

  scrollToFunc() {
    itemScrollController.scrollTo(
        index: currentPage.value + 1, duration: Duration(milliseconds: 500), curve: Curves.slowMiddle, alignment: GlobalController.i.pageNaviAlign);
  }

  final flagsReactions = [
    Reaction(
      previewIcon: builFlagsdPreviewIcon('assets/reaction/0.png', 'UnReact'),
      icon: buildIcon('assets/reaction/0.png'),
    ),
    Reaction(
      previewIcon: builFlagsdPreviewIcon('assets/reaction/1.png', 'Sweet'),
      icon: buildIcon('assets/reaction/1.png'),
    ),
    Reaction(
      previewIcon: builFlagsdPreviewIcon('assets/reaction/2.png', 'Brick'),
      icon: buildIcon('assets/reaction/2.png'),
    ),
  ];

  reactionPost(String idPost, int idReact, BuildContext context) async{
    Get.defaultDialog(
        barrierDismissible: false,
        radius: 6,
        backgroundColor: Theme.of(context).hintColor.withOpacity(0.8),
        content: popUpWaiting(context, 'Hang tight', 'I\'m posting your react'),
        title: 'Reaction');
    var headers = {
      'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
      'host': 'voz.vn',
      'cookie' : '${GlobalController.i.xfCsrfPost}; xf_user=${GlobalController.i.xfUser};',
    };
    var body = {
      '_xfWithData' : '1',
      '_xfToken' : '${GlobalController.i.dataCsrfPost}',
      '_xfResponseType' : 'json'
    };
    await http.post(Uri.parse('https://voz.vn/p/$idPost/react?reaction_id=$idReact?reaction_id=$idReact'),headers: headers, body: body).then((value) => Get.back());
  }
}
