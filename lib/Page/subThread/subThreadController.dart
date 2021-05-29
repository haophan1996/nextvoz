import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:vozforums/Page/ThreadView/ViewBinding.dart';
import 'package:vozforums/Page/ThreadView/ViewUI.dart';

class ThreadController extends GetxController {
  late String _url;
  late String theme;
  late String crawlPage;
  late dom.Document doc;
  var response;
  final int loadItems = 50;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  final String pageLink = "page-";
  RxList myThreadList = [].obs;
  RxList myThreadListLoading = [].obs;
  RxInt currentPage = 0.obs;
  RxInt totalPage = 0.obs;
  List pages = [].obs;

  var linkThread = '';
  var themeTitle = "";
  var title = "";

  @override
  Future<void> onInit() async {
    super.onInit();
    pages.add("1");
    theme = Get.arguments[0];
    _url = Get.arguments[1];
    response = await http.get(Uri.parse(_url));
    doc = parser.parse(response.body);
    await myThread();
    pages.clear();
    if (totalPage.value > 20) {
      pages = List.generate(20, (index) => "${index+1}").obs;
    } else {
      pages = List.generate(totalPage.value, (index) => "${index + 1}").obs;
    }

    itemPositionsListener.itemPositions.addListener(() {
      if (itemPositionsListener.itemPositions.value.last.index > (pages.length-10)){
        int loadMore = totalPage.value - pages.length;
         //    10            total 30   length = 20
        //
        if (loadMore < loadItems){
           loadMore=totalPage.value;
        } else {
          loadMore=pages.length+loadItems;
        }
        for(int i = pages.length+1; i <= loadMore;i++){
          pages.add(i.toString());
        }
      }
    });
  }

  navigateToThread(String title, String link) {
    Get.to(() => ViewUI(),
        binding: ViewBinding(), arguments: [title, link]);
  }

  setPageOnClick(String toPage) async {
    await onPageChange();
    response = await http.get(Uri.parse(_url + pageLink + toPage));
    doc = parser.parse(response.body);
    await myThread();
  }

  onPageChange() {
    crawlPage = "";
    doc.remove();
    response = null;
  }

  myThread() {
    doc.getElementsByClassName("p-body-content").forEach((element) {
      //Get current page and total Page
      var lastP = element.getElementsByClassName("pageNavSimple");
      if (lastP.length == 0) {
        currentPage.value = 1;
        totalPage.value = 1;
      } else {
        if (lastP.map((e) => e.getElementsByTagName("a")[0].innerHtml).first.trim().length > 50) {
          crawlPage = lastP.map((e) => e.getElementsByTagName("a")[2].innerHtml).first.trim();
        } else {
          crawlPage = lastP.map((e) => e.getElementsByTagName("a")[0].innerHtml).first.trim();
        }
        currentPage.value = int.parse(crawlPage.replaceAll(RegExp(r'[^0-9]\S*'), ""));
        totalPage.value = int.parse(crawlPage.replaceAll(RegExp(r'\S*[^0-9]'), ""));
      }
      //Get detail thread
      element.getElementsByClassName("structItem structItem--thread").forEach((element) {
        var _title = element.getElementsByClassName("structItem-title");
        var authorLink = element.getElementsByClassName("structItem-parts").map((e) => e.getElementsByTagName("a")[0].attributes['href']).first;
        var authorName = element.attributes["data-author"];
        var replies = element.getElementsByClassName("pairs pairs--justified").map((e) => e.getElementsByTagName("dd")[0].innerHtml).first;
        var date = element.getElementsByClassName("structItem-latestDate u-dt").map((e) => e.innerHtml).first;

        if (_title.map((e) => e.getElementsByTagName("a").length).toString() == "(1)") {
          title = _title.map((e) => e.getElementsByTagName("a")[0].innerHtml).first;
          linkThread = _title.map((e) => e.getElementsByTagName("a")[0].attributes['href']).first!;
        } else {
          title = " " + _title.map((e) => e.getElementsByTagName("a")[1].innerHtml).first;
          themeTitle = _title.map((e) => e.getElementsByTagName("span")[0].innerHtml).first;
          linkThread = _title.map((e) => e.getElementsByTagName("a")[1].attributes['href']).first!;
        }
        myThreadListLoading.add({
          "title": title,
          "themeTitle": themeTitle,
          "authorLink": authorLink,
          "authorName": authorName,
          "linkThread": linkThread,
          "replies": replies,
          "date": date,
        });
      });
      myThreadList.clear();
    });
    if(Get.isDialogOpen == true){
      Get.back();
    }
    myThreadList.addAll(myThreadListLoading);
    myThreadListLoading.clear();
  }
}
