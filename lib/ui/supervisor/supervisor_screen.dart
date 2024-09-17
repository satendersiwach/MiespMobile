import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:scanner/theme/custom_text_widgets.dart';
import 'package:scanner/theme/elements_screen.dart';
import 'package:scanner/ui/components/element_button.dart';
import 'package:scanner/ui/supervisor/pick_list_screen.dart';

class SupervisorScreen extends StatefulWidget {
  const SupervisorScreen({super.key});

  @override
  State<SupervisorScreen> createState() => _SupervisorScreenState();
}

class _SupervisorScreenState extends State<SupervisorScreen> {
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
                _pickListButton(),
                const SizedBox(
                  height: 16,
                ),
                // _assignPickListButton(),
                // const SizedBox(
                //   height: 16,
                // ),
                // _assignedPickListButton(),
                // const SizedBox(
                //   height: 16,
                // ),
                // _outboundDeliveryButton(),
                // const SizedBox(
                //   height: 16,
                // ),
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
          text: 'Welcome, supervisor',
          fontWeight: FontWeight.w700,
          fontSize: 20),
    );
  }

  // Widget _assignPickListButton() {
  //   return SizedBox(
  //     width: Get.width,
  //     child: loadingButton(
  //       isLoading: false,
  //       btnText: 'Assign Pick List',
  //       onPress: () {
  //         Get.to(()=>const AssignPickListScreen());
  //       },
  //     ),
  //   );
  // }

  Widget _pickListButton() {
    return SizedBox(
      width: Get.width,
      child: loadingButton(
        isLoading: false,
        btnText: 'Pick List',
        onPress: () {
          Get.to(() => const PickListScreen());
        },
      ),
    );
  }

  // Widget _assignedPickListButton() {
  //   return SizedBox(
  //     width: Get.width,
  //     child: loadingButton(
  //       isLoading: false,
  //       btnText: 'Assigned Pick List',
  //       onPress: () {
  //         Get.to(()=>AssignedPickListScreen());
  //       },
  //     ),
  //   );
  // }

  // Widget _outboundDeliveryButton() {
  //   return SizedBox(
  //     width: Get.width,
  //     child: loadingButton(
  //       isLoading: false,
  //       btnText: 'Outbound Delivery',
  //       onPress: () {},
  //     ),
  //   );
  // }

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
