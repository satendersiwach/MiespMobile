import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:scanner/model/pick_list_model.dart';
import 'package:scanner/theme/custom_colors.dart';
import 'package:scanner/theme/custom_text_widgets.dart';
import 'package:scanner/ui/components/pick_list_ui.dart';

class OutboundDeliveryWindow extends StatefulWidget {
  const OutboundDeliveryWindow({super.key});

  @override
  State<OutboundDeliveryWindow> createState() => _OutboundDeliveryWindowState();
}

class _OutboundDeliveryWindowState extends State<OutboundDeliveryWindow> {
  // List<String> optionList = ["All", "Selected"];
  // String selectedOption = "Selected";
  List<PickListModel?> selectedPickList = [];

  @override
  void initState() {
    super.initState();
    selectedPickList = [pickLists[0]];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
            elevation: 10.0,
            backgroundColor: appPrimary,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(Get.height / 4.2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14.0,
                    ),
                    child: getPoppinsText(
                        text: 'Pick List(19)',
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  _pickListMultiSelection(),
                  const SizedBox(
                    height: 10,
                  ),
                  TabBar(
                    indicator: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        color: Colors.white),
                    labelColor: appPrimary,
                    indicatorSize: TabBarIndicatorSize.tab,
                    unselectedLabelColor: Colors.white,
                    labelStyle:
                        GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    tabs: const [
                      Tab(
                          child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Scanned",
                        ),
                      )),
                      Tab(
                          child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Un-Scanned",
                        ),
                      )),
                    ],
                  ),
                ],
              ),
            ),
            title: getHeadingText(
                text: "Outbound Delivery", color: headColor, fontSize: 20)),
        body: TabBarView(
          children: [
            _scannedPickList(),
            _unScannedPickList(),
          ],
        ),
      ),
    );
  }

  Widget _pickListMultiSelection() {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
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
            textStyle: GoogleFonts.poppins(
              color: submitButtonColor,
              fontWeight: FontWeight.w900,
            ),
            scroll: true,
          ),
          buttonText: getInterText(
              text: 'Select',
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400),
          buttonIcon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
            size: 30,
          ),
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

  Widget _scannedPickList() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ListView.separated(
        itemCount: pickLists.length,
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return getScannedPickListUI(pickListModel: pickLists[index]);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            thickness: 1.5,
            color: Colors.grey,
          );
        },
      ),
    );
  }

  Widget _unScannedPickList() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ListView.separated(
        itemCount: pickLists.length,
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return getUnScannedPickListUI(pickListModel: pickLists[index]);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            thickness: 1.5,
            color: Colors.grey,
          );
        },
      ),
    );
  }
}
