# vozforums

- vozForums application, able to view user post, post, quote create thread and login.

- Best user experience: 
    Go to */flutter/packages/flutter/lib/src/cupertino/route.dart inside method void dragEnd(double velocity)
          * edit  
          [ if (controller.isAnimating) {
                  late AnimationStatusListener animationStatusCallback;
                  animationStatusCallback = (AnimationStatus status) {
                    navigator.didStopUserGesture();
                    controller.removeStatusListener(animationStatusCallback);
                    final int droppedPageBackAnimationTime = lerpDouble(0, _kMaxDroppedSwipePageForwardAnimationTime, controller.value)!.floor();
                    controller.animateBack(0.0, duration: Duration(milliseconds: droppedPageBackAnimationTime), curve: animationCurve);
                  };
                  // Otherwise, use a custom popping animation duration and curve.
                } ]
        this will fix ignore touch every time user swipe back on iOS platform

-flutter\lib\src\widgets\routes.dart full width to back previous screen
    * dragAreaWidth = max(dragAreaWidth, _kBackGestureWidth); to dragAreaWidth = max(MediaQuery.of(context).size.width, _kBackGestureWidth);
         

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
