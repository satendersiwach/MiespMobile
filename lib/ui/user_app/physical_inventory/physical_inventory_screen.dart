import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scanner/controllers/physical_inventory_controller.dart';
import 'package:scanner/services/scanner_event_service.dart';
import 'package:scanner/models/group_model.dart';
import 'package:scanner/models/pending_item_model.dart';
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
  final PhysicalInventoryController _controller =
      Get.put(PhysicalInventoryController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    ScannerEventService().pushHandler(_onBarcode);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    ScannerEventService().removeHandler(_onBarcode);
    _scrollController.dispose();
    Get.delete<PhysicalInventoryController>();
    super.dispose();
  }

  void _onBarcode(String barCode) {
    _controller.addInventoryCounting(barCode);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _controller.loadMoreData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return screenWithAppBar(
        title: "Physical Inventory",
        actions: [
          IconButton(
              onPressed: () => Get.to(() => const UserInventory()),
              icon: Icon(MdiIcons.listBoxOutline, color: Colors.white)),
        ],
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            SizedBox(height: 70, child: _itemGroupFilterWidget()),
            Obx(() {
              if (_controller.isLoading.value && _controller.data.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(top: 70.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              return Expanded(
                child: Column(
                  children: [
                    if (_controller.data.isNotEmpty)
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
                                    '(${_controller.pendingItemModel?.totalCount?.toStringAsFixed(0) ?? ''})',
                                color: Colors.red)
                          ],
                        ),
                      ),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _controller.data.length + 1,
                        itemBuilder: (context, index) {
                          if (index < _controller.data.length) {
                            return _buildItem(_controller.data[index]);
                          }
                          return Obx(() => _controller.isMoreLoading.value
                              ? const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                )
                              : const SizedBox(height: 70));
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            try {
              final scanResult = await ScannerService.scanQRCode();
              if (!mounted) return;
              if (scanResult != null && scanResult != '') {
                _onBarcode(scanResult);
              } else {
                CustomSnackBar.errorSnackBar('Could not scan');
              }
            } catch (e) {
              CustomSnackBar.errorSnackBar('Error during scan: $e');
            }
          },
          child: const Icon(Icons.barcode_reader, color: Colors.white),
        ));
  }

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
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(TextSpan(children: [
                        getPoppinsTextSpanHeading(text: 'Item'),
                        getPoppinsTextSpanDetails(
                            text: dataModel.itemCode?.toString() ?? ''),
                      ])),
                      Text.rich(TextSpan(children: [
                        getPoppinsTextSpanHeading(text: 'Name'),
                        getPoppinsTextSpanDetails(
                            text: dataModel.itemName?.toString() ?? ''),
                      ])),
                    ],
                  )),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(TextSpan(children: [
                          getPoppinsTextSpanHeading(text: 'Group Code'),
                          getPoppinsTextSpanDetails(
                              text: dataModel.itmsGrpCod?.toString() ?? ''),
                        ])),
                        Text.rich(TextSpan(children: [
                          getPoppinsTextSpanHeading(text: 'Warehouse'),
                          getPoppinsTextSpanDetails(
                              text: dataModel.whsName?.toString() ?? ''),
                        ])),
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
          const Divider(thickness: .5, color: Colors.black),
          Expanded(
              flex: 2,
              child: Obx(() => DropdownButtonFormField<GroupModel>(
                    decoration: InputDecoration(
                      labelText: "Select Group",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                    value: _controller.selectedItemGroup.value,
                    hint: const Text("Choose a group"),
                    isExpanded: true,
                    items: _controller.itemGroupList
                        .map((group) => DropdownMenuItem(
                              value: group,
                              child: Text(group.groupName),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        _controller.updateItemGroup(value);
                      }
                    },
                  ))),
        ],
      ),
    );
  }
}
