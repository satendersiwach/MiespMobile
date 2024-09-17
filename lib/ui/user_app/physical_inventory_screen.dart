import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scanner/services/service_manager.dart';
import 'package:scanner/theme/custom_text_widgets.dart';
import 'package:scanner/theme/elements_screen.dart';

enum ScanOption { none, scanned, unScanned }

class PhysicalInventoryScreen extends StatefulWidget {
  const PhysicalInventoryScreen({super.key});

  @override
  State<PhysicalInventoryScreen> createState() =>
      _PhysicalInventoryScreenState();
}

class _PhysicalInventoryScreenState extends State<PhysicalInventoryScreen> {
  ScanOption scanOption = ScanOption.none;

  @override
  Widget build(BuildContext context) {
    return screenWithAppBar(
      title: "Physical Inventory",
      actions: [
        PopupMenuButton<int>(
          onSelected: (item) {
            setState(() {
              if (item == 1) {
                scanOption = ScanOption.none;
              } else if (item == 2) {
                scanOption = ScanOption.scanned;
              } else if (item == 3) {
                scanOption = ScanOption.unScanned;
              }
            });
          },
          itemBuilder: (context) => [
            PopupMenuItem<int>(
                value: 1,
                child: getPoppinsText(
                    text: 'None', fontWeight: FontWeight.bold, fontSize: 12)),
            PopupMenuItem<int>(
                value: 2,
                child: getPoppinsText(
                    text: 'Scanned',
                    fontWeight: FontWeight.bold,
                    fontSize: 12)),
            PopupMenuItem<int>(
                value: 3,
                child: getPoppinsText(
                    text: 'Un-scanned',
                    fontWeight: FontWeight.bold,
                    fontSize: 12)),
          ],
          icon: Icon(
            MdiIcons.listBoxOutline,
            color: Colors.white,
          ),
        )
      ],
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            _scanNowContainer(),
            const SizedBox(
              height: 10,
            ),
            if (scanOption != ScanOption.none) _list(),
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
                  color: const Color(0XFFba532b),
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

  Widget _list() {
    return ListView.separated(
      itemCount: 3,
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return InkWell(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4.0,
                  offset: Offset(2.0, 2.0),
                ),
              ],
            ),
            margin: const EdgeInsets.all(15),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                getPoppinsTextSpanHeading(text: 'Pick List id'),
                                getPoppinsTextSpanDetails(text: '1'),
                              ],
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                getPoppinsTextSpanHeading(text: 'Item Code'),
                                getPoppinsTextSpanDetails(text: 'FGOM0002'),
                              ],
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                getPoppinsTextSpanHeading(text: 'SO Id'),
                                getPoppinsTextSpanDetails(text: '1'),
                              ],
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                getPoppinsTextSpanHeading(
                                    text: 'Item Description'),
                                getPoppinsTextSpanDetails(
                                    text:
                                        'FG CSCI 50C1000-B7J8131K00 CORE COMP2'),
                              ],
                            ),
                          ),
                        ],
                      )),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                getPoppinsTextSpanHeading(text: 'WHSE Code'),
                                getPoppinsTextSpanDetails(text: 'B02'),
                              ],
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                getPoppinsTextSpanHeading(text: 'Batch No.'),
                                getPoppinsTextSpanDetails(
                                    text: 'WR21011B41150005'),
                              ],
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                getPoppinsTextSpanHeading(text: 'Release Qty'),
                                getPoppinsTextSpanDetails(text: '0.0'),
                              ],
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                getPoppinsTextSpanHeading(
                                    text: 'Picked Status'),
                                getPoppinsTextSpanDetails(text: 'Not Picked'),
                              ],
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                if (scanOption == ScanOption.unScanned) _buttonContainer(),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          thickness: 1.5,
          color: Colors.grey,
        );
      },
    );
  }

  Widget _buttonContainer() {
    return SizedBox(
      height: 50,
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0, bottom: 8, top: 8),
        child: Material(
          borderRadius: BorderRadius.circular(10.0),
          color: const Color(0XFFba532b),
          elevation: 0.0,
          child: MaterialButton(
            onPressed: () {
              ServiceManager.scanQRCode(onSuccess: (String scanResult) async {
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
    );
  }

  Widget _scanNowContainer() {
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
