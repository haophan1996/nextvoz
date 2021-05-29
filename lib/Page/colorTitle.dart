import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyColorController extends GetxController {
  static MyColorController get i => Get.find();

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
  final Map<String, Color> mapInvertColor = {
    "black": Colors.black,
    "white": Colors.white,
  };

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
}
