import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:vozforums/GlobalController.dart';

class HomeController extends GetxController {
  late String header, label;
  List myHomePage = [];
  late PanelController panelController = PanelController();

  @override
  Future<void> onInit() async {
    super.onInit();
    //await GlobalController.i.setDataUser();
  }

  Future<void> onReady() async {
    await loading();
  }

  loading() async {
    await GlobalController.i.getBody(GlobalController.i.url, true).then((doc) async {
      //Set token

      GlobalController.i.dataCsrfLogin = doc!.getElementsByTagName('html')[0].attributes['data-csrf'];
      if (doc.getElementsByTagName('html')[0].attributes['data-logged-in'] == 'true') {
        GlobalController.i.isLogged.value = true;
        // NaviDrawerController.i.titleUser.value = GlobalController.i.userStorage.read('titleUser');
        // NaviDrawerController.i.linkUser.value = GlobalController.i.userStorage.read('linkUser');
        // NaviDrawerController.i.avatarUser.value = GlobalController.i.userStorage.read('avatarUser');
        // NaviDrawerController.i.nameUser.value = GlobalController.i.userStorage.read('nameUser');
        GlobalController.i.inboxNotifications = doc.getElementsByClassName('p-navgroup-link--conversations').length > 0
            ? int.parse(doc.getElementsByClassName('p-navgroup-link--conversations')[0].attributes['data-badge'].toString())
            : 0;
        GlobalController.i.alertNotifications = doc.getElementsByClassName('p-navgroup-link--alerts').length > 0
            ? int.parse(doc.getElementsByClassName('p-navgroup-link--alerts')[0].attributes['data-badge'].toString())
            : 0;
        GlobalController.i.update();
      } else
        GlobalController.i.isLogged.value = false;

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
    }).then((value) => {update()});
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
