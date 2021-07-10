import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:dio/dio.dart';
import 'package:vozforums/Page/NavigationDrawer/NaviDrawerController.dart';

class GlobalController extends GetxController {
  static GlobalController get i => Get.find();
  late dom.Document doc;
  final String url = "https://voz.vn",
      pageLink = "page-",
      inboxReactLink = 'https://voz.vn/conversations/messages/',
      viewReactLink = 'https://voz.vn/p/';
  final pageNaviAlign = 0.72, userStorage = GetStorage();
  double percentDownload = 0.0;
  var dio = Dio(), xfCsrfLogin, dataCsrfLogin, xfCsrfPost, dataCsrfPost;
  RxBool isLogged = false.obs;
  List alertList = [], tagView = [];
  String xfSession = '', dateExpire = '', xfUser = '';
  int alertNotifications = 0, inboxNotifications = 0;

  @override
  onInit() async {
    super.onInit();
    isLogged.stream.listen((event) {
      if (event == false) {
        alertNotifications = 0;
        inboxNotifications = 0;
      }
    });
  }

  Future<dom.Document> getBody(String url, bool isHomePage) async {
    percentDownload = 0.1;
    update();
    final response = await dio.get(url, onReceiveProgress: (actual, total) {
      percentDownload = (actual.bitLength - 4) / total.bitLength;
      update();
    }).whenComplete(() async {
      percentDownload = -1.0;
      update();
    }).catchError((err) {
      if (CancelToken.isCancel(err)) {
        print('Request canceled! ' + err.message);
      } else {
        print("Heysacsa");
      }
    });
    xfCsrfPost = cookXfCsrf(response.headers['set-cookie'].toString());
    if (isHomePage == true) xfCsrfLogin = cookXfCsrf(response.headers['set-cookie'].toString());

    return parser.parse(response.toString());
  }

  getAlert() async {
    String username, threadName, reaction, time, status, link, key;
    if (isLogged.value == true) {
      getBody(url + '/account/alerts?page=1', false).then((value) {
        GlobalController.i.inboxNotifications = value.getElementsByClassName('p-navgroup-link--conversations').length > 0
            ? int.parse(value.getElementsByClassName('p-navgroup-link--conversations')[0].attributes['data-badge'].toString())
            : 0;
        GlobalController.i.alertNotifications = value.getElementsByClassName('p-navgroup-link--alerts').length > 0
            ? int.parse(value.getElementsByClassName('p-navgroup-link--alerts')[0].attributes['data-badge'].toString())
            : 0;
        GlobalController.i.update();

        value.getElementsByClassName('alert js-alert block-row block-row--separated').forEach((element) {
          time = element.getElementsByTagName('time')[0].innerHtml;
          status = element.getElementsByClassName('contentRow-main contentRow-main--close')[0].text.replaceAll(time, '').trim();
          link = element.getElementsByClassName('fauxBlockLink-blockLink')[0].attributes['href'].toString();
          if (element.getElementsByClassName('username ').length > 0) {
            username = element.getElementsByClassName('username ')[0].text;
            key = status.contains('the thread')
                ? 'the thread'
                : status.contains('a thread called')
                    ? 'a thread called'
                    : 'the conversation'; //'a thread called' ? '' : '';
            threadName = status.split('.')[0].trim().split(key)[1];
            status = status.split('.')[0].trim().split(key)[0].replaceAll(username, '') + key;
          } else {
            username = '';
            threadName = '';
          }
          if (threadName.contains('with  Ưng')) {
            threadName = threadName.split('with  Ưng')[0];
            reaction = '1';
          } else if (threadName.contains('with  Gạch')) {
            threadName = threadName.split('with  Gạch')[0];
            reaction = '2';
          } else
            reaction = '';

          alertList.add({
            'username': username,
            'status': status,
            'threadName': threadName,
            'reaction': reaction,
            'link': link,
            'time': time,
          });
        });
        update();
      });
    }
  }

  getInboxAlert(){

  }

  Future getHttpPost(Map<String, String> header, Map<String, String> body, String link) async {
    final response = await http.post(Uri.parse(link), headers: header, body: body);
    return jsonDecode(response.body);
  }

