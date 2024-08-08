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
    return screenWithAppBar(
        title: "Assigned Pick List",
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ))
        ],
        body: SingleChildScrollView(
          child: Column(
            children: [
              _list(),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buttonContainer(),
        ));
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
        backColor: submitButtonColor);
  }
}
