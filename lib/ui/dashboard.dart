import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:scanner/models/customer_model.dart';
import 'package:scanner/theme/custom_colors.dart';
import 'package:scanner/theme/custom_text_widgets.dart';
import 'package:scanner/theme/elements_screen.dart';
import 'package:scanner/ui/components/custom_drawer.dart';
import 'package:scanner/ui/components/element_button.dart';
import 'package:scanner/ui/supervisor/assigned_pick_list_screen.dart';
import 'package:scanner/ui/user_app/user_outbound_delivery_window.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  PackageInfo? packageInfo;

  @override
  void initState() {
    super.initState();
    setVersion();
  }

  setVersion() async {
    packageInfo = await PackageInfo.fromPlatform();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return screenWithAppBar(
        title: 'Scanner App',
        drawer: const CustomDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              if (packageInfo != null) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getPoppinsText(
                          text: 'Current app version',
                          color: appPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: getPoppinsText(
                            text:
                                ' - ${packageInfo?.version ?? ''}(${packageInfo?.buildNumber ?? ''})',
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: 10,
                )
              ],
              if (!UserModel.isUser()) ...[
                getPoppinsText(
                    text: 'Welcome, Supervisor',
                    fontWeight: FontWeight.w700,
                    fontSize: 20),
                //todo: implement search
                const AssignedPickListScreen(),
              ],
              if (UserModel.isUser()) ...[
                getPoppinsText(
                    text: 'Welcome, HHT1',
                    fontWeight: FontWeight.w700,
                    fontSize: 20),
                //todo: implement refresh
                //IconButton(
                //             onPressed: () {},
                //             icon: Icon(
                //               MdiIcons.refresh,
                //               color: Colors.white,
                //             ))
                const UserOutboundDeliveryWindow(),
              ]
            ],
          ),
        ),
        bottomNavigationBar: _buttonContainer());
  }

  Widget _buttonContainer() {
    if (!UserModel.isUser()) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: loadingButton(
            isLoading: false,
            btnText: 'Submit',
            onPress: () {},
            backColor: appPrimary),
      );
    } else {
      return const SizedBox(
        height: 0,
        width: 0,
      );
    }
  }
}
