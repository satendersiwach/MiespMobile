import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner/theme/custom_colors.dart';
import 'package:scanner/theme/custom_snack_bar.dart';
import 'package:scanner/theme/custom_text_widgets.dart';
import 'package:scanner/theme/display_dialogbox.dart';
import 'package:scanner/theme/elements_screen.dart';
import 'package:scanner/theme/get_text_field.dart';
import 'package:scanner/ui/components/element_button.dart';

class AssignUserListScreen extends StatefulWidget {
  const AssignUserListScreen({super.key});

  @override
  State<AssignUserListScreen> createState() => _AssignUserListScreenState();
}

class _AssignUserListScreenState extends State<AssignUserListScreen> {
  final TextEditingController _query = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return screenWithAppBar(
        title: 'Select customer',
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              _searchContainer(),
              const SizedBox(
                height: 20,
              ),
              _unAssignedContainer(),
            ],
          ),
        ));
  }

  Widget _searchContainer() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: getTextField(
              controller: _query,
              labelText: 'Search customer',
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

  Widget _unAssignedContainer() {
    return ListView.separated(
      itemCount: 10,
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text.rich(
            TextSpan(
              children: [
                getPoppinsTextSpanHeading(text: 'User Code'),
                getPoppinsTextSpanDetails(text: 'HHT1'),
              ],
            ),
          ),
          subtitle: Text.rich(
            TextSpan(
              children: [
                getPoppinsTextSpanHeading(text: 'Name'),
                getPoppinsTextSpanDetails(text: 'ABC'),
              ],
            ),
          ),
          trailing: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                height: 30,
                width: 90,
                child: Material(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 0.0,
                  color: submitButtonColor,

                  clipBehavior: Clip.antiAlias,
                  child: MaterialButton(
                    onPressed: () async {
                      showLoaderDialog(context, text: 'Assigning');
                      await Future.delayed(const Duration(seconds: 1), () {
                        Get.back();
                        Get.back();
                        CustomSnackBar.successSnackBar('Pick lists assigned');
                      });
                    },
                    child: getPoppinsText(
                        text: 'Assign',
                        fontSize: 12,
                        color: white,
                        fontWeight: FontWeight.bold),
                  ),
                )),
          ),
        );
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
            margin: const EdgeInsets.all(16),
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
                                getPoppinsTextSpanHeading(text: 'User Code'),
                                getPoppinsTextSpanDetails(text: 'HHT1'),
                              ],
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                getPoppinsTextSpanHeading(text: 'Name'),
                                getPoppinsTextSpanDetails(text: 'ABC'),
                              ],
                            ),
                          ),
                        ],
                      )),
                      Expanded(
                          child: SizedBox(
                        height: MediaQuery.of(context).size.height / 22,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: appPrimary,
                            elevation: 0.0,
                            child: MaterialButton(
                              onPressed: () {},
                              minWidth: MediaQuery.of(context).size.width,
                              child: const Text(
                                "Assign",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                            ),
                          ),
                        ),
                      )),
                    ],
                  ),
                  // const SizedBox(
                  //   height: 8,
                  // ),
                  // Row(
                  //   children: [
                  //     // getPoppinsText(text: 'Assign',
                  //     // textAlign: TextAlign.start,
                  //     // fontSize: 13,
                  //     // fontWeight: FontWeight.bold),
                  //     // const SizedBox(width: 20,),
                  //     Expanded(
                  //       child: OutlinedButton(
                  //         onPressed: () {},
                  //         style: ButtonStyle(
                  //           backgroundColor: WidgetStateProperty.all(Colors.white),
                  //           side: WidgetStateProperty.all(
                  //               const BorderSide(color: appPrimary, width: 1.5)),
                  //           // Add outline
                  //           shape: WidgetStateProperty.all(
                  //             RoundedRectangleBorder(
                  //               borderRadius: BorderRadius.circular(
                  //                   8.0), // Optional: Adjust border radius
                  //             ),
                  //           ),
                  //         ),
                  //         child: getPoppinsText(
                  //             text: 'Assign',
                  //             color: appPrimary,
                  //             fontSize: 15,
                  //             fontWeight: FontWeight.bold),
                  //       ),
                  //     ),
                  //   ],
                  // )
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
}
