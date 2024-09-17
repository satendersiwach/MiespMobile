import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner/common/get_formatted_date.dart';
import 'package:scanner/model/pick_list_model.dart';
import 'package:scanner/services/service_manager.dart';
import 'package:scanner/theme/custom_colors.dart';
import 'package:scanner/theme/custom_text_widgets.dart';

Widget getAssignedPickListUI({required PickListModel pickListModel}) {
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
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
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
                          getPoppinsTextSpanDetails(
                              text: pickListModel.id.toString()),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          getPoppinsTextSpanHeading(text: 'SO Id'),
                          getPoppinsTextSpanDetails(
                              text: pickListModel.soId?.toString() ?? ''),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          getPoppinsTextSpanHeading(text: 'Status'),
                          getPoppinsTextSpanDetails(
                              text: pickListModel.pickedStatus ?? ''),
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
                          getPoppinsTextSpanHeading(text: 'Total Items'),
                          getPoppinsTextSpanDetails(
                              text: pickListModel.totalItems.toString()),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          getPoppinsTextSpanHeading(text: 'Assigned To'),
                          getPoppinsTextSpanDetails(
                              text: pickListModel.assignedTo ?? ''),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          getPoppinsTextSpanHeading(text: 'Assigned Date'),
                          getPoppinsTextSpanDetails(
                              text:
                                  getFormattedDate(pickListModel.assignedDate)),
                        ],
                      ),
                    ),
                  ],
                )),
              ],
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: InkWell(
                  child: getPoppinsText(
                      text: 'Remove',
                      color: appPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                )),
                Expanded(
                    child: InkWell(
                  child: getPoppinsText(
                      text: 'Update',
                      color: appPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                )),
              ],
            )
          ],
        ),
      ),
    ),
  );
}

Widget getUnassignedPickListUI({required PickListModel pickListModel}) {
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
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
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
                          getPoppinsTextSpanDetails(
                              text: pickListModel.id.toString()),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          getPoppinsTextSpanHeading(text: 'SO Id'),
                          getPoppinsTextSpanDetails(
                              text: pickListModel.soId?.toString() ?? ''),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          getPoppinsTextSpanHeading(text: 'Status'),
                          getPoppinsTextSpanDetails(
                              text: pickListModel.pickedStatus ?? ''),
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
                          getPoppinsTextSpanHeading(text: 'Total Items'),
                          getPoppinsTextSpanDetails(
                              text: pickListModel.totalItems.toString()),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          getPoppinsTextSpanHeading(text: 'Assigned To'),
                          getPoppinsTextSpanDetails(
                              text: pickListModel.assignedTo ?? ''),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          getPoppinsTextSpanHeading(text: 'Assigned Date'),
                          getPoppinsTextSpanDetails(
                              text:
                                  getFormattedDate(pickListModel.assignedDate)),
                        ],
                      ),
                    ),
                  ],
                )),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                // getPoppinsText(text: 'Assign',
                // textAlign: TextAlign.start,
                // fontSize: 13,
                // fontWeight: FontWeight.bold),
                // const SizedBox(width: 20,),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.white),
                      side: WidgetStateProperty.all(
                          const BorderSide(color: appPrimary, width: 1.5)),
                      // Add outline
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8.0), // Optional: Adjust border radius
                        ),
                      ),
                    ),
                    child: getPoppinsText(
                        text: 'Assign',
                        color: appPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}

Widget getUnScannedPickListUI({required PickListModel pickListModel}) {
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
      width: Get.size.width,
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
                          getPoppinsTextSpanDetails(
                              text: pickListModel.id.toString()),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          getPoppinsTextSpanHeading(text: 'Item Code'),
                          getPoppinsTextSpanDetails(
                              text: pickListModel.itemCode),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          getPoppinsTextSpanHeading(text: 'SO Id'),
                          getPoppinsTextSpanDetails(
                              text: pickListModel.soId.toString()),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          getPoppinsTextSpanHeading(text: 'Item Description'),
                          getPoppinsTextSpanDetails(
                              text: pickListModel.description),
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
                          getPoppinsTextSpanDetails(
                              text: pickListModel.whseCode),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          getPoppinsTextSpanHeading(text: 'Batch No.'),
                          getPoppinsTextSpanDetails(
                              text: pickListModel.batchNumber),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          getPoppinsTextSpanHeading(text: 'Release Qty'),
                          getPoppinsTextSpanDetails(
                              text: pickListModel.releaseQty
                                      ?.toStringAsFixed(2) ??
                                  "0.0"),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          getPoppinsTextSpanHeading(text: 'Picked Status'),
                          getPoppinsTextSpanDetails(
                              text: pickListModel.pickedStatus),
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
          SizedBox(
            height: 60,
            child: Row(
              children: [
                // Expanded(
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Material(
                //       borderRadius: BorderRadius.circular(10.0),
                //       color: const Color(0XFFba532b),
                //       elevation: 0.0,
                //       child: MaterialButton(
                //         onPressed: () {},
                //         minWidth: Get.size.width,
                //         child: const Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             Icon(Icons.picture_as_pdf, color: Colors.white),
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
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(right: 8.0, bottom: 8, top: 8),
                    child: Material(
                      borderRadius: BorderRadius.circular(10.0),
                      color: const Color(0XFFba532b),
                      elevation: 0.0,
                      child: MaterialButton(
                        onPressed: () {
                          ServiceManager.scanQRCode(
                              onSuccess: (String scanResult) async {
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
                        minWidth: Get.size.width,
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
          ),
        ],
      ),
    ),
  );
}

Widget getScannedPickListUI({required PickListModel pickListModel}) {
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
      width: Get.size.width,
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
                          getPoppinsTextSpanDetails(
                              text: pickListModel.id.toString()),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          getPoppinsTextSpanHeading(text: 'Item Code'),
                          getPoppinsTextSpanDetails(
                              text: pickListModel.itemCode),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          getPoppinsTextSpanHeading(text: 'SO Id'),
                          getPoppinsTextSpanDetails(
                              text: pickListModel.soId.toString()),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          getPoppinsTextSpanHeading(text: 'Item Description'),
                          getPoppinsTextSpanDetails(
                              text: pickListModel.description),
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
                          getPoppinsTextSpanDetails(
                              text: pickListModel.whseCode),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          getPoppinsTextSpanHeading(text: 'Batch No.'),
                          getPoppinsTextSpanDetails(
                              text: pickListModel.batchNumber),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          getPoppinsTextSpanHeading(text: 'Release Qty'),
                          getPoppinsTextSpanDetails(
                              text: pickListModel.releaseQty
                                      ?.toStringAsFixed(2) ??
                                  "0.0"),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          getPoppinsTextSpanHeading(text: 'Picked Status'),
                          getPoppinsTextSpanDetails(
                              text: pickListModel.pickedStatus),
                        ],
                      ),
                    ),
                  ],
                )),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
