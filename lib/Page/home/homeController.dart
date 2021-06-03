import 'package:vozforums/GlobalController.dart';
import 'package:vozforums/Page/subThread/subThreadBinding.dart';
import 'package:vozforums/Page/subThread/subThreadUI.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final String _url = "https://voz.vn";
  late String header;
  RxList myHomePage = [].obs;


  @override
  onInit() async {
    super.onInit();
    theme();
  }

  theme() async {
    await GlobalController.i.getBody(_url).then((value) async {
      value.getElementsByClassName("block block--category block--category").forEach((element) {
        header = element.getElementsByTagName("a")[0].innerHtml;
        element.getElementsByClassName("node-title").forEach((element) {
          myHomePage.add({
            "header" : header,
            "subHeader" : element.getElementsByTagName("a")[0].innerHtml.trim(),
            "linkSubHeader" : element.getElementsByTagName("a")[0].attributes['href'].toString()
          });
        });
      });
    });
  }


  navigateToThread(String title, String link) {
    Get.to(() => ThreadUI(), binding: ThreadBinding(), arguments: [title, _url + link], popGesture: true, transition: Transition.cupertino);
  }

}
