import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import '../GlobalController.dart';

class ScrollToHideWidget extends StatefulWidget {
  final Widget child;
  final ScrollController controller;
  final Duration duration;

  const ScrollToHideWidget({
    Key? key,
    required this.child,
    required this.controller,
    this.duration = const Duration(milliseconds: 200),
  }) : super(key: key);

  @override
  _ScrollToHideWidgetState createState() => _ScrollToHideWidgetState();
}

class _ScrollToHideWidgetState extends State<ScrollToHideWidget> {
  bool isVisible = true;
  bool isShow = true;
  bool isHide = false;
  final height = kBottomNavigationBarHeight + (GlobalController.i.userStorage.read('heightBottomBar') ?? (GetPlatform.isAndroid ? 0 : 20));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.controller.addListener(listen);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.controller.removeListener(listen);
  }

  void listen() {
    final direction = widget.controller.position.userScrollDirection;
    if (direction == ScrollDirection.forward && isShow != true) {
      isShow = true;
      isHide = false;
      show();
    } else if (direction == ScrollDirection.reverse && isHide != true) {
      isShow = false;
      isHide = true;
      hide();
    }
  }

  void show() {
    if (!isVisible) setState(() => isVisible = true);
  }

  void hide() {
    if (isVisible) setState(() => isVisible = false);
  }

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: widget.duration,
        height:
            isVisible ? height : 0,
        child: widget.child,
      );
}
