import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/GlobalController.dart';
import '/Page/reuseWidget.dart';
import '/Page/Profile/ProfilePost/ProfilePostController.dart';

class ProfilePostUI extends GetView<ProfilePostController> {
  @override
  // TODO: implement tag
  String? get tag => GlobalController.i.sessionTag.last;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarOnly('Profile Post', []),
      backgroundColor: Theme.of(context).backgroundColor,
      body: GetBuilder<ProfilePostController>(
        tag: tag,
        id: 'firstLoading',
        builder: (controller) {
          return controller.data['loading'] == 'error'
              ? Text('error')
              : controller.data['loading'] == 'firstLoad'
                  ? Text('loading')
                  : loadingSuccess();
        },
      ),
    );
  }

  Widget loadingSuccess() => Stack(
        children: [
          GetBuilder<ProfilePostController>(
              tag: tag,
              id: 'listview',
              builder: (controller) {
                return ListView.builder(
                    itemCount: 10,
                    cacheExtent: 999999999999,
                    itemBuilder: (context, index) {
                      return itemView(
                          controller.htmlData.elementAt(index)['username'],
                          controller.htmlData.elementAt(index)['username2'],
                          controller.htmlData.elementAt(index)['time'],
                          controller.htmlData.elementAt(index)['content'],
                          controller.htmlData.elementAt(index)['reaction'],
                          controller.htmlData.elementAt(index)['reactionsIcon'],
                          controller.htmlData.elementAt(index)['profilePostID']);
                    });
              }),
        ],
      );

  Widget itemView(String username, String username2, String time, String content, String reaction, String reactionsIcon, String profilePostID) =>
      Padding(
        padding: EdgeInsets.only(bottom: 5, left: 8, right: 8),
        child: Ink(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(color: Get.theme.shadowColor, borderRadius: BorderRadius.all(Radius.circular(6))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Row(
                  children: [
                    displayAvatar(40, '0x000000', '0x000000', 'u',
                        'https://scontent-bos3-1.xx.fbcdn.net/v/t1.6435-9/85238921_2923304454376136_2314951337768386560_n.jpg?_nc_cat=102&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=BXCxN1nnEZMAX9ChMhE&_nc_ht=scontent-bos3-1.xx&oh=3bf84d1de98d846d28fa901728d5aebe&oe=6142CAD4'),
                    username2 == '' ? singleUserName(username, time) : multipleUserName(username, username2, time),
                  ],
                ),
              ),
              customHtml(content, controller.imageList, (postID, url){}),
              Padding(
                padding: EdgeInsets.only(top: reaction == '' ? 0 : 10, bottom: reaction == '' ? 0 : 10),
                child: InkWell(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/reaction/${reactionsIcon == '' ? 'nil' : reactionsIcon[0]}.png',
                          width: reactionsIcon == '' ? 0 : 15,
                          height: reactionsIcon == '' ? 0 : 15,
                        ),
                        Image.asset(
                          'assets/reaction/${reactionsIcon.length > 1 ? reactionsIcon[1] : 'nil'}.png',
                          width: reactionsIcon.length > 1 ? 15 : 0,
                          height: reactionsIcon.length > 1 ? 15 : 0,
                        ),
                        Expanded(
                            child: Text(
                          '\t' + reaction,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: Get.textTheme.bodyText1!.fontSize, color: Colors.blueAccent, fontWeight: FontWeight.bold),
                        )),
                      ],
                    ),
                    onTap: () async {
                      controller.performReactionList(profilePostID);
                      Get.bottomSheet(
                        Container(
                          alignment: Alignment.center,
                          height: Get.height,
                          child: GetBuilder<ProfilePostController>(
                            tag: tag,
                            id: 'reactionList',
                            builder: (controller) {
                              return controller.reactionList.length == 0
                                  ? CupertinoActivityIndicator()
                                  : controller.reactionList[0] == null
                                      ? Text('No reaction')
                                      : ListView.builder(
                                          physics: BouncingScrollPhysics(),
                                          itemCount: controller.reactionList.length,
                                          itemBuilder: (context, index) {
                                            return reactionChild(controller.reactionList.elementAt(index));
                                          });
                            },
                          ),
                        ),
                        backgroundColor: Get.theme.backgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      );
                    }),
              ),
              InkWell(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Icon(Icons.linked_camera), Text('Like'), Spacer(), Text('View or Comment\t\t')],
                  ),
                  onTap: () {
                    Get.bottomSheet(
                        Container(
                          height: Get.height * 0.9,
                          //color: Colors.pinkAccent,
                        ),
                        backgroundColor: Colors.pinkAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        isScrollControlled: true);
                  }),
            ],
          ),
        ),
      );

  Widget multipleUserName(String username, String username2, String time) => RichText(
        text: TextSpan(
          children: [
            TextSpan(text: '\t$username ', style: TextStyle(color: Colors.blue)),
            TextSpan(text: ' ➡ ', style: TextStyle(color: Get.theme.primaryColor)),
            TextSpan(text: ' $username2\n', style: TextStyle(color: Colors.blue)),
            TextSpan(text: '\t$time', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );

  Widget singleUserName(String username, String time) => RichText(
        text: TextSpan(
          children: [
            TextSpan(text: '\t$username\n', style: TextStyle(color: Colors.blue)),
            TextSpan(text: '\t$time', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
}
