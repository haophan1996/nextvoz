import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class ViewController extends GetxController {
  String _url = "https://voz.vn";
  String theme = '';
  var response;
  late dom.Document doc;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    theme = Get.arguments[0];
    _url+=Get.arguments[1];

    response = await http.get(Uri.parse(_url));
    doc = parser.parse(response.body);
    print("as");
  }

  test(){
   // doc.getElementsByClassName(classNames)
  }
}
