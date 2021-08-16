import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import '/Routes/pages.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import '/GlobalController.dart';
import '/Page/reuseWidget.dart';

class ViewController extends GetxController {
  List htmlData = [], reactionList = [], imageList = [];
  Map<String, dynamic> data = {};
  bool isEdit = false;
  var dio = Dio();
  late dom.Document res;
  late ScrollController listViewScrollController = ScrollController();
  TextEditingController input = TextEditingController();

  @override
  Future<void> onInit() async {
    super.onInit();
    data['percentDownload'] = 0.0;
    data['isScroll'] = 'idle';

    data['subHeader'] = Get.arguments[0];
    data['subTypeHeader'] = Get.arguments[2] ?? '';
    data['view'] = Get.arguments[3];
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    data['loading'] = 'loading';
    data['subLink'] = Get.arguments[1];
    data['subLink'] = data['subLink'].toString().replaceAll(GlobalController.i.url, '');
    data['view'] == 0
        ? await loadUserPost(data['fullUrl'] = GlobalController.i.url + data['subLink'])
        : await loadInboxView(data['fullUrl'] = GlobalController.i.url + data['subLink']);
  }

  @override
  onClose() {
    super.onClose();
    dio.close(force: true);
    dio.clear();
    input.dispose();
    GlobalController.i.sessionTag.removeLast();
    listViewScrollController.dispose();
    htmlData.clear();
    data.clear();
    reactionList.clear();
    imageList.clear();
    PaintingBinding.instance!.imageCache!.clear();
    PaintingBinding.instance!.imageCache!.clearLiveImages();
    this.dispose();
  }

  _removeTag(String content) {
    return content.replaceAll(
        RegExp(r'<div class="bbCodeBlock-expandLink js-expandLink"><a role="button" tabindex="0">Click to expand...</a></div>'), "");
  }

  setPageOnClick(int toPage) async {
    data['view'] == 0
        ? await loadUserPost(data['fullUrl'] + GlobalController.i.pageLink + toPage.toString())
        : await loadInboxView(data['fullUrl'] + GlobalController.i.pageLink + toPage.toString());

    await updateLastItemScroll();
  }

  updateLastItemScroll() async {
    if (data['isScroll'] != 'idle') {
      data['isScroll'] = 'idle';
      update(['lastItemList']);
    }
  }

  getImage(String url) async {
    // return await getCachedImageFile(url);
  }

  write(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/my_file.txt');
    await file.writeAsString(text);
    print('${directory.path}/my_file.txt');
    print(File('${directory.path}/my_file.txt').toString());
  }

  saveImage(String url) async {
    final Directory? directory = Directory("storage/emulated/0/Pictures/vozNext");
    await directory!.create();
    // final File file = File((await getCachedImageFilePath(url)).toString());
    // await file.copy(directory.path + "/${file.path.split("/").last}.jpg");
  }

  final flagsReactions = [
    Reaction(
      previewIcon: buildFlagsPreviewIcon('assets/reaction/0.png', 'unReact'),
      icon: buildIcon('assets/reaction/nil.png', 'react'),
    ),
    Reaction(
      previewIcon: buildFlagsPreviewIcon('assets/reaction/1.png', 'sweet'),
      icon: buildIcon('assets/reaction/1.png', 'sweeted'),
    ),
    Reaction(
      previewIcon: buildFlagsPreviewIcon('assets/reaction/2.png', 'brick'),
      icon: buildIcon('assets/reaction/2.png', 'bricked'),
    ),
  ];

