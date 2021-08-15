import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:nextvoz/GlobalController.dart';
import 'package:nextvoz/Page/View/ViewController.dart';
import 'package:nextvoz/Page/reuseWidget.dart';
import 'package:nextvoz/Routes/routes.dart';
import 'SearchResultController.dart';

class SearchResultUI extends GetView<SearchResultController> {
  @override
  final String tag = GlobalController.i.sessionTag.last;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: appBarOnly('search'.tr + ' ' + controller.data['SearchType'], []),
      body: Column(
        children: [
          // Text('Search results', style: TextStyle(color: Colors.white, fontSize: 110),),
          Expanded(child: GetBuilder<SearchResultController>(
            id: 'updateSearchResult',
            tag: tag,
            builder: (controller) {
              return controller.data['loading'] == 'ok'
                  ? ListView.builder(
                itemCount: controller.htmlData.length,
                itemBuilder: (context, index) {
                  return customCupertinoButton(Alignment.center, EdgeInsets.zero, itemView(index), (){
                    if (controller.htmlData.elementAt(index)['link'].toString().contains('/t/',0)){

                      GlobalController.i.sessionTag.add(controller.htmlData.elementAt(index)['title']);
                      Get.lazyPut<ViewController>(() => ViewController(), tag: GlobalController.i.sessionTag.last);
                      Get.toNamed(Routes.View,
                          arguments: [controller.htmlData.elementAt(index)['title'], controller.htmlData.elementAt(index)['link'], '', 0]);


                    } else {
                      setDialogError('Not supported yet');
                    }

                  });
                },
              )
                  : controller.data['loading'] == 'no' ? Center(child: Text(controller.data['content'])) : Center(child: CupertinoActivityIndicator()
              );
            },
          ))
        ],
      ),
    );
  }
  
  Widget itemView(int index){
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 5),
            child: displayAvatar(
                40,
                controller.htmlData.elementAt(index)['avatarColor1'],
                controller.htmlData.elementAt(index)['avatarColor2'],
                controller.htmlData.elementAt(index)['author'],
                controller.htmlData.elementAt(index)['_userAvatar']),
          ),
          Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.htmlData.elementAt(index)['title'],
                    style: TextStyle(color: Colors.blue),
                  ),
                  Html(
                    data: controller.htmlData.elementAt(index)['content'],
                    style: {'body': Style(color: Colors.grey, margin: EdgeInsets.only(top: 5, bottom: 2))},
                  ),
                  Padding(
                    padding: EdgeInsets.only(),
                    child: Text(controller.htmlData.elementAt(index)['author'], style: TextStyle(color: Colors.deepOrange)),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
