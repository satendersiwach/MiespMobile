import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner/common/enums.dart';
import 'package:scanner/common/get_formatted_date.dart';
import 'package:scanner/controllers/super_admin_controller.dart';
import 'package:scanner/local_storage/local_storage.dart';
import 'package:scanner/models/pick_list_model.dart';
import 'package:scanner/theme/custom_colors.dart';
import 'package:scanner/theme/custom_snack_bar.dart';
import 'package:scanner/theme/custom_text_widgets.dart';
import 'package:scanner/theme/elements_screen.dart';
import 'package:scanner/ui/components/element_button.dart';
import 'package:scanner/ui/login_screen.dart';
import 'package:scanner/ui/supervisor/assign_pick_list_to_user_screen.dart';

class SuperAdminDashboard extends StatefulWidget {
  const SuperAdminDashboard({super.key});

  @override
  State<SuperAdminDashboard> createState() => _SuperAdminDashboardState();
}

class _SuperAdminDashboardState extends State<SuperAdminDashboard> {
  final SuperAdminController _controller = Get.put(SuperAdminController());

  @override
  Widget build(BuildContext context) {
    return screenWithAppBar(
        title: 'Scanner App',
        isBackVisible: false,
        actions: [
          IconButton(
              onPressed: () => _showLogoutDialog(context),
              icon: const Icon(Icons.logout, color: Colors.red)),
        ],
        body: SingleChildScrollView(
          child: Column(
            children: [
              _statusFilterWidget(),
              Obx(() {
                if (_controller.isLoading.value) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: CircularProgressIndicator(),
                  );
                }
                return _list();
              }),
            ],
          ),
        ),
        bottomNavigationBar: Obx(() => _buttonContainer()));
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(children: [
          getPoppinsText(
              text: 'Logout',
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ]),
        content: getPoppinsText(
            text: 'Are you sure you want to logout?',
            textAlign: TextAlign.start,
            fontSize: 15,
            fontWeight: FontWeight.w500),
        actions: [
          Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      LocalStorage.logout();
                      Get.offAll(() => const LoginPage());
                    },
                    child: getPoppinsText(
                        text: 'Logout',
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: getPoppinsText(
                        text: 'No',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: appPrimary),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _statusFilterWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: getInterText(
              text: 'Picklist Status',
              textAlign: TextAlign.left,
              color: const Color(0XFF0F3C4D),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 15, right: 15),
            child: SizedBox(
              width: Get.width / 4,
              child: Obx(() => DropdownButton<PickListStatusEnumForAdmin>(
                    value: _controller.pickListStatusEnum.value,
                    onChanged: (newValue) {
                      if (newValue != null) {
                        _controller.updateStatusFilter(newValue);
                      }
                    },
                    items: PickListStatusEnumForAdmin.values
                        .map((value) => DropdownMenuItem(
                              value: value,
                              child: Text(getEnumLabel(value)),
                            ))
                        .toList(),
                    borderRadius: BorderRadius.circular(10),
                  )),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buttonContainer() {
    if (_controller.pickList.isEmpty ||
        _controller.pickListStatusEnum.value ==
            PickListStatusEnumForAdmin.closed ||
        _controller.pickListStatusEnum.value ==
            PickListStatusEnumForAdmin.all) {
      return const SizedBox(height: 0, width: 0);
    }
    return SizedBox(
      height: Get.height / 13,
      child: Row(
        children: [
          if (_controller.pickListStatusEnum.value ==
              PickListStatusEnumForAdmin.assigned) ...[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: loadingButton(
                    isLoading: false,
                    btnText: 'Remove',
                    onPress: () {
                      if (!_controller.atLeastOneSelected()) {
                        CustomSnackBar.errorSnackBar(
                            'Please select at least one Pick List');
                      } else {
                        _showRemoveDialog(
                          context,
                          'Are you sure you want to remove this picklist?',
                          () {
                            Get.back();
                            _controller.removeSelectedPickLists();
                          },
                        );
                      }
                    },
                    backColor: appPrimary),
              ),
            ),
            const VerticalDivider(color: Colors.grey, thickness: 1),
          ],
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: loadingButton(
                  isLoading: false,
                  btnText: _controller.pickListStatusEnum.value ==
                          PickListStatusEnumForAdmin.assigned
                      ? 'Reassign'
                      : 'Assign',
                  onPress: () {
                    if (!_controller.atLeastOneSelected()) {
                      CustomSnackBar.errorSnackBar(
                          'Please select at least one Pick List');
                    } else {
                      Get.to(() => AssignPicklistToUserScreen(
                                pickList: _controller.selectedPickLists,
                                mode: _controller.pickListStatusEnum.value ==
                                        PickListStatusEnumForAdmin.assigned
                                    ? Mode.update
                                    : Mode.add,
                              ))
                          ?.then((_) => _controller.fetchData());
                    }
                  },
                  backColor: appPrimary),
            ),
          ),
        ],
      ),
    );
  }

  void _showRemoveDialog(
      BuildContext context, String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(children: [
          getPoppinsText(
              text: 'Remove',
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ]),
        content: getPoppinsText(
            text: message,
            textAlign: TextAlign.start,
            fontSize: 15,
            fontWeight: FontWeight.w500),
        actions: [
          Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: onConfirm,
                    child: getPoppinsText(
                        text: 'Remove',
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: getPoppinsText(
                        text: 'No',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: appPrimary),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _list() {
    return Obx(() => ListView.separated(
          itemCount: _controller.pickList.length,
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            PickListModel pickListModel = _controller.pickList[index];
            String btnTxt =
                pickListModel.status == 'A' ? 'Reassign' : 'Assign';
            return CheckboxListTile(
              value: pickListModel.isSelected,
              onChanged: (_) => _controller.toggleSelection(index),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: const EdgeInsets.only(left: 8),
              title: Container(
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
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(TextSpan(children: [
                                getPoppinsTextSpanHeading(text: 'Pick List id'),
                                getPoppinsTextSpanDetails(
                                    text: pickListModel.absEntry.toString()),
                              ])),
                              Text.rich(TextSpan(children: [
                                getPoppinsTextSpanHeading(text: 'SO Id'),
                                getPoppinsTextSpanDetails(
                                    text: pickListModel.docEntry.toString()),
                              ])),
                              Text.rich(TextSpan(children: [
                                getPoppinsTextSpanHeading(text: 'Status'),
                                getPoppinsTextSpanDetails(
                                    text: pickListModel.status),
                              ])),
                            ],
                          )),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(TextSpan(children: [
                                getPoppinsTextSpanHeading(text: 'Total Items'),
                                getPoppinsTextSpanDetails(
                                    text:
                                        pickListModel.totalItems.toString()),
                              ])),
                              Text.rich(TextSpan(children: [
                                getPoppinsTextSpanHeading(text: 'Assigned To'),
                                getPoppinsTextSpanDetails(
                                    text: pickListModel.uUser),
                              ])),
                              Text.rich(TextSpan(children: [
                                getPoppinsTextSpanHeading(
                                    text: 'Assigned Date'),
                                getPoppinsTextSpanDetails(
                                    text: getFormattedDateAndTime(
                                        pickListModel.uAssignDate)),
                              ])),
                            ],
                          )),
                        ],
                      ),
                      if (_controller.pickListStatusEnum.value ==
                              PickListStatusEnumForAdmin.assigned ||
                          _controller.pickListStatusEnum.value ==
                              PickListStatusEnumForAdmin.open) ...[
                        const Divider(color: Colors.grey, thickness: 1),
                        SizedBox(
                          height: 28,
                          child: Row(
                            children: [
                              if (_controller.pickListStatusEnum.value ==
                                  PickListStatusEnumForAdmin.assigned) ...[
                                Expanded(
                                    child: InkWell(
                                  onTap: () => _showRemoveDialog(
                                    context,
                                    'Are you sure you want to remove this picklist?',
                                    () {
                                      Get.back();
                                      _controller
                                          .removeSinglePickList(pickListModel);
                                    },
                                  ),
                                  child: getPoppinsText(
                                      text: 'Remove',
                                      color: Colors.red,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                )),
                                const VerticalDivider(
                                    color: Colors.grey, thickness: 1),
                              ],
                              Expanded(
                                  child: InkWell(
                                onTap: () {
                                  Get.to(() => AssignPicklistToUserScreen(
                                            pickList: [pickListModel],
                                            mode: _controller
                                                        .pickListStatusEnum
                                                        .value ==
                                                    PickListStatusEnumForAdmin
                                                        .assigned
                                                ? Mode.update
                                                : Mode.add,
                                          ))
                                      ?.then((_) => _controller.fetchData());
                                },
                                child: getPoppinsText(
                                    text: btnTxt,
                                    color: appPrimary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              )),
                            ],
                          ),
                        )
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) =>
              const Divider(thickness: 1.5, color: Colors.grey),
        ));
  }
}
