import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:vozforums/GlobalController.dart';
import 'package:vozforums/Page/NavigationDrawer/NaviDrawerController.dart';
import 'package:get/get.dart';

class NaviDrawerUI extends GetView<NaviDrawerController> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text("Login"),
            onTap: () {
              Get.bottomSheet(
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
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
                          controller: controller.textEditingControllerLogin,
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
                          controller: controller.textEditingControllerPassword,
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
                      Text("invalid", style: TextStyle(color: Colors.red)),
                      TextButton(
                          child: Text("Login"),
                          onPressed: () async {
                            await controller.loginFunction();
                          })
                    ],
                  ),
                ),
              );
            },
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
