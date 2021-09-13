import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '/GlobalController.dart';
import 'UserFollIgrType.dart';

class UserFollIgrController extends GetxController {
  Map<String, dynamic> data = {};
  var dio = Dio();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    data['title'] = Get.arguments[0];
  }

  @override
  Future<void> onReady() async {
    // TODO: implement onReady
    super.onReady();
    await action();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    GlobalController.i.sessionTag.removeLast();
  }

  action() async {
    switch (data['title']) {
      case UserFollIgrType.Follow:
        await performActionFollowing();
        break;
      case UserFollIgrType.Ignore:
        print('ignore');
        break;
    }
  }

  performActionFollowing() async {
    await GlobalController.i.getBodyBeta((value) {
      ///Error
    }, (dowload) {
      ///Download
    }, dio, GlobalController.i.url + '/account/following', false).then((value) {

      print(value!.outerHtml);
    });
  }
}
