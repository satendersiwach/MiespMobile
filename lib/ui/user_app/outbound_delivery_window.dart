import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:scanner/model/pick_list_model.dart';
import 'package:scanner/services/service_manager.dart';
import 'package:scanner/theme/custom_colors.dart';
import 'package:scanner/theme/custom_text_widgets.dart';
import 'package:scanner/theme/elements_screen.dart';

class OutboundDeliveryWindow extends StatefulWidget {
  const OutboundDeliveryWindow({super.key});

  @override
  State<OutboundDeliveryWindow> createState() => _OutboundDeliveryWindowState();
}

class _OutboundDeliveryWindowState extends State<OutboundDeliveryWindow> {
  // List<String> optionList = ["All", "Selected"];
  // String selectedOption = "Selected";
  List<PickListModel?> selectedPickList = [];
  List<PickListModel> pickLists = [
    PickListModel(
      id: 1,
      itemCode: "ITEM001",
      description: "Item 1 Description",
      soId: 1001,
      whseCode: "WH001",
      batchNumber: "BATCH001",
      releaseQty: 10.5,
      pickedStatus: "Picked",
    ),
    PickListModel(
      id: 2,
      itemCode: "ITEM002",
      description: "Item 2 Description",
      soId: 1002,
      whseCode: "WH002",
      batchNumber: "BATCH002",
      releaseQty: 8.0,
      pickedStatus: "Not Picked",
    ),
    PickListModel(
      id: 3,
      itemCode: "ITEM003",
      description: "Item 3 Description",
      soId: 1003,
      whseCode: "WH001",
      batchNumber: "BATCH003",
      releaseQty: 15.0,
      pickedStatus: "Picked",
    ),
    PickListModel(
      id: 4,
      itemCode: "ITEM004",
      description: "Item 4 Description",
      soId: 1004,
      whseCode: "WH003",
      batchNumber: "BATCH004",
      releaseQty: 6.5,
      pickedStatus: "Not Picked",
    ),
    PickListModel(
      id: 5,
      itemCode: "ITEM005",
      description: "Item 5 Description",
      soId: 1005,
      whseCode: "WH002",
      batchNumber: "BATCH005",
      releaseQty: 12.0,
      pickedStatus: "Picked",
    ),
    PickListModel(
      id: 6,
      itemCode: "ITEM006",
      description: "Item 6 Description",
      soId: 1006,
      whseCode: "WH001",
      batchNumber: "BATCH006",
      releaseQty: 7.0,
      pickedStatus: "Not Picked",
    ),
    PickListModel(
      id: 7,
      itemCode: "ITEM007",
      description: "Item 7 Description",
      soId: 1007,
      whseCode: "WH003",
      batchNumber: "BATCH007",
      releaseQty: 20.0,
      pickedStatus: "Picked",
    ),
    PickListModel(
      id: 8,
      itemCode: "ITEM008",
      description: "Item 8 Description",
      soId: 1008,
      whseCode: "WH002",
      batchNumber: "BATCH008",
      releaseQty: 5.5,
      pickedStatus: "Not Picked",
    ),
    PickListModel(
      id: 9,
      itemCode: "ITEM009",
      description: "Item 9 Description",
      soId: 1009,
      whseCode: "WH001",
      batchNumber: "BATCH009",
      releaseQty: 18.0,
      pickedStatus: "Picked",
    ),
    PickListModel(
      id: 10,
      itemCode: "ITEM010",
      description: "Item 10 Description",
      soId: 1010,
      whseCode: "WH003",
      batchNumber: "BATCH010",
      releaseQty: 9.0,
      pickedStatus: "Not Picked",
    ),
  ];

  @override
  void initState() {
    super.initState();
    selectedPickList = [pickLists[0]];
  }

  @override
  Widget build(BuildContext context) {
    return screenWithAppBar(
      title: "Outbound Delivery",
      actions: [
        IconButton(
            onPressed: () {},
            icon: Icon(
              MdiIcons.refresh,
              color: Colors.white,
            ))
      ],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),

            // _dropdownContainer(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 16),
              child: getPoppinsText(
                  text: 'Pick List(19)',
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
            _pickListMultiSelection(),
            _list(),
          ],
        ),
      ),
    );
  }

  Widget _pickListMultiSelection() {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: MultiSelectDialogField<PickListModel?>(
          items: pickLists
              .map((hotel) => MultiSelectItem<PickListModel?>(
                  hotel, '${hotel.id}-${hotel.itemCode}'))
              .toList(),
          dialogHeight: Get.height / 5,
          selectedColor: appPrimary,
          initialValue: selectedPickList,
          chipDisplay: MultiSelectChipDisplay(
            chipColor: appPrimary,
            textStyle: const TextStyle(color: Colors.white),
          ),
          buttonText: getInterText(
              text: 'Select',
              color: const Color(0XFF292929),
              fontSize: 16,
              fontWeight: FontWeight.w400),
          buttonIcon: const Icon(
            Icons.arrow_drop_down,
            size: 30,
          ),
          decoration: BoxDecoration(border: Border.all(color: Colors.white)),
          onConfirm: (List<PickListModel?> results) {
            setState(() {
              selectedPickList = results;
            });
          },
        ));
  }

  // Widget _dropdownContainer() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(8),
  //       color: Colors.white,
  //     ),
  //     margin: const EdgeInsets.symmetric(horizontal: 15),
  //     child: DropdownButtonFormField<String>(
  //       onChanged: (String? newValue) {
  //         if (newValue != null) {
  //           setState(() {
  //             selectedOption = newValue;
  //           });
  //         }
  //       },
  //       decoration: const InputDecoration(
  //         contentPadding: EdgeInsets.only(top: 2),
  //         focusedBorder: UnderlineInputBorder(
  //             borderSide: BorderSide(color: Colors.transparent)),
  //         enabledBorder: UnderlineInputBorder(
  //             borderSide: BorderSide(color: Colors.transparent)),
  //       ),
  //       elevation: 0,
  //       isDense: false,
  //       autofocus: false,
  //       hint: optionList.contains(selectedOption)
  //           ? null
  //           : const Center(
  //               child: Text(
  //                 'Select',
  //                 style: TextStyle(
  //                     color: Colors.black, fontWeight: FontWeight.bold),
  //               ),
  //             ),
  //       value: optionList.contains(selectedOption) ? selectedOption : null,
  //       padding: const EdgeInsets.only(left: 16),
  //       borderRadius: BorderRadius.circular(15),
  //       items: optionList.map<DropdownMenuItem<String>>((String value) {
  //         return DropdownMenuItem<String>(
  //           value: value,
  //           child: Container(
  //             constraints: const BoxConstraints(maxWidth: 145),
  //             // Set a maximum width
  //             child: Text(
  //               value,
  //               overflow: TextOverflow.clip,
  //               style:
  //                   const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
  //             ),
  //           ),
  //         );
  //       }).toList(),
  //     ),
  //   );
  // }

  Widget _assignCountContainer() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: getPoppinsText(
            text: 'You have 19 Pick List assigned',
            fontWeight: FontWeight.w700,
            fontSize: 20),
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
                _buttonContainer(),
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
      height: 60,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                borderRadius: BorderRadius.circular(10.0),
                color: const Color(0XFFba532b),
                elevation: 0.0,
                child: MaterialButton(
                  onPressed: () {},
                  minWidth: MediaQuery.of(context).size.width,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.picture_as_pdf, color: Colors.white),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Manual",
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0, bottom: 8, top: 8),
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
        ],
      ),
    );
  }
}
