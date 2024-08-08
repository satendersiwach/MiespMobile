import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:scanner/common/keys.dart';
import 'package:scanner/local_storage/local_storage.dart';
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
  String? userType;

  @override
  void initState() {
    super.initState();
    setVersion();
  }

  setVersion() async {
    packageInfo = await PackageInfo.fromPlatform();
    userType = LocalStorage.getString(key: keyUserType);
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
                  padding: const EdgeInsets.only(top: 20.0, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getPoppinsText(
                          text: 'Current app version',
                          color: appPrimary,
                          fontWeight: FontWeight.bold),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: getPoppinsText(
                            text:
                                ' - ${packageInfo?.version ?? ''}(${packageInfo?.buildNumber ?? ''})',
                            color: Colors.red,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
              if (userType != null && userType == 'Supervisor') ...[
                getPoppinsText(
                    text: 'Welcome, Supervisor',
                    fontWeight: FontWeight.w700,
                    fontSize: 20),
                //todo: implement search
                const AssignedPickListScreen(),
              ],
              if (userType != null && userType == 'User') ...[
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
    if (userType != null && userType == 'Supervisor') {
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
