import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/Routes/pages.dart';
import '/GlobalController.dart';
import 'package:html/dom.dart' as dom;

class ThreadController extends GetxController {
  Map<String, dynamic> data = {};
  late ScrollController listViewScrollController = ScrollController();
  List myThreadList = [];
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
    Get.toNamed(Routes.View, arguments: [
      myThreadList.elementAt(index)['title'],
      myThreadList.elementAt(index)['link'],
      myThreadList.elementAt(index)['prefix'],
      0
    ]);
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
    data['loading'] = 'firstLoading';
    if (data['currentPage'] == null)
      await loadSubHeader(data['_url']);
    else
      await setPageOnClick(data['currentPage']);
  }

  setPageOnClick(int toPage) async {
    await loadSubHeader(data['_url'] + GlobalController.i.pageLink + toPage.toString());
    await updateLastItemScroll();
  }

  updateLastItemScroll() async {
    if (data['isScroll'] != 'idle') {
      data['isScroll'] = 'idle';
      update(['lastItemList']);
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
          int.parse(value
              .getElementsByClassName('p-navgroup-link--alerts')[0]
              .attributes['data-badge']
              .toString()),
          int.parse(value
              .getElementsByClassName('p-navgroup-link--conversations')[0]
              .attributes['data-badge']
              .toString()),
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

    value.getElementsByClassName("p-body-content").forEach((element) async {
      data['lastP'] = element.getElementsByClassName("pageNavSimple");
      if (data['lastP'].length == 0) {
        data['currentPage'] = 1;
        data['totalPage'] = 1;
      } else {
        var naviPage = element
            .getElementsByClassName("pageNavSimple-el pageNavSimple-el--current")
            .first
            .innerHtml
            .trim();
        data['currentPage'] = int.parse(naviPage.replaceAll(RegExp(r'[^0-9]\S*'), ""));
        data['totalPage'] = int.parse(naviPage.replaceAll(RegExp(r'\S*[^0-9]'), ""));
      }
      //Detail SubHeader
      element.getElementsByClassName("structItem structItem--thread").forEach((element) async {
        if (element.getElementsByClassName("structItem-title")[0].getElementsByTagName('a').length >
            1) {
          data['title'] = element.getElementsByClassName("structItem-title")[0].text.trim();
          data['themeTitle'] = element
              .getElementsByClassName("structItem-title")[0]
              .getElementsByTagName('a')[0]
              .text
              .trim();
          data['title'] = ' ' + data['title'].toString().replaceAll(data['themeTitle'], '').trim();
          data['linkThread'] = element
              .getElementsByClassName('structItem-title')[0]
              .getElementsByTagName('a')[1]
              .attributes['href'];
        } else {
          data['title'] = element.getElementsByClassName("structItem-title")[0].text.trim();
          data['linkThread'] = element
              .getElementsByClassName('structItem-title')[0]
              .getElementsByTagName('a')[0]
              .attributes['href'];
        }
        data['authorName'] = element.attributes["data-author"];

        myThreadList.add({
          "title": data['title'],
          "prefix": data['themeTitle'] ?? '',
          'isRead': data['linkThread'].contains('/unread') ? true : false,
          "authorName": data['authorName'],
          "link": data['linkThread'],
          "replies": "Replies " +
              element
                  .getElementsByClassName("pairs pairs--justified")
                  .map((e) => e.getElementsByTagName("dd")[0].innerHtml)
                  .first,
          "date": element
              .getElementsByClassName("structItem-latestDate u-dt")
              .map((e) => e.innerHtml)
              .first,
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
