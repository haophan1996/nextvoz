import 'package:dio_http/dio_http.dart';
import 'package:get/get.dart';
import '../../reuseWidget.dart';
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
    update(['first']);
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    GlobalController.i.sessionTag.removeLast();
  }

  action() async {
    htmlData.clear();
    switch (data['title']) {
      case UserFollIgrType.Follow:
        await performActionFollowing();
        break;
      case UserFollIgrType.Ignore:
        await performActionIgnoring();
        break;
    }
  }

  performActionIgnoring() async {
    await GlobalController.i.getBodyBeta((value) {
      ///error
    }, (download) {
      data['percentDownload'] = download;
      update(['download'], true);
    }, dio, GlobalController.i.url + '/account/ignored', false).then((value) => performParseDataIgnoring(value!));
  }

  performParseDataIgnoring(dom.Document value) {
    data['token'] = value.getElementsByTagName('html')[0].attributes['data-csrf'];
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
        'username': data['username'],
        'usernameLink': data['usernameLink'],
        'userTitle': data['userTitle'],
        'follow': data['follow'] == 'Unignore' ? true : false,
        '_userAvatar': data['_userAvatar'],
        'avatarColor1': data['avatarColor1'],
        'avatarColor2': data['avatarColor2'],
      });
    });

    if (htmlData.length == 0) {
      data['text'] = 'You are not currently ignoring any members.';
    }
    //update(['first']);
  }

  performUnIgnore(int index) async{
    setDialog();
    var headers = {
      'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
      'host': 'voz.vn',
      'cookie': '${GlobalController.i.xfCsrfPost}; ${GlobalController.i.userLoginCookie}',
    };

    var body = {'_xfWithData': '1', '_xfToken': '${data['token']}', '_xfResponseType': 'json'};

    await GlobalController.i
        .getHttpPost(true, headers, body, GlobalController.i.url + htmlData.elementAt(index)['usernameLink'] + 'ignore')
        .then((value) {
      if (Get.isDialogOpen == true) Get.back();
      if (value['status'] == 'ok') {
        if (value['switchKey'] == 'ignore') {
          //Following
          htmlData.elementAt(index)['follow'] = false;
        } else
          htmlData.elementAt(index)['follow'] = true;
        update(['$index']);
      } else {
        setDialogError(value['message']);
      }
    });
  }

  performActionFollowing() async {
    await GlobalController.i.getBodyBeta((value) {
      ///Error
    }, (download) {
      data['percentDownload'] = download;
      update(['download'], true);
    }, dio, GlobalController.i.url + '/account/following', false).then((value) => performParseDataFollowing(value!));
  }

  performParseDataFollowing(dom.Document value) {
    data['token'] = value.getElementsByTagName('html')[0].attributes['data-csrf'];
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
        'username': data['username'],
        'usernameLink': data['usernameLink'],
        'userTitle': data['userTitle'],
        'follow': data['follow'] == 'Unfollow' ? true : false,
        '_userAvatar': data['_userAvatar'],
        'avatarColor1': data['avatarColor1'],
        'avatarColor2': data['avatarColor2'],
      });
    });

    if (htmlData.length == 0) {
      data['text'] = 'You are not currently following any members.';
    }
    //update(['first']);
  }

  performUnFollow(int index) async {
    setDialog();
    var headers = {
      'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
      'host': 'voz.vn',
      'cookie': '${GlobalController.i.xfCsrfPost}; ${GlobalController.i.userLoginCookie}',
    };

    var body = {'_xfWithData': '1', '_xfToken': '${data['token']}', '_xfResponseType': 'json'};

    await GlobalController.i
        .getHttpPost(true, headers, body, GlobalController.i.url + htmlData.elementAt(index)['usernameLink'] + 'follow')
        .then((value) {
      if (Get.isDialogOpen == true) Get.back();
      if (value['status'] == 'ok') {
        if (value['switchKey'] == 'unfollow') {
          //Following
          htmlData.elementAt(index)['follow'] = true;
        } else
          htmlData.elementAt(index)['follow'] = false;
        update(['$index']);
      } else {
        setDialogError(value['message']);
      }
    });
  }
}
