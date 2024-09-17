import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner/local_storage/local_storage.dart';
import 'package:scanner/services/service_manager.dart';
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
            onTap: ()  {
              ServiceManager.showLogoutDialog();
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
