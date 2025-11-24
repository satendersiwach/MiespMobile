import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scanner/LogFile/log_file_functions.dart';
import 'package:scanner/models/group_model.dart';
import 'package:scanner/models/pending_item_model.dart';
import 'package:scanner/services/service_manager.dart';
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
  static const EventChannel _eventChannel = EventChannel('scannerStream');
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

    _eventChannel.receiveBroadcastStream().listen((result) {
      print('Scanned result on Flutter side : $result');
      writeToLogFile(
          text: 'Scanned result on Flutter side through side button : $result',
          fileName: StackTrace.current.toString());
      if (result != null && result != '') {
        if (result.contains('\n')) {
          result = result.split('\n')[0];
        }

        if (result.contains(':')) {
          List l = result.split(":");
          if (l.length >= 2) {
            result = l[1];
          }
        }
        addInventoryCountry(result);
      }
    }, onError: (error) {
      CustomSnackBar.errorSnackBar('Error: $error');
    });

    _scrollController.addListener(_onScroll);
    setFilterList();
  }

  setFilterList() async {
    itemGroupList = await ServiceManager.getItemGroups();
    itemGroupList.removeWhere((itemGroup) => itemGroup.groupName == 'All');
    if (itemGroupList.isNotEmpty) {
      selectedItemGroup = itemGroupList[0];
    }
    setInventoryReport();
  }

  @override
  void dispose() {
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

    // UserModel userModel = UserModel.getLoginCustomer();
    await ServiceManager.getItemsPendingForInventory(
      pageNum: currentPage,
      pageSize: 10,
      itemGroup: selectedItemGroup?.groupCode ?? 0,
      onSuccess: (pendingItemModel) {
        setState(() {
          _pendingItemModel = pendingItemModel;
          data.addAll(pendingItemModel.data ?? []);
          _isLoading = false;
          _isMoreLoading = false; // reset after successful load
        });
      },
      onError: (Map map) {
        setState(() {
          _isLoading = false;
          _isMoreLoading = false;
        });
      },
    );
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
    if (await ServiceManager.isInternetAvailable()) {
      ServiceManager.addInventoryCounting(
          batchNumber: barCode,
          onSuccess: (xx) {
            currentPage = 1;
            setInventoryReport();
            CustomSnackBar.successSnackBar(
                xx['Message'] ?? 'Inventory counting added successfully');
          },
          onError: (vv) {
            currentPage = 1;
            setInventoryReport();
            if (vv['ValidationErrors'].length > 0) {
              CustomSnackBar.errorSnackBar(
                  vv['ValidationErrors'][0]['ErrorMessage']?.toString() ??
                      'Something went wrong!');
            } else {
              CustomSnackBar.errorSnackBar('Something went wrong!');
            }
          });
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

                ///todo: display list via GetInventoryByUser
                ///RemoveInventoryCounting
                ////UpdateInventoryCounting
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
          onPressed: () {
            ServiceManager.scanQRCode(onSuccess: (String scanResult) async {
              if (!mounted) return;
              String barCode = scanResult;
              if (barCode != '') {
                print(barCode);
                addInventoryCountry(barCode);
              }
            });
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
      onTap: () {
        // if (pickListModel.status == 'P') {
        //   PickListItemScreen.pickListStatusEnum =
        //       PickListStatusEnum.picked;
        // } else {
        //   PickListItemScreen.pickListStatusEnum =
        //       PickListStatusEnum.notPicked;
        // }
        // Get.to(() => PickListItemScreen(pickListModel: pickListModel));
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
