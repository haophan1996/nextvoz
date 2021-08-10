import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nextvoz/Routes/routes.dart';
import '/GlobalController.dart';
import '/Page/View/ViewController.dart';

class ThreadController extends GetxController {
  late String _url;
  late String theme;
  late ScrollController listViewScrollController = ScrollController();
  List myThreadList = [];
  int currentPage = 0, totalPage = 0, lengthHtmlDataList = 0;
  String isScroll = 'idle';
  var _title, lastP, linkThread = '', themeTitle = "", title = "", dio = Dio(), percentDownload = 0.0;

  @override
  Future<void> onInit() async {
    super.onInit();
    theme = Get.arguments[0];
    _url = Get.arguments[1];
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await loadSubHeader(_url);
  }

  navigateToThread(int index) {
    GlobalController.i.sessionTag.add(myThreadList.elementAt(index)['title']);
    Get.lazyPut<ViewController>(() => ViewController(), tag: GlobalController.i.sessionTag.last);
    Get.toNamed(Routes.View,
        arguments: [myThreadList.elementAt(index)['title'], myThreadList.elementAt(index)['link'], myThreadList.elementAt(index)['prefix'], 0]);
  }

  @override
  onClose() async {
    super.onClose();
    listViewScrollController.dispose();
    myThreadList.clear();
    dio.close(force: true);
    dio.clear();
  }

  setPageOnClick(int toPage) async {
    await loadSubHeader(_url + GlobalController.i.pageLink + toPage.toString());
    await updateLastItemScroll();
  }

  updateLastItemScroll() async {
    if (isScroll != 'idle') {
      isScroll = 'idle';
      update(['lastItemList']);
    }
  }

  loadSubHeader(String url) async {
    await GlobalController.i.getBody(() {}, (download) {
      percentDownload = download;
      update(['download'], true);
    }, dio, url, false).then((value) async {
      lengthHtmlDataList = myThreadList.length;

      if (value!.getElementsByTagName('html')[0].attributes['data-logged-in'] == 'true') {
        GlobalController.i.controlNotification(
            int.parse(value.getElementsByClassName('p-navgroup-link--alerts')[0].attributes['data-badge'].toString()),
            int.parse(value.getElementsByClassName('p-navgroup-link--conversations')[0].attributes['data-badge'].toString()),
            value.getElementsByTagName('html')[0].attributes['data-logged-in'].toString());
      } else
        GlobalController.i.controlNotification(0, 0, 'false');

      value.getElementsByClassName("p-body-content").forEach((element) async {
        lastP = element.getElementsByClassName("pageNavSimple");
        if (lastP.length == 0) {
          currentPage = 1;
          totalPage = 1;
        } else {
          var naviPage = element.getElementsByClassName("pageNavSimple-el pageNavSimple-el--current").first.innerHtml.trim();
          currentPage = int.parse(naviPage.replaceAll(RegExp(r'[^0-9]\S*'), ""));
          totalPage = int.parse(naviPage.replaceAll(RegExp(r'\S*[^0-9]'), ""));
        }
        //Detail SubHeader
        element.getElementsByClassName("structItem structItem--thread").forEach((element) async {
          _title = element.getElementsByClassName("structItem-title");
          if (_title.map((e) => e.getElementsByTagName("a").length).toString() == "(1)") {
            title = _title.map((e) => e.getElementsByTagName("a")[0].innerHtml).first;
            linkThread = _title.map((e) => e.getElementsByTagName("a")[0].attributes['href']).first!;
          } else {
            title = ' ' + _title.map((e) => e.getElementsByTagName("a")[1].innerHtml).first;
            themeTitle = _title.map((e) => e.getElementsByTagName("span")[0].innerHtml).first;
            linkThread = _title.map((e) => e.getElementsByTagName("a")[1].attributes['href']).first!;
          }
          myThreadList.add({
            "title": title,
            "prefix": themeTitle,
            'isRead': linkThread.contains('/unread') ? true : false,
            "authorName": element.attributes["data-author"],
            "link": linkThread,
            "replies":
                "Replies " + element.getElementsByClassName("pairs pairs--justified").map((e) => e.getElementsByTagName("dd")[0].innerHtml).first,
            "date": element.getElementsByClassName("structItem-latestDate u-dt").map((e) => e.innerHtml).first,
          });
        });
      });
      if (Get.isDialogOpen == true || isScroll == 'Release') {
        if (Get.isDialogOpen == true) Get.back();
        myThreadList.removeRange(0, lengthHtmlDataList);
        listViewScrollController.jumpTo(-10.0);
      }
      myThreadList.add(null);
    }).then((value) => update());
  }
}
