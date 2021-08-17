import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:theNEXTvoz/GlobalController.dart';
import 'package:theNEXTvoz/Page/reuseWidget.dart';
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
      body: ListView.builder(
          itemCount: 10,
          cacheExtent: 999999999999,
          itemBuilder: (context, index) {
            return itemView();
          }),
    );
  }

  Widget itemView() => Padding(
        padding: EdgeInsets.only(bottom: 5, left: 8, right: 8),
        child: Ink(
          decoration: BoxDecoration(color: Get.theme.shadowColor, borderRadius: BorderRadius.all(Radius.circular(6))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  displayAvatar(40, '0x000000', '0x000000', 'u',
                      'https://scontent-bos3-1.xx.fbcdn.net/v/t1.6435-9/85238921_2923304454376136_2314951337768386560_n.jpg?_nc_cat=102&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=BXCxN1nnEZMAX9ChMhE&_nc_ht=scontent-bos3-1.xx&oh=3bf84d1de98d846d28fa901728d5aebe&oe=6142CAD4'),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: '\tOne and only', style: TextStyle(color: Colors.blue)),
                        TextSpan(text: ' ➡ ', style: TextStyle(color: Get.theme.primaryColor)),
                        TextSpan(text: ' devgk1993\n', style: TextStyle(color: Colors.blue)),
                        TextSpan(text: '\tToday at 5:13 AM', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                ],
              ),
              Html(
                data: controller.html,
                tagsList: Html.tags..remove('noscript'),
              ),
              InkWell(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/reaction/1.png',
                        width: 20,
                        height: 20,
                      ),
                      Image.asset(
                        'assets/reaction/2.png',
                        width: 20,
                        height: 20,
                      ),
                      Expanded(
                          child: Text(
                        'Bần Lông Công Tử, Cryolite.2, Thu Minh . của tớ and 2 others',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: Get.textTheme.bodyText1!.fontSize, color: Colors.blueAccent, fontWeight: FontWeight.bold),
                      )),
                    ],
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
                        ), );
                  }),
              InkWell(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Icon(Icons.linked_camera), Text('Like'), Spacer(), Icon(Icons.share), Text('Comment\t\t')],
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
}
