import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '/GlobalController.dart';

class AlertsController extends GetxController {
  var dio = Dio(), percentDownload = 0.0;

  refreshList() async {
    GlobalController.i.alertList.clear();
    update();
    await getAlert();
  }

  @override
  Future<void> onReady() async {
    // TODO: implement onReady
    super.onReady();

    if (GlobalController.i.alertList.isEmpty || GlobalController.i.alertNotifications != 0) {
      GlobalController.i.alertList.clear();
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
    String username, threadName = '', prefix, reaction, time, status, link, key, unread;
    if (GlobalController.i.isLogged == true) {
      await GlobalController.i.getBody(() {}, (download) {
        percentDownload = download;
        update(['download'], true);
      }, dio, GlobalController.i.url + '/account/alerts?page=1', false).then((value) {
        GlobalController.i.inboxNotifications = value!.getElementsByClassName('p-navgroup-link--conversations').length > 0
            ? int.parse(value.getElementsByClassName('p-navgroup-link--conversations')[0].attributes['data-badge'].toString())
            : 0;
        GlobalController.i.alertNotifications = value.getElementsByClassName('p-navgroup-link--alerts').length > 0
            ? int.parse(value.getElementsByClassName('p-navgroup-link--alerts')[0].attributes['data-badge'].toString())
            : 0;

        value.getElementsByClassName('alert js-alert block-row block-row--separated').forEach((element) {
          unread = element.attributes['class']!.contains('is-unread') ? 'true' : 'false';
          time = element.getElementsByTagName('time')[0].innerHtml;
          status = element.getElementsByClassName('contentRow-main contentRow-main--close')[0].text.replaceAll(time, '').trim();
          link = element.getElementsByClassName('fauxBlockLink-blockLink')[0].attributes['href'].toString();
          if (element.getElementsByClassName('username ').length > 0) {
            username = element.getElementsByClassName('username ')[0].text;
            status = status.replaceAll(username, '');
            key = keyStatus(status);

            if (status.contains('is now following you.')) {
              threadName = '';
            } else {
              threadName = status.split(key)[1].replaceAll(' There may be more posts after this', '');
              status = status.split('.')[0].split(key)[0] + key;
            }
          } else {
            threadName = status.split(':')[1];
            status = status.split(':')[0] + ":";
            username = '';
          }
          if (threadName.contains('with  Ưng')) {
            threadName = threadName.split('with  Ưng')[0];
            reaction = '1';
          } else if (threadName.contains('with  Gạch')) {
            threadName = threadName.split('with  Gạch')[0];
            reaction = '2';
          } else
            reaction = '';
          if (element.getElementsByTagName('span')[0].attributes['dir'] == 'auto') {
            threadName = threadName.replaceFirst(element.getElementsByTagName('span')[0].text, '', 0).trim();
            threadName = ' ' + threadName + ' ';
            prefix = element.getElementsByTagName('span')[0].text;
          } else
            prefix = '';

          GlobalController.i.alertList.add({
            'unread': unread,
            'username': username,
            'status': prefix.length > 1 ? status + ' ' : status,
            'prefix': prefix,
            'threadName': threadName,
            'reaction': reaction,
            'link': link,
            'time': time,
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
      update();
    }
  }
}
