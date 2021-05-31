import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ViewController extends GetxController {
  String _url = "https://voz.vn";
  String theme = '';
  var response;
  late dom.Document doc;
  List htmlData = [].obs;

  late String postContent;
  late String userPostDate;
  late String userName;
  late String userAvatar;
  late String userTitle;
  late String userLink;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    theme = Get.arguments[0];
    _url += Get.arguments[1];

    response = await http.get(Uri.parse(_url));
    //response = await http.get(Uri.parse("https://voz.vn/t/giup-do-tai-hoa-nhap-cong-dong.281960/"));
    print("load");
    doc = parser.parse(response.body);
    test();
  }

  // test(){
  //   doc.getElementsByClassName("p-pageWrapper").forEach((element) {
  //    //print( doc.getElementsByClassName("bbWrapper").map((e) => e.outerHtml));
  //    doc.getElementsByClassName("message-body js-selectToQuote").forEach((element) {
  //      htmlData.add(removeTag(element.outerHtml));
  //    });
  //   });
  // }

  test() {
    doc.getElementsByClassName("message message--post js-post js-inlineModContainer").forEach((element) {
      postContent = element.getElementsByClassName("message-body js-selectToQuote").map((e) => e.outerHtml).first;
      userPostDate = element.getElementsByClassName("u-concealed").map((e) => e.getElementsByTagName("time")[0].innerHtml).first;

      var user = element.getElementsByClassName("message-userDetails");
      userName = user.map((e) => e.getElementsByTagName("a")[0].innerHtml).first;
      userLink = user.map((e) => e.getElementsByTagName("a")[0].attributes['href']).first!;
      userTitle = user.map((e) => e.getElementsByTagName("h5")[0].innerHtml).first;

      htmlData.add(removeTag(postContent));
    });
  }

  test2() {
    //_write(htmlData[3]);

    doc.getElementsByClassName("message message--post js-post js-inlineModContainer").forEach((element) {
      // late String userAvatar;

      var user = element.getElementsByClassName("message-avatar-wrapper");
      if (user.map((e) => e.getElementsByTagName("img").length).toString() == "(1)") {
        print(user.map((e) => e.getElementsByTagName("img")[0].attributes['src']).first);
      } else
        print("no");
      // String avt = element.getElementsByTagName("img")[0].attributes['src'].toString();
      // if (!avt.contains("/data/avatars/m")){
      //   print("khong co avata");
      // } else print(avt);

      //print(user.map((e) => e.getElementsByTagName("img")[0].outerHtml));
      // print(user.map((e) => e.getElementsByTagName("img")[0].attributes['src']).first);
      // print(user.map((e) => e.getElementsByTagName("a")[0].innerHtml).first);
    });
  }

  removeTag(String content) {
    return content.replaceAll(
        RegExp(r'<div class="bbCodeBlock-expandLink js-expandLink"><a role="button" tabindex="0">Click to expand...</a></div>'), "");
  }

  _write(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/my_file.txt');
    await file.writeAsString(text);
    print('${directory.path}/my_file.txt');
    print(File('${directory.path}/my_file.txt').toString());
  }
}
