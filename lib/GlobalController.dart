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
  final String url = "https://voz.vn";
  final String pageLink = "page-";
  final pageNaviAlign = 0.72;
  final userStorage = GetStorage();
  double percentDownload = 0.0;
  var dio = Dio();
  var xfCsrfLogin;
  var dataCsrfLogin;
  var xfCsrfPost;
  var dataCsrfPost;
  RxBool isLogged = false.obs;
  String xfUser = '';
  String xfSession = '';
  String dateExpire = '';

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

  Future<dom.Document> getHttpPost(Map<String, String> header, Map<String, String> body, String link) async{
    final response = await http.post(Uri.parse(link), headers: header, body: body);
    return parser.parse(jsonDecode(response.body)['reactionList']['content']);
  }

  setDataUser() async {
    if (userStorage.read('shortcut') != null){
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
    string = string.split('[')[1];
    string = string.split(';')[0];
    return string;
  }

  final Map<String, Color> mapInvertColor = {
    "black": Colors.black,
    "white": Colors.white,
  };

  getEmoji(String s) {
    return "assets/" + s.replaceAll(RegExp(r"\S*smilies\S"), "").replaceAll(RegExp(r'\?[^]*'), "");
  }

  getColor(String typeT) {
    return mapColor[typeT];
  }

  getColorInvert(String typeT) {
    if (typeT == "kiến thức" || typeT == "đánh giá" || typeT == "khoe" || typeT == "HN" || typeT == "SG" || typeT == "download" || typeT == "TQ") {
      return "white";
    } else
      return "black";
  }

  final langList = {
    Locale('en', 'US'),
    Locale('vi', 'VN')
  };

  checkUserSetting() async {
    if (userStorage.read('lang')==null){
      await userStorage.write('lang', 0);
    }
    if (userStorage.read('fontSizeView') == null){
      userStorage.write('fontSizeView', 17.0);
    }
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
    "popo/smile.png": 'assets/popo/biggrin.png',
    "popo/wink.png": "2",
    "popo/frown.png": "3",
    "popo/mad.png": "4",
    "popo/confused.png": "5",
    "popo/cool.png": "6",
    "popo/tongue.png": "7",
    "popo/biggrin.png": "8",
    "popo/eek.png": "",
    "popo/redface.png": "",
    "popo/rolleyes.png": "",
    "popo/O_o.png": "",
    "popo/cautious.png": "",
    "popo/speechless.png": "10",
    "popo/cry.png": "",
    "popo/inlove.png": "",
    "popo/laugh.png": "",
    "popo/roflmao.png": "",
    "popo/sick.png": "",
    "popo/sleep.png": "",
    "popo/sneaky.png": "",
    "popo/unsure.png": "",
    "popo/whistling.png": "",
    "popo/giggle.png": "",
    "popo/devilish.png": "",
    "popopo/adore.png": "",
    "popopo/after_boom.png": "",
    "popopo/ah.png": "",
    "popopo/amazed.png": "",
    "popopo/angry.png": "",
    "popopo/bad_smelly.png": "",
    "popopo/baffle.png": "",
    "popopo/beat_brick.png": "",
    "popopo/beat_plaster.png": "",
    "popopo/beat_shot.png": "",
    "popopo/beated.png": "",
    "popopo/beauty.png": "",
    "popopo/big_smile.png": "",
    "popopo/boss.png": "",
    "popopo/burn_joss_stick.png": "",
    "popopo/byebye.png": "",
    "popopo/canny.png": "",
    "popopo/choler.png": "",
    "popopo/cold.png": "",
    "popopo/confident.png": "",
    "popopo/confuse.png": "",
    "popopo/cool.png": "",
    "popopo/cry.png": "",
    "popopo/doubt.png": "",
    "popopo/dribble.png": "",
    "popopo/embarrassed.png": "",
    "popopo/extreme_sexy_girl.png": "",
    "popopo/feel_good.png": "",
    "popopo/go.png": "",
    "popopo/haha.png": "",
    "popopo/hell_boy.png": "",
    "popopo/hungry.png": "",
    "popopo/look_down.png": "",
    "popopo/matrix.png": "",
    "popopo/misdoubt.png": "",
    "popopo/nosebleed.png": "",
    "popopo/oh.png": "",
    "popopo/ops.png": "",
    "popopo/pudency.png": "",
    "popopo/rap.png": "",
    "popopo/sad.png": "",
    "popopo/sexy_girl.png": "",
    "popopo/shame.png": "",
    "popopo/smile.png": "",
    "popopo/spiderman.png": "",
    "popopo/still_dreaming.png": "",
    "popopo/sure.png": "",
    "popopo/surrender.png": "",
    "popopo/sweat.png": "",
    "popopo/sweet_kiss.png": "",
    "popopo/tire.png": "",
    "popopo/too_sad.png": "",
    "popopo/waaaht.png": "",
    "popopo/what.png": "",
  };
}
