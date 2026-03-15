import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scanner/LogFile/log_file_functions.dart';
import 'package:scanner/services/scanner_event_service.dart';
import 'package:scanner/common/enums.dart';
import 'package:scanner/models/customer_model.dart';
import 'package:scanner/models/pick_list_item_detail_model.dart';
import 'package:scanner/models/pick_list_model.dart';
import 'package:scanner/services/api_exception.dart';
import 'package:scanner/services/auth_service.dart';
import 'package:scanner/services/pick_list_service.dart';
import 'package:scanner/services/scanner_service.dart';
import 'package:scanner/theme/custom_colors.dart';
import 'package:scanner/theme/custom_snack_bar.dart';
import 'package:scanner/theme/custom_text_widgets.dart';
import 'package:scanner/theme/elements_screen.dart';
import 'package:scanner/theme/get_text_field.dart';
import 'package:scanner/ui/components/element_button.dart';

class PickListItemScreen extends StatefulWidget {
  final PickListModel pickListModel;
  static PickListStatusEnum pickListStatusEnum = PickListStatusEnum.notPicked;

  const PickListItemScreen({super.key, required this.pickListModel});

  @override
  State<PickListItemScreen> createState() => _PickListItemScreenState();
}

class _PickListItemScreenState extends State<PickListItemScreen> {
  List<PickListItemDetailModel> pickListItems = [];
  final TextEditingController query = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = true;
  int _currentMax = 15;
  List myList = [];

  @override
  void initState() {
    super.initState();
    ScannerEventService().pushHandler(_handleBarcode);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
    setItemData();
  }

  void _handleBarcode(String barcode) {
    updatePickingQty(barCode: barcode);
  }

  @override
  void dispose() {
    ScannerEventService().removeHandler(_handleBarcode);
    _scrollController.dispose();
    query.dispose();
    super.dispose();
  }

  _getMoreData() {
    for (int i = _currentMax; i < _currentMax + 15; i++) {
      myList.add("Item : ${i + 1}");
    }
    _currentMax = _currentMax + 15;

    setState(() {});
  }

