import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_next_voz/Page/reuseWidget.dart';
import '../../../GlobalController.dart';
import 'UserFollIgrController.dart';

class UserFollIgrUI extends GetView<UserFollIgrController> {
  final tagI = GlobalController.i.sessionTag.last;

  @override
  // TODO: implement tag
  String? get tag => tagI;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarOnly(controller.data['title'], []),
      body: Center(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: download(),
            ),
            Align(
              alignment: Alignment.center,
              child: GetBuilder<UserFollIgrController>(
                id: 'first',
                tag: tagI,
                builder: (controller) {
                  return controller.htmlData.length != 0 ? listFollow() : Text(controller.data['text']);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget listFollow() => GetBuilder<UserFollIgrController>(
      id: 'listFollow',
      tag: tagI,
      builder: (controller) {
        return ListView.builder(
            itemCount: controller.htmlData.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: displayAvatar(40, controller.htmlData.elementAt(index)['avatarColor1'], controller.htmlData.elementAt(index)['avatarColor2'],
                            controller.htmlData.elementAt(index)['username'], controller.htmlData.elementAt(index)['_userAvatar']),
                      ),
                      InkWell(
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(text: controller.htmlData.elementAt(index)['username'] + '\n', style: TextStyle(color: Color(0xFFFff6701))),
                            TextSpan(text: controller.htmlData.elementAt(index)['userTitle'], style: TextStyle(color: Theme.of(context).primaryColor)),
                          ]),
                        ),
                        onTap: () {
                          print('ascsac');
                        },
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: InkWell(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: GetBuilder<UserFollIgrController>(
                              tag: tagI,
                              id: '$index',
                              builder: (controller){
                                return Text(controller.htmlData.elementAt(index)['follow'] == true ? 'Unfollow' : 'Follow', style: TextStyle(color: Colors.blueAccent.shade200),);
                              },
                            ),
                          ),
                          onTap: () async{
                            await controller.performUnFollow(index);
                          },
                        ),
                      )
                    ],
                  ),
                  Divider(indent: 20,endIndent: 20,)
                ],
              );
            });
      });

  Widget download() => GetBuilder<UserFollIgrController>(
      tag: tag,
      id: 'download',
      builder: (controller) {
        return LinearProgressIndicator(
          value: controller.data['percentDownload'],
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0CF301)),
          backgroundColor: Colors.transparent,
        );
      });
}
