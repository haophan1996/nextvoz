import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '/GlobalController.dart';
import '/Page/reuseWidget.dart';
import '/Page/Profile/UserProfile/UserProfileController.dart';

class UserProfileUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarOnly('Members', [
        IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async => await Get.find<UserProfileController>(tag: GlobalController.i.sessionTag.last).onRefresh())
      ]),
      backgroundColor: Theme.of(context).backgroundColor,
      body: GetBuilder<UserProfileController>(
          tag: GlobalController.i.sessionTag.last,
          builder: (controller) {
            return controller.data['loadingStatus'] == 'loadFailed'
                ? loadFailed(controller)
                : controller.data['loadingStatus'] == 'loading'
                    ? loadingShimmer()
                    : profile(controller);
          }),
    );
  }

  Widget loadFailed(UserProfileController controller) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
                text: 'Oops! We ran into some problems.\n', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16)),
            TextSpan(text: 'This member limits who may view their full profile.', style: TextStyle(color: Get.theme.primaryColor, fontSize: 16)),
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
          children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: customCupertinoButton(
                      Alignment.center,
                      EdgeInsets.zero,
                      Container(
                        child: Text(
                          'Report',
                          textAlign: TextAlign.center,
                        ),
                        width: Get.width / 2 - 100,
                      ),
                      () {}),
                ),
                Align(
                  child: Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: displayAvatar(
                        200, controller.data['avatarColor1'], controller.data['avatarColor2'], controller.data['userName'], controller.data['avatarLink']),
                  ),
                  alignment: Alignment.topCenter,
                ), //Avatar
                Align(
                  alignment: Alignment.centerRight,
                  child: customCupertinoButton(
                      Alignment.center,
                      EdgeInsets.zero,
                      Container(
                        child: Text(
                          'Theo dõi',
                          textAlign: TextAlign.center,
                        ),
                        width: Get.width / 2 - 100,
                      ),
                      () {}),
                ),
              ],
            ),
            Align(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        text: '${controller.data['userName'] ??= 'Loading Username...'}\n',
                        style: TextStyle(color: Color(0xFFFD6E00), fontWeight: FontWeight.bold, fontSize: 16)),
                    TextSpan(
                        text: '${controller.data['title'] ??= 'Loading Title...'}\n', style: TextStyle(color: Get.theme.primaryColor, fontSize: 16)),
                    TextSpan(
                        text: controller.data['from'] != '' ? '${controller.data['from']}\n' : '',
                        style: TextStyle(color: Get.theme.primaryColor, fontSize: 16)),
                    TextSpan(
                        text: 'Joined: ${controller.data['joined'] ??= 'Loading...'}\n',
                        style: TextStyle(color: Get.theme.primaryColor, fontSize: 16)),
                    TextSpan(
                        text: 'Last seen: ${controller.data['lastSeen'] ??= 'Loading...'}',
                        style: TextStyle(color: Get.theme.primaryColor, fontSize: 16)),
                  ],
                ),
              ),
              alignment: Alignment.center,
            ), //Info
            Padding(
              padding: EdgeInsets.only(bottom: 10, top: 10),
              child: Stack(
                children: [
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(text: '\t\t\tTOTAL POSTS\n', style: TextStyle(color: Colors.grey, fontSize: 16)),
                        TextSpan(text: 'Messages \n', style: TextStyle(color: Get.theme.primaryColor, fontSize: 16)),
                        TextSpan(text: 'Reaction score\n', style: TextStyle(color: Get.theme.primaryColor, fontSize: 16)),
                        TextSpan(text: 'Points\n', style: TextStyle(color: Get.theme.primaryColor, fontSize: 16)),
                      ],
                    ),
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(),
                        child: RichText(
                          textAlign: TextAlign.start,
                          textDirection: TextDirection.rtl,
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text: '\n${controller.data['messages'] ??= 'Loading...'}\n',
                                  style: TextStyle(color: Get.theme.primaryColor, fontSize: 16)),
                              TextSpan(
                                  text: '${controller.data['reactionScore'] ??= 'Loading...'}\n',
                                  style: TextStyle(color: Get.theme.primaryColor, fontSize: 16)),
                              TextSpan(
                                  text: '${controller.data['pointTrophies'] ??= 'Loading...'}\n',
                                  style: TextStyle(color: Get.theme.primaryColor, fontSize: 16)),
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            ), //totalPosts
            Align(alignment: Alignment.center, child: Text('\t\t\tACTION\n', style: TextStyle(color: Colors.grey))),
            customCupertinoButton(
                Alignment.center,
                EdgeInsets.zero,
                Container(
                  child: Text(
                    'Profile posts',
                    textAlign: TextAlign.center,
                  ),
                  width: Get.width,
                ),
                () {}),
            customCupertinoButton(
                Alignment.center,
                EdgeInsets.zero,
                Container(
                  child: Text(
                    'Latest activity',
                    textAlign: TextAlign.center,
                  ),
                  width: Get.width,
                ),
                () {}),
            customCupertinoButton(
                Alignment.center,
                EdgeInsets.zero,
                Container(
                  child: Text(
                    'Postings',
                    textAlign: TextAlign.center,
                  ),
                  width: Get.width,
                ),
                () {}),
            customCupertinoButton(
                Alignment.center,
                EdgeInsets.zero,
                Container(
                  child: Text(
                    'About',
                    textAlign: TextAlign.center,
                  ),
                  width: Get.width,
                ),
                () {}),
          ],
        ),
      ),
    );
  }
}
