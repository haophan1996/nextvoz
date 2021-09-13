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
        child: Text('null'),
      ),
    );
  }
}
