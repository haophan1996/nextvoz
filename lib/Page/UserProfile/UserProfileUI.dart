import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vozforums/Page/NavigationDrawer/NaviDrawerUI.dart';
import 'UserProfileController.dart';

class UserProfileUI extends GetView<UserProfileController>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: NaviDrawerUI(),
      endDrawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.2,
      body: Center(
        child: Text("a new ui"),
      ),
    );
  }

}