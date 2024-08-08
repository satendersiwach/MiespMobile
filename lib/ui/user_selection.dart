
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner/common/keys.dart';
import 'package:scanner/local_storage/local_storage.dart';
import 'package:scanner/theme/custom_text_widgets.dart';
import 'package:scanner/theme/elements_screen.dart';
import 'package:scanner/ui/components/element_button.dart';
import 'package:scanner/ui/dashboard.dart';

class UserSelection extends StatefulWidget {


  const UserSelection({super.key, });

  @override
  State<UserSelection> createState() => _UserSelectionState();
}

class _UserSelectionState extends State<UserSelection> {
  String selectedUserType = 'Supervisor';
  List<String> userTypeList = ['Supervisor', 'User'];

  @override
  Widget build(BuildContext context) {
    return screenWithAppBar(
        title: 'Select User Type',
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            getHeadingText(text: 'User Type'),
            const SizedBox(
              height: 20,
            ),
            Align(alignment: Alignment.center, child: _dropdownButton()),
          ],
        ),
        bottomNavigationBar: _buttonContainer());
  }

  Widget _dropdownButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 15),
      child: SizedBox(
        width: Get.width / 3,
        child: DropdownButton<String>(
          isExpanded: true,
          items: userTypeList.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (val) {
            setState(() {
              // EmployeeData.ApprovalStatus = val!;
              selectedUserType = val!;
            });
          },
          borderRadius: BorderRadius.circular(10),
          value: selectedUserType,
        ),
      ),
    );
  }

  Widget _buttonContainer() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 13,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: loadingButton(
          isLoading: false,
          btnText: 'Save',
          onPress: _onSave,
        ),
      ),
    );
  }

  _onSave() {
    LocalStorage.setString(key: keyUserType,value: selectedUserType);
    Get.to(() => const Dashboard());
  }
}