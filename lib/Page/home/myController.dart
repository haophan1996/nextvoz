import 'package:web_scraper/web_scraper.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;


class HomeController extends GetxController {
  var response;
  late WebScraper webScraper;
  late dom.Document doc;
  late dom.Document doc2;
  List<String> myData = [];
  RxList myHomePage = [].obs;

  @override
  onInit() async {
    super.onInit();
    response = await http.get(Uri.parse("https://voz.vn/"));
    doc = parser.parse(response.body);
    theme();
  }


  theme() {
    doc.getElementsByClassName("block-container").forEach((element) {
      final the = element.getElementsByClassName("block-header");
      String s = the
          .map((e) => e.getElementsByTagName("a")[0].innerHtml)
          .toString()
          .replaceAll(")", "")
          .replaceAll("(", "")
          .replaceAll("&amp;", "&");
      if (s.length > 5) {
        final e = element.getElementsByClassName("node-title");
        e.forEach((element) {
          myHomePage.add({
            "theme": s,
            "title": element
                .getElementsByTagName("a")[0]
                .innerHtml
                .trim()
                .replaceAll("&amp;", "&"),
            "link": element
                .getElementsByTagName("a")[0]
                .attributes['href']
                .toString()
          });
        });
      }
    });
  }

/*test() async {
    final element = doc.getElementsByClassName("node-title");
    List<String?> as = element
        .map((e) => e.getElementsByTagName("a")[0].attributes['href'])
        .toList();
    List<String> ac =
        element.map((e) => e.getElementsByTagName("a")[0].innerHtml).toList();
    for (int i = 0; i < ac.length; i++) {
      //myHomePage.add(modelHome(ac.elementAt(i).trim(), as.elementAt(i)!.trim()));
    }

    // final regTitle = RegExp( r'<a\s\S*\s\S*\sdata-shortcut="node-description">(.*?)</a>', multiLine: false);
    // final regLink = RegExp(r'<a href="(.*?)"', multiLine: false);
    //
    // String s = myData.elementAt(3).replaceAll(new RegExp(r'(?:[\t ]*(?:\r?\n|\r))+'), '\n');
    //
    // final r = RegExp( r'<a\s\S*\s\S*\sdata-shortcut="node-description">\[s*](.*?)</a>', multiLine: true);
    // var test = r.allMatches(s);
    // print( element.map((e) => e.getElementsByTagName("a")[0].attributes['href']));
    //print( element.map((e) => e.getElementsByTagName("a")[0].innerHtml));
    // ac.forEach((element) {
    //   print("$element \n");
    // });

    // for (int i = 0; i < myData.length; i++) {
    //   var link = regLink.allMatches(myData.elementAt(i));
    //   var title = regTitle.allMatches(myData.elementAt(i));
    //   print(linkcc);
    //   print(title.map((e) => e.group(1)).first);
    // }

    // for(int i =0; i < myData.length; i++){
    //   test = intReg.allMatches(myData.elementAt(i));
    //   test.map((e) => e.group(1)).toString().replaceAll(")", "").replaceAll("(", "");
    //   myTitle.add(test.map((e) => e.group(1)).toString().replaceAll(")", "").replaceAll("(", ""));
    // }
    // print(myTitle);
  }*/
}
