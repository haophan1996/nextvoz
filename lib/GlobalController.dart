import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class GlobalController extends GetxController{
  static GlobalController get i => Get.find();
  var response;
  late dom.Document doc;

  Future<dom.Document> getBody(String url) async {
    response = await http.get(Uri.parse(url));
    return parser.parse(response.body);
  }


  final Map<String, Color> mapInvertColor = {
    "black": Colors.black,
    "white": Colors.white,
  };

  getEmoji(String s){
    return "assets/"+s.replaceAll(RegExp(r"\S*smilies\S"), "").replaceAll(RegExp(r'\?[^]*'), "");
  }

  getColor(String typeT) {
    return mapColor[typeT];
  }

  getColorInvert(String typeT) {
    if (typeT == "kiến thức" ||
        typeT == "đánh giá" ||
        typeT == "HN" ||
        typeT == "SG" ||
        typeT == "download" ||
        typeT == "TQ") {
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
    "khoe ": Color(0xff006C00),
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
    "popo/smile.png" : 'assets/popo/biggrin.png',
    "popo/wink.png" : "2",
    "popo/frown.png" : "3",
    "popo/mad.png" : "4",
    "popo/confused.png" : "5",
    "popo/cool.png" : "6",
    "popo/tongue.png" : "7",
    "popo/biggrin.png" : "8",
    "popo/eek.png" : "",
    "popo/redface.png" : "",
    "popo/rolleyes.png" : "",
    "popo/O_o.png" : "",
    "popo/cautious.png" : "",
    "popo/speechless.png" : "10",
    "popo/cry.png" : "",
    "popo/inlove.png" : "",
    "popo/laugh.png" : "",
    "popo/roflmao.png" : "",
    "popo/sick.png" : "",
    "popo/sleep.png" : "",
    "popo/sneaky.png" : "",
    "popo/unsure.png" : "",
    "popo/whistling.png" : "",
    "popo/giggle.png" : "",
    "popo/devilish.png" : "",

    "popopo/adore.png" : "",
    "popopo/after_boom.png" : "",
    "popopo/ah.png" : "",
    "popopo/amazed.png" : "",
    "popopo/angry.png" : "",
    "popopo/bad_smelly.png" : "",
    "popopo/baffle.png" : "",
    "popopo/beat_brick.png" : "",
    "popopo/beat_plaster.png" : "",
    "popopo/beat_shot.png" : "",
    "popopo/beated.png" : "",
    "popopo/beauty.png" : "",
    "popopo/big_smile.png" : "",
    "popopo/boss.png" : "",
    "popopo/burn_joss_stick.png" : "",
    "popopo/byebye.png" : "",
    "popopo/canny.png" : "",
    "popopo/choler.png" : "",
    "popopo/cold.png" : "",
    "popopo/confident.png" : "",
    "popopo/confuse.png" : "",
    "popopo/cool.png" : "",
    "popopo/cry.png" : "",
    "popopo/doubt.png" : "",
    "popopo/dribble.png" : "",
    "popopo/embarrassed.png" : "",
    "popopo/extreme_sexy_girl.png" : "",
    "popopo/feel_good.png" : "",
    "popopo/go.png" : "",
    "popopo/haha.png" : "",
    "popopo/hell_boy.png" : "",
    "popopo/hungry.png" : "",
    "popopo/look_down.png" : "",
    "popopo/matrix.png" : "",
    "popopo/misdoubt.png" : "",
    "popopo/nosebleed.png" : "",
    "popopo/oh.png" : "",
    "popopo/ops.png" : "",
    "popopo/pudency.png" : "",
    "popopo/rap.png" : "",
    "popopo/sad.png" : "",
    "popopo/sexy_girl.png" : "",
    "popopo/shame.png" : "",
    "popopo/smile.png" : "",
    "popopo/spiderman.png" : "",
    "popopo/still_dreaming.png" : "",
    "popopo/sure.png" : "",
    "popopo/surrender.png" : "",
    "popopo/sweat.png" : "",
    "popopo/sweet_kiss.png" : "",
    "popopo/tire.png" : "",
    "popopo/too_sad.png" : "",
    "popopo/waaaht.png" : "",
    "popopo/what.png" : "",
  };
}