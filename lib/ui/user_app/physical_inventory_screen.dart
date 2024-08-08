import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scanner/services/service_manager.dart';
import 'package:scanner/theme/custom_colors.dart';
import 'package:scanner/theme/custom_text_widgets.dart';
import 'package:scanner/theme/elements_screen.dart';

class PhysicalInventoryScreen extends StatefulWidget {
  const PhysicalInventoryScreen({super.key});

  @override
  State<PhysicalInventoryScreen> createState() =>
      _PhysicalInventoryScreenState();
}

class _PhysicalInventoryScreenState extends State<PhysicalInventoryScreen> {
  @override
  Widget build(BuildContext context) {
    return screenWithAppBar(
      title: "Physical Inventory",
      actions: [
        IconButton(
            onPressed: () {},
            icon: Icon(
              MdiIcons.listBoxOutline,
              color: Colors.white,
            ))
      ],
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            _assignCountContainer(),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: Get.height / 12,
        child: Row(
          children: [
            Expanded(child: Container()),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  borderRadius: BorderRadius.circular(10.0),
                  color: appPrimary,
                  elevation: 0.0,
                  child: MaterialButton(
                    onPressed: () {
                      ServiceManager.scanQRCode(
                          onSuccess: (String scanResult) async {
                        if (!mounted) return;
                        String barCode = scanResult;
                        if (barCode != '-1') {
                          print(barCode);
                          // if (await ServiceManager.isInternetAvailable()) {
                          //   ServiceManager.getItemDetails(
                          //       barCode: barCode,
                          //       onSuccess: onSuccess,
                          //       onError: onError);
                          // }
                        }
                      });
                    },
                    minWidth: MediaQuery.of(context).size.width,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.qr_code_scanner,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Scan",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }

  Widget _assignCountContainer() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: getPoppinsText(
            text: 'Scan Now', fontWeight: FontWeight.w700, fontSize: 20),
      ),
    );
  }
}
