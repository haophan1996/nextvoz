import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube_view/flutter_youtube_view.dart';
import '/Page/youtubeView/YoutubeController.dart';

class YoutubeView extends GetView<YoutubeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FlutterYoutubeView(
        onViewCreated: controller.onYoutubeCreated,
        listener: controller,
        params: YoutubeParam(
          videoId: Get.arguments[0],
          showUI: true,
          //startSeconds: 5 * 60.0,
          showYoutube: false,
          showFullScreen: true,
        ),
      ),
    );
  }
}
