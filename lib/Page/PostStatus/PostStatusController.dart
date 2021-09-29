import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rich_editor/rich_editor.dart';
import 'package:image_picker/image_picker.dart';
import '/utils/emoji.dart';
import '/GlobalController.dart';
import '/Page/reuseWidget.dart';

class PostStatusController extends GetxController {
  static PostStatusController get i => Get.find();
  GlobalKey<RichEditorState> keyEditor = GlobalKey();
  int currentTab = 0;
  Map<String, dynamic> data = {};
  List finderMember = [], prefixList = [];
  RxBool isToolClicked = false.obs;
  double heightToolbar = Get.height * 0.07, heightEditor = Get.height * 0.3;
  TextEditingController link = TextEditingController(), label = TextEditingController();
  final picker = ImagePicker();
  late File image;
  List formats = [
    {'id': '1', 'title': '<h1>Heading 1</h1>'},
    {'id': '2', 'title': '<h2>Heading 2</h2>'},
    {'id': '3', 'title': '<h3>Heading 3</h3>'},
    {'id': '4', 'title': '<h4>Heading 4</h4>'},
    {'id': '5', 'title': '<h5>Heading 5</h5>'},
    {'id': '6', 'title': '<h6>Heading 6</h6>'},
    {'id': 'p', 'title': '<p>Text body</p>'},
    {'id': 'pre', 'title': '<pre><font face=\"courier\">Preformat</font></pre>'},
    {'id': 'blockquote', 'title': '<blockquote>Quote</blockquote>'},
  ];

  List formatsSize = [
    {'id': '1', 'title': 'Tiny', 'size': '9'},
    {'id': '2', 'title': 'Very Small', 'size': '10'},
    {'id': '3', 'title': 'Small', 'size': '12'},
    {'id': '4', 'title': 'Medium', 'size': '15'},
    {'id': '5', 'title': 'Large', 'size': '18'},
    {'id': '6', 'title': 'Very large', 'size': '22'},
    {'id': '7', 'title': 'Huge', 'size': '26'},
  ];

  List<Color> textColor = [
    Color(0xff61BD6D),
    Color(0xff1ABC9C),
    Color(0xff54ACD2),
    Color(0xff2C82C9),
    Color(0xff9365B8),
    Color(0xff475577),
    Color(0xffCCCCCC),
    Color(0xff41A85F),
    Color(0xff00A885),
    Color(0xff3D8EB9),
    Color(0xff2969B0),
    Color(0xff553982),
    Color(0xff28324E),
    Color(0xff000000),
    Color(0xffF7DA64),
    Color(0xffFBA026),
    Color(0xffEB6B56),
    Color(0xffE25041),
    Color(0xffA38F84),
    Color(0xffEFEFEF),
    Color(0xffFAC51C),
    Color(0xffF37934),
    Color(0xffD14841),
    Color(0xffB8312F),
    Color(0xff7C706B),
    Color(0xffD1D5D8),
    Colors.black
  ];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    data['xf_csrf'] = Get.arguments[0] ??= '';
    data['token'] = Get.arguments[1] ??= '';
    data['link'] = Get.arguments[2] ??= '';
    data['postID'] = Get.arguments[3] ??= '';
    data['isEditPost'] = Get.arguments[4] ??= '';

    /// View id
    ///  0 : add relies x
    ///  1 : edit post x
    ///  2 : new Conversation \/
    ///  3 : create thread \/
    ///  4 : create post profile \/

    data['view'] = Get.arguments[5] ??= '';
    data['value'] = Get.arguments[6] ??= '';

    if (data['value'].toString().length > 0){
      data['value'] = data['value'].toString().replaceAll('<p></p>', '<br>');
    }

    ///Optional
    if (data['view'] == '2')
      data['recipients'] = Get.arguments[7] ?? '';
    else if (data['view'] == '3') {
      prefixList = Get.arguments[8];
      if (prefixList.length > 0) data['prefixIndex'] = 0;
    }
    data['title'] = '';
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  onClose() {
    super.onClose();
    isToolClicked.close();
    data.clear();
    finderMember.clear();
    link.dispose();
    label.dispose();
    formats.clear();
    textColor.clear();
  }

