import 'package:expandable/expandable.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter/material.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:vozforums/Page/UserProfile/UserProfileController.dart';
import 'package:vozforums/GlobalController.dart';
import 'package:vozforums/Page/reuseWidget.dart';

class UserProfileUI extends StatefulWidget {
  _UserProfileUI createState() => _UserProfileUI();
}

class _UserProfileUI extends State<UserProfileUI> with AutomaticKeepAliveClientMixin {
  int _currentIndex = 0;
  final List<Widget> _children = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          GetBuilder<UserProfileController>(
              tag: GlobalController.i.sessionTag.last,
              builder: (controller) {
                return SliverAppBar(
                  pinned: true,
                  snap: false,
                  floating: false,
                  expandedHeight: 160.0,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(
                      controller.data['loadError'] == 'true' ? 'Oops! We ran into some problems.' : '${controller.data['userName'] ??= 'Loading...'} | theNEXTvoz',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Get.theme.primaryColor),
                    ),
                    background: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                                color: Color(
                                  int.parse(controller.data['avatarColor1']),
                                ),
                                shape: BoxShape.circle),
                            child: controller.data['avatarLink'] == 'no'
                                ? Center(
                                    child: Text(
                                      controller.data['conservationWith'].toString().toUpperCase()[0],
                                      style: TextStyle(
                                          color: Color(int.parse(controller.data['avatarColor2'])),
                                          fontWeight: FontWeight.bold,
                                          fontSize: Get.theme.textTheme.headline5!.fontSize),
                                    ),
                                  )
                                : ExtendedImage.network(
                                    controller.data['avatarLink'],
                                    shape: BoxShape.circle,
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        ),
                        RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text: controller.data['loadError'] == 'true' ? '   ' : '${controller.data['title'] ??= 'Loading Title...'}\n',
                                  style: TextStyle(color: Color(0xFFFD6E00), fontWeight: FontWeight.bold, fontSize: 16)),
                              TextSpan(
                                  text: controller.data['loadError'] == 'true' ? '   ' : 'Joined: ${controller.data['joined'] ??= 'Loading...'}\n',
                                  style: TextStyle(color: Get.theme.primaryColor, fontSize: 16)),
                              TextSpan(
                                  text:
                                      controller.data['loadError'] == 'true' ? '   ' : 'Last seen: ${controller.data['lastSeen'] ??= 'Loading...'}',
                                  style: TextStyle(color: Get.theme.primaryColor, fontSize: 16)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
          GetBuilder<UserProfileController>(
              tag: GlobalController.i.sessionTag.last,
              builder: (controller) {
                return SliverToBoxAdapter(
                  child: SizedBox(
                    height: 20,
                    child: Center(
                      child: Text(controller.data['loadError'] == 'true'
                          ? '     '
                          : 'Messages: ${controller.data['messages'] ??= 'Loading...'} | Reaction score: ${controller.data['reactionScore'] ??= 'Loading...'}'),
                    ),
                  ),
                );
              }),
          // SliverList(
          //   delegate: SliverChildBuilderDelegate(
          //     (BuildContext context, int index) {
          //       return Container(
          //         color: index.isOdd ? Colors.white : Colors.black12,
          //         height: 100.0,
          //         child: Center(
          //           child: Text(' ', textScaleFactor: 5),
          //         ),
          //       );
          //     },
          //     childCount: 20,
          //   ),
          // )
          GetBuilder<UserProfileController>(
              tag: GlobalController.i.sessionTag.last,
              builder: (controller) {
                return controller.data['loadError'] == 'true'
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: Text('This member limits who may view their full profile.'),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return Container(
                              color: index.isOdd ? Colors.white : Colors.black12,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      RichText(
                                        textAlign: TextAlign.end,
                                        text: TextSpan(children: <TextSpan>[
                                          TextSpan(
                                              text: controller.htmlData.elementAt(index)['userNameProfile'],
                                              style: TextStyle(color: Color(0xFFFD6E00), fontWeight: FontWeight.bold, fontSize: 16)),
                                          TextSpan(
                                              text: controller.htmlData.elementAt(index)['datePostedProfile'],
                                              style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 13)),
                                        ]),
                                      )
                                    ],
                                  ),
                                  customHtml(controller.htmlData, index),
                                  Row(
                                    children: [
                                      controller.htmlData.elementAt(index)['reactionIcon'].toString() != 'no'
                                          ? Image.asset('assets/reaction/' + controller.htmlData.elementAt(index)['reactionIcon'][0] + '.png',
                                              width: 17, height: 17)
                                          : Container(),
                                      controller.htmlData.elementAt(index)['reactionIcon'].toString().length > 1 &&
                                              controller.htmlData.elementAt(index)['reactionIcon'].toString() != 'no'
                                          ? Image.asset('assets/reaction/' + controller.htmlData.elementAt(index)['reactionIcon'][1] + '.png',
                                              width: 17, height: 17)
                                          : Container(),
                                      Expanded(
                                        child: TextButton(
                                          style: ButtonStyle(alignment: Alignment.centerLeft),
                                          onPressed: () {},
                                          child: Text(controller.htmlData.elementAt(index)['reactionName'],
                                              style: TextStyle(color: Colors.blue), overflow: TextOverflow.ellipsis, maxLines: 1),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                          childCount: controller.htmlData.length,
                        ),
                      );
              }),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => {
          setState(() {
            _currentIndex = index;
          })
        },
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box_outlined),
            label: 'Profile posts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hourglass_top_outlined),
            label: 'Latest activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add_outlined),
            label: 'Postings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_score_outlined),
            label: 'Trophies',
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
