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
  final userStorage = GetStorage();
  var xfCsrfLogin, dataCsrfLogin, xfCsrfPost, token;
  Map<String, dynamic> data = {};
  bool isLogged = false;
  List alertList = [], inboxList = [], sessionTag = [];
  String xfSession = '', dateExpire = '', xfUser = '';
  int alertNotifications = 0, inboxNotifications = 0;

  ///Default settings
  double heightAppbar = 45, overScroll = 100;
  final String url = "https://voz.vn",
      pageLink = "page-",
      inboxReactLink = 'https://voz.vn/conversations/messages/',
      viewReactLink = 'https://voz.vn/p/';

  @override
  onInit() async {
    super.onInit();
  }

  ///Only update when variables are different
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

  Future<dom.Document?> getBodyBeta(Function(int) onError, Function(double) onDownload, Dio dios, String url, bool isHomePage) async {
    onDownload(0.1);
    final response = await dios.get(url,
        options: Options(
          headers: {'cookie': 'xf_user=${xfUser.toString()}; xf_session=${xfSession.toString()}'},
        ), onReceiveProgress: (actual, total) {
      onDownload((actual.bitLength - 4) / total.bitLength);
    }).whenComplete(() async {
      onDownload(0.0);
    }).catchError((err) async {
      if (err.type == DioErrorType.other) {
        onError(1);
      } else {
        onError(2);
      }
    });
    xfCsrfPost = cookXfCsrf(response.headers['set-cookie'].toString());
    if (isHomePage == true) xfCsrfLogin = cookXfCsrf(response.headers['set-cookie'].toString());
    return parser.parse(_removeTag(response.toString()));
  }

  Future getHttpPost(bool isJson, Map<String, String> header, dynamic body, String link) async {
    final response = await http.post(Uri.parse(link), headers: header, body: body).catchError((err) {
      print('get http post error: $header \n$body \n$link');
      Get.back();
      setDialogError('Server down or No connection\n\n Details: $err');
    });

    return isJson ? jsonDecode(response.body) : response.body;
  }

  Future getHttp(bool isJson, Map<String, String> header, String link) async {
    final response = await http.get(Uri.parse(link), headers: header).catchError((err) {
      print('get http post error: $header \n$link');
      Get.back();
      setDialogError('Server down or No connection\n\n Details: $err');
    });
    return isJson ? jsonDecode(response.body) : response.body;
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
      NaviDrawerController.i.data['avatarUser'] = await userStorage.read('avatarUser') ?? 'no';
      NaviDrawerController.i.data['avatarColor1'] = await userStorage.read('avatarColor1');
      NaviDrawerController.i.data['avatarColor2'] = await userStorage.read('avatarColor2');
      NaviDrawerController.i.data['nameUser'] = await userStorage.read('nameUser');
      NaviDrawerController.i.data['titleUser'] = await userStorage.read('titleUser');
      NaviDrawerController.i.data['linkUser'] = await userStorage.read('linkUser');
    }
  }

  String cookXfCsrf(String string) {
    return string.split('[')[1].split(';')[0];
  }

  final langList = {Locale('en', 'US'), Locale('vi', 'VN')};

  String getEmoji(String s) {
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

  Future<void> launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: true, forceWebView: false, enableJavaScript: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  performQueryReaction(dom.Document doc, List reactionList) async {
    if (doc.getElementsByTagName('html')[0].attributes['data-logged-in'] == 'true') {
      controlNotification(
          int.parse(doc.getElementsByClassName('p-navgroup-link--alerts')[0].attributes['data-badge'].toString()),
          int.parse(doc.getElementsByClassName('p-navgroup-link--conversations')[0].attributes['data-badge'].toString()),
          doc.getElementsByTagName('html')[0].attributes['data-logged-in'].toString());
    } else
      controlNotification(0, 0, 'false');

    if (doc.getElementsByClassName('block-row block-row--separated').length == 0) {
      reactionList.add(null);
    } else
      doc.getElementsByClassName('block-row block-row--separated').forEach((value) {
        ///Username
        data['rName'] = value.getElementsByClassName('username ')[0].text.trim();

        data['rLink'] = value.getElementsByClassName('username ')[0].attributes['href'];

        ///Reaction Icon
        data['rReactIcon'] = value.getElementsByClassName('reaction reaction--right')[0].attributes['data-reaction-id'];

        ///User title
        data['rTitle'] = value.getElementsByClassName('userTitle')[0].innerHtml;

        ///Time
        data['rTime'] = value.getElementsByClassName('u-dt')[0].innerHtml;

        ///Avatar
        if (value.getElementsByClassName('avatar avatar--s')[0].getElementsByTagName('img').length > 0) {
          data['_userAvatar'] = value.getElementsByClassName('avatar avatar--s')[0].getElementsByTagName('img')[0].attributes['src'].toString();
          data['avatarColor1'] = '0x00000000';
          data['avatarColor2'] = '0x00000000';
          if (data['_userAvatar'].contains('https') == false) {
            data['_userAvatar'] = GlobalController.i.url + data['_userAvatar'];
          }
        } else {
          data['_userAvatar'] = 'no';
          data['avatarColor1'] =
              '0xFFF' + value.getElementsByClassName('avatar avatar--s')[0].attributes['style'].toString().split('#')[1].split(';')[0];
          data['avatarColor2'] = '0xFFF' + value.getElementsByClassName('avatar avatar--s')[0].attributes['style'].toString().split('#')[2];
        }

        reactionList.add({
          'rLink': data['rLink'],
          'rName': data['rName'],
          'rTitle': data['rTitle'],
          'rTime': data['rTime'],
          'rReactIcon': data['rReactIcon'],
          'rAvatar': data['_userAvatar'],
          'avatarColor1': data['avatarColor1'],
          'avatarColor2': data['avatarColor2'],
        });
      });
    return reactionList;
  }

  performTooltipMember(String value) {
    dom.Document document = parser.parse(value);

    // print(document.outerHtml);
    //print(document.getElementsByClassName('memberTooltip-blurb')[0].text.trim());
    //print(document.getElementsByTagName('time')[0].innerHtml);
    //print(document.getElementsByClassName('memberTooltip-blurb')[2].ge);
    //print(document.getElementsByClassName('username ')[0].text);
    print(document.getElementsByClassName('pairs pairs--rows')[0].getElementsByTagName('dd')[0].text.trim());
    print(document.getElementsByClassName('pairs pairs--rows')[1].getElementsByTagName('dd')[0].text.trim());
    print(document.getElementsByClassName('pairs pairs--rows')[2].getElementsByTagName('dd')[0].text.trim());
    return {
      'username': document.getElementsByClassName('username ')[0].text + '\n',
      'userTitle': document.getElementsByClassName('userTitle')[0].text + '\n',
      'joined': document.getElementsByClassName('u-dt')[0].text,
      'message': document.getElementsByClassName('pairs pairs--rows')[0].getElementsByTagName('dd')[0].text.trim() + '\n',
      'reaction': document.getElementsByClassName('pairs pairs--rows')[1].getElementsByTagName('dd')[0].text.trim() + '\n',
      'point': document.getElementsByClassName('pairs pairs--rows')[2].getElementsByTagName('dd')[0].text.trim() + '\n'
    };
  }

  _removeTag(String content) {
    return content.replaceAll(
        RegExp(r'<div class="bbCodeBlock-expandLink js-expandLink"><a role="button" tabindex="0">Click to expand...</a></div>'), "");
  }
}
