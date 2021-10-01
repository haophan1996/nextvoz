import 'package:dio_http/dio_http.dart';
import 'package:get/get.dart';
import 'package:the_next_voz/Routes/pages.dart';
import '../../GlobalController.dart';

class InboxController extends GetxController {
  var percentDownload = 0.0, dio = Dio();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    // TODO: implement onReady
    super.onReady();
    if (GlobalController.i.inboxList.isEmpty == true || GlobalController.i.inboxNotifications != 0) {
      GlobalController.i.inboxList.clear();
      await getInboxAlert();
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    dio.close(force: true);
    this.dispose();
  }

  navigateToCreatePost() async {
    var result =
        await Get.toNamed(Routes.CreatePost, arguments: [GlobalController.i.xfCsrfPost, GlobalController.i.token, 'link', '', '', '2', '', '']);
    if (result != null && result[0] == 'ok') {
      await Get.toNamed(Routes.View, arguments: [result[2], result[1], '', 1]);
      await refreshList();
    }
  }

  refreshList() async {
    GlobalController.i.inboxList.clear();
    update();
    await getInboxAlert();
  }

  getInboxAlert() async {
    String getName = '', title, link, rep, party, latestDay, latestRep, avatarLink, avatarColor1, avatarColor2, isUnread;
    if (GlobalController.i.isLogged == true) {
      await GlobalController.i.getBodyBeta((value) async {
        if (value == 1) {
          print('retry');
          await getInboxAlert();
        }
      }, (download) {
        percentDownload = download;
        update(['download'], true);
      }, dio, GlobalController.i.url + '/conversations/', false).then((value) {
        GlobalController.i.token = value!.getElementsByTagName('html')[0].attributes['data-csrf'];
        GlobalController.i.inboxNotifications = value.getElementsByClassName('p-navgroup-link--conversations').length > 0
            ? int.parse(value.getElementsByClassName('p-navgroup-link--conversations')[0].attributes['data-badge'].toString())
            : 0;
        GlobalController.i.alertNotifications = value.getElementsByClassName('p-navgroup-link--alerts').length > 0
            ? int.parse(value.getElementsByClassName('p-navgroup-link--alerts')[0].attributes['data-badge'].toString())
            : 0;

        var items = value.getElementsByClassName('structItem structItem--conversation  js-inlineModContainer');
        if (items.length > 0) {
          items.forEach((element) {
            isUnread = element.attributes['class']!.contains('is-unread') == true ? 'true' : 'false';
            title = element.getElementsByClassName('structItem-title')[0].text; //title
            link = element.getElementsByClassName('structItem-title')[0].attributes['href'].toString(); //link
            rep = element.getElementsByClassName('pairs pairs--justified')[0].getElementsByTagName('dd')[0].text; //replies
            party = element.getElementsByClassName('pairs pairs--justified structItem-minor')[0].getElementsByTagName('dd')[0].text; // participants
            latestDay = element.getElementsByClassName('structItem-latestDate u-dt')[0].text; //latestDate
            latestRep = element.getElementsByClassName('username').last.text;

            var getClassName =
                element.getElementsByClassName('listInline listInline--comma listInline--selfInline')[0].getElementsByClassName('username ');
            getClassName.forEach((element) {
              getName += element.text + ', ';
            });

            var avatar = element.getElementsByClassName('avatar avatar--s').first;
            if (avatar.getElementsByTagName('img').length > 0) {
              avatarLink = avatar.getElementsByTagName('img')[0].attributes['src'].toString();
              if (avatarLink.contains('https') == false) {
                avatarLink = GlobalController.i.url + avatarLink;
              }
              avatarColor1 = '0x00000000';
              avatarColor2 = '0x00000000';
            } else {
              avatarLink = 'no';
              avatarColor1 = '0xFFF' + avatar.attributes['style'].toString().split('#')[1].split(';')[0];
              avatarColor2 = '0xFFF' + avatar.attributes['style'].toString().split('#')[2];
            }

            GlobalController.i.inboxList.add({
              'isUnread': isUnread,
              'title': title,
              'linkInbox': link,
              'repAndParty': 'Replies: $rep \u2022 Participants: $party',
              'latestDay': latestDay,
              'conservationWith': getName.replaceFirst(', ', '', getName.length - 2),
              'latestRep': latestRep,
              'avatarLink': avatarLink,
              'avatarColor1': avatarColor1,
              'avatarColor2': avatarColor2,
            });
            getName = '';
          });
        }
      });
      update();
    }
  }
}
