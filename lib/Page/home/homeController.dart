import 'package:get/get.dart';
import '/GlobalController.dart';

class HomeController extends GetxController {
  String loadingStatus = 'loading';
  List myHomePage = [];

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  Future<void> onReady() async {
    super.onReady();
    // Get.toNamed('/Settings');


    if (GlobalController.i.userStorage.read('defaultsPage') == true){

      Get.toNamed("/ThreadPage", arguments: [GlobalController.i.userStorage.read('defaultsPage_title'), GlobalController.i.userStorage.read('defaultsPage_link')]);

      if (GlobalController.i.userStorage.read('homeList') == null){
        await loading();
      } else {
        loadingStatus = 'loadSucceeded';
        myHomePage = GlobalController.i.userStorage.read('homeList');
        update();
      }
    } else await loading();





    // if (Get.currentRoute != '/' && GlobalController.i.userStorage.read('homeList') != null) {
    //   myHomePage = GlobalController.i.userStorage.read('homeList');
    //   loadingStatus = 'loadSucceeded';
    //   update();
    // } else
    //   await loading();
  }

  onLoadError() {
    loadingStatus = 'loadFailed';
    update();
  }

  onRefresh() async {
    update();
    await loading();
  }

  loading() async {
    loadingStatus = 'loading';
    await GlobalController.i.getBodyBeta(() => onLoadError(), GlobalController.i.url, true).then((doc) async {
      //Set token
      GlobalController.i.dataCsrfLogin = doc!.getElementsByTagName('html')[0].attributes['data-csrf'];
      if (doc.getElementsByTagName('html')[0].attributes['data-logged-in'] == 'true') {
        GlobalController.i.isLogged = true;
        GlobalController.i.inboxNotifications = doc.getElementsByClassName('p-navgroup-link--conversations').length > 0
            ? int.parse(doc.getElementsByClassName('p-navgroup-link--conversations')[0].attributes['data-badge'].toString())
            : 0;
        GlobalController.i.alertNotifications = doc.getElementsByClassName('p-navgroup-link--alerts').length > 0
            ? int.parse(doc.getElementsByClassName('p-navgroup-link--alerts')[0].attributes['data-badge'].toString())
            : 0;
        GlobalController.i.update();
      } else
        GlobalController.i.isLogged = false;

      doc.getElementsByClassName("block block--category block--category").forEach((value) {
        value.getElementsByClassName("node-body").forEach((element) {
          myHomePage.add({
            "header": value.getElementsByTagName("a")[0].innerHtml.replaceAll("&amp;", "&"),
            "title": (element.getElementsByClassName("label label").length > 0
                    ? (element.getElementsByClassName("label label")[0].innerHtml + ": ")
                    : "") +
                element.getElementsByClassName("node-extra-row").map((e) => e.getElementsByTagName("a")[0].attributes["title"]).first!.trim(),
            "subHeader": element.getElementsByTagName("a")[0].innerHtml.trim().replaceAll("&amp;", "&"),
            "linkSubHeader": element.getElementsByTagName("a")[0].attributes['href'].toString(),
            "threads": "Threads: " +
                element.getElementsByClassName("pairs pairs--inline").map((e) => e.getElementsByTagName("dd")[0].innerHtml).elementAt(0),
            "messages": "Messages: " +
                element.getElementsByClassName("pairs pairs--inline").map((e) => e.getElementsByTagName("dd")[0].innerHtml).elementAt(1)
          });
        });
      });
    }).then((value) {
      loadingStatus = 'loadSucceeded';
      update();
      GlobalController.i.userStorage.write('homeList', myHomePage);
    });
  }

  navigateToThread(String title, String link) async {
    Future.delayed(Duration(milliseconds: 200), () {
      Get.toNamed("/ThreadPage", arguments: [title, GlobalController.i.url + link]);
    });
  }
}
// doc = await GlobalController.i.getBody(GlobalController.i.url);
// late dom.Document doc;
// doc.getElementsByClassName("block block--category block--category")
