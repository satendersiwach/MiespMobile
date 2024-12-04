import 'package:flutter/material.dart';
import 'package:scanner/common/get_formatted_date.dart';
import 'package:scanner/theme/custom_colors.dart';
import 'package:scanner/theme/custom_text_widgets.dart';
import 'package:scanner/theme/elements_screen.dart';
import 'package:scanner/ui/components/element_button.dart';

class AssignedPickListScreen extends StatefulWidget {
  const AssignedPickListScreen({super.key});

  @override
  State<AssignedPickListScreen> createState() => _AssignedPickListScreenState();
}

class _AssignedPickListScreenState extends State<AssignedPickListScreen> {
  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: Column(
        children: [
          _list(),
        ],
      ),
    );
  }

  Widget _list() {
    //api/picklist/getpicklistbystatus?status=O
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
                                getPoppinsTextSpanHeading(
                                    text: 'Assigned Date'),
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
                  // SizedBox(
                  //   height: 28,
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //           child: InkWell(
                  //             onTap: (){
                  //               //todo:
                  //               //api/picklist/UpdatePickList
                  //               // model : Remove
                  //             },
                  //         child: getPoppinsText(
                  //             text: 'Add',
                  //             color: Colors.red,
                  //             fontSize: 13,
                  //             fontWeight: FontWeight.bold),
                  //       )),
                  //       const VerticalDivider(
                  //         color: Colors.grey,
                  //         thickness: 1,
                  //       ),
                  //       Expanded(
                  //           child: InkWell(
                  //             onTap: (){
                  //               //todo:
                  //               //api/picklist/UpdatePickList
                  //               // model : Update
                  //             },
                  //         child: getPoppinsText(
                  //             text: 'Update',
                  //             color: appPrimary,
                  //             fontSize: 13,
                  //             fontWeight: FontWeight.bold),
                  //       )),
                  //     ],
                  //   ),
                  // )
                  SizedBox(
                    height: 28,
                    child: Row(
                      children: [
                        // Expanded(
                        //     child: InkWell(
                        //       onTap: (){
                        //         //todo:
                        //         //api/picklist/UpdatePickList
                        //         // model : Remove
                        //       },
                        //   child: getPoppinsText(
                        //       text: 'Add',
                        //       color: Colors.red,
                        //       fontSize: 13,
                        //       fontWeight: FontWeight.bold),
                        // )),
                        // const VerticalDivider(
                        //   color: Colors.grey,
                        //   thickness: 1,
                        // ),
                        Expanded(
                            child: InkWell(
                              onTap: (){
                                //todo:
                                //api/picklist/UpdatePickList
                                /// call /master/getusers to get user and then assign only for one user
                              },
                          child: getPoppinsText(
                              text: 'Assign',
                              color: appPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        )),
                      ],
                    ),
                  )
                ],
              ),
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
    return loadingButton(
        isLoading: false,
        btnText: 'Submit',
        onPress: () {},
        backColor: appPrimary);
  }
}
