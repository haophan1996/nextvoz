import 'dart:ui';
import 'package:flutter/material.dart';

Color getColorInvert(String typeT) {
  if (typeT == 'tin tức' || typeT == 'thảo luận')
    return Colors.black;
  else
    return Colors.white;
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
