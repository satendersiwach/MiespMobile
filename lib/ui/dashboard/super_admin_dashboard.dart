import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner/common/enums.dart';
import 'package:scanner/common/get_formatted_date.dart';
import 'package:scanner/models/pick_list_model.dart';
import 'package:scanner/services/service_manager.dart';
import 'package:scanner/theme/custom_colors.dart';
import 'package:scanner/theme/custom_snack_bar.dart';
import 'package:scanner/theme/custom_text_widgets.dart';
import 'package:scanner/theme/elements_screen.dart';
import 'package:scanner/ui/components/custom_drawer.dart';
import 'package:scanner/ui/components/element_button.dart';
import 'package:scanner/ui/components/element_common_widget.dart';
import 'package:scanner/ui/supervisor/assign_pick_list_to_user_screen.dart';

class SuperAdminDashboard extends StatefulWidget {
  const SuperAdminDashboard({super.key});

  @override
  State<SuperAdminDashboard> createState() => _SuperAdminDashboardState();
}

class _SuperAdminDashboardState extends State<SuperAdminDashboard> {
  List<PickListModel> pickList = [];
  PickListStatusEnum pickListStatusEnum = PickListStatusEnum.open;

  @override
  void initState() {
    super.initState();
    setData();
  }

  setData() async {
    await ServiceManager.getPickListByStatus(
        status: ServiceManager.getPickListStatusFromEnum(
            pickListStatusEnum: pickListStatusEnum),
        onSuccess: (pickList) {
          setState(() {
            this.pickList = pickList;
          });
        },
        onError: (Map map) {});
  }

  @override
  Widget build(BuildContext context) {
    return screenWithAppBar(
        title: 'Scanner App',
        drawer: const CustomDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              appVersionWidget(),
              getPoppinsText(
                  text: 'Welcome, Supervisor',
                  fontWeight: FontWeight.w700,
                  fontSize: 20),
              //todo: add filter based on status
              //todo: implement search
              _list(),
            ],
          ),
        ),
        bottomNavigationBar: _buttonContainer());
  }

  Widget _buttonContainer() {
    if (pickList.isEmpty) {
      return const SizedBox(
        height: 0,
        width: 0,
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: loadingButton(
            isLoading: false,
            btnText: 'Assign',
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
                    ))?.then((onValue) {
                  setState(() {});
                });
              }
            },
            backColor: appPrimary),
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
                                    text: getFormattedDate(getDateFromString(
                                        pickListModel.assignDate))),
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
                          onTap: () {
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
