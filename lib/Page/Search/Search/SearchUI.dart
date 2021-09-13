import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/Page/reuseWidget.dart';
import 'SearchController.dart';
import 'package:expandable/expandable.dart';

class SearchUI extends GetView<SearchController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: appBarOnly('search'.tr, [IconButton(onPressed: () => controller.search(), icon: Icon(Icons.search))]),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.only(top: 5, left: 5, right: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              inputCustom(TextInputType.text, controller.keywords, false, 'keywords'.tr, () => controller.search()),
              GetBuilder<SearchController>(
                tag: tag,
                id: 'visibleTitlesOnly',
                builder: (controller) {
                  return controller.visible == false
                      ? Padding(padding: EdgeInsets.only(top: 20, bottom: 20))
                      : Visibility(
                          visible: controller.visible,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GetBuilder<SearchController>(
                                  tag: tag,
                                  id: 'updateSearchTitlesOnly',
                                  builder: (controller) {
                                    return CupertinoSwitch(
                                        value: controller.isSearchTitlesOnly,
                                        onChanged: (value) {
                                          controller.isSearchTitlesOnly = value;
                                          controller.update(['updateSearchTitlesOnly']);
                                        });
                                  }),
                              Text('searchTitleOnly'.tr),
                            ],
                          ),
                        );
                },
              ),
              inputCustom(TextInputType.text, controller.postBy, false, 'postBy'.tr, () => controller.search()),
              Text(
                'You may enter multiple names here.',
                style: TextStyle(color: Colors.grey),
              ),
              customCupertinoButton(
                  Alignment.center,
                  EdgeInsets.zero,
                  GetBuilder<SearchController>(
                      tag: tag,
                      id: 'updateDate',
                      builder: (controller) {
                        return Text('Newer than ${controller.dateTime}');
                      }), () {
                Get.bottomSheet(datetimePicker(), ignoreSafeArea: false, isScrollControlled: true);
              }),
              ExpandableNotifier(
                child: ExpandableTheme(
                  data: ExpandableThemeData(
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      bodyAlignment: ExpandablePanelBodyAlignment.center,
                      iconColor: Colors.red,
                      animationDuration: const Duration(milliseconds: 500)),
                  child: ExpandablePanel(
                    controller: controller.expandableController,
                    header: GetBuilder<SearchController>(
                      id: 'visibleTitlesOnly',
                      builder: (controller) {
                        return Align(
                          alignment: Alignment.topRight,
                          child: Text(controller.visible == true ? 'searchThreads'.tr : 'Search profile posts'),
                        );
                      },
                    ),
                    expanded: Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: inputCustom(TextInputType.text, controller.postedOnTheProfileOfMember, false, 'Posted on the profile of member', () => controller.search()),
                    ),
                    collapsed: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('Minimum number of replies:'),
                      Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: Get.width * 0.2,
                              height: Get.height * 0.06,
                              padding: EdgeInsets.only(top: 5, bottom: 5),
                              child: inputCustom(TextInputType.number, controller.replies, false, 'replies', () {}),
                            ),
                            customCupertinoButton(Alignment.center, EdgeInsets.zero, Icon(Icons.add), () {
                              controller.replies.text = controller.replies.text == '' ? '0' : (int.parse(controller.replies.text) + 1).toString();
                            }),
                            customCupertinoButton(Alignment.center, EdgeInsets.zero, Icon(Icons.remove), () {
                              if (controller.replies.text == '0' || controller.replies.text == '')
                                controller.replies.text = '';
                              else
                                controller.replies.text = (int.parse(controller.replies.text) - 1).toString();
                            })
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          customCupertinoButton(
                              Alignment.center,
                              EdgeInsets.only(left: 5),
                              Text(
                                'Prefixes: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                                  () => Get.defaultDialog(content: listviewOptional('updatePrefix', controller.prefix, controller.selectPrefix, (onTap){
                                controller.selectPrefix = onTap;
                                controller.update(['updatePrefix']);
                                Get.back();
                              }))),
                          GetBuilder<SearchController>(
                              id: 'updatePrefix',
                              builder: (controller){
                                return Text(controller.prefix.elementAt(controller.selectPrefix)['name']);
                              }),
                        ],
                      ),
                      Row(
                        children: [
                          customCupertinoButton(
                              Alignment.center,
                              EdgeInsets.only(left: 5),
                              Text(
                                'Search in forums: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                                  () => Get.defaultDialog(
                                  content: listviewOptional('updateSearchInForums', controller.searchInForums, controller.selectSearchInForum, (onTap){
                                    controller.selectSearchInForum = onTap;
                                    controller.update(['updateSearchInForums']);
                                    Get.back();
                                  }))),
                          GetBuilder<SearchController>(
                              id: 'updateSearchInForums',
                              builder: (controller){
                                return Text(controller.searchInForums.elementAt(controller.selectSearchInForum)['name']);
                              }),
                        ],
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: Text(
                          'Order by',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      GetBuilder<SearchController>(
                          id: 'updateGroupRadio',
                          builder: (controller) {
                            return Column(
                              children: [
                                RadioListTile(
                                    controlAffinity: ListTileControlAffinity.leading,
                                    title: Text('Relevance'),
                                    value: 'relevance',
                                    groupValue: controller.radioGroup,
                                    onChanged: (value) {
                                      controller.handleRadioValueChange(value!);
                                    }),
                                RadioListTile(
                                    title: Text('Date'),
                                    value: 'date',
                                    groupValue: controller.radioGroup,
                                    onChanged: (value) {
                                      controller.handleRadioValueChange(value!);
                                    }),
                                RadioListTile(
                                    title: Text('Most replies'),
                                    value: 'replies',
                                    groupValue: controller.radioGroup,
                                    onChanged: (value) {
                                      controller.handleRadioValueChange(value!);
                                    }),
                              ],
                            );
                          })
                    ]),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget listviewOptional(String id, List list, int select, Function(int) onTap) {
    return Container(
      height: Get.height*0.7,
      width: Get.width,
      child: GetBuilder<SearchController>(
        id: id,
        builder: (controller) {
          return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return InkWell(
                  child: Container(
                    color: select == index ? Colors.blue : Colors.transparent,
                    child: Text(
                      list.elementAt(index)['name'],
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  onTap: () {
                    onTap(index);
                  },
                );
              });
        },
      ),
    );
  }

  Widget datetimePicker() {
    return SafeArea(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            height: Get.height * 0.4,
            child: CupertinoTheme(
                data: CupertinoThemeData(brightness: Get.isDarkMode ? Get.theme.primaryColorBrightness : Get.theme.brightness),
                child: CupertinoDatePicker(
                  maximumYear: DateTime.now().year,
                  minimumYear: 2015,
                  mode: CupertinoDatePickerMode.date,
                  backgroundColor: Get.theme.backgroundColor,
                  initialDateTime: controller.dateTime == '' ? DateTime.now() : DateTime.parse(controller.dateTime),
                  onDateTimeChanged: (DateTime newDateTime) {
                    controller.newDateTime = newDateTime;
                  },
                ))),
        customCupertinoButton(
            Alignment.center,
            EdgeInsets.zero,
            Container(
              alignment: Alignment.center,
              width: Get.width,
              height: 40,
              decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(6))),
              child: Text('Clear'),
            ), () {
          controller.dateTime = '';
          controller.update(['updateDate']);
          Get.back();
        }),
        Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: customCupertinoButton(
              Alignment.center,
              EdgeInsets.zero,
              Container(
                alignment: Alignment.center,
                width: Get.width,
                height: 40,
                decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(6))),
                child: Text('Done'),
              ), () {
            controller.dateTime = controller.newDateTime.toString().split(' ')[0];
            controller.update(['updateDate']);
            Get.back();
          }),
        )
      ],
    ));
  }
}
