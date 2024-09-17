import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scanner/model/pick_list_model.dart';
import 'package:scanner/services/service_manager.dart';
import 'package:scanner/theme/custom_colors.dart';
import 'package:scanner/theme/custom_text_widgets.dart';
import 'package:scanner/theme/elements_screen.dart';
import 'package:scanner/theme/get_text_field.dart';
import 'package:scanner/ui/components/element_button.dart';
import 'package:scanner/ui/components/pick_list_ui.dart';

enum ScanOption { none, scanned, unScanned }

class PhysicalInventoryScreen extends StatefulWidget {
  const PhysicalInventoryScreen({super.key});

  @override
  State<PhysicalInventoryScreen> createState() =>
      _PhysicalInventoryScreenState();
}

class _PhysicalInventoryScreenState extends State<PhysicalInventoryScreen> {
  ScanOption scanOption = ScanOption.none;
  final TextEditingController _query = TextEditingController();

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
            if (scanOption == ScanOption.none) ...[
              _scanNowContainer(),
              const SizedBox(
                height: 10,
              ),
            ],
            if (scanOption != ScanOption.none) ...[_searchContainer(), _list()],
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      bottomNavigationBar: scanOption == ScanOption.none
          ? Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: SizedBox(
                height: Get.height / 15,
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
            )
          : null,
    );
  }

  Widget _searchContainer() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: getTextField(
              controller: _query,
              labelText: 'Search',
              enabled: false,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
              suffixIcon: const Icon(
                Icons.search,
                color: appPrimary,
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0, bottom: 4),
          child: SizedBox(
            height: 43,
            child: loadingButton(
                isLoading: false,
                btnText: 'Search',
                onPress: () {
                  setState(() {});
                }),
          ),
        )
      ],
    );
  }

  Widget _list() {
    return ListView.separated(
      itemCount: pickLists.length,
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (_query.text.isNotEmpty
            ? pickLists[index]
                    .itemCode
                    .toUpperCase()
                    .contains(_query.text.toUpperCase()) ||
                pickLists[index]
                        .description
                        ?.toUpperCase()
                        .contains(_query.text.toUpperCase()) ==
                    true
            : true) {
          if (scanOption == ScanOption.unScanned) {
            return getUnScannedPickListUI(pickListModel: pickLists[index]);
          } else {
            return getScannedPickListUI(pickListModel: pickLists[index]);
          }
        } else {
          return Container();
        }
      },
      separatorBuilder: (BuildContext context, int index) {
        if (_query.text.isNotEmpty
            ? pickLists[index]
                    .itemCode
                    .toUpperCase()
                    .contains(_query.text.toUpperCase()) ||
                pickLists[index]
                        .description
                        ?.toUpperCase()
                        .contains(_query.text.toUpperCase()) ==
                    true
            : true) {
          return const Divider(
            thickness: 1.5,
            color: Colors.grey,
          );
        } else {
          return Container();
        }
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
