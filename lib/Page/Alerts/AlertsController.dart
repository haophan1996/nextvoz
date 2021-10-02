import 'package:dio_http/dio_http.dart';
import 'package:get/get.dart';
import '/GlobalController.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class AlertsController extends GetxController {
  var dio = Dio(), percentDownload = 0.0;
  Map<String, dynamic> data = {};

  late dom.Document value;

  refreshList() async {
    GlobalController.i.alertList.clear();
    data['loadingStatus'] = 'loading';
    update(['loadingState']);
    await getAlert();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    data.clear();
    dio.close(force: true);
    this.dispose();
  }

  @override
  Future<void> onReady() async {
    // TODO: implement onReady
    super.onReady();

    if (GlobalController.i.alertList.isEmpty || GlobalController.i.alertNotifications != 0) {
      GlobalController.i.alertList.clear();
      data['loadingStatus'] = 'loading';
      update(['loadingState'], true);
      await getAlert();
    }
  }

  getAlert() async {
    if (GlobalController.i.isLogged == true) {
      await GlobalController.i.getBodyBeta((value) async {
        if (value == 1) {
          await getAlert();
        }
      }, (download) {
        percentDownload = download;
        update(['download'], true);
      }, dio, GlobalController.i.url + '/account/alerts?page=1', false).then((values) {
        performQueryHtml(values!);
        value = values;
      });
    }
  }

  performQueryHtml(dom.Document value) {
    GlobalController.i.token = value.getElementsByTagName('html')[0].attributes['data-csrf'];
    if (value.getElementsByTagName('html')[0].attributes['data-logged-in'] == 'true') {
      GlobalController.i.controlNotification(
          int.parse(value.getElementsByClassName('p-navgroup-link--alerts')[0].attributes['data-badge'].toString()),
          int.parse(value.getElementsByClassName('p-navgroup-link--conversations')[0].attributes['data-badge'].toString()),
          value.getElementsByTagName('html')[0].attributes['data-logged-in'].toString());
    } else {
      GlobalController.i.controlNotification(0, 0, 'false');
    }

    value.getElementsByClassName('alert js-alert block-row block-row--separated').forEach((element) {
      data['unread'] = element.attributes['class']!.contains('is-unread') ? 'true' : 'false';
      data['sentence'] = element.text.trim();
      data['time'] = element.getElementsByClassName('u-dt')[0].text;
      data['link'] = element.getElementsByClassName('fauxBlockLink-blockLink')[0].attributes['href'].toString();
      if (element.getElementsByClassName('username ').length != 0) {
        data['username'] = element.getElementsByClassName('username ')[0].text + ' ';
      } else {
        data['username'] = '';
      }
      data['sentence'] = data['sentence'].replaceAll(data['username'], '').replaceAll(data['time'], '').trim();
      data['title'] = element.getElementsByClassName('fauxBlockLink-blockLink')[0].text;
      data['phase1'] = data['sentence'].toString().split(data['title'])[0];
      data['phase3'] = data['sentence'].replaceAll(data['title'], '').split(data['phase1'])[1];
      data['title'] = data['title'].replaceAll(RegExp('\\s+'), ' ');

      if (data['phase3'].contains('with')) {
        data['hasReact'] = true;
        data['react'] = data['phase3'].contains('Ưng') ? '1.png' : '2.png';
        data['phase3'] = ' with ';
      } else {
        data['hasReact'] = false;
      }

      if (element.getElementsByClassName('label').length != 0) {
        data['prefixTitle'] = element.getElementsByClassName('label')[0].text;
        data['title'] = data['title'].replaceAll(data['prefixTitle'], '');
      } else {
        data['prefixTitle'] = '';
      }

        if (data['title'] == 'your post'){
          data['sentence'].split(data['title'])[1].contains('thread');
          data['title2'] = data['title'] + ' ';
          data['phase2'] = ' in the thread ';
          data['title'] = ' '+data['sentence'].split('thread')[1].replaceAll(data['prefixTitle'],'').trim();
          if (data['title'].contains('with')){
            data['title'] = ' '+data['title'].split('with')[0].trim();
          }
        } else {
          data['title2'] = '';
          data['phase2'] = '';
        }
        print(data['username'] + data['phase1'] + data['title2'] + data['phase2'] + data['prefixTitle'] + data['title'] + data['phase3'] + (data['hasReact'] == true ? data['react'] : ''));


      var avatar = element.getElementsByClassName('avatar avatar--xxs').first;
      if (avatar.getElementsByTagName('img').length > 0) {
        data['avatarLink'] = avatar.getElementsByTagName('img')[0].attributes['src'].toString();
        if (data['avatarLink'].contains('https') == false) {
          data['avatarLink'] = GlobalController.i.url + data['avatarLink'];
        }
        data['avatarColor1'] = '0x00000000';
        data['avatarColor2'] = '0x00000000';
      } else {
        data['avatarLink'] = 'no';
        data['avatarColor1'] = '0xFFF' + avatar.attributes['style'].toString().split('#')[1].split(';')[0];
        data['avatarColor2'] = '0xFFF' + avatar.attributes['style'].toString().split('#')[2];
      }

      GlobalController.i.alertList.add({
        'username' : data['username'],
        'phase1' : data['phase1'],
        'title2' : data['title2'],
        'phase2' : data['phase2'],
        'prefixTitle' : data['prefixTitle'],
        'title' : data['title'],
        'phase3' : data['phase3'],
        'hasReact' : data['hasReact'],
        'react' : data['react'],
        'time' : '\n'+data['time'],
        'unread' : data['unread'],
        'avatarLink' : data['avatarLink'],
        'avatarColor1' : data['avatarColor1'],
        'avatarColor2' : data['avatarColor2'],
        'link' : data['link'],
      });
    });
    data['loadingStatus'] = 'done';
    update(['loadingState']);
  }
}
