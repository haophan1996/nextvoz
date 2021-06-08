import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:vozforums/GlobalController.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  late String header;
  RxList myHomePage = [].obs;

  @override
  onInit() async {
    super.onInit();
    GlobalController.i.percentDownload.value = 0.01;
    theme();
  }

  theme() async {
    await GlobalController.i.getBody(GlobalController.i.url).then((value) async {
      value.getElementsByClassName("block block--category block--category").forEach((element) {
        header = element.getElementsByTagName("a")[0].innerHtml;
        element.getElementsByClassName("node-title").forEach((element) {
          myHomePage.add({
            "header": header,
            "subHeader": element.getElementsByTagName("a")[0].innerHtml.trim(),
            "linkSubHeader": element.getElementsByTagName("a")[0].attributes['href'].toString()
          });
        });
      });
    });
  }


  navigateToThread(String title, String link) {
    Future.delayed(Duration(milliseconds: 200), (){
      Get.toNamed("/ThreadPage", arguments: [title, GlobalController.i.url + link]);
    });
  }
}
