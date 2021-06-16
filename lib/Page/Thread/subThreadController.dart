import 'package:flutter/cupertino.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:get/get.dart';
import 'package:vozforums/GlobalController.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ThreadController extends GetxController {
  late String _url;
  late String theme;
  late RefreshController refreshController = RefreshController(initialRefresh: false);
  late ScrollController listViewScrollController = ScrollController();
  late ItemScrollController itemScrollController = ItemScrollController();

  RxList myThreadList = [].obs;
  RxInt currentPage = 0.obs;
  RxInt totalPage = 0.obs;
  int lengthHtmlDataList = 0;
  var _title;
  var authorLink;
  var authorName;
  var replies;
  var date;
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

  navigateToThread(String title, String link) {
    Future.delayed(Duration(milliseconds: 100), (){
      Get.toNamed("/ViewPage", arguments: [title, link]);
    });
  }

  @override
  onClose() async {
    super.onClose();
    refreshController.dispose();
    listViewScrollController.dispose();
    myThreadList.close();
    currentPage.close();
    totalPage.close();
  }

  setPageOnClick(String toPage) async {
    await loadSubHeader(_url + GlobalController.i.pageLink + toPage);
  }

  loadSubHeader(String url) async {
    await GlobalController.i.getBody(url, false).then((value) async {
      lengthHtmlDataList = myThreadList.length;
      value.getElementsByClassName("p-body-content").forEach((element) async {
        lastP = element.getElementsByClassName("pageNavSimple");
        if (lastP.length == 0) {
          currentPage.value = 1;
          totalPage.value = 1;
        } else {
          var naviPage = element
              .getElementsByClassName("pageNavSimple-el pageNavSimple-el--current")
              .first
              .innerHtml
              .trim();
          currentPage.value = int.parse(naviPage.replaceAll(RegExp(r'[^0-9]\S*'), ""));
          totalPage.value = int.parse(naviPage.replaceAll(RegExp(r'\S*[^0-9]'), ""));
        }
        //Detail SubHeader
        element.getElementsByClassName("structItem structItem--thread").forEach((element) async {
          _title = element.getElementsByClassName("structItem-title");
          authorLink = element
              .getElementsByClassName("structItem-parts")
              .map((e) => e.getElementsByTagName("a")[0].attributes['href'])
              .first;
          authorName = element.attributes["data-author"];
          replies = element
              .getElementsByClassName("pairs pairs--justified")
              .map((e) => e.getElementsByTagName("dd")[0].innerHtml)
              .first;
          date = element
              .getElementsByClassName("structItem-latestDate u-dt")
              .map((e) => e.innerHtml)
              .first;
          if (_title.map((e) =>
          e
              .getElementsByTagName("a")
              .length).toString() == "(1)") {
            title = _title
                .map((e) => e.getElementsByTagName("a")[0].innerHtml)
                .first;
            linkThread = _title
                .map((e) => e.getElementsByTagName("a")[0].attributes['href'])
                .first!;
          } else {
            title = "   " + _title
                .map((e) => e.getElementsByTagName("a")[1].innerHtml)
                .first;
            themeTitle = _title
                .map((e) => e.getElementsByTagName("span")[0].innerHtml)
                .first;
            linkThread = _title
                .map((e) => e.getElementsByTagName("a")[1].attributes['href'])
                .first!;
          }
          myThreadList.add({
            "title": title,
            "themeTitle": themeTitle,
            "authorLink": authorLink,
            "authorName": authorName,
            "linkThread": linkThread,
            "replies": "Replies " + replies,
            "date": date,
          });
        });
      });
      if (Get.isDialogOpen == true || refreshController.isLoading) {
        if (Get.isDialogOpen == true) Get.back();
        myThreadList.removeRange(0, lengthHtmlDataList);
        itemScrollController.scrollTo(index: currentPage.value + 1, duration: Duration(seconds: 2),curve: Curves.easeInOutCubic,alignment: GlobalController.i.pageNaviAlign);
        listViewScrollController.jumpTo(-10.0);
      }

      refreshController.loadComplete();

    });

  }
}
