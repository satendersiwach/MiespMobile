import 'package:flutter/material.dart';
import 'package:scanner/models/user_inventory_model.dart';
import 'package:scanner/services/service_manager.dart';
import 'package:scanner/theme/custom_colors.dart';
import 'package:scanner/theme/custom_text_widgets.dart';
import 'package:scanner/theme/elements_screen.dart';
class UserInventory extends StatefulWidget {
  const UserInventory({super.key});

  @override
  State<UserInventory> createState() => _UserInventoryState();
}

class _UserInventoryState extends State<UserInventory> {
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
                          UserInventoryModel userInventoryModel = snapshot.data![index];




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
                                                        text: userInventoryModel.user ??
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
                                                        text: userInventoryModel.name ?? ''),
                                                  ],
                                                ),
                                              ),
                                              Text.rich(
                                                TextSpan(
                                                  children: [
                                                    getPoppinsTextSpanHeading(
                                                        text: 'Whs Code'),
                                                    getPoppinsTextSpanDetails(
                                                        text: userInventoryModel.whsCode ?? ''),
                                                  ],
                                                ),
                                              ),
                                              Text.rich(
                                                TextSpan(
                                                  children: [
                                                    getPoppinsTextSpanHeading(
                                                        text: 'Item Code'),
                                                    getPoppinsTextSpanDetails(
                                                        text: userInventoryModel.itemCode ?? ''),
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
                                                        text: userInventoryModel.itemName ?? ''),
                                                  ],
                                                ),
                                              ),
                                              Text.rich(
                                                TextSpan(
                                                  children: [
                                                    getPoppinsTextSpanHeading(
                                                        text: 'Whs Name'),
                                                    getPoppinsTextSpanDetails(
                                                        text: userInventoryModel.whsName ?? ''),
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
}
