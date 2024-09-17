import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner/local_storage/local_storage.dart';
import 'package:scanner/theme/custom_colors.dart';
import 'package:scanner/theme/custom_text_widgets.dart';
import 'package:scanner/ui/login_screen.dart';
import 'package:scanner/ui/supervisor/supervisor_screen.dart';
import 'package:scanner/ui/user_app/user_app_screen.dart';

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
              'User name',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            accountEmail: const Text('email@gmail.com',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)),
            currentAccountPicture: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: const FlutterLogo(
                size: 100,
              ),
              // child: Image.asset(logoPath),
            ),
            decoration: const BoxDecoration(
              color: appPrimary,
            ),
          ),
          ListTile(
            title: const Text(
              'Supervisor Window',
              style: TextStyle(color: Colors.white),
            ),
            trailing:
                const Icon(Icons.keyboard_arrow_right, color: Colors.white),
            onTap: () {
              Get.to(() => const SupervisorScreen());
            },
          ),
          ListTile(
            title: const Text(
              'User App Window',
              style: TextStyle(color: Colors.white),
            ),
            trailing:
                const Icon(Icons.keyboard_arrow_right, color: Colors.white),
            onTap: () {
              Get.to(() => const UserAppScreen());
            },
          ),
          InkWell(
            onTap: () async {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: getHeadingText(text: "Logout", fontSize: 15),
                    content: SizedBox(
                      height: Get.height / 20,
                      width: Get.width / 1.5,
                      child: getHeadingText(
                          text: 'Are you sure you want to logout?',
                      fontWeight: FontWeight.w500),
                    ),
                    actions: [
                      MaterialButton(
                        // OPTIONAL BUTTON
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        color: submitButtonColor,
                        child: getHeadingText(text: 'No',color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      MaterialButton(
                        // OPTIONAL BUTTON
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        color: Colors.red,
                        child:getHeadingText(text: 'Yes',color: Colors.white),
                        onPressed: () async {
                          LocalStorage.logout();
                          Get.offAll(() => const LoginPage());
                        },
                      ),
                    ],
                  );
                },
              ).then((val) {
                setState(() {});
              });
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
