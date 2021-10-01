import 'package:dio_http/dio_http.dart';
import 'package:get/get.dart';
import '/GlobalController.dart';
import 'package:html/dom.dart' as dom;

class ProfilePostController extends GetxController {
  var dios = Dio();
  List htmlData = [], reactionList = [], imageList = [];
  Map<String, dynamic> data = {};
  late dom.Document res;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    data['loading'] = 'firstLoad';
  }

  @override
  Future<void> onReady() async {
    // TODO: implement onReady
    super.onReady();

    await performLoading();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    htmlData.clear();
    data.clear();
    imageList.clear();
    dios.close(force: true);
    GlobalController.i.sessionTag.removeLast();
    this.dispose();
  }

  performLoading() async {
    GlobalController.i.getBodyBeta((value) {}, (download) {}, dios, GlobalController.i.url + '/whats-new/profile-posts/', false).then((value) async {
      await performQuery(value!);
      //res = value!;
    });
  }

  performQuery(dom.Document value) async {
    value.getElementsByClassName('message message--simple  js-inlineModContainer').forEach((element) {
      ///Username
      if (element.getElementsByClassName('attribution')[0].getElementsByTagName('a').length == 1) {
        data['username'] = element.getElementsByClassName('attribution')[0].text.trim();
        data['username2'] = '';
      } else {
        data['username'] = element.getElementsByClassName('attribution')[0].getElementsByTagName('a')[0].text;
        data['username2'] = element.getElementsByClassName('attribution')[0].getElementsByTagName('a')[1].text;
      }

      ///Time
      data['time'] = element.getElementsByClassName('u-dt')[0].text;

      ///Content
      data['content'] = element.getElementsByClassName('lbContainer js-lbContainer')[0].innerHtml;

      ///Usernames Reactions and Reactions Icon
      if (element.getElementsByClassName('reactionsBar-link').length == 0) {
        ///no one reaction on this post
        data['reaction'] = '';
        data['reactionsIcon'] = '';
      } else {
        data['reaction'] = element.getElementsByClassName('reactionsBar-link')[0].text;
        data['reactionsIcon'] =
            element.getElementsByClassName('reactionSummary')[0].getElementsByClassName('reaction reaction--small')[0].attributes['data-reaction-id'];
        if (element.getElementsByClassName('reactionSummary')[0].getElementsByTagName('li').length == 2) {
          data['reactionsIcon'] += element
              .getElementsByClassName('reactionSummary')[0]
              .getElementsByClassName('reaction reaction--small')[1]
              .attributes['data-reaction-id'];
        }
      }

      ///View comment previous
      if (element.getElementsByClassName('message-responseRow u-jsOnly js-commentLoader').length == 0) {
        ///no one comment
      } else {
        print(element.getElementsByClassName('message-responseRow u-jsOnly js-commentLoader')[0].getElementsByTagName('a')[0].attributes['href']);
      }

      ///Profile post ID
      data['profilePostID'] = element.getElementsByClassName('lbContainer js-lbContainer')[0].attributes['data-lb-id']!.split('profile-post-')[1];

      htmlData.add({
        'profilePostID': data['profilePostID'],
        'username': data['username'],
        'username2': data['username2'],
        'time': data['time'],
        'content': data['content'],
        'reaction': data['reaction'],
        'reactionsIcon': data['reactionsIcon'],
      });

      if (data['loading'] == 'firstLoad') {
        data['loading'] = 'ok';
        update(['firstLoading']);
      } else {
        update(['listview']);
      }
    });
  }

  performReactionList(String idPost) async {
    reactionList.clear();
    await GlobalController.i
        .getBodyBeta((value) {}, (download) {}, dios, GlobalController.i.url + '/profile-posts/$idPost/reactions', false)
        .then((value) async {
      reactionList = await GlobalController.i.performQueryReaction(value!, reactionList);
      if (Get.isBottomSheetOpen == true) update(['reactionList']);
    });
  }


}