  post() async {
    String? html = await checkImage();
    var headers = {
      'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
      'host': 'voz.vn',
      'cookie': '${data['xf_csrf']}; ${GlobalController.i.userLoginCookie}',
    };

    if (GlobalController.i.userStorage.read('signature') ?? true){
      html = (html! + await applySignatureToPost());
    }

    var body = {'_xfWithData': '1', '_xfToken': '${data['token']}', '_xfResponseType': 'json', 'message_html': '$html'};

    await GlobalController.i.getHttpPost(true, headers, body, "${data['link']}add-reply").then((value) {
      if (Get.isDialogOpen == true) Get.back();
      if (value['status'] == 'ok') {
        Get.back(result: ['ok']);
      } else {
        setDialogError(value['errors'].toString());
      }
    });
  }

  applySignatureToPost() async {
    if (GlobalController.i.userStorage.read('appSignatureDevice') == null){
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (GetPlatform.isAndroid){
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        GlobalController.i.userStorage.write('appSignatureDevice', androidInfo.device);
      } else {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        GlobalController.i.userStorage.write('appSignatureDevice', iosInfo.name);
      }
    }


    return
        '''<p><br><span style="font-size: 12px;"><em>Sent from ${GlobalController.i.userStorage.read('appSignatureDevice')} by&nbsp;</em></span><a href="https://play.google.com/store/apps/details?id=com.vozer.nextvoz" target="_blank" rel="noopener noreferrer"><span style="font-size: 12px;"><em>NEXTvoz for android</em></span></a></p>''';
  }

  editPost() async {
    String? html = await checkImage();
    var body = {'_xfWithData': '1', '_xfToken': '${data['token']}', '_xfResponseType': 'json', 'message_html': '$html'};
    var headers = {
      'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
      'host': 'voz.vn',
      'cookie': '${data['xf_csrf']}; ${GlobalController.i.userLoginCookie}',
    };
    await GlobalController.i
        .getHttpPost(
            true, headers, body, '${data['view'] == 1 ? GlobalController.i.inboxReactLink : GlobalController.i.viewReactLink}${data['postID']}/edit')
        .then((value) {
      if (Get.isDialogOpen == true) Get.back();
      if (value['status'] == 'ok') {
        Get.back(result: ['ok']);
      } else {
        setDialogError(value.toString());
      }
    });
  }

  startConversation() async {
    if (data['title'].length == 0) {
      await inputTitNRe('title', '${'please'.tr} ${'input'.tr} ${'title'.tr}');

      if (data['title'].length == 0) return;
    }
    if (data['recipients'].length == 0) {
      await inputTitNRe('recipients', '${'please'.tr} ${'input'.tr} ${'recipients'.tr}');
      if (data['recipients'].length == 0) return;
    }

    String? html = await checkImage();
    if (GlobalController.i.userStorage.read('signature') ?? true){
      html = (html! + await applySignatureToPost());
    }

    var body = {
      '_xfWithData': '1',
      '_xfToken': '${data['token']}',
      '_xfResponseType': 'json',
      'message_html': '$html',
      'recipients': data['recipients'],
      'title': data['title'],
    };

    var headers = {
      'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
      'host': 'voz.vn',
      'cookie': '${data['xf_csrf']}; ${GlobalController.i.userLoginCookie}',
    };

    await GlobalController.i.getHttpPost(true, headers, body, GlobalController.i.url + '/conversations/add').then((value) {
      if (Get.isDialogOpen == true) Get.back();
      if (value['status'] == 'ok') {
        Get.back(result: ['ok', value['redirect'], data['title']]);
      } else {
        setDialogError(value
            .toString()
            .split('<div class="blockMessage">')[1]
            .split('</div>,')[0]
            .replaceAll('<ul>', '')
            .replaceAll('</ul>', '')
            .replaceAll('<li>', '')
            .replaceAll('</li>', '')
            .trim());
      }
    });
  }

