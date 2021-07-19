import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rich_editor/rich_editor.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../GlobalController.dart';
import '../reuseWidget.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:image_picker/image_picker.dart';

class PostStatusController extends GetxController{
  static PostStatusController get i => Get.find();
  GlobalKey<RichEditorState> keyEditor = GlobalKey();
  int currentTab = 0;
  int typeWidget = 3; // 0 emoji, 1 fontFormat
  Map<String, dynamic> data = {};
  late String temp;
  RxBool isToolClicked = false.obs;
  late List toolData;
  PanelController slidingUpController = PanelController();
  double heightToolbar = Get.height * 0.07;
  double heightEditor = Get.height*0.3;
  TextEditingController link = TextEditingController();
  TextEditingController label = TextEditingController();
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
    {
      'id': 'pre',
      'title': '<pre><font face=\"courier\">Preformat</font></pre>'
    },
    {'id': 'blockquote', 'title': '<blockquote>Quote</blockquote>'},
  ];

  List formatsSize = [
    {'id': '1', 'title': 'Tiny', 'size' : '9'},
    {'id': '2', 'title': 'Very Small', 'size' : '10'},
    {'id': '3', 'title': 'Small', 'size' : '12'},
    {'id': '4', 'title': 'Medium', 'size' : '15'},
    {'id': '5', 'title': 'Large', 'size' : '18'},
    {'id': '6', 'title': 'Very large', 'size' : '22'},
    {'id': '7', 'title': 'Huge', 'size' : '26'},
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
    data['xf_csrf'] = Get.arguments[0];
    data['token'] = Get.arguments[1];
    data['link'] = Get.arguments[2];
    data['value'] = Get.arguments[3] ??= '';
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  onClose() {
    super.onClose();
    print('onClose');
    isToolClicked.close();
  }


  post(BuildContext context) async {
     String? html = await checkImage(context);

    var headers = {
      'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
      'host': 'voz.vn',
      'cookie': '${data['xf_csrf']}; xf_user=${GlobalController.i.xfUser};',
    };

    var body = {'_xfWithData': '1', '_xfToken': '${data['token']}', '_xfResponseType': 'json', 'message_html': '$html'};

    await GlobalController.i.getHttpPost(headers, body, "${data['link']}add-reply").then((value) {
      Get.back();
      if (value['status'] == 'ok') {
        Get.back(result: ['hey']);
      } else {
        setDialogError(context, value['errors'][0].toString());
      }
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

  emoji() async{
    typeWidget = 0;
    slidingUpController.open();
    update();
  }

  fontFormat() async {
    typeWidget = 1;
    slidingUpController.open();
    update();
  }

  toolbarActive() async{
    if (isToolClicked.value == true){
      keyEditor.currentState!.focus();
      //await SystemChannels.textInput.invokeMethod('TextInput.show');
      isToolClicked.value = false;
    } else {
      //keyEditor.currentState!.unFocus();
      await SystemChannels.textInput.invokeMethod('TextInput.hide');
      isToolClicked.value = true;
    }
  }

  keyboard(){
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    isToolClicked.value = false;
  }

  getIDYt(String text){
    return text.split("?v=")[1];
  }

  uploadImage(String src) async{
    String type = src.split('/').last.split('.').last;
    var headers = {
      'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
      'host': '2.pik.vn',
    };

    var body = {
      'image' : 'data:image/$type;base64,' + base64Encode(File(src).readAsBytesSync()),
    };

    final response = await GlobalController.i.getHttpPost(headers, body, 'https://2.pik.vn/');
    return 'https://3.pik.vn/' +  response['saved'];
  }

  Future<String?> checkImage(BuildContext context) async {
    String? html = await getHtml();
    String temp = html!;
    final dom.Document document = parser.parse(html);
    if (document.getElementsByTagName('img').length > 0){
      setDialog(context,'Uploading Image', 'Hang tight');
    } else setDialog(context, 'popMess'.tr, 'popMess2'.tr);

    for(var element in document.getElementsByTagName('img'))  {
      if (element.attributes['src']!.contains('com.example.vozforums')){
        temp = temp.replaceAll(element.attributes['src'].toString(),  await uploadImage(element.attributes['src'].toString()));
      }
    }

    if (document.getElementsByTagName('img').length > 0){
      Get.back();
      setDialog(context, 'popMess'.tr, 'popMess2'.tr);
    }
    return Future.value(temp);
  }

  Future<String?> getHtml() async{
   return await keyEditor.currentState!.getHtml();
  }

}