  setDataUser() async {
    if (userStorage.read('shortcut') != null) {
      NaviDrawerController.i.shortcuts.clear();
      NaviDrawerController.i.shortcuts = await userStorage.read('shortcut');
    }
    if (userStorage.read('userLoggedIn') != null && userStorage.read('xf_user') != null && userStorage.read('xf_session') != null) {
      isLogged.value = await userStorage.read('userLoggedIn');
      xfUser = await userStorage.read('xf_user');
      xfSession = await userStorage.read('xf_session');
      dio.options.headers['cookie'] = 'xf_user=${xfUser.toString()}; xf_session=${xfSession.toString()}';
    }
  }

  String cookXfCsrf(String string) {
    return string.split('[')[1].split(';')[0];
  }

  final langList = {Locale('en', 'US'), Locale('vi', 'VN')};

  checkUserSetting() async {
    if (userStorage.read('lang') == null) {
      await userStorage.write('lang', 0);
    }
    if (userStorage.read('fontSizeView') == null) {
      userStorage.write('fontSizeView', 17.0);
    }
  }

  final Map<String, Color> mapInvertColor = {
    "black": Colors.black,
    "white": Colors.white,
  };

  getEmoji(String s) {
    return "assets/" + s.replaceAll(RegExp(r"\S*smilies\S"), "").replaceAll(RegExp(r'\?[^]*'), "");
  }

  getColorInvert(String typeT) {
    if (typeT == "kiến thức" || typeT == "đánh giá" || typeT == "khoe" || typeT == "HN" || typeT == "SG" || typeT == "download" || typeT == "TQ") {
      return "white";
    } else
      return "black";
  }

  final Map<String, Color> mapColor = {
    "báo lỗi": Color(0xffCE0000),
    "chú ý": Color(0xffEBBB00),
    "download": Color(0xff6C6C00),
    "đánh giá": Color(0xffCE0000),
    "góp ý": Color(0xff006C00),
    "kiến thức": Color(0xff2F5BDE),
    "khoe": Color(0xff006C00),
    "tin tức": Color(0xffFFD4B8),
    "thảo luận": Color(0xffCCDCF1),
    "thắc mắc": Color(0xffEBBB00),
    "khác": Color(0xffEBBB00),
    "SG": Color(0xffce0000),
    "ĐN": Color(0xff2F5BDE),
    "HN": Color(0xff006C00),
    "TQ": Color(0xff767676),
  };

  final List smallVozEmoji = [
    {'dir': "popo/smile.png", 'symbol': ':)'},
    {'dir': "popo/wink.png", 'symbol': ";)"},
    {'dir': "popo/frown.png", 'symbol': ":("},
    {'dir': "popo/mad.png", 'symbol': ":mad:"},
    {'dir': "popo/confused.png", 'symbol': ":confused:"},
    {'dir': "popo/cool.png", 'symbol': "8-)"},
    {'dir': "popo/tongue.png", 'symbol': ":p"},
    {'dir': "popo/biggrin.png", 'symbol': ":D"},
    {'dir': "popo/eek.png", 'symbol': ":eek:"},
    {'dir': "popo/redface.png", 'symbol': ":oops:"},
    {'dir': "popo/rolleyes.png", 'symbol': ":rolleyes:"},
    {'dir': "popo/O_o.png", 'symbol': "o_O"},
    {'dir': "popo/cautious.png", 'symbol': ":cautious:"},
    {'dir': "popo/speechless.png", 'symbol': ":censored:"},
    {'dir': "popo/cry.png", 'symbol': "=(("},
    {'dir': "popo/inlove.png", 'symbol': ":love:"},
    {'dir': "popo/laugh.png", 'symbol': ":LOL:"},
    {'dir': "popo/roflmao.png", 'symbol': ":ROFLMAO:"},
    {'dir': "popo/sick.png", 'symbol': ":sick:"},
    {'dir': "popo/sleep.png", 'symbol': ":sleep:"},
    {'dir': "popo/sneaky.png", 'symbol': ":sneaky:"},
    {'dir': "popo/unsure.png", 'symbol': ":unsure:"},
    {'dir': "popo/whistling.png", 'symbol': ":whistle:"},
    {'dir': "popo/giggle.png", 'symbol': ":giggle:"},
    {'dir': "popo/devilish.png", 'symbol': ":devilish:"}
  ];

