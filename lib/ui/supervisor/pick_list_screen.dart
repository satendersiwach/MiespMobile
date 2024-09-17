import 'package:flutter/material.dart';
import 'package:scanner/model/pick_list_model.dart';
import 'package:scanner/theme/custom_colors.dart';
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
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return screenWithAppBar(
        title: "Pick List",
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ))
        ],
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
        bottomNavigationBar: _assignButtonContainer());
  }

  Widget _assignButtonContainer() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 13,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          borderRadius: BorderRadius.circular(10.0),
          color: appPrimary,
          elevation: 0.0,
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : MaterialButton(
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
    );
  }

  Widget _unAssignedContainer() {
    return ListView.separated(
      itemCount: 3,
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        PickListModel pickListModel = pickLists[index];
        return CheckboxListTile(
          value: pickListModel.checked,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          onChanged: (bool? value) {
            setState(() {
              pickListModel.checked = value ?? !pickListModel.checked;
            });
          },
          checkColor: Colors.white,
          activeColor: appPrimary,
          title: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: getUnassignedPickListUI(pickListModel: pickListModel),
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

  Widget _assignedContainer() {
    return ListView.separated(
      itemCount: pickLists.length,
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        PickListModel pickListModel = pickLists[index];
        return CheckboxListTile(
          value: pickListModel.checked,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          onChanged: (bool? value) {
            setState(() {
              pickListModel.checked = value ?? !pickListModel.checked;
            });
          },
          checkColor: Colors.white,
          activeColor: appPrimary,
          title: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: getAssignedPickListUI(pickListModel: pickListModel),
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

  Widget _allContainer() {
    return ListView.separated(
      itemCount: 6,
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        PickListModel pickListModel = pickLists[index];
        if (index % 2 == 0) {
          return CheckboxListTile(
            value: pickListModel.checked,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            onChanged: (bool? value) {
              setState(() {
                pickListModel.checked = value ?? !pickListModel.checked;
              });
            },
            checkColor: Colors.white,
            activeColor: appPrimary,
            title: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: getAssignedPickListUI(pickListModel: pickListModel),
            ),
          );
        } else {
          return CheckboxListTile(
            value: pickListModel.checked,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            onChanged: (bool? value) {
              setState(() {
                pickListModel.checked = value ?? !pickListModel.checked;
              });
            },
            checkColor: Colors.white,
            activeColor: appPrimary,
            title: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: getUnassignedPickListUI(pickListModel: pickListModel),
            ),
          );
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
              for (PickListModel pickListModel in pickLists) {
                pickListModel.checked = false;
              }
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
}
