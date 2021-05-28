import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class ThreadController extends GetxController{
  late String _url;
  late String theme;
  late dom.Document doc;
  var response;
  RxList myThreadList = [].obs;

  //             danh gia   kien thuc        thac mac       thac luan
  List colors = [Colors.red, Colors.blue, Colors.yellow, Colors.teal];
  Random random = new Random();
  var themeTitle = "";
  var title = "";

  @override
  Future<void> onInit() async {
    super.onInit();
    theme = Get.arguments[0];
    _url = Get.arguments[1];
    response = await http.get(Uri.parse(_url));
    doc = parser.parse(response.body);
    myThread();
  }

  getColors(int index){
    if (myThreadList.elementAt(index)['themeTitle'] == "đánh giá"){
      return 0;
    } else if (myThreadList.elementAt(index)['themeTitle'] == "kiến thức"){
      return 1;
    } else if (myThreadList.elementAt(index)['themeTitle'] == "thắc mắc"){
      return 2;
    } else {
      return 3;
    }
  }

  myThread(){
    doc.getElementsByClassName("p-body-content").forEach((element) {
      element.getElementsByClassName("structItem structItem--thread").forEach((element) {
        var _title = element.getElementsByClassName("structItem-title");
        var authorLink = element.getElementsByClassName("structItem-parts").map((e) => e.getElementsByTagName("a")[0].attributes['href']).first;
        var authorName = element.attributes["data-author"];
        var replies = element.getElementsByClassName("pairs pairs--justified").map((e) => e.getElementsByTagName("dd")[0].innerHtml).first;
        var date = element.getElementsByClassName("structItem-startDate").map((e) => e.getElementsByTagName("time")[0].innerHtml).first;

         if (_title.map((e) => e.getElementsByTagName("a").length).toString() == "(1)"){
           title = _title.map((e) => e.getElementsByTagName("a")[0].innerHtml).first;
         } else {
           title = " " + _title.map((e) => e.getElementsByTagName("a")[1].innerHtml).first;
           themeTitle = _title.map((e) => e.getElementsByTagName("span")[0].innerHtml).first;
         }

        myThreadList.add({
          "title" : title,
          "themeTitle" : themeTitle,
          "authorLink" : authorLink,
          "authorName" : authorName,
          "replies" : replies,
          "date" : date,
        });
      });

    });
  }
}

/*
myThread(){
    doc.getElementsByClassName("p-body-content").forEach((element) {
      element.getElementsByClassName("structItem structItem--thread").forEach((element) {
        var title = element.getElementsByClassName("structItem-title").map((e) => e.getElementsByTagName("a")[0].innerHtml).first;
        var authorLink = element.getElementsByClassName("structItem-parts").map((e) => e.getElementsByTagName("a")[0].attributes['href']).first;
        var authorName = element.attributes["data-author"];
        var replies = element.getElementsByClassName("pairs pairs--justified").map((e) => e.getElementsByTagName("dd")[0].innerHtml).first;
        var date = element.getElementsByClassName("structItem-startDate").map((e) => e.getElementsByTagName("time")[0].innerHtml).first;

        myThreadList.add({
          "title" : title,
          "authorLink" : authorLink,
          "authorName" : authorName,
          "replies" : replies,
          "date" : date,
        });
        //print("$title $authorLink $authorName $replies $date");
      });

    });
  }
 */

