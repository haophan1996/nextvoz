import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../reuseWidget.dart';
import '/Routes/pages.dart';
import '/GlobalController.dart';
import 'package:html/dom.dart' as dom;

class ThreadController extends GetxController {
  Map<String, dynamic> data = {};
  late ScrollController listViewScrollController = ScrollController();
  List myThreadList = [], prefixList = [];
  var dio = Dio();

  @override
  Future<void> onInit() async {
    super.onInit();
    data['isScroll'] = 'idle';
    data['percentDownload'] = 0.0;
    data['loading'] = 'firstLoading';
    data['theme'] = Get.arguments[0];
    data['_url'] = Get.arguments[1];
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await loadSubHeader(data['_url']);
  }

  navigateToThread(int index) {
    Get.toNamed(Routes.View,
        arguments: [myThreadList.elementAt(index)['title'], myThreadList.elementAt(index)['link'], myThreadList.elementAt(index)['prefix'], 0]);
  }

  navigateToCreatePost() async {
    var result = await Get.toNamed(Routes.CreatePost,
        arguments: [GlobalController.i.xfCsrfPost, GlobalController.i.token, data['_url'], '', '', '3', '', '', prefixList]);
    if (result != null && result[0] == 'ok') {
      await Get.toNamed(Routes.View, arguments: [result[2], result[1], '', 1]);
    }
  }

  @override
  onClose() async {
    super.onClose();
    dio.close(force: true);
    dio.clear();
    listViewScrollController.dispose();
    myThreadList.clear();
    data.clear();
    GlobalController.i.sessionTag.removeLast();
    this.dispose();
  }

  onRefresh() async {
    data['isScroll'] = 'Release';
    if (data['currentPage'] == null) {
      data['loading'] = 'firstLoading';
      await loadSubHeader(data['_url']);
    } else {
      await setPageOnClick(data['currentPage']);
    }
    data['isScroll'] = 'idle';
  }

  setPageOnClick(int toPage) async {
    await loadSubHeader(data['_url'] + GlobalController.i.pageLink + toPage.toString());
    await updateLastItemScroll();
  }

  navigatePage(String symbol){
    if (data['isScroll'] == 'Release') return;
    setDialog();
    switch (symbol) {
      case 'F':
        setPageOnClick(1);
        break;
      case 'P':
        setPageOnClick(data['currentPage'] - 1);
        break;
      case 'N':
        setPageOnClick(data['currentPage'] + 1);
        break;
      case 'L':
        setPageOnClick(data['totalPage']);
        break;
    }
  }

  updateLastItemScroll() async {
    if (data['isScroll'] != 'idle') {
      data['isScroll'] = 'idle';
    }
  }

  Future<void> loadSubHeader(String url) async {
    await GlobalController.i.getBodyBeta((value) async {
      if (value == 1) {
        loadSubHeader(url);
      } else {
        data['loading'] = 'error';
        update(['FirstLoading']);
      }
    }, (download) {
      data['percentDownload'] = download;
      update(['download'], true);
    }, dio, url, false).then((value) async {
      await performQueryData(value!);
      update(['updatePageNum']);
      if (data['loading'] == 'firstLoading') {
        data['loading'] = 'ok';
        update(['FirstLoading']);
      } else
        update();
    });
  }

  performQueryData(dom.Document value) async {
    if (Get.currentRoute == Routes.Home) {
      dio.close(force: true);
      dio.clear();
      return;
    }
    data['lengthHtmlDataList'] = myThreadList.length;
    GlobalController.i.token = value.getElementsByTagName('html')[0].attributes['data-csrf'];
    if (value.getElementsByTagName('html')[0].attributes['data-logged-in'] == 'true') {
      GlobalController.i.controlNotification(
          int.parse(value.getElementsByClassName('p-navgroup-link--alerts')[0].attributes['data-badge'].toString()),
          int.parse(value.getElementsByClassName('p-navgroup-link--conversations')[0].attributes['data-badge'].toString()),
          value.getElementsByTagName('html')[0].attributes['data-logged-in'].toString());
    } else
      GlobalController.i.controlNotification(0, 0, 'false');

    data['_url'] = value
        .getElementsByTagName('head')[0]
        .getElementsByTagName('meta')
        .where((element) => element.attributes['property'] == 'og:url')
        .first
        .attributes['content'];
    if (data['_url'].contains('page-') == true) {
      data['_url'] = data['_url']
          .toString()
          .split(
            'page-',
          )
          .first;
    }

    if (value.getElementsByClassName('js-prefixSelect u-noJsOnly input').length > 0 && prefixList.isEmpty) {
      value.getElementsByClassName('js-prefixSelect u-noJsOnly input')[0].getElementsByTagName('option').forEach((element) {
        prefixList.add({'value': element.attributes['value'], 'text': element.text});
      });
    }
    if (value.getElementsByClassName('button--cta button button--icon button--icon--write').length == 0) {
      data['ableToPost'] = false;
    } else
      data['ableToPost'] = true;

    value.getElementsByClassName("p-body-content").forEach((element) async {
      data['lastP'] = element.getElementsByClassName("pageNavSimple");
      if (data['lastP'].length == 0) {
        data['currentPage'] = 1;
        data['totalPage'] = 1;
      } else {
        var naviPage = element.getElementsByClassName("pageNavSimple-el pageNavSimple-el--current").first.innerHtml.trim();
        data['currentPage'] = int.parse(naviPage.replaceAll(RegExp(r'[^0-9]\S*'), ""));
        data['totalPage'] = int.parse(naviPage.replaceAll(RegExp(r'\S*[^0-9]'), ""));
      }
      //Detail SubHeader
      element.getElementsByClassName("structItem structItem--thread").forEach((element) async {
        data['sticky'] = element.getElementsByClassName('structItem-status structItem-status--sticky').length > 0 ? true : false;
        if (element.getElementsByClassName("structItem-title")[0].getElementsByTagName('a').length > 1) {
          data['title'] = element.getElementsByClassName("structItem-title")[0].text.trim();
          data['themeTitle'] = element.getElementsByClassName("structItem-title")[0].getElementsByTagName('a')[0].text.trim();
          data['title'] = ' ' + data['title'].toString().replaceAll(data['themeTitle'], '').trim().replaceAll(RegExp('\\s+'), ' ');
          data['linkThread'] = element.getElementsByClassName('structItem-title')[0].getElementsByTagName('a')[1].attributes['href'];
        } else {
          data['title'] = element.getElementsByClassName("structItem-title")[0].text.trim().replaceAll(RegExp('\\s+'), ' ');
          data['linkThread'] = element.getElementsByClassName('structItem-title')[0].getElementsByTagName('a')[0].attributes['href']!.trim();
        }
        data['authorName'] = element.attributes["data-author"];

        myThreadList.add({
          "sticky" : data['sticky'],
          "title": data['title'],
          "prefix": data['themeTitle'] ?? '',
          'isRead': data['linkThread'].contains('/unread') ? true : false,
          "authorName": data['authorName'],
          "link": data['linkThread'],
          "replies":
              "Replies " + element.getElementsByClassName("pairs pairs--justified").map((e) => e.getElementsByTagName("dd")[0].innerHtml).first,
          "date": element.getElementsByClassName("structItem-latestDate u-dt").map((e) => e.innerHtml).first,
        });
      });
    });
    if (Get.isDialogOpen == true || data['isScroll'] == 'Release') {
      if (Get.isDialogOpen == true) Get.back();
      myThreadList.removeRange(0, data['lengthHtmlDataList']);
      listViewScrollController.jumpTo(-10.0);
    }
  }
}
