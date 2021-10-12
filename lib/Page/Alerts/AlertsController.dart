import 'package:dio_http/dio_http.dart';
import 'package:get/get.dart';
import '/GlobalController.dart';
import 'package:html/dom.dart' as dom;

class AlertsController extends GetxController {
  var dio = Dio(), percentDownload = 0.0;
  Map<String, dynamic> data = {};

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
      data['time'] = element.getElementsByClassName('u-dt')[0].text.trim();

      data['title1'] = element.getElementsByClassName('fauxBlockLink-blockLink')[0].text;

      if (element.getElementsByClassName('username ').length != 0) {
        data['username'] = element.getElementsByClassName('username ')[0].text + ' ';
        data['sentence'] = element.text.split(data['time'])[0].split(data['username'])[1].trim();
      } else {
        data['username'] = '';
        data['sentence'] = element.text.split(data['time'])[0].trim();
      }
      data['phase1'] = data['sentence'].split(data['title1'])[0].toString();

      if (data['title1'] != '') {
        data['phase1'] = data['sentence'].split(data['title1'])[0];
      } else
        data['phase1'] = data['sentence'];

      if (data['title1'] == 'your post') {
        data['title2'] = data['sentence'].split('in the thread')[1].split('with')[0].trim();
        data['phase2'] = data['sentence'].split(data['title1'])[1].split(data['title2'])[0];
        data['phase3'] = data['sentence'].split(data['title2'])[1];
      } else {
        data['phase3'] = data['sentence'].replaceAll(data['phase1'], '').replaceAll(data['title1'], '');
        data['title2'] = '';
        data['phase2'] = '';
      }

      if (data['phase3'].contains('with')) {
        if (data['phase3'].contains('Ưng')) {
          data['react'] = '1.png';
        } else
          data['react'] = '2.png';
        data['phase3'] = ' with ';
        data['hasReact'] = true;
      } else
        data['hasReact'] = false;

      if (data['title1'] != 'your post') {
        data['prefix1'] = '';
        if (element.getElementsByClassName('label').length != 0) {
          data['prefix1'] = element.getElementsByClassName('label')[0].text;
          data['title1'] = data['title1'].split(data['prefix1'])[1];
        }
      } else {
        data['prefix1'] = '';
      }

      if (data['title2'] != '') {
        if (element.getElementsByClassName('label').length != 0) {
          data['prefix2'] = element.getElementsByClassName('label')[0].text;
          data['title2'] = data['title2'].split(data['prefix2'])[1];
        }
      } else
        data['prefix2'] = '';

      // print(data['username'] +
      //     data['phase1'] +
      //     data['prefix1']  +
      //     data['title1'] +
      //     data['phase2'] +
      //     data['prefix2'] +
      //     data['title2'] +
      //     data['phase3'] +
      //     (data['hasReact'] == true ? data['react'] : ''));

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
      data['link'] = element.getElementsByClassName('fauxBlockLink-blockLink')[0].attributes['href'].toString();

      GlobalController.i.alertList.add({
        'username': data['username'] ?? '',
        'phase1': data['phase1'] ?? '',
        'prefix1': data['prefix1'] ?? '',
        'title1': data['title1'] ?? '',
        'phase2': data['phase2'] ?? '',
        'prefix2' : data['prefix2'],
        'title2' : data['title2'],
        'phase3' : data['phase3'],
        'hasReact': data['hasReact'] ?? '',
        'react': data['react'] ?? '',
        'time': '\n' + data['time'],
        'unread': data['unread'],
        'avatarLink': data['avatarLink'],
        'avatarColor1': data['avatarColor1'],
        'avatarColor2': data['avatarColor2'],
        'link': data['link'],
      });
    });

    if (value.getElementsByClassName('alert js-alert block-row block-row--separated').length==0) {
      GlobalController.i.alertList.add({
        'username': '',
        'phase1': 'No Alerts',
        'title2': '',
        'phase2': '',
        'prefixTitle': '',
        'title': '',
        'phase3': '',
        'hasReact': '',
        'react': '',
        'time': '',
        'unread': '',
        'avatarLink': '',
        'avatarColor1': '0x00000000',
        'avatarColor2': '0x00000000',
        'link': '',
      });
    }
    data['loadingStatus'] = 'done';
    update(['loadingState']);
  }
}
