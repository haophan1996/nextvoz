import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:theNEXTvoz/Page/reuseWidget.dart';
import '/Page/Profile/AlertPlus/AlertPlusType.dart';
import '../../../GlobalController.dart';
import '/Routes/pages.dart';

class AlertPlusController extends GetxController {
  Map<String, dynamic> data = {};
  List htmlData = [];
  var dios = Dio();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    data['percentDownload'] = 0.0;
    data['isScroll'] = 'idle';

    data['type'] = Get.arguments[0]['type'];
    data['userLink'] = Get.arguments[0]['userLink'];
    data['userName'] = Get.arguments[0]['userName'] ?? '';

    /// Only required for AlertPlusType.ProfileLatestActivity
    data['next'] = '';
  }

  @override
  Future<void> onReady() async {
    // TODO: implement onReady
    super.onReady();
    data['loading'] = 'firstLoading';
    await performType();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    GlobalController.i.sessionTag.removeLast();
    data.clear();
    dios.clear();
  }

  performType() async {
    if (data['next'] == 'noMore') {
      await updateLastItemScroll();
      return;
    }
    switch (data['type']) {
      case AlertPlusType.LatestActivity:
        await performActivity();
        break;
      case AlertPlusType.NewFeed:
        await performNewFeed();
        break;
      case AlertPlusType.ProfileLatestActivity:
        await performUserLatestActivity();
        break;
    }
  }

  updateLastItemScroll() async {
    if (data['isScroll'] != 'idle') {
      data['isScroll'] = 'idle';
      update(['lastItemList']);
    }
  }

  updateListView() async {
    print('ascsacsa');
    if (data['loading'] == 'firstLoading') {
      data['loading'] = 'ok';
      update(['firstLoading']);
    } else {
      update(['listview']);
      HapticFeedback.lightImpact();
    }
  }

  updateNullHtmlDataList() {
    htmlData.add({
      'firstIndex': true,
      'username': '',
      'userNamePost': '',
      'action': '',
      'thread': '',
      'reaction': '',
      'inThread': '',
      'content': '\t\tThere are no more items to show.',
      'time': '',
      'link': '',
    });
  }

  navigateView(String link) async {
    if (link == '') {
      setDialogError('Can\'t open');
      return;
    }
    if (link.contains('/p/', 0) == true) {
      Get.toNamed(Routes.View, arguments: [link, link, '', 0]);
    } else
      setDialogError('Not supported yet');
  }

  performActivity() async {
    GlobalController.i.getBodyBeta((value) async {
      if (Get.currentRoute == Routes.AlertPlus) {
        if (value == 1) await performActivity();
      }
    }, (download) {
      ///download
      data['percentDownload'] = download;
      update(['download'], true);
    }, dios, GlobalController.i.url + AlertPlusType.LatestActivity + data['next'], false).then((value) async {
      if (value!.getElementsByClassName('block-footer-controls').length == 0) {
        updateNullHtmlDataList();
        await updateListView();
        await updateLastItemScroll();
        data['next'] = 'noMore';
      } else {
        data['next'] = value
            .getElementsByClassName('block-footer-controls')[0]
            .getElementsByTagName('a')[0]
            .attributes['href']!
            .replaceAll(AlertPlusType.LatestActivity, '');
        await performQuery(value);
      }
    });
  }

  performNewFeed() async {
    GlobalController.i.getBodyBeta((value) async {
      if (Get.currentRoute == Routes.AlertPlus) {
        if (value == 1) await performNewFeed();
      }
    }, (download) {
      data['percentDownload'] = download;
      update(['download'], true);
    }, dios, GlobalController.i.url + AlertPlusType.NewFeed + data['next'], false).then((value) async {
      if (value!.getElementsByClassName('block-footer-controls').length == 0) {
        updateNullHtmlDataList();
        await updateListView();
        await updateLastItemScroll();
        data['next'] = 'noMore';
      } else {
        data['next'] = value
            .getElementsByClassName('block-footer-controls')[0]
            .getElementsByTagName('a')[0]
            .attributes['href']!
            .replaceAll(AlertPlusType.NewFeed, '');
        await performQuery(value);
      }
    });
  }

  performUserLatestActivity() async {
    GlobalController.i.getBodyBeta((value) async {
      if (Get.currentRoute == Routes.AlertPlus) {
        if (value == 1) await performUserLatestActivity();
      }
    }, (download) {
      data['percentDownload'] = download;
      update(['download'], true);
    }, dios, GlobalController.i.url + data['userLink'] + AlertPlusType.ProfileLatestActivity + data['next'], false).then((value) async {
      if (value!.getElementsByClassName('block-footer-controls').length == 0) {
        updateNullHtmlDataList();
        await updateListView();
        await updateLastItemScroll();
        data['next'] = 'noMore';
      } else {
        data['next'] = value
            .getElementsByClassName('block-footer-controls')[0]
            .getElementsByTagName('a')[0]
            .attributes['href']!
            .split(AlertPlusType.ProfileLatestActivity)[1];
        await performQuery(value);
      }
    });
  }

  performQuery(dynamic value) async {
    data['firstIndex'] = 0;
    if (value.getElementsByTagName('html')[0].attributes['data-logged-in'] == 'true') {
      GlobalController.i.controlNotification(
          int.parse(value.getElementsByClassName('p-navgroup-link--alerts')[0].attributes['data-badge'].toString()),
          int.parse(value.getElementsByClassName('p-navgroup-link--conversations')[0].attributes['data-badge'].toString()),
          value.getElementsByTagName('html')[0].attributes['data-logged-in'].toString());
    } else
      GlobalController.i.controlNotification(0, 0, 'false');

    value.getElementsByClassName('block-row block-row--separated ').forEach((element) {
      data['firstIndex'] += 1;
      data['username'] = element.getElementsByClassName('username')[0].text;

      data['time'] = element.getElementsByClassName('u-dt')[0].innerHtml;
      data['fullTitle'] = element.getElementsByClassName('contentRow-title')[0].text.trim();
      data['content'] = element.getElementsByClassName('contentRow-snippet')[0].text.trim().replaceAll(RegExp('\\s+'), ' ');

      if (element.getElementsByClassName('contentRow-title')[0].getElementsByTagName('a').length == 3) {
        data['thread'] = element.getElementsByClassName('contentRow-title')[0].getElementsByTagName('a')[2].text;
        data['userNamePost'] = element.getElementsByClassName('contentRow-title')[0].getElementsByTagName('a')[1].text;
        data['reaction'] = data['fullTitle'].toString().split(data['thread'])[1].trim();
        data['inThread'] = data['fullTitle'].toString().split(data['userNamePost'])[1].split(data['thread'])[0].trim();
        data['action'] = data['fullTitle'].toString().replaceAll(data['username'], '').split(data['userNamePost'])[0].trim();
      } else {
        data['thread'] = element.getElementsByClassName('contentRow-title')[0].getElementsByTagName('a')[1].text;
        data['action'] = data['fullTitle'].toString().split(data['username'])[1].split(data['thread'])[0].trim();
        data['userNamePost'] = '';
        data['inThread'] = data['fullTitle'].toString().split(data['thread'])[1];
        if (data['inThread'].toString().contains('with') == true) {
          data['reaction'] = data['inThread'].toString().split('with')[1];
          data['inThread'] = data['inThread'].toString().split('with')[0] + 'with';
        } else {
          data['reaction'] = '';
          data['inThread'] = '';
        }
      }
      data['link'] = element.getElementsByClassName('contentRow-title')[0].getElementsByTagName('a')[1].attributes['href'];
      htmlData.add({
        'firstIndex': data['firstIndex'] == 1 ? true : false,
        'username': data['username'],
        'userNamePost': data['userNamePost'],
        'action': data['action'],
        'thread': data['thread'],
        'reaction': data['reaction'],
        'inThread': data['inThread'],
        'content': data['content'],
        'time': data['time'],
        'link': data['link'] ?? ''
      });
    });
    await updateListView();
    await updateLastItemScroll();
  }
}
