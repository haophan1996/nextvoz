import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '/GlobalController.dart';
import 'package:html/dom.dart' as dom;
import 'UserFollIgrType.dart';

class UserFollIgrController extends GetxController {
  Map<String, dynamic> data = {};
  List htmlData = [];
  var dio = Dio();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    data['percentDownload'] = 0.0;
    data['text'] = 'Loading';

    data['title'] = Get.arguments[0];
  }

  @override
  Future<void> onReady() async {
    // TODO: implement onReady
    super.onReady();
    await action();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    GlobalController.i.sessionTag.removeLast();
  }

  action() async {
    switch (data['title']) {
      case UserFollIgrType.Follow:
        await performActionFollowing();
        break;
      case UserFollIgrType.Ignore:
        print('ignore');
        break;
    }
  }

  performActionFollowing() async {
    await GlobalController.i.getBodyBeta((value) {
      ///Error
    }, (download) {
      data['percentDownload'] = download;
      update(['download'], true);
    }, dio, GlobalController.i.url + '/account/following', false).then((value) {
      performParseDataFollowing(value!);

    });
  }


  performParseDataFollowing(dom.Document value){
    data['dataCsrfPost'] = value.getElementsByTagName('html')[0].attributes['data-csrf'];

    if (value.getElementsByTagName('html')[0].attributes['data-logged-in'] == 'true') {
      GlobalController.i.controlNotification(
          int.parse(value.getElementsByClassName('p-navgroup-link--alerts')[0].attributes['data-badge'].toString()),
          int.parse(value.getElementsByClassName('p-navgroup-link--conversations')[0].attributes['data-badge'].toString()),
          value.getElementsByTagName('html')[0].attributes['data-logged-in'].toString());
    } else
      GlobalController.i.controlNotification(0, 0, 'false');



    value.getElementsByClassName('block-row block-row--separated').forEach((element) { 
      data['username'] = element.getElementsByClassName('username ')[0].text.trim();
      data['usernameLink'] = element.getElementsByClassName('username ')[0].attributes['href'];
      data['userTitle'] = element.getElementsByClassName('userTitle')[0].text.trim();
      data['follow'] = element.getElementsByClassName('button-text')[0].text.trim();

      if (element.getElementsByClassName('avatar avatar--s')[0].getElementsByTagName('img').length > 0) {
        data['_userAvatar'] = element.getElementsByClassName('avatar avatar--s')[0].getElementsByTagName('img')[0].attributes['src'].toString();
        data['avatarColor1'] = '0x00000000';
        data['avatarColor2'] = '0x00000000';
        if (data['_userAvatar'].contains('https') == false) {
          data['_userAvatar'] = GlobalController.i.url + data['_userAvatar'];
        }
      } else {
        data['_userAvatar'] = 'no';
        data['avatarColor1'] =
            '0xFFF' + element.getElementsByClassName('avatar avatar--s')[0].attributes['style'].toString().split('#')[1].split(';')[0];
        data['avatarColor2'] = '0xFFF' + element.getElementsByClassName('avatar avatar--s')[0].attributes['style'].toString().split('#')[2];
      }

      htmlData.add({
        'username' : data['username'],
        'usernameLink' : data['usernameLink'],
        'userTitle' : data['userTitle'],
        'follow' : data['follow'] == 'Unfollow' ? true : false,
        '_userAvatar' : data['_userAvatar'],
        'avatarColor1' : data['avatarColor1'],
        'avatarColor2' : data['avatarColor2'],
      });
    update(['first']);
    });
  }

  performUnFollow(int index){
    var headers = {
      'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
      'host': 'voz.vn',
      'cookie': '${data['xfCsrfPost']}; xf_user=${GlobalController.i.xfUser};',
    };

    var body = {'_xfWithData': '1', '_xfToken': '${data['dataCsrfPost']}', '_xfResponseType': 'json'};
  }
}