  final List bigVozEmoji = [
    {'dir': "popopo/adore.png", 'symbol': ":adore:"},
    {'dir': "popopo/after_boom.png", 'symbol': ":after_boom:"},
    {'dir': "popopo/ah.png", 'symbol': ":ah:"},
    {'dir': "popopo/amazed.png", 'symbol': ":amazed:"},
    {'dir': "popopo/angry.png", 'symbol': ":angry:"},
    {'dir': "popopo/bad_smelly.png", 'symbol': ":bad_smelly:"},
    {'dir': "popopo/baffle.png", 'symbol': ":baffle:"},
    {'dir': "popopo/beat_brick.png", 'symbol': ":beat_brick:"},
    {'dir': "popopo/beat_plaster.png", 'symbol': ":beat_plaster:"},
    {'dir': "popopo/beat_shot.png", 'symbol': ":beat_shot:"},
    {'dir': "popopo/beated.png", 'symbol': ":beated:"},
    {'dir': "popopo/beauty.png", 'symbol': ":beauty:"},
    {'dir': "popopo/big_smile.png", 'symbol': ":big_smile:"},
    {'dir': "popopo/boss.png", 'symbol': ":boss:"},
    {'dir': "popopo/burn_joss_stick.png", 'symbol': ":burn_joss_stick:"},
    {'dir': "popopo/byebye.png", 'symbol': ":byebye:"},
    {'dir': "popopo/canny.png", 'symbol': ":canny:"},
    {'dir': "popopo/choler.png", 'symbol': ":choler:"},
    {'dir': "popopo/cold.png", 'symbol': ":cold:"},
    {'dir': "popopo/confident.png", 'symbol': ":confident:"},
    {'dir': "popopo/confuse.png", 'symbol': ":confuse:"},
    {'dir': "popopo/cool.png", 'symbol': ":cool:"},
    {'dir': "popopo/cry.png", 'symbol': ":cry:"},
    {'dir': "popopo/doubt.png", 'symbol': ":doubt:"},
    {'dir': "popopo/dribble.png", 'symbol': ":dribble:"},
    {'dir': "popopo/embarrassed.png", 'symbol': ":embarrassed:"},
    {'dir': "popopo/extreme_sexy_girl.png", 'symbol': ":extreme_sexy_girl:"},
    {'dir': "popopo/feel_good.png", 'symbol': ":feel_good:"},
    {'dir': "popopo/go.png", 'symbol': ":go:"},
    {'dir': "popopo/haha.png", 'symbol': ":haha:"},
    {'dir': "popopo/hell_boy.png", 'symbol': ":hell_boy:"},
    {'dir': "popopo/hungry.png", 'symbol': ":hungry:"},
    {'dir': "popopo/look_down.png", 'symbol': ":look_down:"},
    {'dir': "popopo/matrix.png", 'symbol': ":matrix:"},
    {'dir': "popopo/misdoubt.png", 'symbol': ":misdoubt:"},
    {'dir': "popopo/nosebleed.png", 'symbol': ":nosebleed:"},
    {'dir': "popopo/oh.png", 'symbol': ":oh:"},
    {'dir': "popopo/ops.png", 'symbol': ":ops:"},
    {'dir': "popopo/pudency.png", 'symbol': ":pudency:"},
    {'dir': "popopo/rap.png", 'symbol': ":rap:"},
    {'dir': "popopo/sad.png", 'symbol': "sad:"},
    {'dir': "popopo/sexy_girl.png", 'symbol': ":sexy_girl:"},
    {'dir': "popopo/shame.png", 'symbol': ":shame:"},
    {'dir': "popopo/smile.png", 'symbol': ":smile:"},
    {'dir': "popopo/spiderman.png", 'symbol': ":spiderman:"},
    {'dir': "popopo/still_dreaming.png", 'symbol': ":still_dreaming:"},
    {'dir': "popopo/sure.png", 'symbol': ":sure:"},
    {'dir': "popopo/surrender.png", 'symbol': ":surrender:"},
    {'dir': "popopo/sweat.png", 'symbol': ":sweat:"},
    {'dir': "popopo/sweet_kiss.png", 'symbol': ":sweet_kiss:"},
    {'dir': "popopo/tire.png", 'symbol': ":tire:"},
    {'dir': "popopo/too_sad.png", 'symbol': ":too_sad:"},
    {'dir': "popopo/waaaht.png", 'symbol': ":waaaht:"},
    {'dir': "popopo/what.png", 'symbol': ":what:"}
  ];
}
