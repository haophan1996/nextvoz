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
  final String url = "https://voz.vn", pageLink = "page-";
  final pageNaviAlign = 0.72, userStorage = GetStorage();
  double percentDownload = 0.0;
  var dio = Dio(), xfCsrfLogin, dataCsrfLogin, xfCsrfPost, dataCsrfPost;
  RxBool isLogged = false.obs;
  List alertList = [];
  String xfSession = '', dateExpire = '', alertNotification = '0', xfUser = '';
  List tagView = [];
  @override
  onInit() async {
    super.onInit();
    isLogged.stream.listen((event) {
      if (event == false) alertNotification = '0';
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

  getAlert() {
    String username, threadName, time, status, link, key;
    if (isLogged.value == true) {
      getBody(url + '/account/alerts?page=1', false).then((value) {
        value.getElementsByClassName('alert js-alert block-row block-row--separated').forEach((element) {
          time = element.getElementsByTagName('time')[0].innerHtml;
          status = element.getElementsByClassName('contentRow-main contentRow-main--close')[0].text.replaceAll(time, '').trim();
          link = element.getElementsByClassName('fauxBlockLink-blockLink')[0].attributes['href'].toString();
          if (element.getElementsByClassName('username ').length > 0) {
            username = element.getElementsByClassName('username ')[0].text;
            key = status.contains('the thread') ? 'the thread' : 'a thread called';
            threadName = status.split('.')[0].trim().split(key)[1];
            status = status.split('.')[0].trim().split(key)[0].replaceAll(username, '')+key;
          } else{
            username = '';
            threadName = '';
          }
          alertList.add({
            'username': username,
            'status': status,
            'threadName': threadName,
            'link': link,
            'time': time,
          });
        });
        update();
      });
    }
  }

  Future<dom.Document> getHttpPost(Map<String, String> header, Map<String, String> body, String link) async {
    final response = await http.post(Uri.parse(link), headers: header, body: body);
    return parser.parse(jsonDecode(response.body)['reactionList']['content']);
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

  final Map<String, String> mapEmojiVoz = {
    "popo/smile.png": ':)',
    "popo/wink.png": ";)",
    "popo/frown.png": ":(",
    "popo/mad.png": ":mad:",
    "popo/confused.png": ":confused:",
    "popo/cool.png": "8-)",
    "popo/tongue.png": ":p",
    "popo/biggrin.png": ":D",
    "popo/eek.png": ":eek:",
    "popo/redface.png": ":oops:",
    "popo/rolleyes.png": ":rolleyes:",
    "popo/O_o.png": "o_O",
    "popo/cautious.png": ":cautious:",
    "popo/speechless.png": ":censored:",
    "popo/cry.png": "=((",
    "popo/inlove.png": ":love:",
    "popo/laugh.png": ":LOL:",
    "popo/roflmao.png": ":ROFLMAO:",
    "popo/sick.png": ":sick:",
    "popo/sleep.png": ":sleep:",
    "popo/sneaky.png": ":sneaky:",
    "popo/unsure.png": ":unsure:",
    "popo/whistling.png": ":whistle:",
    "popo/giggle.png": ":giggle:",
    "popo/devilish.png": ":devilish:",
    "popopo/adore.png": ":adore:",
    "popopo/after_boom.png": ":after_boom:",
    "popopo/ah.png": ":ah:",
    "popopo/amazed.png": ":amazed:",
    "popopo/angry.png": ":angry:",
    "popopo/bad_smelly.png": ":bad_smelly:",
    "popopo/baffle.png": ":baffle:",
    "popopo/beat_brick.png": ":beat_brick:",
    "popopo/beat_plaster.png": ":beat_plaster:",
    "popopo/beat_shot.png": ":beat_shot:",
    "popopo/beated.png": ":beated:",
    "popopo/beauty.png": ":beauty:",
    "popopo/big_smile.png": ":big_smile:",
    "popopo/boss.png": ":boss:",
    "popopo/burn_joss_stick.png": ":burn_joss_stick:",
    "popopo/byebye.png": ":byebye:",
    "popopo/canny.png": ":canny:",
    "popopo/choler.png": ":choler:",
    "popopo/cold.png": ":cold:",
    "popopo/confident.png": ":confident:",
    "popopo/confuse.png": ":confuse:",
    "popopo/cool.png": ":cool:",
    "popopo/cry.png": ":cry:",
    "popopo/doubt.png": ":doubt:",
    "popopo/dribble.png": ":dribble:",
    "popopo/embarrassed.png": ":embarrassed:",
    "popopo/extreme_sexy_girl.png": ":extreme_sexy_girl:",
    "popopo/feel_good.png": ":feel_good:",
    "popopo/go.png": ":go:",
    "popopo/haha.png": ":haha:",
    "popopo/hell_boy.png": ":hell_boy:",
    "popopo/hungry.png": ":hungry:",
    "popopo/look_down.png": ":look_down:",
    "popopo/matrix.png": ":matrix:",
    "popopo/misdoubt.png": ":misdoubt:",
    "popopo/nosebleed.png": ":nosebleed:",
    "popopo/oh.png": ":oh:",
    "popopo/ops.png": ":ops:",
    "popopo/pudency.png": ":pudency:",
    "popopo/rap.png": ":rap:",
    "popopo/sad.png": "sad:",
    "popopo/sexy_girl.png": ":sexy_girl:",
    "popopo/shame.png": ":shame:",
    "popopo/smile.png": ":smile:",
    "popopo/spiderman.png": ":spiderman:",
    "popopo/still_dreaming.png": ":still_dreaming:",
    "popopo/sure.png": ":sure:",
    "popopo/surrender.png": ":surrender:",
    "popopo/sweat.png": ":sweat:",
    "popopo/sweet_kiss.png": ":sweet_kiss:",
    "popopo/tire.png": ":tire:",
    "popopo/too_sad.png": ":too_sad:",
    "popopo/waaaht.png": ":waaaht:",
    "popopo/what.png": ":what:",
  };
}
