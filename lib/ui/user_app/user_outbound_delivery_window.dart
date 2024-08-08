import 'package:flutter/material.dart';
import 'package:scanner/services/service_manager.dart';
import 'package:scanner/theme/custom_colors.dart';
import 'package:scanner/theme/custom_text_widgets.dart';

class UserOutboundDeliveryWindow extends StatefulWidget {
  const UserOutboundDeliveryWindow({super.key});

  @override
  State<UserOutboundDeliveryWindow> createState() =>
      _UserOutboundDeliveryWindowState();
}

class _UserOutboundDeliveryWindowState
    extends State<UserOutboundDeliveryWindow> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          _assignCountContainer(),
          const SizedBox(
            height: 10,
          ),
          _list(),
        ],
      ),
    );
  }

  Widget _assignCountContainer() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                const Divider(
                  thickness: 1.5,
                  color: Colors.grey,
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
      height: 35,
      child: Row(
        children: [
          Expanded(
              child: TextButton(
            onPressed: () {},
            child: getPoppinsText(
                text: 'Manual',
                color: appPrimary,
                fontSize: 13,
                fontWeight: FontWeight.bold),
          )),
          Expanded(
              child: TextButton(
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
          //             if (barCode != '-1') {
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
