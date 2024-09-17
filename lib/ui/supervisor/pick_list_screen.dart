import 'package:flutter/material.dart';
import 'package:scanner/services/service_manager.dart';
import 'package:scanner/theme/custom_text_widgets.dart';
import 'package:scanner/theme/elements_screen.dart';
import 'package:scanner/ui/components/pick_list_ui.dart';

class PickListScreen extends StatefulWidget {
  const PickListScreen({super.key});

  @override
  State<PickListScreen> createState() => _PickListScreenState();
}

class _PickListScreenState extends State<PickListScreen> {
  List<String> optionList = ["All", "Assigned", "Unassigned"];
  String selectedOption = "Unassigned";

  @override
  Widget build(BuildContext context) {
    return screenWithAppBar(
      title: "Pick List",
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            _dropdownContainer(),
            const SizedBox(
              height: 10,
            ),
            if (selectedOption == "Unassigned") ...[_unAssignedContainer()],
            if (selectedOption == "Assigned") ...[
              _assignedContainer(),
            ],
            if (selectedOption == "All") ...[
              _allContainer(),
            ],
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      // bottomNavigationBar: SizedBox(
      //   height: Get.height / 12,
      //   child: Row(
      //     children: [
      //       Expanded(child: Container()),
      //       Expanded(
      //         flex: 2,
      //         child: Padding(
      //           padding: const EdgeInsets.all(8.0),
      //           child: Material(
      //             borderRadius: BorderRadius.circular(10.0),
      //             color: const Color(0XFFba532b),
      //             elevation: 0.0,
      //             child: MaterialButton(
      //               onPressed: () {
      //                 ServiceManager.scanQRCode(
      //                     onSuccess: (String scanResult) async {
      //                   if (!mounted) return;
      //                   String barCode = scanResult;
      //                   if (barCode != '-1') {
      //                     print(barCode);
      //                     // if (await ServiceManager.isInternetAvailable()) {
      //                     //   ServiceManager.getItemDetails(
      //                     //       barCode: barCode,
      //                     //       onSuccess: onSuccess,
      //                     //       onError: onError);
      //                     // }
      //                   }
      //                 });
      //               },
      //               minWidth: MediaQuery.of(context).size.width,
      //               child: const Row(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: [
      //                   Icon(
      //                     Icons.qr_code_scanner,
      //                     color: Colors.white,
      //                   ),
      //                   SizedBox(
      //                     width: 10,
      //                   ),
      //                   Text(
      //                     "Scan",
      //                     textAlign: TextAlign.center,
      //                     style: TextStyle(
      //                         color: Colors.white,
      //                         fontWeight: FontWeight.bold,
      //                         fontSize: 20.0),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
      //       Expanded(child: Container()),
      //     ],
      //   ),
      // ),
    );
  }

  Widget _unAssignedContainer() {
    return ListView.separated(
      itemCount: 3,
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return getUnassignedPickListUI();
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          thickness: 1.5,
          color: Colors.grey,
        );
      },
    );
  }

  Widget _assignedContainer() {
    return ListView.separated(
      itemCount: 3,
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return getAssignedPickListUI();
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          thickness: 1.5,
          color: Colors.grey,
        );
      },
    );
  }

  Widget _allContainer() {
    return ListView.separated(
      itemCount: 6,
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (index % 2 == 0) {
          return getAssignedPickListUI();
        } else {
          return getUnassignedPickListUI();
        }
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          thickness: 1.5,
          color: Colors.grey,
        );
      },
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

  Widget _dropdownContainer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: DropdownButtonFormField<String>(
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              selectedOption = newValue;
            });
          }
        },
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(top: 2),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)),
        ),
        elevation: 0,
        isDense: false,
        autofocus: false,
        hint: optionList.contains(selectedOption)
            ? null
            : const Center(
                child: Text(
                  'Select',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
        value: optionList.contains(selectedOption) ? selectedOption : null,
        padding: const EdgeInsets.only(left: 16),
        borderRadius: BorderRadius.circular(15),
        items: optionList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 145),
              // Set a maximum width
              child: Text(
                value,
                overflow: TextOverflow.clip,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }).toList(),
      ),
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
