import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '/GlobalController.dart';

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

  String keyStatus(String status) {
    return status.contains('the thread')
        ? 'the thread'
        : status.contains('a thread called')
            ? 'a thread called'
            : status.contains('reacted to your message in the conversation') // status
                ? 'reacted to your message in the conversation'
                : status.contains('reacted to your')
                    ? 'reacted to your'
                    : 'the conversation';
  }

  getAlert() async {
    if (GlobalController.i.isLogged == true) {
      await GlobalController.i.getBodyBeta((value) async {
        if (value == 1){
          print('retry');
          await getAlert();
        }
      }, (download) {
        percentDownload = download;
        update(['download'], true);
      }, dio, GlobalController.i.url + '/account/alerts?page=1', false).then((value) {
        GlobalController.i.token = value!.getElementsByTagName('html')[0].attributes['data-csrf'];
        if (value.getElementsByTagName('html')[0].attributes['data-logged-in'] == 'true') {
          GlobalController.i.controlNotification(
              int.parse(value.getElementsByClassName('p-navgroup-link--alerts')[0].attributes['data-badge'].toString()),
              int.parse(value.getElementsByClassName('p-navgroup-link--conversations')[0].attributes['data-badge'].toString()),
              value.getElementsByTagName('html')[0].attributes['data-logged-in'].toString());
        } else
          GlobalController.i.controlNotification(0, 0, 'false');

        value.getElementsByClassName('alert js-alert block-row block-row--separated').forEach((element) {
          data['unread'] = element.attributes['class']!.contains('is-unread') ? 'true' : 'false';
          data['time'] = element.getElementsByTagName('time')[0].innerHtml;
          data['status'] = element.getElementsByClassName('contentRow-main contentRow-main--close')[0].text.replaceAll(data['time'], '').trim();
          data['link'] = element.getElementsByClassName('fauxBlockLink-blockLink')[0].attributes['href'].toString();
          if (element.getElementsByClassName('username ').length > 0) {
            data['username'] = element.getElementsByClassName('username ')[0].text;
            data['status'] = data['status'].replaceAll(data['username'], '');
            data['key'] = keyStatus(data['status']);

            if (data['status'].contains('is now following you.')) {
              data['threadName'] = '';
            } else {
              data['threadName'] = data['status'].split(data['key'])[1].replaceAll(' There may be more posts after this', '');
              data['status'] = data['status'].split('.')[0].split(data['key'])[0] + data['key'];
            }
          } else {
            data['threadName'] = data['status'].split(':')[1];
            data['status'] = data['status'].split(':')[0] + ":";
            data['username'] = '';
          }

          if (data['threadName'].contains('with  Ưng')) {
            data['threadName'] = data['threadName'].split('with  Ưng')[0];
            data['reaction'] = '1';
          } else if (data['threadName'].contains('with  Gạch')) {
            data['threadName'] = data['threadName'].split('with  Gạch')[0];
            data['reaction'] = '2';
          } else
            data['reaction'] = '';
          if (element.getElementsByTagName('span')[0].attributes['dir'] == 'auto') {
            data['threadName'] = data['threadName'].replaceFirst(element.getElementsByTagName('span')[0].text, '', 0).trim();
            data['threadName'] = ' ' + data['threadName'] + ' ';
            data['prefix'] = element.getElementsByTagName('span')[0].text;
          } else
            data['prefix'] = '';

          GlobalController.i.alertList.add({
            'unread': data['unread'],
            'username': data['username'],
            'status': data['prefix'].length > 1 ? data['status'] + ' ' : data['status'],
            'prefix': data['prefix'],
            'threadName': data['threadName'],
            'reaction': data['reaction'],
            'link': data['link'],
            'time': data['time'],
          });
        });
        if (GlobalController.i.alertList.length == 0) {
          GlobalController.i.alertList.add({
            'unread': 'true',
            'username': '',
            'status': 'No Alerts',
            'threadName': '',
            'reaction': '',
            'link': '',
            'time': '',
          });
        }
      });
      data['loadingStatus'] = 'done';
      update(['loadingState']);
    }
  }
}
