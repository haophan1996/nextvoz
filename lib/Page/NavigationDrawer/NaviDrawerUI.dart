import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:vozforums/GlobalController.dart';
import 'package:vozforums/Page/NavigationDrawer/NaviDrawerController.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:extended_image/extended_image.dart';
import 'package:get/get.dart';

class NaviDrawerUI extends GetView<NaviDrawerController> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Obx(
            () => GlobalController.i.isLogged.value == false
                ? login(context)
                : Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                border: Border.all(width: 0.5, color: Colors.black),
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: controller.avatarUser.value == "no"
                                      ? Image.asset(
                                          "assets/NoAvata.png",
                                          height: 48,
                                          width: 48,
                                        ).image
                                      : ExtendedNetworkImageProvider(GlobalController.i.url + controller.avatarUser.value, cache: true),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10, left: 10),
                            child: RichText(
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                    text: controller.nameUser.value + "\n",
                                    style: TextStyle(color: Color(0xFFFD6E00), fontWeight: FontWeight.bold, fontSize: 16)),
                                TextSpan(text: controller.titleUser.value, style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 13)),
                              ]),
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                          onPressed: () async {
                            await controller.logout();
                          },
                          child: Text('Logout')),
                      Divider(
                        color: Theme.of(context).primaryColor,
                      )
                    ],
                  ),
          ),
          ListTile(
            title: Text("Home"),
            onTap: () {
              print(Get.currentRoute);
            },
          )
        ],
      ),
    );
  }
}

Widget login(BuildContext context) {
  return ListTile(
    title: Text("Login"),
    onTap: () {
      NaviDrawerController.i.statusLogin.value = '';
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
              Obx(
                () => Text(NaviDrawerController.i.statusLogin.value, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ),
              TextButton(
                  child: Text("Login"),
                  onPressed: () async {
                    Get.defaultDialog(
                        barrierDismissible: false,
                        radius: 6,
                        backgroundColor: Theme.of(context).hintColor.withOpacity(0.8),
                        content: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CupertinoActivityIndicator(),
                            SizedBox(height: 20,),
                            DefaultTextStyle(
                                style: TextStyle(color: Theme.of(context).primaryColor),
                                child: AnimatedTextKit(
                                  repeatForever: true,
                                  isRepeatingAnimation: true,
                                  animatedTexts: [
                                    WavyAnimatedText('Hang tight'),
                                    WavyAnimatedText('I\'m processing your request')
                                  ],
                                ),
                            ),
                          ],
                        ),
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
