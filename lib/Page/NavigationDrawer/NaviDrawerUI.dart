import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:vozforums/GlobalController.dart';
import 'package:vozforums/Page/NavigationDrawer/NaviDrawerController.dart';
import 'package:extended_image/extended_image.dart';
import 'package:get/get.dart';
import 'package:vozforums/Page/reuseWidget.dart';

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
                      onTap: (){
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
            padding: EdgeInsets.only(top: 5, left: 15),
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
                      : ExtendedNetworkImageProvider(GlobalController.i.url + NaviDrawerController.i.avatarUser.value, cache: true),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, left: 15),
            child: RichText(
              text: TextSpan(children: <TextSpan>[
                TextSpan(
                    recognizer: TapGestureRecognizer()..onTap = () => Get.toNamed("/UserProfile"),
                    text: NaviDrawerController.i.nameUser.value + "\n",
                    style: TextStyle(color: Color(0xFFFD6E00), fontWeight: FontWeight.bold, fontSize: 16)),
                TextSpan(text: NaviDrawerController.i.titleUser.value, style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 13)),
              ]),
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: () async {
              setDialog(context, 'Hang tight', 'I\'m refreshing');
              await NaviDrawerController.i.getUserProfile();
              Get.back();
            },
            icon: Icon(Icons.refresh),
            alignment: Alignment.bottomCenter,
          ),
        ],
      ),
      TextButton(
          onPressed: () async {
            await NaviDrawerController.i.logout();
          },
          child: Text('Logout')),
      Divider(
        color: Theme.of(context).primaryColor,
      )
    ],
  );
}

Widget login(BuildContext context) {
  return ListTile(
    title: Text("Login"),
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
              Text(
                "Log in your account",
                style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
                child: TextField(
                  textInputAction: TextInputAction.next,
                  controller: NaviDrawerController.i.textEditingControllerLogin,
                  style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: "Login",
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
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffCED0D2), width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                  ),
                ),
              ),
              GetBuilder<NaviDrawerController>(builder: (controller) {
                return Text(controller.statusLogin, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold));
              }),
              TextButton(
                  child: Text("Login"),
                  onPressed: () async {
                    Get.defaultDialog(
                        barrierDismissible: false,
                        radius: 6,
                        backgroundColor: Theme.of(context).hintColor.withOpacity(0.8),
                        content: popUpWaiting(context, 'Hang tight', 'I\'m processing your request'),
                        title: 'Login');
                    await NaviDrawerController.i.loginFunction();
                  })
            ],
          ),
        ),
      );
    },
  );
}