import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:nextvoz/Routes/routes.dart';
import '../reuseWidget.dart';
import '/GlobalController.dart';

class HomeController extends GetxController {
  String loadingStatus = 'loading';
  List myHomePage = [];
  double percentDownload = 0.0;
  var dio = Dio();

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  Future<void> onReady() async {
    super.onReady();
    if (GlobalController.i.userStorage.read('defaultsPage') == true) {
      navigateToThread(GlobalController.i.userStorage.read('defaultsPage_title'), GlobalController.i.userStorage.read('defaultsPage_link'));
      if (GlobalController.i.userStorage.read('homeList') == null) {
        await loading();
      } else {
        loadingStatus = 'loadSucceeded';
        myHomePage = GlobalController.i.userStorage.read('homeList');
        update();
      }
    } else
      await loading();
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
    await GlobalController.i.getBodyBeta((value) async {
      if (value == 1) {
        setDialogError(value.toString());
        await loading();
      } else
        onLoadError();
    }, (download) {
      percentDownload = download;
      update(['download'], true);
    }, dio, GlobalController.i.url, true).then((doc) async {
      //Set token
      GlobalController.i.dataCsrfLogin = doc!.getElementsByTagName('html')[0].attributes['data-csrf'];
      GlobalController.i.token = doc.getElementsByTagName('html')[0].attributes['data-csrf'];

      if (doc.getElementsByTagName('html')[0].attributes['data-logged-in'] == 'true') {
        GlobalController.i.controlNotification(
            int.parse(doc.getElementsByClassName('p-navgroup-link--alerts')[0].attributes['data-badge'].toString()),
            int.parse(doc.getElementsByClassName('p-navgroup-link--conversations')[0].attributes['data-badge'].toString()),
            doc.getElementsByTagName('html')[0].attributes['data-logged-in'].toString());
      } else
        GlobalController.i.controlNotification(0, 0, 'false');

      doc.getElementsByClassName("block block--category block--category").forEach((value) {
        value.getElementsByClassName("node-body").forEach((element) {
          myHomePage.add({
            "header": value.getElementsByTagName("a")[0].innerHtml.replaceAll("&amp;", "&"),
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

  navigateToThread(String title, String link) {
    Get.toNamed(Routes.Thread, arguments: [title, GlobalController.i.url + link]);
  }
}
