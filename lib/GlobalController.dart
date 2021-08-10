import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:ui';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '/Page/reuseWidget.dart';
import '/Page/NavigationDrawer/NaviDrawerController.dart';

class GlobalController extends GetxController {
  static GlobalController get i => Get.find();
  final String url = "https://voz.vn",
      pageLink = "page-",
      inboxReactLink = 'https://voz.vn/conversations/messages/',
      viewReactLink = 'https://voz.vn/p/';
  final userStorage = GetStorage();
  var xfCsrfLogin, dataCsrfLogin, xfCsrfPost, dataCsrfPost;
  bool isLogged = false;
  List alertList = [], inboxList = [], sessionTag = [];
  String xfSession = '', dateExpire = '', xfUser = '';
  int alertNotifications = 0, inboxNotifications = 0;
  double heightAppbar = 45, overScroll = 100;

  @override
  onInit() async {
    super.onInit();
  }

  controlNotification(int alt, int ib, String login) {
    if (login == 'false') {
      if (login != isLogged.toString()) {
        isLogged = false;
        update();
      }
    } else {
      if (login != isLogged.toString()) {
        isLogged = true;
        update(['Notification'], true);
        update();
      }
      if (alt != alertNotifications || ib != inboxNotifications) {
        if (alt != alertNotifications) {
          alertNotifications = alt;
          update(['alertNotification'], true);
        }
        if (ib != inboxNotifications) {
          inboxNotifications = ib;
          update(['inboxNotification'], true);
        }
        update(['Notification'], true);
      }
    }
  }

  Future<dom.Document?> getBody(Function onError, Function(double) onDownload, Dio dios, String url, bool isHomePage) async {
    if (isLogged == true) {
      dios.options.headers['cookie'] = 'xf_user=${xfUser.toString()}; xf_session=${xfSession.toString()}';
    } else
      dios.options.headers['cookie'] = '';

    onDownload(0.1);
    final response = await dios.get(url,options: Options(receiveTimeout: 5000, sendTimeout: 5000,),onReceiveProgress: (actual, total) {
      onDownload((actual.bitLength - 4) / total.bitLength);
    }).whenComplete(() async {
      onDownload(0.0);
    }).catchError((err) async {
      if (err.type == DioErrorType.other) {

      } else {
        onError();
      }
    });
    xfCsrfPost = cookXfCsrf(response.headers['set-cookie'].toString());
    if (isHomePage == true) xfCsrfLogin = cookXfCsrf(response.headers['set-cookie'].toString());
    return parser.parse(response.toString());
  }

  Future<dom.Document?> getBodyBeta(Function onError, Function(double) onDownload, Dio dios, String url, bool isHomePage) async {
    if (isLogged == true) {
      dios.options.headers['cookie'] = 'xf_user=${xfUser.toString()}; xf_session=${xfSession.toString()}';
    } else
      dios.options.headers['cookie'] = '';

    onDownload(0.1);
    final response = await dios.get(url,options: Options(receiveTimeout: 5000, sendTimeout: 5000,),onReceiveProgress: (actual, total) {
      onDownload((actual.bitLength - 4) / total.bitLength);
    }).whenComplete(() async {
      onDownload(0.0);
    }).catchError((err) async {
      if (err.type == DioErrorType.other) {
        onError();
      } else {
        //onError();
      }
    });
    xfCsrfPost = cookXfCsrf(response.headers['set-cookie'].toString());
    if (isHomePage == true) xfCsrfLogin = cookXfCsrf(response.headers['set-cookie'].toString());
    return parser.parse(response.toString());
  }

  Future getHttpPost(Map<String, String> header, dynamic body, String link) async {
    final response = await http.post(Uri.parse(link), headers: header, body: body).catchError((err) {
      print('get http post error: $header \n$body \n$link');
      Get.back();
      setDialogError('Server down or No connection\n\n Details: $err');
    });
    return jsonDecode(response.body);
  }

  Future getHttp(Map<String, String> header, String link) async {
    final response = await http.get(Uri.parse(link), headers: header).catchError((err) {
      print('get http post error: $header \n$link');
      Get.back();
      setDialogError('Server down or No connection\n\n Details: $err');
    });
    return jsonDecode(response.body);
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');
    final file = File('${(await getTemporaryDirectory()).path}/${path.replaceAll("/", '-')}');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  Future<void> setDataUser() async {
    if (userStorage.read('shortcut') != null) {
      NaviDrawerController.i.shortcuts = await userStorage.read('shortcut');
    }
    if (userStorage.read('userLoggedIn') != null && userStorage.read('xf_user') != null && userStorage.read('xf_session') != null) {
      isLogged = await userStorage.read('userLoggedIn');
      xfUser = await userStorage.read('xf_user');
      xfSession = await userStorage.read('xf_session');
    }
  }

  Future<void> setAccountUser() async {
    if (isLogged == true) {
      NaviDrawerController.i.data['avatarUser'] = await userStorage.read('avatarUser');
      NaviDrawerController.i.data['nameUser'] = await userStorage.read('nameUser');
      NaviDrawerController.i.data['titleUser'] = await userStorage.read('titleUser');
      NaviDrawerController.i.data['linkUser'] = await userStorage.read('linkUser');
    }
  }

  String cookXfCsrf(String string) {
    return string.split('[')[1].split(';')[0];
  }

  final langList = {Locale('en', 'US'), Locale('vi', 'VN')};

  Future<void> checkUserSetting() async {
    if (userStorage.read('lang') == null) {
      await userStorage.write('lang', 1); // Default Vietnamese
    }
    if (userStorage.read('fontSizeView') == null) {
      await userStorage.write('fontSizeView', 18.0); // Default fontSize 18
    }
    if (userStorage.read('scrollToMyRepAfterPost') == null) {
      await userStorage.write('scrollToMyRepAfterPost', true); // D
    }
    if (userStorage.read('showImage') == null) {
      await userStorage.write('showImage', true); // D
    }
    if (userStorage.read('signature') == null) {
      await userStorage.write('signature', true); // D
    }
  }

  getEmoji(String s) {
    return "assets/" + s.replaceAll(RegExp(r"\S*smilies\S"), "").replaceAll(RegExp(r'\?[^]*'), "");
  }

  getIDYoutube(String link) {
    if (link.contains('embed/') == true) {
      return link.split('embed/')[1].split('?')[0];
    } else if (link.contains('watch?v=') == true) {
      return link.split("?v=")[1];
    } else if (link.contains('youtu.be/') == true) {
      return link.split('youtu.be/')[1];
    } else
      return null;
  }

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: true, forceWebView: false, enableJavaScript: true);
    } else {
      throw 'Could not launch $url';
    }
  }
}
