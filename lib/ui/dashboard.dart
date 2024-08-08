import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:scanner/theme/custom_colors.dart';
import 'package:scanner/theme/custom_text_widgets.dart';
import 'package:scanner/theme/elements_screen.dart';
import 'package:scanner/ui/components/custom_drawer.dart';

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
        drawer: CustomDrawer(),
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
            ],
          ),
        ));
  }
}
