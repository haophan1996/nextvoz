import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../GlobalController.dart';
import '../../reuseWidget.dart';
import '/Page/Login/AccountList/AccountListController.dart';

class AccountListUI extends GetView<AccountListController> {
  final tagI = GlobalController.i.sessionTag.last;

  @override
  // TODO: implement tag
  String? get tag => tagI;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarOnly('accounts'.tr, []),
      backgroundColor: Theme.of(context).backgroundColor,
      body: controller.accountList.length == 0
          ? Center(
              child: Text(
                'accountListHelper'.tr,
                textAlign: TextAlign.center,
              ),
            )
          : list(),
    );
  }

  Widget list() => GetBuilder<AccountListController>(
      tag: tagI,
      id: 'list',
      builder: (controller) {
        return ListView.builder(
            padding: EdgeInsets.only(left: 10, top: 5),
            itemCount: controller.accountList.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  InkWell(
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      width: Get.width * 0.85,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          displayAvatar(
                              30,
                              controller.accountList.elementAt(index)['avatarColor1'],
                              controller.accountList.elementAt(index)['avatarColor2'],
                              controller.accountList.elementAt(index)['nameUser'],
                              controller.accountList.elementAt(index)['avatarUser']),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              controller.accountList.elementAt(index)['nameUser'],
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: Theme.of(context).textTheme.headline6!.fontSize),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () => controller.onSelectAccount(index),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: customCupertinoButton(
                        Alignment.center,
                        EdgeInsets.zero,
                        Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: Theme.of(context).textTheme.headline4!.fontSize,
                        ), () {
                      controller.removeAccount(index);
                    }),
                  )
                ],
              );
            });
      });
}
