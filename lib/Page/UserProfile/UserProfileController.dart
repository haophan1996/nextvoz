import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:vozforums/GlobalController.dart';
import 'package:vozforums/Page/NavigationDrawer/NaviDrawerController.dart';

class UserProfileController extends GetxController {
  late var xfCsrfPost;
  late var dataCsrfPost;

  @override
  onInit() async {
    super.onInit();
    await getIDPage();
  }

  getIDPage() async {
    await GlobalController.i.getBody(GlobalController.i.url + NaviDrawerController.i.linkUser.value, false).then((value) {
      dataCsrfPost = value.getElementsByTagName('html')[0].attributes['data-csrf'];
    });
  }

  uploadStatus() async {
    var header = {
      'cookie': 'xf_user=${GlobalController.i.xfUser.toString()}; $xfCsrfPost',
      'referer': GlobalController.i.url + NaviDrawerController.i.linkUser.value,
      'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
      'User-Agent': NaviDrawerController.i.nameUser.value,
      'Host': 'voz.vn'
    };
    var body = {
      'message_html': 'post tu app flutter',
      'load_extra': '1',
      '_xfToken': dataCsrfPost,
      '_xfRequestUri': NaviDrawerController.i.linkUser.value,
      '_xfResponseType': 'json'
    };

    await http.post(Uri.parse(GlobalController.i.url + NaviDrawerController.i.linkUser.value + "/post"), headers: header, body: body).then((value) {
      print(value.statusCode);
      print(value.headers);
      print(value.body);
    });
  }
}
