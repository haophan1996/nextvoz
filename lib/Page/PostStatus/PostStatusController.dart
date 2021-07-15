import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rich_editor/rich_editor.dart';
import '../../GlobalController.dart';
import '../reuseWidget.dart';

class PostStatusController extends GetxController {
  GlobalKey<RichEditorState> keyEditor = GlobalKey();
  int currentTab = 0;
  RxDouble heightKeyboard = 0.1.obs;
  Map<String, dynamic> data = {};
  final FocusNode nodeText6 = FocusNode();
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
    heightKeyboard.value = 0.1;
    heightKeyboard.close();
  }

  getKeyboardHeight(BuildContext context){

   if (heightKeyboard.value == 0.1){
     if (MediaQuery.of(context).viewInsets.bottom == 0){
       heightKeyboard.value = 200;
     } else heightKeyboard.value = MediaQuery.of(context).viewInsets.bottom;
   }
  }

  Future<void> post(BuildContext context) async {
    setDialog(context, 'popMess'.tr, 'popMess2'.tr);
    String? html = await keyEditor.currentState?.getHtml();

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
}
