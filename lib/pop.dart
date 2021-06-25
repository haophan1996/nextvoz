import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vozforums/GlobalController.dart';

class Popup extends GetView<GlobalController> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        GestureDetector(
          onTap: () => Get.back(),
        ),
        Hero(
          transitionOnUserGestures: true,
          tag: 'noti',
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(7)),
              color: Theme.of(context).backgroundColor.withOpacity(0.9),
            ),
            child: GetBuilder<GlobalController>(
              builder: (controller) {
                return ListView.builder(
                  itemCount: controller.alertList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: BoxDecoration(
                          border: Border(
                        bottom: BorderSide(width: 0.5, color: Theme.of(context).primaryColor),
                      )),
                      child: CupertinoButton(
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(text: controller.alertList.elementAt(index)['username'], style: TextStyle(color: Colors.blue)),
                              TextSpan(
                                  text: controller.alertList.elementAt(index)['status'], style: TextStyle(color: Theme.of(context).primaryColor)),
                              TextSpan(text: controller.alertList.elementAt(index)['threadName'] + '\n', style: TextStyle(color: Colors.blue)),
                              TextSpan(
                                  text: controller.alertList.elementAt(index)['time'],
                                  style: TextStyle(color: Theme.of(context).secondaryHeaderColor))
                            ],
                          ),
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                              backgroundColor: Colors.transparent, isScrollControlled: true, context: context, builder: (builder) => sheetPage());
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        )
      ],
    );
  }
}

Widget sheetPage() => DraggableScrollableSheet(
    initialChildSize: 0.7,
    maxChildSize: 0.9,
    minChildSize: 0.7,
    builder: (_, controller) => Container(
          color: Colors.white,
          child: ListView(
            physics: BouncingScrollPhysics(),
            controller: controller,
            children: [
              Text(
                'sackjslcnasjcsdjcnsdncnjsdnjcsdjnvdnsvndfvifdnvndfinviufdvuifdvuindfiuvndfjvnjdfnvjkdfnjkvnjfksnjk',
                style: TextStyle(color: Colors.blue),
              ),
              Text(
                'sackjslcnasjcsdjcnsdncnjsdnjcsdjnvdnsvndfvifdnvndfinviufdvuifdvuindfiuvndfjvnjdfnvjkdfnjkvnjfksnjk',
                style: TextStyle(color: Colors.blue),
              ),
              Text(
                'sackjslcnasjcsdjcnsdncnjsdnjcsdjnvdnsvndfvifdnvndfinviufdvuifdvuindfiuvndfjvnjdfnvjkdfnjkvnjfksnjk',
                style: TextStyle(color: Colors.blue),
              ),
              Text(
                'sackjslcnasjcsdjcnsdncnjsdnjcsdjnvdnsvndfvifdnvndfinviufdvuifdvuindfiuvndfjvnjdfnvjkdfnjkvnjfksnjk',
                style: TextStyle(color: Colors.blue),
              ),
              Text(
                'sackjslcnasjcsdjcnsdncnjsdnjcsdjnvdnsvndfvifdnvndfinviufdvuifdvuindfiuvndfjvnjdfnvjkdfnjkvnjfksnjk',
                style: TextStyle(color: Colors.blue),
              ),
            ],
          ),
        ));
