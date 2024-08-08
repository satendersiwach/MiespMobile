import 'package:flutter/material.dart';
import 'package:scanner/theme/custom_colors.dart';
import 'package:scanner/theme/custom_text_widgets.dart';
import 'package:scanner/theme/elements_screen.dart';
import 'package:scanner/ui/components/element_button.dart';

class AssignPickListScreen extends StatefulWidget {
  const AssignPickListScreen({super.key});

  @override
  State<AssignPickListScreen> createState() => _AssignPickListScreenState();
}

class _AssignPickListScreenState extends State<AssignPickListScreen> {
  @override
  Widget build(BuildContext context) {
    return screenWithAppBar(
        title: "Assign Pick List",
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ))
        ],
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                _list(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buttonContainer(),
        ));
  }

  Widget _list() {
    return GridView.builder(
      itemCount: 3,
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container(
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
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
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
                const SizedBox(
                  height: 8,
                ),
                const Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
                Align(
                  alignment: Alignment.center,
                  child: getPoppinsText(
                      text: 'Assign',
                      color: appPrimary,
                      textAlign: TextAlign.center,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 4 / 3),
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
