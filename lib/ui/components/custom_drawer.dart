import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner/LogFile/LogFileScreen.dart';
import 'package:scanner/local_storage/local_storage.dart';
import 'package:scanner/models/customer_model.dart';
import 'package:scanner/theme/custom_colors.dart';
import 'package:scanner/theme/custom_text_widgets.dart';
import 'package:scanner/ui/components/element_common_widget.dart';
import 'package:scanner/ui/login_screen.dart';
import 'package:scanner/ui/supervisor/assign_pick_list_screen.dart';
import 'package:scanner/ui/user_app/physical_inventory/physical_inventory_screen.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  CustomDrawerState createState() => CustomDrawerState();
}

class CustomDrawerState extends State<CustomDrawer> {
  @override
  void initState() {
    super.initState();
    setVersion();
  }

  setVersion() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: Get.height / 7,
            padding: EdgeInsets.zero,
            color: appPrimary,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  getHeadingText(
                      text: 'Hi, ${UserModel.getLoginCustomer().username}',
                      textAlign: TextAlign.start,
                      fontSize: 22,
                      color: Colors.white),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          if (!UserModel.isUser()) ...[
            ListTile(
              title: getPoppinsText(
                  text: 'Assign Pick List',
                  textAlign: TextAlign.start,
                  color: appPrimary,
                  fontWeight: FontWeight.bold),
              trailing:
                  const Icon(Icons.keyboard_arrow_right, color: appPrimary),
              onTap: () {
                Get.to(() => const AssignPickListScreen());
              },
            ),
            ListTile(
              title: getPoppinsText(
                  text: 'Outbound Delivery',
                  textAlign: TextAlign.start,
                  color: appPrimary,
                  fontWeight: FontWeight.bold),
              trailing:
                  const Icon(Icons.keyboard_arrow_right, color: appPrimary),
              onTap: () {
                Get.to(() => const PhysicalInventoryScreen());
              },
            ),
          ],
          if (UserModel.isUser()) ...[
            ListTile(
              title: getPoppinsText(
                  text: 'Physical Inventory',
                  textAlign: TextAlign.start,
                  color: appPrimary,
                  fontWeight: FontWeight.bold),
              trailing:
                  const Icon(Icons.keyboard_arrow_right, color: appPrimary),
              onTap: () {
                Get.to(() => const PhysicalInventoryScreen());
              },
            ),
          ],
          // ListTile(
          //   title: getPoppinsText(
          //       text: 'Supervisor Window',
          //       textAlign: TextAlign.start,
          //       color: appPrimary,
          //       fontWeight: FontWeight.bold),
          //   trailing: const Icon(Icons.keyboard_arrow_right, color: appPrimary),
          //   onTap: () {
          //     Get.to(() => const SupervisorScreen());
          //   },
          // ),
          //
          // ListTile(
          //   title: getPoppinsText(
          //       text: 'Scan sample',
          //       textAlign: TextAlign.start,
          //       color: appPrimary,
          //       fontWeight: FontWeight.bold),
          //   trailing: const Icon(Icons.keyboard_arrow_right, color: appPrimary),
          //   onTap: () {
          //     Get.to(() => const BarcodeScannerSimple());
          //   },
          // ),
          // ListTile(
          //   title: getPoppinsText(
          //       text: 'User App Window',
          //       textAlign: TextAlign.start,
          //       color: appPrimary,
          //       fontWeight: FontWeight.bold),
          //   trailing: const Icon(Icons.keyboard_arrow_right, color: appPrimary),
          //   onTap: () {
          //     Get.to(() => const UserAppScreen());
          //   },
          // ),
          ListTile(
            title: getPoppinsText(
                text: 'Logout',
                textAlign: TextAlign.start,
                color: Colors.red,
                fontWeight: FontWeight.bold),
            trailing: const Icon(Icons.keyboard_arrow_right, color: appPrimary),
            onTap: () {
              List<Widget> titleRowWidgets = [
                getPoppinsText(
                    text: 'Logout',
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ];
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
                          child: getPoppinsText(
                              text: 'Logout',
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: getPoppinsText(
                              text: 'No',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: appPrimary),
                        ),
                        // TextButton(
                        //   onPressed: () {
                        //     LocalStorage.logout();
                        //     Get.offAll(() => const LoginPage());
                        //   },
                        //   child: const Text(
                        //     "Logout",
                        //     style: TextStyle(
                        //         color: Colors.red,
                        //         fontWeight: FontWeight.bold,
                        //         fontSize: 16),
                        //   ),
                        // ),
                        // TextButton(
                        //   onPressed: () {
                        //     Navigator.pop(context);
                        //   },
                        //   child: const Text(
                        //     "No",
                        //     style: TextStyle(
                        //         fontWeight: FontWeight.bold, fontSize: 16),
                        //   ),
                        // ),
                      ],
                    )),
              ];
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Row(
                      children: titleRowWidgets,
                    ),
                    content: getPoppinsText(
                        text: 'Are you sure you want to logout?',
                        textAlign: TextAlign.start,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                    actions: actions,
                  );
                },
              );
            },
          ),
          ListTile(
            title: getPoppinsText(
                text: 'Log File Screen',
                textAlign: TextAlign.start,
                color: Colors.red,
                fontWeight: FontWeight.bold),
            trailing: const Icon(Icons.keyboard_arrow_right, color: appPrimary),
            onTap: () {
              Get.to(()=>const LogFileScreen());
            },
          ),
          const Divider(
            thickness: 1,
            color: Colors.grey,
          ),
          appVersionWidget(),
        ],
      ),
    );
  }
}
