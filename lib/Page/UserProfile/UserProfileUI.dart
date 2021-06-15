import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'UserProfileController.dart';

class UserProfileUI extends GetView<UserProfileController>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("a new ui"),
      ),
    );
  }

}