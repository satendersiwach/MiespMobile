import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner/common/get_formatted_date.dart';
import 'package:scanner/theme/custom_colors.dart';
import 'package:scanner/theme/custom_text_widgets.dart';

Widget getAssignedPickListUI() {
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
                          getPoppinsTextSpanDetails(text: '1'),
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
                          getPoppinsTextSpanHeading(text: 'Status'),
                          getPoppinsTextSpanDetails(text: 'Not Picked'),
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
                          getPoppinsTextSpanDetails(text: '1'),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          getPoppinsTextSpanHeading(text: 'Assigned To'),
                          getPoppinsTextSpanDetails(text: 'HHT1'),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          getPoppinsTextSpanHeading(text: 'Assigned Date'),
                          getPoppinsTextSpanDetails(
                              text: getFormattedDate(DateTime.now())),
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

Widget getUnassignedPickListUI() {
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
                          getPoppinsTextSpanDetails(text: '1'),
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
                          getPoppinsTextSpanDetails(text: '1'),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          getPoppinsTextSpanHeading(text: 'Status'),
                          getPoppinsTextSpanDetails(text: 'Not Picked'),
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