  createThread() async {
    if (data['title'].length == 0) {
      await inputTitNRe('title', '${'please'.tr} ${'input'.tr} ${'title'.tr}');
      if (data['title'].length == 0) return;
    }

    if (data['prefixIndex'] == 0) {
      await prefixSelect();
      if (data['recipients'] == 0) return;
    }

    String? html = await checkImage();

    if (GlobalController.i.userStorage.read('signature') ?? true){
      html = (html! + await applySignatureToPost());
    }

    var headers = {
      'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
      'host': 'voz.vn',
      'cookie': '${data['xf_csrf']}; ${GlobalController.i.userLoginCookie}',
    };

    var body = {
      '_xfToken': '${data['token']}',
      '_xfResponseType': 'json',
      'title': data['title'],
      'message_html': html,
      'watch_thread': '1',
      'discussion_type': 'discussion',
      'prefix_id': prefixList.length > 0 ? prefixList.elementAt(data['prefixIndex'])['value'] : '',
    };

    await GlobalController.i.getHttpPost(true, headers, body, data['link'] + 'post-thread?inline-mode=1').then((value) {
      if (Get.isDialogOpen == true) Get.back();
      if (value['status'] == 'ok') {
        print(value);
        //Get.back(result: ['ok',value['redirect'], data['title']]);
      } else {
        setDialogError(value
            .toString()
            .split('<div class="blockMessage">')[1]
            .split('</div>,')[0]
            .replaceAll('<ul>', '')
            .replaceAll('</ul>', '')
            .replaceAll('<li>', '')
            .replaceAll('</li>', '')
            .trim());
      }
    });
  }

  membersSearcher(String mem) async {
    var headers = {
      'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
      'host': 'voz.vn',
      'cookie': '${data['xf_csrf']};',
    };

    data['memberFinder'] = '_xfResponseType=json&_xfToken=${data['token']}&q=$mem';

    await GlobalController.i.getHttp(true, headers, GlobalController.i.url + '/u/find?' + data['memberFinder']).then((value) {
      if (value['results'].length > 0) {
        finderMember = value['results'] as List;
        update(['updateMember']);
      }
      print(value);
    });
  }

  /// Features toolbar editor html

  bold() => keyEditor.currentState!.javascriptExecutor.setBold();

  italic() => keyEditor.currentState!.javascriptExecutor.setItalic();

  underline() => keyEditor.currentState!.javascriptExecutor.setUnderline();

  strikeThrough() => keyEditor.currentState!.javascriptExecutor.setStrikeThrough();

  clearFormat() => keyEditor.currentState!.javascriptExecutor.removeFormat();

  undo() => keyEditor.currentState!.javascriptExecutor.undo();

  redo() => keyEditor.currentState!.javascriptExecutor.redo();

  blockquote() => keyEditor.currentState!.javascriptExecutor.setBlockQuote();

  indentDes() => keyEditor.currentState!.javascriptExecutor.setOutdent();

  alignLeft() => keyEditor.currentState!.javascriptExecutor.setJustifyLeft();

  alignRight() => keyEditor.currentState!.javascriptExecutor.setJustifyRight();

  alignCenter() => keyEditor.currentState!.javascriptExecutor.setJustifyCenter();

  alignFull() => keyEditor.currentState!.javascriptExecutor.setJustifyFull();

  bulletList() => keyEditor.currentState!.javascriptExecutor.insertBulletList();

  numList() => keyEditor.currentState!.javascriptExecutor.insertNumberedList();

  checkBox(String nameCheck) => keyEditor.currentState!.javascriptExecutor.insertCheckbox(nameCheck);

