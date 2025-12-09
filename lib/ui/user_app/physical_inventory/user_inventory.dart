import 'package:flutter/material.dart';
import 'package:scanner/models/customer_model.dart';
import 'package:scanner/models/remove_inventory_model.dart';
import 'package:scanner/models/update_inventory_model.dart';
import 'package:scanner/models/user_inventory_model.dart';
import 'package:scanner/services/service_manager.dart';
import 'package:scanner/theme/custom_colors.dart';
import 'package:scanner/theme/custom_snack_bar.dart';
import 'package:scanner/theme/custom_text_widgets.dart';
import 'package:scanner/theme/elements_screen.dart';
import 'package:scanner/theme/get_text_field.dart';

class UserInventory extends StatefulWidget {
  const UserInventory({super.key});

  @override
  State<UserInventory> createState() => _UserInventoryState();
}

class _UserInventoryState extends State<UserInventory> {
  final TextEditingController _remark = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return screenWithAppBar(
        title: 'User Inventory List',
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              FutureBuilder(
                  future: ServiceManager.getUserInventoryList(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    return ListView.builder(
                        itemCount: snapshot.data?.length,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, index) {
                          UserInventoryModel userInventoryModel =
                              snapshot.data![index];

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
                                                    text: userInventoryModel
                                                            .user ??
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
                                                    text: userInventoryModel
                                                            .name ??
                                                        ''),
                                              ],
                                            ),
                                          ),
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                getPoppinsTextSpanHeading(
                                                    text: 'Whs Code'),
                                                getPoppinsTextSpanDetails(
                                                    text: userInventoryModel
                                                            .whsCode ??
                                                        ''),
                                              ],
                                            ),
                                          ),
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                getPoppinsTextSpanHeading(
                                                    text: 'Item Code'),
                                                getPoppinsTextSpanDetails(
                                                    text: userInventoryModel
                                                            .itemCode ??
                                                        ''),
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
                                                    text: 'Code'),
                                                getPoppinsTextSpanDetails(
                                                    text: userInventoryModel
                                                        .code),
                                              ],
                                            ),
                                          ),
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                getPoppinsTextSpanHeading(
                                                    text: 'Item Name'),
                                                getPoppinsTextSpanDetails(
                                                    text: userInventoryModel
                                                            .itemName ??
                                                        ''),
                                              ],
                                            ),
                                          ),
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                getPoppinsTextSpanHeading(
                                                    text: 'Whs Name'),
                                                getPoppinsTextSpanDetails(
                                                    text: userInventoryModel
                                                            .whsName ??
                                                        ''),
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
                                            List<Widget> titleRowWidgets = [
                                              getPoppinsText(
                                                  text: 'Remove',
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ];
                                            List<Widget> actions = [
                                              Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  alignment: Alignment.center,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      // if (!isShowNegative)
                                                      const Spacer(),

                                                      TextButton(
                                                        onPressed: () {
                                                          UpdateInventoryModel removeInventoryModel = UpdateInventoryModel(
                                                              batchNumber:
                                                                  userInventoryModel
                                                                      .name,
                                                              itemCode:
                                                                  userInventoryModel
                                                                      .itemCode,
                                                              quantity:
                                                                  userInventoryModel
                                                                      .quantity,
                                                              remark:
                                                                  _remark.text,
                                                              user: UserModel
                                                                      .getLoginCustomer()
                                                                  .userCode,
                                                              isManEntry: 'Y',
                                                              whsCode:
                                                                  userInventoryModel
                                                                      .whsCode,
                                                              mode: 'Manual');
                                                          ServiceManager
                                                              .updateInventoryCounting(
                                                                  updateInventoryModel:
                                                                      removeInventoryModel,
                                                                  onSuccess:
                                                                      (res) {
                                                                    CustomSnackBar.successSnackBar(
                                                                        res['Result'] ??
                                                                            'Inventory Updated');
                                                                    Navigator.pop(
                                                                        context);
                                                                    _remark
                                                                        .clear();
                                                                  },
                                                                  onError:
                                                                      (error) {});
                                                        },
                                                        child: getPoppinsText(
                                                            text: 'Update',
                                                            color: appPrimary,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: getPoppinsText(
                                                            text: 'No',
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                                  content: getTextField(
                                                      controller: _remark,
                                                      maxLines: 4,
                                                      height: null,
                                                      labelText: 'Remark'),
                                                  actions: actions,
                                                );
                                              },
                                            );
                                          },
                                          child: getPoppinsText(
                                              text: 'Update',
                                              color: appPrimary,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold),
                                        )),
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
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  alignment: Alignment.center,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      // if (!isShowNegative)
                                                      const Spacer(),

                                                      TextButton(
                                                        onPressed: () {
                                                          RemoveInventoryModel
                                                              removeInventoryModel =
                                                              RemoveInventoryModel(
                                                                  batchNumber:
                                                                      userInventoryModel
                                                                          .name,
                                                                  itemCode:
                                                                      userInventoryModel
                                                                          .itemCode,
                                                                  whsCode:
                                                                      userInventoryModel
                                                                          .whsCode);
                                                          ServiceManager
                                                              .removeInventoryCounting(
                                                                  removeInventoryModel:
                                                                      removeInventoryModel,
                                                                  onSuccess:
                                                                      (res) {
                                                                    Navigator.pop(
                                                                        context);
                                                                    CustomSnackBar.successSnackBar(
                                                                        res['Result'] ??
                                                                            'Inventory Removed');
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  onError:
                                                                      (error) {});
                                                        },
                                                        child: getPoppinsText(
                                                            text: 'Remove',
                                                            color: Colors.red,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: getPoppinsText(
                                                            text: 'No',
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                                          'Are you sure you want to remove?',
                                                      textAlign:
                                                          TextAlign.start,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
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
}
