import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:get/get.dart';
import 'package:vozforums/GlobalController.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vozforums/Page/NavigationDrawer/NaviDrawerController.dart';
import 'package:vozforums/Page/View/ViewController.dart';

class ThreadController extends GetxController {
  late String _url;
  late String theme;
  late RefreshController refreshController = RefreshController(initialRefresh: false);
  late ScrollController listViewScrollController = ScrollController();
  late ItemScrollController itemScrollController = ItemScrollController();

  List myThreadList = [];
  int currentPage = 0;
  int totalPage = 0;
  int lengthHtmlDataList = 0;
  var _title;
  var lastP;
  var linkThread = '';
  var themeTitle = "";
  var title = "";

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
    Future.delayed(Duration(milliseconds: 100), () {
      GlobalController.i.tagView.add(myThreadList.elementAt(index)['title']);
      Get.lazyPut<ViewController>(() => ViewController(), tag: GlobalController.i.tagView.last);
      Get.toNamed("/ViewPage", arguments: [myThreadList.elementAt(index)['title'], myThreadList.elementAt(index)['link'],myThreadList.elementAt(index)['prefix'] ]);
    });
  }

  @override
  onClose() async {
    super.onClose();
    refreshController.dispose();
    listViewScrollController.dispose();
  }

  setPageOnClick(String toPage) async {
    await loadSubHeader(_url + GlobalController.i.pageLink + toPage);
  }

  loadSubHeader(String url) async {
    await GlobalController.i.getBody(url, false).then((value) async {
      lengthHtmlDataList = myThreadList.length;
      if (value.getElementsByTagName('html')[0].attributes['data-logged-in'] == 'true') {
        GlobalController.i.isLogged.value = true;
        NaviDrawerController.i.titleUser.value = GlobalController.i.userStorage.read('titleUser');
        NaviDrawerController.i.linkUser.value = GlobalController.i.userStorage.read('linkUser');
        NaviDrawerController.i.avatarUser.value = GlobalController.i.userStorage.read('avatarUser');
        NaviDrawerController.i.nameUser.value = GlobalController.i.userStorage.read('nameUser');
        GlobalController.i.alertNotification = value.getElementsByClassName('badgeContainer--highlighted').length > 0 ? value.getElementsByClassName('badgeContainer--highlighted')[0].attributes['data-badge'].toString() : '0';
        GlobalController.i.update();
      } else
        GlobalController.i.isLogged.value = false;

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
            title = ' ' +_title.map((e) => e.getElementsByTagName("a")[1].innerHtml).first;
            themeTitle = _title.map((e) => e.getElementsByTagName("span")[0].innerHtml).first;
            linkThread = _title.map((e) => e.getElementsByTagName("a")[1].attributes['href']).first!;
          }
           myThreadList.add({
            "title": title,
            "prefix": themeTitle,
            'isRead' : linkThread.contains('/unread') ? true : false,
            "authorName": element.attributes["data-author"],
            "link": linkThread,
            "replies": "Replies " + element.getElementsByClassName("pairs pairs--justified").map((e) => e.getElementsByTagName("dd")[0].innerHtml).first,
            "date": element.getElementsByClassName("structItem-latestDate u-dt").map((e) => e.innerHtml).first,
          });
        });
      });
      if (Get.isDialogOpen == true || refreshController.isLoading) {
        if (Get.isDialogOpen == true) Get.back();
        myThreadList.removeRange(0, lengthHtmlDataList);
        itemScrollController.scrollTo(
            index: currentPage + 1, duration: Duration(milliseconds: 100), curve: Curves.easeInOutCubic, alignment: GlobalController.i.pageNaviAlign);
        listViewScrollController.jumpTo(-10.0);
      }
      refreshController.loadComplete();
    }).then((value) => update());
  }
}
