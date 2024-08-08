import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:scanner/theme/custom_text_widgets.dart';
import 'package:scanner/theme/elements_screen.dart';
import 'package:scanner/ui/components/element_button.dart';

class UserAppScreen extends StatefulWidget {
  const UserAppScreen({super.key});

  @override
  State<UserAppScreen> createState() => _UserAppScreenState();
}

class _UserAppScreenState extends State<UserAppScreen> {
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
        title: 'Supervisor Window',
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                _welcomeContainer(),
                SizedBox(
                  height: Get.height / 8,
                ),
                _outboundDeliveryButton(),
                const SizedBox(
                  height: 16,
                ),
                _physicalEntryButton(),
                const SizedBox(
                  height: 16,
                ),


                _signOutButton()
              ],
            ),
          ),
        ),
        bottomNavigationBar: packageInfo != null
            ? Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  "Version - ${packageInfo?.version ?? ''}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Color(0XFF46519D),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              )
            : null);
  }

  Widget _welcomeContainer() {
    return Align(
      alignment: Alignment.centerLeft,
      child: getPoppinsText(
          text: 'Welcome, HHT1',
          fontWeight: FontWeight.w700,
          fontSize: 20),
    );
  }


  Widget _physicalEntryButton() {
    return SizedBox(
      width: Get.width,
      child: loadingButton(
        isLoading: false,
        btnText: 'Physical Entry',
        onPress: () {},
      ),
    );
  }

  Widget _outboundDeliveryButton() {
    return SizedBox(
      width: Get.width,
      child: loadingButton(
        isLoading: false,
        btnText: 'Outbound Delivery',
        onPress: () {},
      ),
    );
  }

  Widget _signOutButton() {
    return SizedBox(
      width: Get.width,
      child: loadingButton(
        isLoading: false,
        btnText: 'Sign out',
        onPress: () {},
      ),
    );
  }
}