  inputTitNRe(String value, String title) async {
    label.text = data[value] ?? '';
    await Get.defaultDialog(
        radius: 6,
        content: Container(
          width: Get.width,
          child: value != 'recipients'
              ? inputCustom(TextInputType.text, label, false, value.tr, () {
                  Get.back();
                })
              : Column(
                  children: [
                    inputCustom(TextInputType.text, label, false, value.tr, () {
                      Get.back();
                    }),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Container(
                        decoration: BoxDecoration(color: Color(0xfff5c7099), borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: customCupertinoButton(
                            Alignment.center,
                            EdgeInsets.fromLTRB(5, 2, 5, 2),
                            Text(
                              'Find',
                              style: TextStyle(color: Colors.white),
                            ), () async {
                          membersSearcher(label.text.split(',').last);
                          print(label.text.split(',').last);
                          //update(['updateMember']);
                        }),
                      ),
                    ),
                    GetBuilder<PostStatusController>(
                        id: 'updateMember',
                        builder: (controller) {
                          return finderMember.length > 0
                              ? Container(
                                  height: 150,
                                  width: Get.width,
                                  child: ListView.builder(
                                      itemCount: finderMember.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return TextButton(
                                            onPressed: () {
                                              data['m'] = finderMember.elementAt(index)['id'];
                                              finderMember.clear();
                                              finderMember = label.text.split(',');
                                              finderMember.removeLast();
                                              finderMember.add(data['m']);
                                              label.text = finderMember.toString().replaceAll('[', '').replaceAll(']', '');
                                              label.selection = TextSelection(baseOffset: label.text.length, extentOffset: label.text.length);
                                              finderMember.clear();
                                              update(['updateMember']);
                                            },
                                            child: Text(finderMember.elementAt(index)['id']));
                                      }),
                                )
                              : Text('No results');
                        })
                  ],
                ),
        ),
        title: title);
    if (label.text.length > 0) {
      data[value] = label.text;
      update([value]);
    }
    label.clear();
  }

  prefixSelect() async {
    await Get.defaultDialog(
      radius: 6,
      title: 'Select prefix',
      content: Container(
        height: (prefixList.length * 20) > Get.height.toInt() ? (Get.height * 0.5) : (prefixList.length * 20),
        width: Get.width,
        child: ListView.builder(
            itemCount: prefixList.length,
            itemBuilder: (context, index) {
              return InkWell(
                child: Text(
                  prefixList.elementAt(index)['text'],
                  style: TextStyle(color: data['prefixIndex'] == index ? Colors.blue : Get.theme.primaryColor),
                ),
                onTap: () {
                  data['prefixIndex'] = index;
                  update(['prefix']);
                  Get.back();
                },
              );
            }),
      ),
    );
  }

  insertLink() {
    keyEditor.currentState!.javascriptExecutor.insertLink(link.text, label.text == '' ? link.text : label.text);
    link.clear();
    label.clear();
    if (Get.isDialogOpen == true) Get.back();
  }

  editLink(List<dynamic> args) async {
    args[0] = link.text;
    args[1] = label.text;
    if (Get.isDialogOpen == true) Get.back();
  }

  insertEmojiVozOnly(String url) async {
    var img = await GlobalController.i.getImageFileFromAssets(url);
    keyEditor.currentState!.javascriptExecutor.insertCustomEmojiVoz(img.path);
  }

  toolbarActive() async {
    if (isToolClicked.value == true) {
      keyEditor.currentState!.focus();
      //await SystemChannels.textInput.invokeMethod('TextInput.show');
      isToolClicked.value = false;
    } else {
      //keyEditor.currentState!.unFocus();
      await SystemChannels.textInput.invokeMethod('TextInput.hide');
      isToolClicked.value = true;
    }
  }

  keyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    isToolClicked.value = false;
  }

  getIDYt() async {
    if (link.text.length < 4) return;
    await keyEditor.currentState!.javascriptExecutor.insertHtml('[MEDIA=youtube]${GlobalController.i.getIDYoutube(link.text)}[/MEDIA] ');
    link.clear();
    Get.back();
  }

  uploadImage(String src) async {
    String type = src.split('/').last.split('.').last;
    var headers = {
      'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
      'host': '2.pik.vn',
    };

    var body = {
      'image': 'data:image/$type;base64,' + base64Encode(File(src).readAsBytesSync()),
    };

    var response = await GlobalController.i.getHttpPost(true, headers, body, 'https://2.pik.vn/');

    return 'https://3.pik.vn/' + response['saved'];
  }

  Future<String?> checkImage() async {
    String? html = await getHtml();
    final dom.Document document = parser.parse(html);
    if (document.getElementsByTagName('img').length > 0) {
      setDialog();
    }

    for (var element in document.getElementsByTagName('img')) {
      if (element.attributes['src']!.contains('https://', 0) == false) {
        if (element.attributes['class']!.contains('smilie')) {
          html = html!.replaceAll(element.outerHtml, mapEmojiVoz[element.attributes['src']!.split('/').last.replaceAll('-', '/')].toString());
        } else if (element.attributes['class']!.contains('bbImage') /*element.attributes['src']!.contains('com.example.vozforums') || */) {
          print('hey im not');
          html = html!.replaceAll(element.attributes['src'].toString(), await uploadImage(element.attributes['src'].toString()));
        }
      }
    }

    if (Get.isDialogOpen == true) Get.back();
    setDialog();
    return Future.value(html);
  }

  Future<String?> getHtml() async {
    return await keyEditor.currentState!.getHtml();
  }
}
