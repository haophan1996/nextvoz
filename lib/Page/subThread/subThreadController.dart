import 'package:flutter/cupertino.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:vozforums/Page/ThreadView/ViewBinding.dart';
import 'package:vozforums/Page/ThreadView/ViewUI.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ThreadController extends GetxController {
  late String _url;
  late String theme;
  late String crawlPage;
  late dom.Document doc;
  var response;
  final int loadItems = 50;
  final RefreshController refreshController = RefreshController(initialRefresh: false);
  final ScrollController listViewScrollController = ScrollController();
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  final String pageLink = "page-";
  RxList myThreadList = [].obs;
  RxInt currentPage = 0.obs;
  RxInt totalPage = 0.obs;
  List pages = [].obs;
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
    response = await http.get(Uri.parse(_url));
    doc = parser.parse(response.body);
    await myThread();

    if (totalPage.value > 20) {
      pages = List.generate(20, (index) => "${index + 1}").obs;
    } else {
      pages = List.generate(totalPage.value, (index) => "${index + 1}").obs;
    }

    itemPositionsListener.itemPositions.addListener(() {
      if (itemPositionsListener.itemPositions.value.last.index > (pages.length - 10)) {
        int loadMore = totalPage.value - pages.length;
        //    10            total 30   length = 20
        //
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

  navigateToThread(String title, String link) {
    Get.to(() => ViewUI(), binding: ViewBinding(), arguments: [title, link], popGesture: true, transition: Transition.cupertino);
  }

  setPageOnClick(String toPage) async {
    response = await http.get(Uri.parse(_url + pageLink + toPage));
    doc = parser.parse(response.body);
    await myThread();
    refreshController.loadComplete();
    itemScrollController.scrollTo(index: int.parse(toPage)+1, duration: Duration(microseconds: 500), alignment: 0.735);
    listViewScrollController.jumpTo(-10.0);

    doc.remove();
    response = null;
  }



  myThread() async{
    lengthHtmlDataList = myThreadList.length;
    doc.getElementsByClassName("p-body-content").forEach((element) {
      //Get current page and total Page
      lastP = element.getElementsByClassName("pageNavSimple");
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
        _title = element.getElementsByClassName("structItem-title");
        authorLink = element.getElementsByClassName("structItem-parts").map((e) => e.getElementsByTagName("a")[0].attributes['href']).first;
        authorName = element.attributes["data-author"];
        replies = element.getElementsByClassName("pairs pairs--justified").map((e) => e.getElementsByTagName("dd")[0].innerHtml).first;
        date = element.getElementsByClassName("structItem-latestDate u-dt").map((e) => e.innerHtml).first;

        if (_title.map((e) => e.getElementsByTagName("a").length).toString() == "(1)") {
          title = _title.map((e) => e.getElementsByTagName("a")[0].innerHtml).first;
          linkThread = _title.map((e) => e.getElementsByTagName("a")[0].attributes['href']).first!;
        } else {
          title = " " + _title.map((e) => e.getElementsByTagName("a")[1].innerHtml).first;
          themeTitle = _title.map((e) => e.getElementsByTagName("span")[0].innerHtml).first;
          linkThread = _title.map((e) => e.getElementsByTagName("a")[1].attributes['href']).first!;
        }
        myThreadList.add({
          "title": title,
          "themeTitle": themeTitle,
          "authorLink": authorLink,
          "authorName": authorName,
          "linkThread": linkThread,
          "replies": replies,
          "date": date,
        });
      });
    });
    if (Get.isDialogOpen == true || refreshController.isLoading) {
      if (Get.isDialogOpen==true)  Get.back();
      myThreadList.removeRange(0, lengthHtmlDataList);
    }
  }
}
