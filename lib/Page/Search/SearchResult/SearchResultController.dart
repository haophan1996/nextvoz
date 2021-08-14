import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:nextvoz/Page/Search/SearchType.dart';
import '../../../GlobalController.dart';
import 'package:html/parser.dart' as parser;

class SearchResultController extends GetxController {
  Map<String, dynamic> data = {};
  List htmlData = [];
  var dios = Dio();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    data['SearchType'] = Get.arguments[0];
    data['SearchConfig'] = Get.arguments[1];
    data['loading'] = 'loading';
  }

  @override
  Future<void> onReady() async {
    // TODO: implement onReady
    super.onReady();

    switch (data['SearchType']) {
      case SearchType.SearchEverything:
        await performSearchEverything();
        break;
      case SearchType.SearchProfilePosts:
        print('SearchProfilePosts');
        break;
      case SearchType.SearchTags:
        print('SearchTags');
        break;
      case SearchType.SearchThreads:
        print('SearchThreads');
        break;
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    GlobalController.i.sessionTag.removeLast();
  }

  performSearchEverything() async {
    var headers = {
      'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
      'host': 'voz.vn',
      'cookie': '${GlobalController.i.xfCsrfPost}; xf_user=${GlobalController.i.xfUser};',
    };
    var body = {
      'c[title_only]': data['SearchConfig']['isSearchTitlesOnly'],
      'c[newer_than]': data['SearchConfig']['dateTime'],
      'c[users]': data['SearchConfig']['postBy'],
      'keywords': data['SearchConfig']['keywords'],
      'order': 'relevance',
      '_xfToken': '${GlobalController.i.token}'
    };
    await GlobalController.i.getHttpPost(false, headers, body, GlobalController.i.url + SearchType.SearchEverything).then((value) {
      final doc = parser.parse(value);
      if (doc.getElementsByClassName('block-row block-row--separated  js-inlineModContainer').length == 0) {
        data['loading'] = 'no';
        data['content'] = doc.getElementsByClassName('p-body-content')[0].text;
        return;
      }
      doc.getElementsByClassName('block-row block-row--separated  js-inlineModContainer').forEach((element) {
        data['author'] = element.attributes['data-author'];
        data['link'] = element.getElementsByClassName('contentRow-title')[0].getElementsByTagName('a')[0].attributes['href'];
        data['title'] = element.getElementsByClassName('contentRow-title')[0].text.trim();
        data['content'] = element.getElementsByClassName('contentRow-snippet')[0].text.trim();

        if (element.getElementsByClassName('avatar avatar--s')[0].getElementsByTagName('img').length > 0) {
          data['_userAvatar'] = element.getElementsByClassName('avatar avatar--s')[0].getElementsByTagName('img')[0].attributes['src'].toString();
          data['avatarColor1'] = '0x00000000';
          data['avatarColor2'] = '0x00000000';
          if (data['_userAvatar'].contains('https') == false) {
            data['_userAvatar'] = GlobalController.i.url + data['_userAvatar'];
          }
        } else {
          data['_userAvatar'] = 'no';
          data['avatarColor1'] =
              '0xFFF' + element.getElementsByClassName('avatar avatar--s')[0].attributes['style'].toString().split('#')[1].split(';')[0];
          data['avatarColor2'] = '0xFFF' + element.getElementsByClassName('avatar avatar--s')[0].attributes['style'].toString().split('#')[2];
        }

        htmlData.add({
          'author': data['author'],
          'link': data['link'],
          'title': data['title'],
          'content': data['content'],
          '_userAvatar': data['_userAvatar'],
          'avatarColor1': data['avatarColor1'],
          'avatarColor2': data['avatarColor2'],
        });
      });
      data['loading'] = 'ok';
    });
    update(['updateSearchResult']);
  }

  performSearchThreads() async {}

  performSearchProfilePosts() async {}

  performSearchTags() async {}
}
