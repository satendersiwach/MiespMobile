import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner/models/customer_model.dart';
import 'package:scanner/models/pick_list_model.dart';
import 'package:scanner/services/service_manager.dart';
import 'package:scanner/theme/custom_colors.dart';
import 'package:scanner/theme/custom_snack_bar.dart';
import 'package:scanner/theme/custom_text_widgets.dart';
import 'package:scanner/theme/display_dialogbox.dart';
import 'package:scanner/theme/elements_screen.dart';

class AssignPicklistToUserScreen extends StatefulWidget {
  final List<PickListModel> pickList;

  const AssignPicklistToUserScreen({super.key, required this.pickList});

  @override
  State<AssignPicklistToUserScreen> createState() =>
      _AssignPicklistToUserScreenState();
}

class _AssignPicklistToUserScreenState
    extends State<AssignPicklistToUserScreen> {
  @override
  Widget build(BuildContext context) {
    return screenWithAppBar(
        title: 'User List',
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              FutureBuilder(
                  future: ServiceManager.getUserList(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    return ListView.builder(
                        itemCount: snapshot.data?.length,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, index) {
                          UserModel userModel = snapshot.data![index];
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
                            margin: const EdgeInsets.all(15),
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                getPoppinsTextSpanHeading(
                                                    text: 'Username'),
                                                getPoppinsTextSpanDetails(
                                                    text: userModel.username ??
                                                        ''),
                                              ],
                                            ),
                                          ),
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                getPoppinsTextSpanHeading(
                                                    text: 'Name'),
                                                getPoppinsTextSpanDetails(
                                                    text: userModel.name ?? ''),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                getPoppinsTextSpanHeading(
                                                    text: 'Is Supervisor'),
                                                getPoppinsTextSpanDetails(
                                                    text: userModel
                                                                .isSupervisor ==
                                                            'True'
                                                        ? "Yes"
                                                        : "No"),
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
                                  SizedBox(
                                    height: 20,
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: InkWell(
                                          onTap: () {
                                            //todo:
                                            //api/picklist/UpdatePickList
                                            /// call /master/getusers to get user and then assign only for one user
                                            showLoaderDialog(context,
                                                text: 'Assigning pick lists');
                                            ServiceManager.updatePickList(
                                                l: [],
                                                onSuccess: onSuccess,
                                                onError: onError);
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
                          );
                        });
                  }),
            ],
          ),
        ));
  }

  onError(Map responseMap) {
    Get.back();
    CustomSnackBar.errorSnackBar(responseMap['Error']);
  }

  onSuccess(Map responseMap) {
    Get.back();
    Get.back();
    CustomSnackBar.errorSnackBar(responseMap['result']);
  }
}