  getDataReactionList(int index) async {
    reactionList.clear();
    await GlobalController.i
        .getBody(
            () {},
            (download) {},
            dio,
            '${data['view'] == 0 ? GlobalController.i.viewReactLink : GlobalController.i.inboxReactLink}' +
                htmlData.elementAt(index)['postID'] +
                '/reactions',
            false)
        .then((value) {
      value!.getElementsByClassName('block-row block-row--separated').forEach((element) {
        data['rName'] = element.getElementsByClassName('username ')[0].text;
        data['rTitle'] = element.getElementsByClassName('userTitle')[0].text;
        data['rMessage'] = element.getElementsByClassName('pairs pairs--inline')[0].getElementsByTagName('dd')[0].text;
        data['rMessage2'] = element.getElementsByClassName('pairs pairs--inline')[1].getElementsByTagName('dd')[0].text;
        data['rMessage3'] = element.getElementsByClassName('pairs pairs--inline')[2].getElementsByTagName('dd')[0].text;
        data['rTime'] = element.getElementsByClassName('u-dt')[0].text;
        data['rReactIcon'] = element.getElementsByClassName('reaction-image js-reaction')[0].attributes['alt'].toString() == 'Ưng' ? '1' : '2';

        // data['avatar'] = element.getElementsByClassName('avatar')[0].getElementsByTagName('img').length > 0
        //     ? element.getElementsByClassName('avatar')[0].getElementsByTagName('img')[0].attributes['src']
        //     : 'no';

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


        reactionList.add({
          'rName': data['rName'],
          'rTitle': data['rTitle'],
          'rMessage': data['rMessage'],
          'rMessage2': data['rMessage2'],
          'rMessage3': data['rMessage3'],
          'rTime': data['rTime'],
          'rReactIcon': data['rReactIcon'],
          'rAvatar': data['_userAvatar'],
          'avatarColor1' : data['avatarColor1'],
          'avatarColor2' : data['avatarColor2'],
        });
      });
      PaintingBinding.instance!.imageCache!.clear();
      PaintingBinding.instance!.imageCache!.clearLiveImages();
      update(['reactionState'], true);
    });
  }

