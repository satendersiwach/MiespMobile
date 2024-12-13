import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner/common/enums.dart';
import 'package:scanner/common/get_formatted_date.dart';
import 'package:scanner/local_storage/local_storage.dart';
import 'package:scanner/models/pick_list_model.dart';
import 'package:scanner/models/update_pick_list_model.dart';
import 'package:scanner/services/service_manager.dart';
import 'package:scanner/theme/custom_colors.dart';
import 'package:scanner/theme/custom_snack_bar.dart';
import 'package:scanner/theme/custom_text_widgets.dart';
import 'package:scanner/theme/elements_screen.dart';
import 'package:scanner/ui/components/element_button.dart';
import 'package:scanner/ui/components/element_common_widget.dart';
import 'package:scanner/ui/login_screen.dart';
import 'package:scanner/ui/supervisor/assign_pick_list_to_user_screen.dart';

class SuperAdminDashboard extends StatefulWidget {
  const SuperAdminDashboard({super.key});

  @override
  State<SuperAdminDashboard> createState() => _SuperAdminDashboardState();
}

class _SuperAdminDashboardState extends State<SuperAdminDashboard> {
  List<PickListModel> pickList = [];
  PickListStatusEnum pickListStatusEnum = PickListStatusEnum.open;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    setData();
  }

  setData() async {
    _isLoading = true;
    pickList.clear();
    await ServiceManager.getPickListByStatus(
        status: ServiceManager.getPickListStatusFromEnum(
            pickListStatusEnum: pickListStatusEnum),
        onSuccess: (pickList) {
          setState(() {
            this.pickList = pickList;
            _isLoading = false;
          });
        },
        onError: (Map map) {
          setState(() {
            _isLoading = false;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return screenWithAppBar(
        title: 'Scanner App',
        // drawer: const CustomDrawer(),
        isBackVisible: false,
        actions: [
          IconButton(
              onPressed: () {
                List<Widget> titleRowWidgets = [
                  getPoppinsText(
                      text: 'Logout',
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ];
                List<Widget> actions = [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // if (!isShowNegative)
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
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: getPoppinsText(
                                text: 'No',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: appPrimary),
                          ),
                          // TextButton(
                          //   onPressed: () {
                          //     LocalStorage.logout();
                          //     Get.offAll(() => const LoginPage());
                          //   },
                          //   child: const Text(
                          //     "Logout",
                          //     style: TextStyle(
                          //         color: Colors.red,
                          //         fontWeight: FontWeight.bold,
                          //         fontSize: 16),
                          //   ),
                          // ),
                          // TextButton(
                          //   onPressed: () {
                          //     Navigator.pop(context);
                          //   },
                          //   child: const Text(
                          //     "No",
                          //     style: TextStyle(
                          //         fontWeight: FontWeight.bold, fontSize: 16),
                          //   ),
                          // ),
                        ],
                      )),
                ];
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Row(
                        children: titleRowWidgets,
                      ),
                      content: getPoppinsText(
                          text: 'Are you sure you want to logout?',
                          textAlign: TextAlign.start,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                      actions: actions,
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.red,
              )),
        ],
        body: SingleChildScrollView(
          child: Column(
            children: [
              appVersionWidget(),
              getPoppinsText(
                  text: 'Welcome, Supervisor',
                  fontWeight: FontWeight.w700,
                  fontSize: 20),
              //todo: implement search
              _statusFilterWidget(),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: CircularProgressIndicator(),
                )
              else
                _list(),
            ],
          ),
        ),
        bottomNavigationBar: _buttonContainer());
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
              child: DropdownButton<PickListStatusEnum>(
                value: pickListStatusEnum, // Currently selected value
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() {
                      pickListStatusEnum =
                          newValue; // Update the selected value
                    });
                    setData();
                  }
                },
                items:
                    PickListStatusEnum.values.map((PickListStatusEnum value) {
                  return DropdownMenuItem<PickListStatusEnum>(
                    value: value,
                    child: Text(
                        getEnumLabel(value)), // Display user-friendly label
                  );
                }).toList(), // Converts enum values to dropdown items
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buttonContainer() {
    if (pickList.isEmpty ||
        pickListStatusEnum == PickListStatusEnum.closed ||
        pickListStatusEnum == PickListStatusEnum.all) {
      return const SizedBox(
        height: 0,
        width: 0,
      );
    } else {
      return SizedBox(
        height: Get.height/13,
        child: Row(
          children: [
            if(pickListStatusEnum==PickListStatusEnum.assigned)...[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: loadingButton(
                      isLoading: false,
                      btnText: 'Remove',
                      onPress: () {
                        if (!atLeastOnePickListSelected()) {
                          CustomSnackBar.errorSnackBar(
                              'Please select at least one Pick List');
                        } else {
                          List<Widget> titleRowWidgets = [
                            getPoppinsText(
                                text: 'Remove',
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ];
                          List<Widget> actions = [
                            Container(
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.center,
                                child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    // if (!isShowNegative)
                                    const Spacer(),

                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                        List<String> selectedPickList = [];
                                        for (PickListModel pickListModel in pickList) {
                                          if (pickListModel.isSelected) {
                                            selectedPickList.add(pickListModel
                                                .docEntry.toString());
                                          }
                                        }
                                        ServiceManager.removePickList(
                                            l: selectedPickList,
                                            onSuccess: (Map responseMap) {
                                              setData();
                                              CustomSnackBar
                                                  .successSnackBar(
                                                  responseMap[
                                                  'Error']);
                                            },
                                            onError: (Map responseMap) {
                                              CustomSnackBar
                                                  .errorSnackBar(
                                                  responseMap[
                                                  'Error']);
                                            });
                                      },
                                      child: getPoppinsText(
                                          text: 'Remove',
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: getPoppinsText(
                                          text: 'No',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: appPrimary),
                                    ),
                                  ],
                                )),
                          ];
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Row(
                                  children: titleRowWidgets,
                                ),
                                content: getPoppinsText(
                                    text:
                                    'Are you sure you want to remove this picklist?',
                                    textAlign: TextAlign.start,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                                actions: actions,
                              );
                            },
                          );


                        }
                      },
                      backColor: appPrimary),
                ),
              ),
              const VerticalDivider(
                color: Colors.grey,
                thickness: 1,
              ),
            ],

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: loadingButton(
                    isLoading: false,
                    btnText: pickListStatusEnum == PickListStatusEnum.assigned
                        ? 'Reassign'
                        : 'Assign',
                    onPress: () {
                      if (!atLeastOnePickListSelected()) {
                        CustomSnackBar.errorSnackBar(
                            'Please select at least one Pick List');
                      } else {
                        List<PickListModel> selectedPickList = [];
                        for (PickListModel pickListModel in pickList) {
                          if (pickListModel.isSelected) {
                            selectedPickList.add(pickListModel);
                          }
                        }
                        Get.to(() => AssignPicklistToUserScreen(
                              pickList: selectedPickList,
                              mode: pickListStatusEnum == PickListStatusEnum.assigned
                                  ? Mode.update
                                  : Mode.add,
                            ))?.then((onValue) {
                          setState(() {
                            setData();
                          });
                        });
                      }
                    },
                    backColor: appPrimary),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _list() {
    return ListView.separated(
      itemCount: pickList.length,
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        PickListModel pickListModel = pickList[index];
        String btnTxt = 'Assign';
        if (pickListModel.status == 'A') {
          btnTxt = 'Reassign';
        }
        return CheckboxListTile(
          value: pickListModel.isSelected,
          onChanged: (val) {
            pickListModel.isSelected = !pickListModel.isSelected;

            setState(() {});
          },
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
                                    text: pickListModel.pickListId.toString()),
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
                                getPoppinsTextSpanHeading(text: 'Status'),
                                getPoppinsTextSpanDetails(
                                    text: pickListModel.status),
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
                                    text: pickListModel.user),
                              ],
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                getPoppinsTextSpanHeading(
                                    text: 'Assigned Date'),
                                getPoppinsTextSpanDetails(
                                    text: getFormattedDateAndTime(
                                        getDateFromString(
                                            pickListModel.assignDate))),
                              ],
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),
                  if (pickListStatusEnum == PickListStatusEnum.assigned ||
                      pickListStatusEnum == PickListStatusEnum.open) ...[
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 28,
                      child: Row(
                        children: [
                          if (pickListStatusEnum ==
                              PickListStatusEnum.assigned) ...[
                            Expanded(
                                child: InkWell(
                              onTap: () {
                                List<Widget> titleRowWidgets = [
                                  getPoppinsText(
                                      text: 'Remove',
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ];
                                List<Widget> actions = [
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      alignment: Alignment.center,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          // if (!isShowNegative)
                                          const Spacer(),

                                          TextButton(
                                            onPressed: () {
                                              Get.back();

                                              ServiceManager.removePickList(
                                                  l: [pickListModel.absEntry.toString()],
                                                  onSuccess: (Map responseMap) {
                                                    setData();
                                                    CustomSnackBar
                                                        .successSnackBar(
                                                        responseMap['Result']);
                                                  },
                                                  onError: (Map responseMap) {
                                                    CustomSnackBar
                                                        .errorSnackBar(
                                                            responseMap[
                                                                'Error']);
                                                  });
                                            },
                                            child: getPoppinsText(
                                                text: 'Remove',
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: getPoppinsText(
                                                text: 'No',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: appPrimary),
                                          ),
                                        ],
                                      )),
                                ];
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Row(
                                        children: titleRowWidgets,
                                      ),
                                      content: getPoppinsText(
                                          text:
                                              'Are you sure you want to remove this picklist?',
                                          textAlign: TextAlign.start,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                      actions: actions,
                                    );
                                  },
                                );
                              },
                              child: getPoppinsText(
                                  text: 'Remove',
                                  color: Colors.red,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            )),
                            const VerticalDivider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                          ],
                          Expanded(
                              child: InkWell(
                            onTap: () {
                              Get.to(() => AssignPicklistToUserScreen(
                                    pickList: [pickListModel],
                                    mode: pickListStatusEnum ==
                                            PickListStatusEnum.assigned
                                        ? Mode.update
                                        : Mode.add,
                                  ))?.then((onValue) {
                                setState(() {
                                  setData();
                                });
                              });
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
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          thickness: 1.5,
          color: Colors.grey,
        );
      },
    );
  }

  bool atLeastOnePickListSelected() {
    bool isSelected = false;
    for (PickListModel pickListModel in pickList) {
      if (pickListModel.isSelected) {
        isSelected = true;
        break;
      }
    }
    return isSelected;
  }
}
