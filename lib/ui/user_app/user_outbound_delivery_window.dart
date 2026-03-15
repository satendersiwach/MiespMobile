import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner/services/scanner_event_service.dart';
import 'package:scanner/common/enums.dart';
import 'package:scanner/models/user_model.dart';
import 'package:scanner/models/pick_list_model.dart';
import 'package:scanner/services/api_exception.dart';
import 'package:scanner/services/auth_service.dart';
import 'package:scanner/services/pick_list_service.dart';
import 'package:scanner/services/scanner_service.dart';
import 'package:scanner/theme/custom_snack_bar.dart';
import 'package:scanner/theme/custom_text_widgets.dart';
import 'package:scanner/theme/elements_screen.dart';
import 'package:scanner/theme/get_text_field.dart';
import 'package:scanner/ui/components/custom_drawer.dart';
import 'package:scanner/ui/components/element_button.dart';
import 'package:scanner/ui/user_app/pick_list_item_screen.dart';

class UserOutboundDeliveryWindow extends StatefulWidget {
  const UserOutboundDeliveryWindow({super.key});

  @override
  State<UserOutboundDeliveryWindow> createState() =>
      _UserOutboundDeliveryWindowState();
}

class _UserOutboundDeliveryWindowState
    extends State<UserOutboundDeliveryWindow> {
  List<PickListModel> pickList = [];
  List<PickListModel> displayedPickList = [];
  bool _isLoading = false;
  bool _isMoreLoading = false;
  final TextEditingController _query = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int itemsPerPage = 20; // Number of items to load per batch
  int currentPage = 0;

  PickListStatusEnumForUser pickListStatusEnum =
      PickListStatusEnumForUser.notPicked;

  @override
  void initState() {
    super.initState();

    ScannerEventService().pushHandler(_onBarcodeScanned);
    _scrollController.addListener(_onScroll);
    setUserData();
  }

  @override
  void dispose() {
    ScannerEventService().removeHandler(_onBarcodeScanned);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onBarcodeScanned(String barcode) async {
    if (await AuthService.isInternetAvailable()) {
      UserModel userModel = UserModel.getLoginCustomer();
      try {
        final responseMap = await PickListService.pickByBarcode(
          barcode: barcode,
          user: userModel.username ?? "",
        );
        if (!mounted) return;
        CustomSnackBar.successSnackBar(
            responseMap['Result'] ?? 'Picked successfully');
        setUserData();
      } on ApiException catch (e) {
        if (!mounted) return;
        CustomSnackBar.errorSnackBar(
            e.validationError ?? e.message);
      } catch (e) {
        if (!mounted) return;
        CustomSnackBar.errorSnackBar(e.toString());
      }
    } else {
      CustomSnackBar.errorSnackBar('No internet connection');
    }
  }

  Future<void> setUserData() async {
    setState(() {
      _isLoading = true;
      pickList.clear();
      displayedPickList.clear();
      currentPage = 0;
    });

    UserModel userModel = UserModel.getLoginCustomer();
    try {
      final result = await PickListService.getPickListByUser(
        username: userModel.username ?? "",
        status: getPickListStatusFromEnum(
            pickListStatusEnum: pickListStatusEnum),
      );
      if (!mounted) return;
      setState(() {
        pickList = result;
        _loadMoreData();
        _isLoading = false;
      });
    } on ApiException {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreData();
    }
  }

  void _loadMoreData() {
    if (_isMoreLoading || (currentPage * itemsPerPage) >= pickList.length) {
      return;
    }

    setState(() {
      _isMoreLoading = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        int start = currentPage * itemsPerPage;
        int end = start + itemsPerPage;
        displayedPickList
            .addAll(pickList.sublist(start, end.clamp(0, pickList.length)));
        currentPage++;
        _isMoreLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return screenWithAppBar(
      title: 'Pick List',
      drawer: const CustomDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: setUserData,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  _assignCountContainer(),
                  const SizedBox(height: 25),
                  _queryWidget(),
                  const SizedBox(height: 5),
                  _statusFilterWidget(),
                  const SizedBox(height: 5),
                  Expanded(child: _list()),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            final scanResult = await ScannerService.scanQRCode();
            if (!mounted) return;
            if (scanResult != null && scanResult != '') {
              _onBarcodeScanned(scanResult);
            } else {
              CustomSnackBar.errorSnackBar('Could not scan');
            }
          } catch (e) {
            CustomSnackBar.errorSnackBar('Error during scan: $e');
          }
        },
        child: const Icon(
          Icons.barcode_reader,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _list() {
    return ListView.builder(
        controller: _scrollController,
        itemCount: displayedPickList.length + 1,
        itemBuilder: (context, index) {
          if (index == displayedPickList.length) {
            return _isMoreLoading
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox.shrink();
          }

          PickListModel pickListModel = displayedPickList[index];

          if (_query.text.isNotEmpty &&
              !(pickListModel.absEntry
                      .toString()
                      .toUpperCase()
                      .contains(_query.text.toUpperCase()) ||
                  pickListModel.docEntry
                      .toString()
                      .toUpperCase()
                      .contains(_query.text.toUpperCase()))) {
            return const SizedBox.shrink();
          }

          return InkWell(
            onTap: () {
              if (pickListModel.status == 'P') {
                PickListItemScreen.pickListStatusEnum =
                    PickListStatusEnum.picked;
              } else {
                PickListItemScreen.pickListStatusEnum =
                    PickListStatusEnum.notPicked;
              }
              Get.to(() => PickListItemScreen(pickListModel: pickListModel));
            },
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
                padding: const EdgeInsets.all(16.0),
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
                                  getPoppinsTextSpanHeading(
                                      text: 'Pick List id'),
                                  getPoppinsTextSpanDetails(
                                      text: pickListModel.absEntry.toString()),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  getPoppinsTextSpanHeading(text: 'SO Id'),
                                  getPoppinsTextSpanDetails(
                                      text: pickListModel.docEntry.toString()),
                                ],
                              ),
                            ),
                            // Text.rich(
                            //   TextSpan(
                            //     children: [
                            //       getPoppinsTextSpanHeading(
                            //           text: 'Item Description'),
                            //       getPoppinsTextSpanDetails(
                            //           text: pickListModel.description),
                            //     ],
                            //   ),
                            // ),
                          ],
                        )),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text.rich(
                              //   TextSpan(
                              //     children: [
                              //       getPoppinsTextSpanHeading(
                              //           text: 'WHSE Code'),
                              //       getPoppinsTextSpanDetails(
                              //           text: pickListModel.whseCode),
                              //     ],
                              //   ),
                              // ),
                              // Text.rich(
                              //   TextSpan(
                              //     children: [
                              //       getPoppinsTextSpanHeading(
                              //           text: 'Batch No.'),
                              //       getPoppinsTextSpanDetails(
                              //           text: pickListModel.batchNo),
                              //     ],
                              //   ),
                              // ),
                              // Text.rich(
                              //   TextSpan(
                              //     children: [
                              //       getPoppinsTextSpanHeading(
                              //           text: 'Release Qty'),
                              //       getPoppinsTextSpanDetails(
                              //           text: pickListModel.releaseQty
                              //               .toString()),
                              //     ],
                              //   ),
                              // ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    getPoppinsTextSpanHeading(text: 'Status'),
                                    getPoppinsTextSpanDetails(
                                        text: pickListModel.status == 'P'
                                            ? 'Picked'
                                            : 'Assigned'),
                                  ],
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    getPoppinsTextSpanHeading(
                                        text: 'Total Items'),
                                    getPoppinsTextSpanDetails(
                                        text: pickListModel.totalItems
                                            .toString()),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
    );
  }

  Widget _statusFilterWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, top: 4),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: getInterText(
              text: 'Picklist Status',
              textAlign: TextAlign.left,
              color: const Color(0XFF0F3C4D),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 15, right: 15),
            child: DropdownButton<PickListStatusEnumForUser>(
              value: pickListStatusEnum, // Currently selected value
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    pickListStatusEnum = newValue; // Update the selected value
                  });
                  setUserData();
                }
              },
              items: PickListStatusEnumForUser.values
                  .map((PickListStatusEnumForUser value) {
                return DropdownMenuItem<PickListStatusEnumForUser>(
                  value: value,
                  child:
                      Text(getEnumLabel(value)), // Display user-friendly label
                );
              }).toList(), // Converts enum values to dropdown items
              borderRadius: BorderRadius.circular(10),
            ),
          )),
        ],
      ),
    );
  }

  Widget _assignCountContainer() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: getPoppinsText(
            text: 'You have ${pickList.length} Pick List assigned',
            decoration: TextDecoration.underline,
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 14),
      ),
    );
  }

  Widget _queryWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: getTextField(
                controller: _query,
                hintText: 'Search...',
                inputFontSize: 12,
                onChanged: (val) {
                  setState(() {});
                },
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _query.clear();
                      });
                    },
                    icon: const Icon(Icons.clear)),
                labelFontSize: 14),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(
              bottom: 8,
              top: 2,
            ),
            child: SizedBox(
              height: 43,
              child: loadingButton(
                  isLoading: false, btnText: 'Search', onPress: () {}),
            ),
          )),
        ],
      ),
    );
  }

  Widget _pickListDetails(PickListModel pickListModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(children: [
            getPoppinsTextSpanHeading(text: 'Pick List id'),
            getPoppinsTextSpanDetails(text: pickListModel.absEntry.toString()),
          ]),
        ),
        Text.rich(
          TextSpan(children: [
            getPoppinsTextSpanHeading(text: 'Item Code'),
            getPoppinsTextSpanDetails(text: pickListModel.code),
          ]),
        ),
        Text.rich(
          TextSpan(children: [
            getPoppinsTextSpanHeading(text: 'SO Id'),
            getPoppinsTextSpanDetails(text: pickListModel.docEntry.toString()),
          ]),
        ),
        Text.rich(
          TextSpan(children: [
            getPoppinsTextSpanHeading(text: 'Item Description'),
            getPoppinsTextSpanDetails(text: pickListModel.description),
          ]),
        ),
      ],
    );
  }
}