  Future<void> loadUserPost(String url) async {
    data['_commentImg'] = '';
    await GlobalController.i.getBodyBeta((value) async {
      ///error
      if (value == 1){
        ///retry server if unresponsive
        await loadUserPost(url);
        await updateLastItemScroll();
      } else {
        data['loading'] = 'error';
        update(['firstLoading']);
      }

    }, (download) {
      ///download
      data['percentDownload'] = download;
      update(['download'], true);
    }, dio, url, false).then((value) async {
      data['lengthHtmlDataList'] = htmlData.length;
      GlobalController.i.token = value!.getElementsByTagName('html')[0].attributes['data-csrf'];
      data['dataCsrfPost'] = value.getElementsByTagName('html')[0].attributes['data-csrf'];
      data['xfCsrfPost'] = GlobalController.i.xfCsrfPost;
      data['fullUrl'] = value
          .getElementsByTagName('head')[0]
          .getElementsByTagName('meta')
          .where((element) => element.attributes['property'] == 'og:url')
          .first
          .attributes['content'];
      if (data['fullUrl'].contains('page-') == true) {
        data['fullUrl'] = data['fullUrl']
            .toString()
            .split(
              'page-',
            )
            .first;
      }
      if (value.getElementsByTagName('html')[0].attributes['data-logged-in'] == 'true') {
        GlobalController.i.controlNotification(
            int.parse(value.getElementsByClassName('p-navgroup-link--alerts')[0].attributes['data-badge'].toString()),
            int.parse(value.getElementsByClassName('p-navgroup-link--conversations')[0].attributes['data-badge'].toString()),
            value.getElementsByTagName('html')[0].attributes['data-logged-in'].toString());
      } else
        GlobalController.i.controlNotification(0, 0, 'false');

      value.getElementsByClassName("block block--messages").forEach((element) {
        var lastP = element.getElementsByClassName("pageNavSimple");
        if (lastP.length == 0) {
          data['currentPage'] = 1;
          data['totalPage'] = 1;
        } else {
          var naviPage = element.getElementsByClassName("pageNavSimple-el pageNavSimple-el--current").first.innerHtml.trim();
          data['currentPage'] = int.parse(naviPage.replaceAll(RegExp(r'[^0-9]\S*'), ""));
          data['totalPage'] = int.parse(naviPage.replaceAll(RegExp(r'\S*[^0-9]'), ""));
        }

        //Get post
        element.getElementsByClassName("message message--post js-post js-inlineModContainer").forEach((element) {
          data['_postContent'] = element.getElementsByClassName("message-body js-selectToQuote")[0].outerHtml; //.replaceAll('color: #000000', '');

          if (element.getElementsByClassName('message-lastEdit').length > 0) {
            data['_postContent'] = data['_postContent'] + fixLastEditPost(element.getElementsByClassName('message-lastEdit')[0].text);
          }

          data['_userPostDate'] = element.getElementsByClassName("u-concealed")[0].text.trim();

          data['_user'] = element.getElementsByClassName("message-cell message-cell--user");
          data['postID'] = element.attributes['id']!.split('t-')[1];
          data['_userLink'] = data['_user'].map((e) => e.getElementsByTagName("a")[1].attributes['href']).first!;
          data['_userTitle'] = data['_user'].map((e) => e.getElementsByClassName("userTitle message-userTitle")[0].innerHtml).first;

          if (element.getElementsByClassName('avatar avatar--m')[0].getElementsByTagName('img').length > 0) {
            data['_userAvatar'] = element.getElementsByClassName('avatar avatar--m')[0].getElementsByTagName('img')[0].attributes['src'].toString();
            data['avatarColor1'] = '0x00000000';
            data['avatarColor2'] = '0x00000000';
            if (data['_userAvatar'].contains('https') == false) {
              data['_userAvatar'] = GlobalController.i.url + data['_userAvatar'];
            }
          } else {
            data['_userAvatar'] = 'no';
            data['avatarColor1'] =
                '0xFFF' + element.getElementsByClassName('avatar avatar--m')[0].attributes['style'].toString().split('#')[1].split(';')[0];
            data['avatarColor2'] = '0xFFF' + element.getElementsByClassName('avatar avatar--m')[0].attributes['style'].toString().split('#')[2];
          }

          data['_userName'] = data['_user'].map((e) => e.getElementsByTagName("a")[1].text).first;

          data['_orderPost'] = element
              .getElementsByClassName("message-attribution-opposite message-attribution-opposite--list")
              .map((e) => e.getElementsByTagName("a")[GlobalController.i.isLogged == true ? 2 : 1].innerHtml)
              .first
              .trim();

          if (element.getElementsByClassName('reactionsBar-link').length > 0) {
            data['_commentName'] = element.getElementsByClassName('reactionsBar-link')[0].innerHtml.replaceAll(RegExp(r"<[^>]*>"), '');

            if (element.getElementsByClassName('has-reaction').length > 0) {
              if (element.getElementsByClassName('has-reaction')[0].getElementsByTagName('img')[0].attributes['title'] == 'Ưng') {
                data['_commentByMe'] = '1';
              } else
                data['_commentByMe'] = '2';
            } else
              data['_commentByMe'] = '0';

            element.getElementsByClassName('reactionSummary').forEach((element) {
              element.getElementsByClassName('reaction reaction--small').forEach((element) {
                data['_commentImg'] += element.attributes['data-reaction-id'].toString();
              });
            });
          } else {
            data['_commentImg'] = 'no';
            data['_commentName'] = '';
            data['_commentByMe'] = '0';
          }

          htmlData.add({
            'newPost': element.getElementsByClassName('message-newIndicator').isNotEmpty == false ? false : true,
            "postContent": _removeTag(data['_postContent']),
            "userPostDate": data['_userPostDate'],
            "userName": data['_userName'],
            "userLink": data['_userLink'],
            "userTitle": data['_userTitle'],
            "userAvatar": data['_userAvatar'],
            'avatarColor1': data['avatarColor1'],
            'avatarColor2': data['avatarColor2'],
            "orderPost": data['_orderPost'],
            "commentName": data['_commentName'],
            "commentImage": data['_commentImg'],
            "postID": data['postID'],
            'commentByMe': int.parse(data['_commentByMe'])
          });
          data['_commentImg'] = '';
        });
      });
      imageList.clear();
      PaintingBinding.instance!.imageCache!.clear();
      PaintingBinding.instance!.imageCache!.clearLiveImages();

      if (Get.isDialogOpen == true || data['isScroll'] == 'Release' || isEdit == true) {
        if (Get.isDialogOpen == true) Get.back();
        htmlData.removeRange(0, data['lengthHtmlDataList']);
        listViewScrollController.jumpTo(-10.0);
      }
      if (data['loading'] == 'loading'){
        data['loading'] = 'ok';
        update(['firstLoading']);
      } else update();
    });
  }

