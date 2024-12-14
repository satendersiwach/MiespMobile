import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner/common/enums.dart';
import 'package:scanner/models/customer_model.dart';
import 'package:scanner/models/pick_list_model.dart';
import 'package:scanner/services/service_manager.dart';
import 'package:scanner/theme/custom_colors.dart';
import 'package:scanner/theme/custom_snack_bar.dart';
import 'package:scanner/theme/custom_text_widgets.dart';
import 'package:scanner/theme/get_text_field.dart';
import 'package:scanner/ui/components/element_button.dart';

class UserOutboundDeliveryWindow extends StatefulWidget {
  const UserOutboundDeliveryWindow({super.key});

  @override
  State<UserOutboundDeliveryWindow> createState() =>
      _UserOutboundDeliveryWindowState();
}

class _UserOutboundDeliveryWindowState
    extends State<UserOutboundDeliveryWindow> {
  List<PickListModel> pickList = [];
  bool _isLoading = false;
  final TextEditingController _query = TextEditingController();
  PickListStatusEnumForUser pickListStatusEnum =
      PickListStatusEnumForUser.notPicked;

  @override
  void initState() {
    super.initState();
    setUserData();
  }

  Future<void>setUserData() async {
    _isLoading = true;
    pickList.clear();
    UserModel userModel = UserModel.getLoginCustomer();
    await ServiceManager.getPickListByUser(
        username: userModel.username ?? "",
        status: ServiceManager.getPickListStatusFromEnum(
            pickListStatusEnum: pickListStatusEnum),
        onSuccess: (pickList) {
          setState(() {
            this.pickList = pickList;
            _isLoading = false;
          });
        },
        onError: (Map map) {
          setState(() {
            _isLoading = false;
          });
        });
  }


  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
          onRefresh: setUserData,
          child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  _assignCountContainer(),
                  const SizedBox(
                    height: 25,
                  ),
                  _queryWidget(),
                  const SizedBox(
                    height: 5,
                  ),
                  _statusFilterWidget(),
                  const SizedBox(
                    height: 5,
                  ),
                  _list(),
                ],
              ),
            ),
        );
  }

  Widget _statusFilterWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, top: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: getInterText(
              text: 'Picklist Status',
              textAlign: TextAlign.left,
              color: const Color(0XFF0F3C4D),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 15, right: 15),
            child: SizedBox(
              width: Get.width / 4,
              child: DropdownButton<PickListStatusEnumForUser>(
                value: pickListStatusEnum, // Currently selected value
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() {
                      pickListStatusEnum =
                          newValue; // Update the selected value
                    });
                    setUserData();
                  }
                },
                items: PickListStatusEnumForUser.values
                    .map((PickListStatusEnumForUser value) {
                  return DropdownMenuItem<PickListStatusEnumForUser>(
                    value: value,
                    child: Text(
                        getEnumLabel(value)), // Display user-friendly label
                  );
                }).toList(), // Converts enum values to dropdown items
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _assignCountContainer() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: getPoppinsText(
            text: 'You have ${pickList.length} Pick List assigned',
            decoration: TextDecoration.underline,
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 14),
      ),
    );
  }

  Widget _queryWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: getTextField(
                controller: _query,
                hintText: 'Search...',
                inputFontSize: 12,
                onChanged: (val) {
                  setState(() {});
                },
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _query.clear();
                      });
                    },
                    icon: const Icon(Icons.clear)),
                labelFontSize: 14),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(
              bottom: 8,
              top: 2,
            ),
            child: SizedBox(
              height: 43,
              child: loadingButton(
                  isLoading: false, btnText: 'Search', onPress: () {}),
            ),
          )),
        ],
      ),
    );
  }

  Widget _list() {
    return ListView.separated(
      itemCount: pickList.length,
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        PickListModel pickListModel = pickList[index];
        if (_query.text.isNotEmpty
            ? pickListModel.absEntry
                    .toString()
                    .toUpperCase()
                    .contains(_query.text.toUpperCase()) ||
                pickListModel.code
                    .toString()
                    .toUpperCase()
                    .contains(_query.text.toUpperCase())
            : true) {
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                                    getPoppinsTextSpanHeading(
                                        text: 'Pick List id'),
                                    getPoppinsTextSpanDetails(
                                        text:
                                            pickListModel.absEntry.toString()),
                                  ],
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    getPoppinsTextSpanHeading(
                                        text: 'Item Code'),
                                    getPoppinsTextSpanDetails(
                                        text: pickListModel.code),
                                  ],
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    getPoppinsTextSpanHeading(text: 'SO Id'),
                                    getPoppinsTextSpanDetails(
                                        text:
                                            pickListModel.docEntry.toString()),
                                  ],
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    getPoppinsTextSpanHeading(
                                        text: 'Item Description'),
                                    getPoppinsTextSpanDetails(
                                        text: pickListModel.description),
                                  ],
                                ),
                              ),
                            ],
                          )),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      getPoppinsTextSpanHeading(
                                          text: 'WHSE Code'),
                                      getPoppinsTextSpanDetails(
                                          text: pickListModel.whseCode),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      getPoppinsTextSpanHeading(
                                          text: 'Batch No.'),
                                      getPoppinsTextSpanDetails(
                                          text: pickListModel.batchNo),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      getPoppinsTextSpanHeading(
                                          text: 'Release Qty'),
                                      getPoppinsTextSpanDetails(
                                          text: pickListModel.releaseQty
                                              .toString()),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      getPoppinsTextSpanHeading(
                                          text: 'Picked Status'),
                                      getPoppinsTextSpanDetails(
                                          text: pickListModel.status),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                    ),
                    _buttonContainer(),
                  ],
                ),
              ),
            ),
          );
        }
        return const SizedBox(
          height: 0,
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
      height: 30,
      child: Row(
        children: [
          Expanded(
              child: InkWell(
            onTap: () {},
            child: getPoppinsText(
                text: 'Manual',
                color: appPrimary,
                fontSize: 13,
                fontWeight: FontWeight.bold),
          )),
          const VerticalDivider(
            color: Colors.grey,
            thickness: 1,
          ),
          Expanded(
              child: InkWell(
            onTap: () {
              ServiceManager.scanQRCode(onSuccess: (String scanResult) async {
                if (!mounted) return;
                String barCode = scanResult;
                if (barCode != '') {
                  print(barCode);
                  Get.back();
                  CustomSnackBar.successSnackBar('Scanned result: $barCode');
                  // if (await ServiceManager.isInternetAvailable()) {
                  //   ServiceManager.getItemDetails(
                  //       barCode: barCode,
                  //       onSuccess: onSuccess,
                  //       onError: onError);
                  // }
                }
              });
            },
            child: getPoppinsText(
                text: 'Scan',
                color: appPrimary,
                fontSize: 13,
                fontWeight: FontWeight.bold),
          )),
          // Expanded(
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Material(
          //       borderRadius: BorderRadius.circular(10.0),
          //       color: appPrimary,
          //       elevation: 0.0,
          //       child: MaterialButton(
          //         onPressed: () {},
          //         minWidth: MediaQuery.of(context).size.width,
          //         child: const Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             Icon(
          //               Icons.picture_as_pdf,
          //               color: Colors.white,
          //               size: 20,
          //             ),
          //             SizedBox(
          //               width: 10,
          //             ),
          //             Text(
          //               "Manual",
          //               textAlign: TextAlign.center,
          //               style: TextStyle(
          //                   color: Colors.white,
          //                   fontWeight: FontWeight.bold,
          //                   fontSize: 20.0),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          // Expanded(
          //   child: Padding(
          //     padding: const EdgeInsets.only(right: 8.0, bottom: 8, top: 8),
          //     child: Material(
          //       borderRadius: BorderRadius.circular(10.0),
          //       color: appPrimary,
          //       elevation: 0.0,
          //       child: MaterialButton(
          //         onPressed: () {
          //           ServiceManager.scanQRCode(
          //               onSuccess: (String scanResult) async {
          //             if (!mounted) return;
          //             String barCode = scanResult;
          //             if (barCode != '') {
          //               print(barCode);
          //               // if (await ServiceManager.isInternetAvailable()) {
          //               //   ServiceManager.getItemDetails(
          //               //       barCode: barCode,
          //               //       onSuccess: onSuccess,
          //               //       onError: onError);
          //               // }
          //             }
          //           });
          //         },
          //         minWidth: MediaQuery.of(context).size.width,
          //         child: const Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             Icon(
          //               Icons.qr_code_scanner,
          //               size: 20,
          //               color: Colors.white,
          //             ),
          //             SizedBox(
          //               width: 10,
          //             ),
          //             Text(
          //               "Scan",
          //               textAlign: TextAlign.center,
          //               style: TextStyle(
          //                   color: Colors.white,
          //                   fontWeight: FontWeight.bold,
          //                   fontSize: 20.0),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
