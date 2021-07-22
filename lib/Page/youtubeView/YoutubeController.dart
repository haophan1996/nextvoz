import 'package:get/get.dart';
import 'package:flutter_youtube_view/flutter_youtube_view.dart';

class YoutubeController extends GetxController implements YouTubePlayerListener{
  double currentVideoSecond = 0.0;
  String playerState = "";
  late FlutterYoutubeViewController controller;

  @override
  void onCurrentSecond(double second) {
    // TODO: implement onCurrentSecond
    print("onCurrentSecond second = $second");
    currentVideoSecond = second;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    //SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    print(Get.arguments[0]);
    print('ready');
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    //SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }



  @override
  void onError(String error) {
    // TODO: implement onError
    print("onError error = $error");
  }

  @override
  void onStateChange(String state) {
    // TODO: implement onStateChange
    print("onStateChange state = $state");
    // setState(() {
    //   _playerState = state;
    // });
  }

  @override
  void onVideoDuration(double duration) {
    // TODO: implement onVideoDuration
    print("onVideoDuration duration = $duration");
  }

  void onYoutubeCreated(FlutterYoutubeViewController controller) {
    this.controller = controller;
  }

}