  Future<void> loadInboxView(String link) async {
    data['_commentImg'] = '';
    await GlobalController.i.getBody(() {}, (download) {
      data['percentDownload'] = download;
      update(['download'], true);
    }, dio, link, false).then((value) {
      data['lengthHtmlDataList'] = htmlData.length;
      GlobalController.i.token = value!.getElementsByTagName('html')[0].attributes['data-csrf'];
      data['dataCsrfPost'] = value.getElementsByTagName('html')[0].attributes['data-csrf'];
      data['xfCsrfPost'] = GlobalController.i.xfCsrfPost;

      data['fullUrl'] = value
          .getElementsByTagName('head')[0]
          .getElementsByTagName('meta')
          .where((element) => element.attributes['property'] == 'og:url')
          .first
          .attributes['content'];
      if (data['fullUrl'].contains('page-') == true) {
        data['fullUrl'] = data['fullUrl']
            .toString()
            .split(
              'page-',
            )
            .first;
      }

      if (value.getElementsByTagName('html')[0].attributes['data-logged-in'] == 'true') {
        GlobalController.i.controlNotification(
            int.parse(value.getElementsByClassName('p-navgroup-link--alerts')[0].attributes['data-badge'].toString()),
            int.parse(value.getElementsByClassName('p-navgroup-link--conversations')[0].attributes['data-badge'].toString()),
            value.getElementsByTagName('html')[0].attributes['data-logged-in'].toString());
      } else
        GlobalController.i.controlNotification(0, 0, 'false');

      var lastP = value.getElementsByClassName("pageNavSimple");
      if (lastP.length == 0) {
        data['currentPage'] = 1;
        data['totalPage'] = 1;
      } else {
        var naviPage = value.getElementsByClassName("pageNavSimple-el pageNavSimple-el--current").first.innerHtml.trim();
        data['currentPage'] = int.parse(naviPage.replaceAll(RegExp(r'[^0-9]\S*'), ""));
        data['totalPage'] = int.parse(naviPage.replaceAll(RegExp(r'\S*[^0-9]'), ""));
      }

      value.getElementsByClassName('message message--conversationMessage').forEach((element) {
        data['_postContent'] =
            _removeTag(element.getElementsByClassName('message-body js-selectToQuote')[0].getElementsByClassName('bbWrapper')[0].innerHtml);
        data['postID'] =
            element.getElementsByClassName('actionBar-action actionBar-action--mq u-jsOnly js-multiQuote')[0].attributes['data-message-id'];
        data['_userName'] = element.getElementsByClassName('username ')[0].text;
        data['_userLink'] = element.getElementsByClassName('username')[0].attributes['href'].toString();
        data['_userTitle'] = element.getElementsByClassName('message-userTitle')[0].text;
        data['_userPostDate'] = element.getElementsByClassName('u-dt')[0].text;

        if (element.getElementsByClassName('avatar avatar--m')[0].getElementsByTagName('img').length > 0) {
          data['_userAvatar'] = element.getElementsByClassName('avatar avatar--m')[0].getElementsByTagName('img')[0].attributes['src'].toString();
          if (data['_userAvatar'].contains('https') == false) {
            data['_userAvatar'] = GlobalController.i.url + data['_userAvatar'];
          }
          data['avatarColor1'] = '0x00000000';
          data['avatarColor2'] = '0x00000000';
        } else {
          data['_userAvatar'] = 'no';
          data['avatarColor1'] =
              '0xFFF' + element.getElementsByClassName('avatar avatar--m')[0].attributes['style'].toString().split('#')[1].split(';')[0];
          data['avatarColor2'] = '0xFFF' + element.getElementsByClassName('avatar avatar--m')[0].attributes['style'].toString().split('#')[2];
        }

        if (element.getElementsByClassName('reactionsBar-link').length > 0) {
          data['_commentName'] = element.getElementsByClassName('reactionsBar-link')[0].innerHtml.replaceAll(RegExp(r"<[^>]*>"), '');

          if (element.getElementsByClassName('has-reaction').length > 0) {
            if (element.getElementsByClassName('has-reaction')[0].getElementsByTagName('img')[0].attributes['title'] == 'Ưng') {
              data['_commentByMe'] = '1';
            } else
              data['_commentByMe'] = '2';
          } else
            data['_commentByMe'] = '0';

          element.getElementsByClassName('reactionSummary').forEach((element) {
            element.getElementsByClassName('reaction reaction--small').forEach((element) {
              data['_commentImg'] += element.attributes['data-reaction-id'].toString();
            });
          });
        } else {
          data['_commentImg'] = 'no';
          data['_commentName'] = '';
          data['_commentByMe'] = '0';
        }
        htmlData.add({
          'newPost': false,
          'postContent': data['_postContent'],
          'userPostDate': data['_userPostDate'],
          'postID': data['postID'],
          'userName': data['_userName'],
          'userTitle': data['_userTitle'],
          'userAvatar': data['_userAvatar'],
          'avatarColor1': data['avatarColor1'],
          'avatarColor2': data['avatarColor2'],
          'commentName': data['_commentName'],
          'commentImage': data['_commentImg'],
          'commentByMe': int.parse(data['_commentByMe']),
          'userLink': data['_userLink'],
          'orderPost': '',
        });
        data['_commentImg'] = '';
      });
      imageList.clear();
      if (Get.isDialogOpen == true || data['isScroll'] == 'Release' || isEdit == true) {
        if (Get.isDialogOpen == true) Get.back();
        htmlData.removeRange(0, data['lengthHtmlDataList']);
        listViewScrollController.jumpTo(-10.0);
      }
      if (data['loading'] == 'loading'){
        data['loading'] = 'ok';
        update(['firstLoading']);
      } else update();
    });
  }

