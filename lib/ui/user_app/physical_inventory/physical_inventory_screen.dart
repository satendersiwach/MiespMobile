import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scanner/services/scanner_event_service.dart';
import 'package:scanner/models/group_model.dart';
import 'package:scanner/models/pending_item_model.dart';
import 'package:scanner/services/api_exception.dart';
import 'package:scanner/services/auth_service.dart';
import 'package:scanner/services/inventory_service.dart';
import 'package:scanner/services/master_data_service.dart';
import 'package:scanner/services/scanner_service.dart';
import 'package:scanner/theme/custom_colors.dart';
import 'package:scanner/theme/custom_snack_bar.dart';
import 'package:scanner/theme/custom_text_widgets.dart';
import 'package:scanner/theme/elements_screen.dart';
import 'package:scanner/ui/user_app/physical_inventory/user_inventory.dart';

class PhysicalInventoryScreen extends StatefulWidget {
  const PhysicalInventoryScreen({super.key});

  @override
  State<PhysicalInventoryScreen> createState() =>
      _PhysicalInventoryScreenState();
}

class _PhysicalInventoryScreenState extends State<PhysicalInventoryScreen> {
  GroupModel? selectedItemGroup;
  List<GroupModel> itemGroupList = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _isMoreLoading = false;
  List<Datum> data = [];
  PendingItemModel? _pendingItemModel = null;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();

    ScannerEventService().pushHandler(addInventoryCountry);
    _scrollController.addListener(_onScroll);
    setFilterList();
  }

  setFilterList() async {
    itemGroupList = await MasterDataService.getItemGroups();
    itemGroupList.removeWhere((itemGroup) => itemGroup.groupName == 'All');
    if (itemGroupList.isNotEmpty) {
      selectedItemGroup = itemGroupList[0];
    }
    setInventoryReport();
  }

  @override
  void dispose() {
    ScannerEventService().removeHandler(addInventoryCountry);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> setInventoryReport() async {
    if (_isLoading) return;
    setState(() {
      if (currentPage == 1) {
        _isLoading = true;
      }
      _pendingItemModel = null;
    });

    try {
      final pendingItemModel = await InventoryService.getItemsPendingForInventory(
        pageNum: currentPage,
        pageSize: 10,
        itemGroup: selectedItemGroup?.groupCode ?? 0,
      );
      if (!mounted) return;
      setState(() {
        _pendingItemModel = pendingItemModel;
        data.addAll(pendingItemModel.data ?? []);
        _isLoading = false;
        _isMoreLoading = false;
      });
    } on ApiException {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _isMoreLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _isMoreLoading = false;
      });
      CustomSnackBar.errorSnackBar(e.toString());
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (currentPage < (_pendingItemModel?.totalPages ?? 0) &&
          !_isMoreLoading) {
        _loadMoreData();
      }
    }
  }

  void _loadMoreData() {
    if (_isMoreLoading) return;
    setState(() {
      _isMoreLoading = true;
      currentPage++;
    });
    setInventoryReport();
  }

  addInventoryCountry(String barCode) async {
    if (await AuthService.isInternetAvailable()) {
      try {
        final responseMap = await InventoryService.addInventoryCounting(
            batchNumber: barCode);
        if (!mounted) return;
        currentPage = 1;
        data.clear();
        setInventoryReport();
        CustomSnackBar.successSnackBar(
            responseMap['Result'] ?? 'Inventory counting added successfully');
      } on ApiException catch (e) {
        if (!mounted) return;
        currentPage = 1;
        data.clear();
        setInventoryReport();
        CustomSnackBar.errorSnackBar(
            e.validationError ?? 'Something went wrong!');
      } catch (e) {
        if (!mounted) return;
        CustomSnackBar.errorSnackBar(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return screenWithAppBar(
        title: "Physical Inventory",
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => const UserInventory());
              },
              icon: Icon(
                MdiIcons.listBoxOutline,
                color: Colors.white,
              )),
        ],
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            SizedBox(height: 70, child: _itemGroupFilterWidget()),
            if (_isLoading && data.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 70.0),
                child: Center(child: CircularProgressIndicator()),
              )
            else
              Expanded(
                child: Column(
                  children: [
                    if (data.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 24.0, right: 24, top: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            getHeadingText(
                                text: 'Total Count : ', color: appPrimary),
                            getHeadingText(
                                text:
                                    '(${_pendingItemModel?.totalCount?.toStringAsFixed(0) ?? ''})',
                                color: Colors.red)
                          ],
                        ),
                      ),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController, // ✅ scroll attached here
                        itemCount: data.length + 1, // loader at bottom
                        itemBuilder: (context, index) {
                          if (index < data.length) {
                            Datum dataModel = data[index];
                            return _buildItem(dataModel);
                          } else {
                            return _isMoreLoading
                                ? const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  )
                                : const SizedBox(
                                    height: 70,
                                  );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            try {
              final scanResult = await ScannerService.scanQRCode();
              if (!mounted) return;
              if (scanResult != null && scanResult != '') {
                addInventoryCountry(scanResult);
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
        ));
  }

  /// Extracted list item widget
  Widget _buildItem(Datum dataModel) {
    return InkWell(
      onTap: () {},
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
                            getPoppinsTextSpanHeading(text: 'Item'),
                            getPoppinsTextSpanDetails(
                                text: dataModel.itemCode?.toString() ?? ''),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            getPoppinsTextSpanHeading(text: 'Name'),
                            getPoppinsTextSpanDetails(
                              text: dataModel.itemName?.toString() ?? '',
                            )
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
                              getPoppinsTextSpanHeading(text: 'Group Code'),
                              getPoppinsTextSpanDetails(
                                  text: dataModel.itmsGrpCod?.toString() ?? ''),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              getPoppinsTextSpanHeading(text: 'Warehouse'),
                              getPoppinsTextSpanDetails(
                                  text: dataModel.whsName?.toString() ?? ''),
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
  }

  Widget _itemGroupFilterWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: getInterText(
              text: 'Item Group',
              textAlign: TextAlign.left,
              color: const Color(0XFF0F3C4D),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Divider(
            thickness: .5,
            color: Colors.black,
          ),
          Expanded(
              flex: 2,
              child: DropdownButtonFormField<GroupModel>(
                decoration: InputDecoration(
                  labelText: "Select Group",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                value: selectedItemGroup,
                hint: const Text("Choose a group"),
                isExpanded: true,
                items: itemGroupList.map((group) {
                  return DropdownMenuItem<GroupModel>(
                    value: group,
                    child: Text(group.groupName),
                  );
                }).toList(),
                onChanged: (GroupModel? value) {
                  if (value != null) {
                    setState(() {
                      selectedItemGroup = value;
                      currentPage = 1; // Reset pagination
                      data.clear(); // Clear old data
                    });
                    setInventoryReport(); // Fetch filtered data
                  }
                  setState(() {});
                },
              )),
        ],
      ),
    );
  }
}
