import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vozforums/Page/ThreadView/ViewController.dart';

class ViewUI extends GetView<ViewController>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          controller.theme,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: TextButton(
          onPressed: (){controller.test();},
          child: Text("test me"),
        ),
      ),
    );
  }

}