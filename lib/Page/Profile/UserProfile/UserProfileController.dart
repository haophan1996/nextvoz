import 'package:dio_http/dio_http.dart';
import 'package:get/get.dart';
import '/GlobalController.dart';

class UserProfileController extends GetxController {
  late var xfCsrfPost, dataCsrfPost;
  double percentDownload = 0.0;
  Map<String, dynamic> data = {};
  List htmlData = [];
  var dio = Dio();

  @override
  onInit() async {
    super.onInit();
    data['linkProfileUser'] = Get.arguments[0];
    data['loadingStatus'] = 'loading';
  }

  @override
  Future<void> onReady() async {
    // TODO: implement onReady
    super.onReady();
    await loadProfileUser();
  }

  @override
  onClose() {
    super.onClose();
    GlobalController.i.sessionTag.removeLast();
    data.clear();
    htmlData.clear();
    dio.close(force: true);
  }

  onErrorLoad() {
    data['loadingStatus'] = 'loadFailed';
    update(['loadingState']);
  }

  onRefresh() async {
    data['loadingStatus'] = 'loading';
    update(['loadingState']);
    await loadProfileUser();
  }

  loadProfileUser() async {
    percentDownload = 0.1;
    await GlobalController.i.getBodyBeta((value) async {
      if (value == 1) {
        await loadProfileUser();
      } else
        onErrorLoad();
    }, (download) {
      percentDownload = download;
      update(['download']);
    }, dio, GlobalController.i.url + data['linkProfileUser'], false).then((value) {
      data['dataCsrfPost'] = value!.getElementsByTagName('html')[0].attributes['data-csrf']; //Current page token
      data['xfCsrfPost'] = GlobalController.i.xfCsrfPost; // Post token
      GlobalController.i.token = value.getElementsByTagName('html')[0].attributes['data-csrf'];
      var userProfile = value.getElementsByClassName('memberHeader ')[0];
      var avatar = userProfile.getElementsByClassName('avatar avatar--l').first;
      if (avatar.getElementsByTagName('img').length > 0) {
        data['avatarLink'] = avatar.attributes['href'].toString();
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

      data['data-user-id'] = userProfile.getElementsByClassName('username ')[0].attributes['data-user-id'];
      data['userName'] = userProfile.getElementsByClassName('username ')[0].text;
      data['title'] = userProfile.getElementsByClassName('userTitle ')[0].text;
      data['joined'] = userProfile.getElementsByClassName('u-dt ')[0].text;
      data['from'] = userProfile.getElementsByClassName('memberHeader-blurb')[0].getElementsByClassName('u-concealed').length > 0
          ? 'From ' + userProfile.getElementsByClassName('memberHeader-blurb')[0].getElementsByClassName('u-concealed')[0].text
          : '';
      data['lastSeen'] =
          userProfile.getElementsByClassName('u-dt ').length > 1 ? userProfile.getElementsByClassName('u-dt ')[1].text : 'No information';
      data['pointTrophies'] = userProfile.getElementsByClassName('fauxBlockLink-linkRow u-concealed')[1].text.trim();
      data['messages'] = userProfile.getElementsByClassName('fauxBlockLink-linkRow u-concealed ')[0].text.trim();
      data['reactionScore'] =
          userProfile.getElementsByClassName('pairs pairs--rows pairs--rows--centered')[1].getElementsByTagName('dd')[0].text.trim();

      // if (value.getElementsByClassName('message message--simple  js-inlineModContainer').length > 0) {
      //   value.getElementsByClassName('message message--simple  js-inlineModContainer').forEach((element) {
      //     data['userNameProfile'] = element.getElementsByClassName('attribution')[0].text.trim(); //userName
      //     data['datePostedProfile'] = element.getElementsByClassName('u-dt')[0].text; //date posted
      //     data['postContent'] = element.getElementsByClassName('lbContainer js-lbContainer')[0].outerHtml; //message
      //     element.getElementsByClassName('lbContainer js-lbContainer')[0].getElementsByTagName('img').forEach((element) {
      //       if (element.attributes['src']!.contains('data:image/', 0)) {
      //         data['postContent'] = data['postContent'].replaceAll(element.outerHtml, element.outerHtml.replaceFirst('src', 'source-base64').replaceFirst('data-src', 'src'));
      //       }
      //     });
      //
      //     data['userLinkPostProfile'] = element.getElementsByClassName('username ')[0].attributes['href'].toString(); // link owner
      //     data['linkContentProfile'] = element.getElementsByClassName('u-concealed')[0].attributes['href']; //link content
      //
      //     data['reactionName'] =
      //         element.getElementsByClassName('reactionsBar-link').length > 0 ? element.getElementsByClassName('reactionsBar-link')[0].text : '';
      //
      //     if (element.getElementsByClassName('reaction reaction--small reaction').length > 0) {
      //       data['reactionIcon'] = element.getElementsByClassName('reaction reaction--small reaction')[0].attributes['data-reaction-id'].toString();
      //       if (element.getElementsByClassName('reaction reaction--small reaction').length > 1) {
      //         data['reactionIcon'] +=
      //             element.getElementsByClassName('reaction reaction--small reaction')[1].attributes['data-reaction-id'].toString();
      //       }
      //     } else
      //       data['reactionIcon'] = 'no';
      //
      //     htmlData.add({
      //       'userNameProfile': data['userNameProfile'],
      //       'datePostedProfile': " \u2022 " + data['datePostedProfile'],
      //       'postContent': data['postContent'],
      //       'userLinkPostProfile': data['userLinkPostProfile'],
      //       'linkContentProfile': data['linkContentProfile'],
      //       'reactionName': data['reactionName'],
      //       'reactionIcon': data['reactionIcon'],
      //       //'avatarLink' : data['avatarLink'],
      //       //'avatarColor1' : data['avatarColor1'],
      //       //'avatarColor2' : data['avatarColor2'],
      //     });
      //   });
      // } else {
      //   htmlData.add({
      //     'userNameProfile': '',
      //     'datePostedProfile': '',
      //     'postContent': '''<p>There are no messages on ${data['userName']}'s profile yet.</p>''',
      //     'userLinkPostProfile': '',
      //     'linkContentProfile': '',
      //     'reactionName': '',
      //     'reactionIcon': 'no',
      //     //'avatarLink' : 'no',
      //     //'avatarColor1' : '0x00000000',
      //     //'avatarColor2' : '0x00000000',
      //   });
    }
        //}
        );
    data['loadingStatus'] = 'loadSucceeded';
    update(['loadingState']);
  }

// uploadStatus() async {
//   var header = {
//     'cookie': 'xf_user=${GlobalController.i.xfUser.toString()}; $xfCsrfPost',
//     'referer': GlobalController.i.url + NaviDrawerController.i.linkUser,
//     'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
//     'User-Agent': NaviDrawerController.i.nameUser,
//     'Host': 'voz.vn'
//   };
//   var body = {
//     'message_html': 'post tu app flutter',
//     'load_extra': '1',
//     '_xfToken': dataCsrfPost,
//     '_xfRequestUri': NaviDrawerController.i.linkUser,
//     '_xfResponseType': 'json'
//   };
//
//   await http.post(Uri.parse(GlobalController.i.url + NaviDrawerController.i.linkUser + "/post"), headers: header, body: body).then((value) {
//     print(value.statusCode);
//     print(value.headers);
//     print(value.body);
//   });
// }
}