  Future reactionPost(int index, String idPost, int idReact) async {
    var status = {};
    setDialog();
    var headers = {
      'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
      'host': 'voz.vn',
      'cookie': '${data['xfCsrfPost']}; xf_user=${GlobalController.i.xfUser};',
    };
    var body = {'_xfWithData': '1', '_xfToken': '${data['dataCsrfPost']}', '_xfResponseType': 'json'};

    await GlobalController.i
        .getHttpPost(true, headers, body,
            '${data['view'] == 0 ? GlobalController.i.viewReactLink : GlobalController.i.inboxReactLink}$idPost/react?reaction_id=$idReact?reaction_id=$idReact')
        .then((jsonValue) {
      if (jsonValue['status'] == 'error') {
        status['status'] = 'error';
        status['mess'] = jsonValue['errors'].first;
      } else {
        final value = parser.parse(jsonValue['reactionList']['content']);
        if (value.documentElement!.getElementsByClassName('reactionsBar-link').length > 0) {
          data['_commentImg'] = '';
          value.getElementsByClassName('reaction reaction--small reaction').forEach((element) {
            data['_commentImg'] += element.attributes['data-reaction-id'].toString();
          });

          htmlData.elementAt(index)['commentName'] =
              value.documentElement!.getElementsByClassName('reactionsBar-link')[0].innerHtml.replaceAll(RegExp(r"<[^>]*>"), '');
          htmlData.elementAt(index)['commentImage'] = data['_commentImg'];
        } else {
          htmlData.elementAt(index)['commentName'] = '';
          htmlData.elementAt(index)['commentImage'] = 'no';
        }
        status['status'] = 'ok';
        status['mess'] = '';
      }
    });
    imageList.clear();

    ///only update anything below HTML view
    update([index]);
    Get.back();
    return status;
  }

  reply(String message, bool isEditPost) async {
    //                                            token               xf_csrf             link
    var x = await Get.toNamed(Routes.AddReply,
        arguments: [data['xfCsrfPost'], data['dataCsrfPost'], data['fullUrl'], data['postID'], isEditPost, data['view'], message]);
    if (x?[0] == 'ok') {
      if (GlobalController.i.userStorage.read('scrollToMyRepAfterPost') ?? true /* == true*/) {
        isEdit = true;
        int lastPage = data['totalPage'];
        await setPageOnClick(lastPage);
        if (data['totalPage'] != lastPage) {
          await setPageOnClick(data['totalPage']);
        }
        isEdit = false;
        listViewScrollController.animateTo(listViewScrollController.position.maxScrollExtent + 200,
            duration: Duration(milliseconds: 200), curve: Curves.slowMiddle);
      }
    }
  }

  editRep(int index) async {
    if (Get.isBottomSheetOpen == true) Get.back();
    setDialog();

    String url =
        '${data['view'] == 0 ? GlobalController.i.viewReactLink : GlobalController.i.inboxReactLink}${htmlData.elementAt(index)['postID']}/edit?_xfToken=${data['dataCsrfPost']}&_xfResponseType=json';
    var headers = {
      'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
      'host': 'voz.vn',
      'cookie': '${data['xfCsrfPost']}; xf_user=${GlobalController.i.xfUser};',
    };

    await GlobalController.i.getHttp(true, headers, url).then((value) async {
      if (Get.isDialogOpen == true) Get.back();
      if (value['status'] == 'ok') {
        data['postID'] = htmlData.elementAt(index)['postID'];
        reply(await fixEdit(value['html']['content']), true);
      } else {
        setDialogError(value['errors'][0]);
      }
    });
  }

