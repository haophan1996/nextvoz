import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:theNEXTvoz/GlobalController.dart';

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
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    GlobalController.i.sessionTag.removeLast();
  }

  performLoading() async {
    //GlobalController.i.url + '/whats-new/profile-posts/'
    GlobalController.i.getBodyBeta((value) {}, (download) {}, dios, 'https://voz.vn/whats-new/profile-posts/3569763/', false).then((value) async {
      print('done');
      //await performQuery(value);
      res = value!;
    });
  }

  performQuery() async {
    htmlData.clear();
    reactionList.clear();
    res.getElementsByClassName('message message--simple  js-inlineModContainer').forEach((element) {
      /// username
      if (element.getElementsByClassName('attribution')[0].getElementsByTagName('a').length == 1) {
        /// username
        //print(element.getElementsByClassName('attribution')[0].text.trim());
      } else {
        ///Username => username2
        //print(element.getElementsByClassName('attribution')[0].getElementsByTagName('a')[0].text);
        //print(element.getElementsByClassName('attribution')[0].getElementsByTagName('a')[1].text);
      }

      ///time
      //print(element.getElementsByClassName('u-dt')[0].text);

      ///content
      //print(element.getElementsByClassName('lbContainer js-lbContainer')[0].innerHtml);

      ///Usernames reactions
      if (element.getElementsByClassName('reactionsBar-link').length == 0) {
        ///no one reaction on this post
      } else {
        //print(element.getElementsByClassName('reactionsBar-link')[0].text);
      }

      ///Usernames reactions Icon
      if (element.getElementsByClassName('reactionSummary').length == 0) {
        ///no one reaction on this post
      } else {
        data['reactionIcon'] =
            element.getElementsByClassName('reactionSummary')[0].getElementsByClassName('reaction reaction--small')[0].attributes['data-reaction-id'];
        if (element.getElementsByClassName('reactionSummary')[0].getElementsByTagName('li').length == 2) {
          data['reactionIcon'] += element
              .getElementsByClassName('reactionSummary')[0]
              .getElementsByClassName('reaction reaction--small')[1]
              .attributes['data-reaction-id'];
        }
        //print(data['reactionIcon']);
      }

      ///View comment previous
      if (element.getElementsByClassName('message-responseRow u-jsOnly js-commentLoader').length == 0) {
        ///no one comment
      } else {
        print(element.getElementsByClassName('message-responseRow u-jsOnly js-commentLoader')[0].getElementsByTagName('a')[0].attributes['href']);
      }

      reactionList.add({'value': 'acsacascas'});
      reactionList.add({'value': 'acsacascas'});
      reactionList.add({'value': 'acsacascas'});


      htmlData.add({
        'username' : 'haophan',
        'comment' : reactionList
      });


    });
    print(htmlData);
  }


  String html = '''<article class="message-body">
								<div class="bbWrapper">Hùng ơi, qua dịch ae bố trí làm tý bia nhé 
	

	
	
		
		



		
		
	


	<div class="bbImageWrapper  js-lbImage lazyloaded" title="ex3a9EM.png" data-src="https://camo.voz.tech/6ca0fbe0df9f3730444068691247a39def6b310e/68747470733a2f2f692e696d6775722e636f6d2f6578336139454d2e706e67/" data-lb-sidebar-href="" data-lb-caption-extra-html="" data-single-image="1" data-fancybox="lb-profile-post-45548" data-caption="<h4>ex3a9EM.png</h4><p><a href=&quot;https:&amp;#x2F;&amp;#x2F;voz.vn&amp;#x2F;whats-new&amp;#x2F;profile-posts&amp;#x2F;3569743&amp;#x2F;page-2#profile-post-45548&quot; class=&quot;js-lightboxCloser&quot;>Motnoibuon · Aug 16, 2021 at 2:02 PM</a></p>" style="cursor: pointer;">
		
<img src="https://camo.voz.tech/6ca0fbe0df9f3730444068691247a39def6b310e/68747470733a2f2f692e696d6775722e636f6d2f6578336139454d2e706e67/" data-src="https://camo.voz.tech/6ca0fbe0df9f3730444068691247a39def6b310e/68747470733a2f2f692e696d6775722e636f6d2f6578336139454d2e706e67/" data-url="https://i.imgur.com/ex3a9EM.png" class="bbImage lazyloaded" data-zoom-target="1" style="" alt="ex3a9EM.png" title="" width="" height="" loading="lazy">

<noscript><img src="https://camo.voz.tech/6ca0fbe0df9f3730444068691247a39def6b310e/68747470733a2f2f692e696d6775722e636f6d2f6578336139454d2e706e67/"
			data-url="https://i.imgur.com/ex3a9EM.png"
			class="bbImage"
			data-zoom-target="1"
			style=""
			alt="ex3a9EM.png"
			title=""
			width="" height=""  /></noscript>


	</div></div>
							</article>''';
}
