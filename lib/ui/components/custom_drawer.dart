import 'dart:io';

import 'package:scanner/common/app_assets.dart';
import 'package:scanner/local_storage/local_storage.dart';
import 'package:scanner/theme/custom_colors.dart';
import 'package:scanner/ui/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: appPrimary,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text(
              'Ayush',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            accountEmail: const Text('ayush@gmail.com',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)),
            currentAccountPicture: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child:const  FlutterLogo(
                  size: 100,
                ),
                // child: Image.asset(logoPath),
            ),
            decoration: const BoxDecoration(
              color: appPrimary,
            ),
          ),
          const ListTile(
            title: Text(
              'Menu',
              style: TextStyle(color: Colors.white),
            ),
            trailing: Icon(Icons.keyboard_arrow_right, color: Colors.white),
          ),
          InkWell(
            onTap: () async {
              List<Widget> titleRowWidgets = [const Text("Logout")];
              List<Widget> actions = [
                Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // if (!isShowNegative)
                        const Spacer(),

                        TextButton(
                          onPressed: () {
                            LocalStorage.logout();
                            Get.offAll(() => const LoginPage());
                          },
                          child: const Text(
                            "Logout",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("No"),
                        ),
                      ],
                    )),
              ];
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  if (Platform.isIOS) {
                    return CupertinoAlertDialog(
                      title: Row(
                        children: titleRowWidgets,
                      ),
                      content: const Text("Are you sure you want to logout?"),
                      actions: actions,
                    );
                  } else {
                    return AlertDialog(
                      title: Row(
                        children: titleRowWidgets,
                      ),
                      content: const Text("Are you sure you want to logout?"),
                      actions: actions,
                    );
                  }
                },
              );
            },
            child: const ListTile(
              title: Text(
                'Logout',
                style: TextStyle(color: white),
              ),
              leading: Icon(Icons.logout, color: Colors.white),
              trailing: Icon(Icons.keyboard_arrow_right, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