  Future<void> quote(int index) async {
    setDialog();
    var headers = {
      'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
      'host': 'voz.vn',
      'cookie': '${data['xfCsrfPost']}; xf_user=${GlobalController.i.xfUser};',
    };
    var body = {'_xfWithData': '1', '_xfToken': '${data['dataCsrfPost']}', '_xfResponseType': 'json'};

    await GlobalController.i
        .getHttpPost(true, headers, body,
            '${data['view'] == 0 ? GlobalController.i.viewReactLink : GlobalController.i.inboxReactLink}${htmlData.elementAt(index)['postID']}/quote')
        .then(
      (value) {
        Get.back();
        if (value['status'] == 'ok') {
          fixQuote(value['quoteHtml']);
        } else {
          setDialogError(value['errors'][0].toString());
        }
      },
    );
  }

  fixLastEditPost(String text) {
    return '''<p style="text-align: right;"><span style="font-family: arial; color: rgb(143, 145, 147); font-size: 12px;">$text</span></p>''';
  }

  fixQuote(String html) async {
    reply(await fixHtmlUrl(html) + '<br>', false);
  }

  fixHtmlUrl(String html) async {
    dom.Document document = parser.parse(html);
    if (document.getElementsByTagName('img').length > 0) {
      for (var element in document.getElementsByTagName('img')) {
        if (element.outerHtml.contains('smilie smilie--emoji')) {
          html = html.replaceAll(element.outerHtml.replaceAll('>', ' />'), element.attributes['alt'].toString());
        } else if (element.attributes['class'] == 'smilie') {
          var img = await GlobalController.i.getImageFileFromAssets(element.attributes['src']!.split('smilies/')[1].split('?')[0]);
          html = html.replaceAll(element.outerHtml.replaceAll('>', ' />'), '<img src="${img.path}" class="smilie">');
        }
      }
    }

    return html
        .replaceAll('src="/attachments', 'src="https://voz.vn/attachments')
        .replaceAll('src="/data/attachments', 'src="https://voz.vn/data/attachments')
        .replaceAll('\'', '&#039;')
        .replaceAll('amp;', '');
  }

  fixEdit(String html) {
    late List code = [];
    html = '<textarea name=' + html.split('<textarea name=')[1].split('</textarea>')[0] + '</textarea>';
    dom.Document document = parser.parse(html);
    html = document.getElementsByTagName('textarea')[0].innerHtml;

    if (html.contains('[/CODE]') == true) {
      int lengthCode = (html.split('[/CODE]').length);
      while (lengthCode != 1) {
        lengthCode -= 1;
        String first = '[CODE' + html.split('[CODE')[1].split('[/CODE]')[0] + '[/CODE]';
        html = html.replaceAll(first, '[comCodeLength$lengthCode]');
        code.insert(0, first);
      }
    }

    html = html
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&amp;nbsp;', " ")
        .replaceAll('&amp;quot;', "\"")
        .replaceAll('&amp;lt;', '<')
        .replaceAll('&amp;gt;', '>')
        .replaceAll('&amp;quot;', "\"")
        .replaceAll('&quot;', "\"");

    if (html.contains('[comCodeLength') == true) {
      while (code.length != 0) {
        html = html.replaceAll(
            '[comCodeLength${code.length}]', code.elementAt(code.length - 1).toString().replaceAll('&lt;', '<').replaceAll('&gt;', '>'));
        code.removeLast();
      }
    }

    return fixHtmlUrl(html);
  }

  deletePost(String response, int index) async {
    if (response.length == 0) {
      setDialogError('Reason cannot be NULL');
      return;
    }
    setDialog();
    var headers = {
      'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
      'host': 'voz.vn',
      'cookie': '${data['xfCsrfPost']}; xf_user=${GlobalController.i.xfUser};',
    };
    var body = {'_xfToken': '${data['dataCsrfPost']}', '_xfResponseType': 'json', 'reason': response};

    await GlobalController.i
        .getHttpPost(true, headers, body, GlobalController.i.viewReactLink + htmlData.elementAt(index)['postID'] + '/delete')
        .then((value) async {
      if (value['status'] == 'ok') {
        if (Get.isDialogOpen == true) Get.back();
        if (Get.isDialogOpen == true) Get.back();
        setDialog();
        await setPageOnClick(data['currentPage']);
        input.clear();
      } else {
        if (Get.isDialogOpen == true) Get.back();
        setDialogError(value['errors'][0].toString());
      }
    });
  }
}