  setItemData() async {
    pickListItems.clear();
    _currentMax = 15;
    setState(() {
      _isLoading = true;
    });
    try {
      final items = await PickListService.getListingItems(
          status:
              PickListItemScreen.pickListStatusEnum == PickListStatusEnum.picked
                  ? 'Y'
                  : 'N',
          search: query.text,
          pickListId: [widget.pickListModel.absEntry]);
      if (!mounted) return;
      myList = List.generate(15, (index) => "Item : ${index + 1}");
      setState(() {
        _isLoading = false;
        pickListItems = items;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      CustomSnackBar.errorSnackBar(e.validationError ?? e.message);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      CustomSnackBar.errorSnackBar(e.toString());
    }
  }

  Widget _queryWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: getTextField(
                controller: query,
                hintText: 'Search...',
                inputFontSize: 12,
                onChanged: (val) {
                  setState(() {});
                },
                suffixIcon: IconButton(
                    onPressed: () {
                      query.clear();
                      setItemData();
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
              child: FittedBox(
                child: loadingButton(
                    isLoading: false,
                    btnText: 'Search',
                    onPress: () {
                      setItemData();
                    }),
              ),
            ),
          )),
        ],
      ),
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
            child: DropdownButton<PickListStatusEnum>(
              value: PickListItemScreen.pickListStatusEnum,
              // Currently selected value
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    PickListItemScreen.pickListStatusEnum =
                        newValue; // Update the selected value
                  });
                  setItemData();
                }
              },
              items: PickListStatusEnum.values.map((PickListStatusEnum value) {
                return DropdownMenuItem<PickListStatusEnum>(
                  value: value,
                  child:
                      Text(getEnumLabel(value)), // Display user-friendly label
                );
              }).toList(),
              // Converts enum values to dropdown items
              borderRadius: BorderRadius.circular(10),
            ),
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return screenWithAppBar(
        title: 'Pick list items',
        body: _isLoading
            ? const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Center(child: CircularProgressIndicator()),
              )
            : SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    _queryWidget(),
                    const SizedBox(
                      height: 10,
                    ),
                    _statusFilterWidget(),
                    const SizedBox(
                      height: 4,
                    ),
                    _list(),
                  ],
                ),
              ));
  }

  Widget _list() {
    return Column(
      children: [
        getHeadingText(
            text:
                'You have total of (${pickListItems.length}) ${pickListItems.length == 1 ? 'item' : 'items'}'),
        ListView.separated(
          // itemCount: pickListItems.length,
          itemCount: ((query.text == "") && ((pickListItems.length ?? 0) > 31)
                  ? myList.length + 1
                  : pickListItems.length) ??
              0,
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            if (index >= pickListItems.length) {
              return Container();
            }
            if (index == myList.length) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            PickListItemDetailModel pickListModel = pickListItems[index];
            return InkWell(
              onTap: () {
                // Get.to(()=>PickListItemScreen(pickListModel: pickListModel));
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
                      Text.rich(
                        TextSpan(
                          children: [
                            getPoppinsTextSpanHeading(text: 'Item Name'),
                            getPoppinsTextSpanDetails(
                                text: pickListModel.itemName),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            getPoppinsTextSpanHeading(text: 'Dist Number'),
                            getPoppinsTextSpanDetails(
                                text: pickListModel.distNumber.toString()),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
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
                                        text: 'Item Code'),
                                    getPoppinsTextSpanDetails(
                                        text:
                                            pickListModel.itemCode.toString()),
                                  ],
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    getPoppinsTextSpanHeading(
                                        text: 'Doc Entry'),
                                    getPoppinsTextSpanDetails(
                                        text:
                                            pickListModel.docEntry.toString()),
                                  ],
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    getPoppinsTextSpanHeading(
                                        text: 'Abs Entry'),
                                    getPoppinsTextSpanDetails(
                                        text:
                                            pickListModel.absEntry.toString()),
                                  ],
                                ),
                              ),
                            ],
                          )),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      getPoppinsTextSpanHeading(
                                          text: 'Rel Qtty'),
                                      getPoppinsTextSpanDetails(
                                          text:
                                              pickListModel.relQtty.toString()),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      getPoppinsTextSpanHeading(
                                          text: 'Whs Code'),
                                      getPoppinsTextSpanDetails(
                                          text:
                                              pickListModel.whsCode.toString()),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      getPoppinsTextSpanHeading(text: 'Picked'),
                                      getPoppinsTextSpanDetails(
                                          text: pickListModel.picked),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                        ],
                      ),
                      if (pickListModel.picked == 'N') ...[
                        const SizedBox(
                          height: 10,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey,
                          ),
                        ),
                        _buttonContainer(),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            if (index >= pickListItems.length) {
              return Container();
            }

            if (index == myList.length) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const Divider(
              thickness: 1.5,
              color: Colors.grey,
            );
          },
        ),
      ],
    );
  }

  updatePickingQty({required String barCode}) async {
    PickListItemDetailModel? pickListModel;
    for (PickListItemDetailModel pickListItemDetailModel in pickListItems) {
      if (barCode == pickListItemDetailModel.distNumber) {
        pickListModel = pickListItemDetailModel;
        break;
      }
    }
    if (pickListModel == null) {
      CustomSnackBar.errorSnackBar('$barCode does not belong to these items');
      String text = '''
    $barCode does not belong to this item
    -----------------
    Bar Code : $barCode
    Dis Number : ${pickListModel?.distNumber}
    ''';
      await writeToLogFile(
          text: text,
          heading: 'Value',
          fileName: StackTrace.current.toString());
      return;
    }
    if (await AuthService.isInternetAvailable()) {
      try {
        await PickListService.pickByBarcode(
            barcode: barCode,
            user: UserModel.getLoginCustomer().userCode ?? '');
        setItemData();
      } on ApiException catch (e) {
        debugPrint('pickByBarcode error: ${e.message}');
      } catch (e) {
        CustomSnackBar.errorSnackBar(e.toString());
      }
    }
  }

  Widget _buttonContainer() {
    return SizedBox(
      height: 30,
      child: InkWell(
        onTap: () async {
          String text = '''
    Scanning
    -----------------
    Calling scan function
    ''';
          await writeToLogFile(
              text: text,
              heading: 'Value',
              fileName: StackTrace.current.toString());
          try {
            final scanResult = await ScannerService.scanQRCode();
            if (!mounted) return;
            if (scanResult != null) {
              updatePickingQty(barCode: scanResult);
            } else {
              CustomSnackBar.errorSnackBar('Could not scan');
            }
          } catch (e) {
            CustomSnackBar.errorSnackBar('Error during scan: $e');
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              MdiIcons.barcode,
              color: appPrimary,
            ),
            const SizedBox(
              width: 10,
            ),
            getPoppinsText(
                text: 'Scan',
                color: appPrimary,
                fontSize: 13,
                fontWeight: FontWeight.bold),
          ],
        ),
      ),
    );
  }
}
