import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '/Page/Profile/AlertPlus/AlertPlusType.dart';
import '/Page/Search/SearchType.dart';
import '/Routes/pages.dart';
import '/GlobalController.dart';
import '/Page/reuseWidget.dart';
import '/Page/Profile/UserProfile/UserProfileController.dart';

class UserProfileUI extends GetView<UserProfileController> {
  @override
  // TODO: implement tag
  String? get tag => GlobalController.i.sessionTag.last;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarOnly('Members', [IconButton(icon: Icon(Icons.refresh), onPressed: () async => await controller.onRefresh())]),
      backgroundColor: Theme.of(context).backgroundColor,
      body: GetBuilder<UserProfileController>(
          id: 'loadingState',
          tag: tag,
          builder: (controller) {
            return controller.data['loadingStatus'] == 'loadFailed'
                ? loadFailed(controller)
                : controller.data['loadingStatus'] == 'loading'
                    ? loading()
                    : profile(controller);
          }),
    );
  }

  Widget loading() => Stack(
        children: [
          GetBuilder<UserProfileController>(
              id: 'download',
              tag: tag,
              builder: (controller) {
                return LinearProgressIndicator(
                  value: controller.percentDownload,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0CF301)),
                  backgroundColor: Get.theme.backgroundColor,
                );
              }),
        ],
      );

  Widget loadFailed(UserProfileController controller) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
                text: 'Oops! We ran into some problems.\n',
                style: TextStyle(color: Colors.redAccent, fontFamily: 'BeVietNam', fontWeight: FontWeight.bold, fontSize: 16)),
            TextSpan(
                text: 'This member limits who may view their full profile.',
                style: TextStyle(color: Get.theme.primaryColor, fontFamily: 'BeVietNam', fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget profile(UserProfileController controller) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Align(
                  child: Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: displayAvatar(80, controller.data['avatarColor1'], controller.data['avatarColor2'], controller.data['userName'],
                        controller.data['avatarLink']),
                  ),
                  alignment: Alignment.topLeft,
                ),
                Align(
                  child: RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: '${controller.data['userName'] ??= 'Loading Username...'}\n',
                            style: TextStyle(
                              fontFamily: 'BeVietNam',
                              color: Color(0xFFFD6E00),
                              fontWeight: FontWeight.bold,
                              fontSize: Get.textTheme.bodyText1!.fontSize,
                            )),
                        TextSpan(
                            text: '${controller.data['title'] ??= 'Loading Title...'}\n',
                            style: TextStyle(
                              fontFamily: 'BeVietNam',
                              color: Get.theme.primaryColor,
                              fontSize: Get.textTheme.bodyText1!.fontSize,
                            )),
                        TextSpan(
                            text: controller.data['from'] != '' ? '${controller.data['from']}\n' : '',
                            style: TextStyle(
                              fontFamily: 'BeVietNam',
                              color: Get.theme.primaryColor,
                              fontSize: Get.textTheme.bodyText1!.fontSize,
                            )),
                        TextSpan(
                            text: 'Joined: ${controller.data['joined'] ??= 'Loading...'}\n',
                            style: TextStyle(
                              fontFamily: 'BeVietNam',
                              color: Get.theme.primaryColor,
                              fontSize: Get.textTheme.bodyText1!.fontSize,
                            )),
                        TextSpan(
                            text: 'Last seen: ${controller.data['lastSeen'] ??= 'Loading...'}',
                            style: TextStyle(
                              fontFamily: 'BeVietNam',
                              color: Get.theme.primaryColor,
                              fontSize: Get.textTheme.bodyText1!.fontSize,
                            )),
                      ],
                    ),
                  ),
                  alignment: Alignment.center,
                ), //Info
              ],
            ),
            Row(
              children: [
                customCupertinoButton(
                    Alignment.center,
                    EdgeInsets.zero,
                    Text(
                      'Send private message',
                      style: TextStyle(fontSize: Get.textTheme.bodyText1!.fontSize),
                    ), () async {
                  await Get.toNamed(Routes.CreatePost,
                      arguments: [GlobalController.i.xfCsrfPost, GlobalController.i.token, 'link', '', '', '2', '', controller.data['userName']]);
                })
              ],
            ),
            RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: 'TOTAL POSTS\n',
                      style: TextStyle(fontFamily: 'BeVietNam', color: Colors.grey, fontSize: Get.textTheme.headline6!.fontSize)),
                  TextSpan(
                      text: 'Messages: ',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.toNamed(Routes.SearchResult, arguments: [
                            SearchType.SearchEverything,
                            {
                              'postBy': controller.data['userName'],
                              'order': 'relevance',
                            }
                          ]);
                        },
                      style: TextStyle(fontFamily: 'BeVietNam', color: Colors.blue, fontSize: Get.textTheme.bodyText1!.fontSize)),
                  TextSpan(
                      text: '${controller.data['messages'] ??= 'Loading...'}\n',
                      style: TextStyle(fontFamily: 'BeVietNam', color: Get.theme.primaryColor, fontSize: Get.textTheme.bodyText2!.fontSize)),
                  TextSpan(
                      text: 'Reaction score: ',
                      style: TextStyle(fontFamily: 'BeVietNam', color: Get.theme.primaryColor, fontSize: Get.textTheme.bodyText1!.fontSize)),
                  TextSpan(
                      text: '${controller.data['reactionScore'] ??= 'Loading...'}\n',
                      style: TextStyle(fontFamily: 'BeVietNam', color: Get.theme.primaryColor, fontSize: Get.textTheme.bodyText2!.fontSize)),
                  TextSpan(
                      text: 'Points: ',
                      style: TextStyle(fontFamily: 'BeVietNam', color: Get.theme.primaryColor, fontSize: Get.textTheme.bodyText1!.fontSize)),
                  TextSpan(
                      text: '${controller.data['pointTrophies'] ??= 'Loading...'}\n',
                      style: TextStyle(fontFamily: 'BeVietNam', color: Get.theme.primaryColor, fontSize: Get.textTheme.bodyText2!.fontSize)),
                ],
              ),
            ), //totalPosts
            Align(
                alignment: Alignment.topLeft,
                child: Text('ACTION', style: TextStyle(color: Colors.grey, fontSize: Get.textTheme.headline6!.fontSize))),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                text: 'All Threads\n',
                style: TextStyle(fontFamily: 'BeVietNam', color: Colors.blue, fontSize: Get.textTheme.bodyText1!.fontSize),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Get.toNamed(Routes.SearchResult, arguments: [
                      SearchType.SearchThreadsOnly,
                      {'data-user-id': controller.data['data-user-id']}
                    ]);
                  },
              ),
              TextSpan(
                  text: 'Profile posts\n',
                  style: TextStyle(fontFamily: 'BeVietNam', color: Get.theme.primaryColor, fontSize: Get.textTheme.bodyText1!.fontSize)),
              TextSpan(
                text: 'Latest activity\n',
                style: TextStyle(fontFamily: 'BeVietNam', color: Colors.blue, fontSize: Get.textTheme.bodyText1!.fontSize),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    //print(controller.data['linkProfileUser'] + AlertPlusType.ProfileLatestActivity);
                    Get.toNamed(Routes.AlertPlus, arguments: [
                      {
                        'type': AlertPlusType.ProfileLatestActivity,
                        'userLink': controller.data['linkProfileUser'],
                        'userName': controller.data['userName'] + '\'s '
                      }
                    ]);
                  },
              ),
              TextSpan(
                  text: 'About\n',
                  style: TextStyle(fontFamily: 'BeVietNam', color: Get.theme.primaryColor, fontSize: Get.textTheme.bodyText1!.fontSize)),
            ])),
          ],
        ),
      ),
    );
  }
}
