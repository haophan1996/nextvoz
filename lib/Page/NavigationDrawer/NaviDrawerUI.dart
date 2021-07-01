import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:vozforums/GlobalController.dart';
import 'package:vozforums/Page/NavigationDrawer/NaviDrawerController.dart';
import 'package:vozforums/Page/reuseWidget.dart';
import 'package:extended_image/extended_image.dart';
import 'package:get/get.dart';

class NaviDrawerUI extends GetView<NaviDrawerController> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Obx(
              () => GlobalController.i.isLogged.value == false ? login(context) : logged(context),
            ),
            Divider(
              color: Theme.of(context).primaryColor,
            ),
            Expanded(child: GetBuilder<NaviDrawerController>(builder: (controller) {
              return controller.shortcuts.length == 0
                  ? Container()
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.shortcuts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                            controller.shortcuts.elementAt(index)['title'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            controller.navigateToThread(
                                controller.shortcuts.elementAt(index)['title'], controller.shortcuts.elementAt(index)['link']);
                          },
                          onLongPress: () async {
                            controller.shortcuts.removeAt(index);
                            controller.update();
                            await GlobalController.i.userStorage.remove('shortcut');
                            await GlobalController.i.userStorage.write('shortcut', controller.shortcuts);
                          },
                        );
                      });
            }))
          ],
        ),
      ),
    );
  }
}

Widget logged(BuildContext context) {
  return Column(
    children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 5, left: 15, right: 15),
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                border: Border.all(width: 0.5, color: Colors.black),
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NaviDrawerController.i.avatarUser.value == "no"
                      ? Image.asset(
                          "assets/NoAvata.png",
                          height: 48,
                          width: 48,
                        ).image
                      : ExtendedNetworkImageProvider((GlobalController.i.url + NaviDrawerController.i.avatarUser.value), cache: true),
                ),
              ),
            ),
          ), //Show avatar
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textDrawer(Color(0xFFFD6E00), 16, NaviDrawerController.i.nameUser.value, FontWeight.bold),
                textDrawer(Theme.of(context).primaryColor, 13, NaviDrawerController.i.titleUser.value, FontWeight.normal),
              ],
            ),
          ), //Title and name user
          IconButton(
            onPressed: () async {
              setDialog(context, 'popMess'.tr, 'popMess3'.tr);
              await NaviDrawerController.i.getUserProfile();
              Get.back();
            },
            icon: Icon(Icons.refresh),
            alignment: Alignment.bottomCenter,
          ), //Refresh user data
          TextButton(
            onPressed: () async {
              await NaviDrawerController.i.logout();
            },
            child: text('logout'.tr, TextStyle()),
          ), //Loggout
        ],
      ),
      settings(context),
    ],
  );
}

Widget login(BuildContext context) {
  return Column(
    children: [
      ListTile(
        title: text('login'.tr, TextStyle()),
        onTap: () {
          NaviDrawerController.i.statusLogin = '';
          NaviDrawerController.i.textEditingControllerPassword.text = '';
          NaviDrawerController.i.textEditingControllerLogin.text = '';
          Get.bottomSheet(
            Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor.withOpacity(0.8),
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.all(
                  Radius.circular(6),
                ),
              ),
              child: Column(
                children: [
                  text(
                    'loginMess'.tr,
                    TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
                    child: TextField(
                      textInputAction: TextInputAction.next,
                      controller: NaviDrawerController.i.textEditingControllerLogin,
                      style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'loginAccount'.tr,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffCED0D2), width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                    child: TextField(
                      textInputAction: TextInputAction.next,
                      controller: NaviDrawerController.i.textEditingControllerPassword,
                      style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'loginPassword'.tr,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffCED0D2), width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                      ),
                    ),
                  ),
                  GetBuilder<NaviDrawerController>(builder: (controller) {
                    return text(controller.statusLogin, TextStyle(color: Colors.red, fontWeight: FontWeight.bold));
                  }),
                  TextButton(
                      child: text('login'.tr, TextStyle()),
                      onPressed: () async {
                        setDialog(context, 'popMess'.tr, 'popMess2'.tr);
                        await NaviDrawerController.i.loginFunction();
                      })
                ],
              ),
            ),
          );
        },
      ),
      settings(context),
    ],
  );
}
