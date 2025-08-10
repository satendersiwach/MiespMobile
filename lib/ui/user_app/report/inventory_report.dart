import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner/models/inventory_report_model.dart';
import 'package:scanner/services/service_manager.dart';
import 'package:scanner/theme/custom_text_widgets.dart';
import 'package:scanner/theme/get_text_field.dart';
import 'package:scanner/ui/components/element_button.dart';

class InventoryReport extends StatefulWidget {
  const InventoryReport({super.key});

  @override
  State<InventoryReport> createState() => _InventoryReportState();
}

class _InventoryReportState extends State<InventoryReport> {
  InventoryReportModel? inventoryReport;
  List<Datum> data=[];
  bool _isLoading = false;
  bool _isMoreLoading = false;
  final TextEditingController _query = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int itemsPerPage = 10;
  int currentPage = 1;

  String filter = 'All';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    data.clear();
    setInventoryReport();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> setInventoryReport() async {
    setState(() {
      _isLoading = true;
      this.inventoryReport = null;
    });

    // UserModel userModel = UserModel.getLoginCustomer();
    await ServiceManager.getPaginatedInventoryReport(
      filter: 'All',
      pageNum: currentPage,
      searchTerm: _query.text,
      pageSize: itemsPerPage,
      onSuccess: (inventoryReport) {
        setState(() {
          currentPage=inventoryReport.pageNum??currentPage;
          currentPage++;
          this.inventoryReport = inventoryReport;
          data.addAll(inventoryReport.data??[]);
          // _loadMoreData(); // Load the first batch
          _isLoading = false;
        });
      },
      onError: (Map map) {
        setState(() {
          _isLoading = false;
        });
      },
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreData();
    }
  }

  void _loadMoreData() {
    if (_isMoreLoading ||
        (currentPage * itemsPerPage) >= (inventoryReport?.data?.length ?? 0)) {
      return;
    }
    currentPage++;
    setInventoryReport();


    // setState(() {
    //   _isMoreLoading = true;
    // });

    //todo:
    // Future.delayed(const Duration(seconds: 1), () {
    //   setState(() {
    //     int start = currentPage * itemsPerPage;
    //     int end = start + itemsPerPage;
    //     inventoryReport
    //         .addAll(pickList.sublist(start, end.clamp(0, pickList.length)));
    //     currentPage++;
    //     _isMoreLoading = false;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inventory Report"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                // _assignCountContainer(),
                // const SizedBox(height: 25),
                _queryWidget(),
                const SizedBox(height: 5),
                // _statusFilterWidget(),
                // const SizedBox(height: 5),
                _list(),
              ],
            ),
          ),
    );
  }

  Widget _list() {
    return ListView.builder(
      controller: _scrollController,
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: (data?.length ?? 0) + 1,
      itemBuilder: (context, index) {
        if (index == data.length) {
          return _isMoreLoading
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                )
              : const SizedBox.shrink();
        }

        Datum? dataModel = data[index];

        // if (_query.text.isNotEmpty &&
        //     !(pickListModel.absEntry
        //         .toString()
        //         .toUpperCase()
        //         .contains(_query.text.toUpperCase()) ||
        //         pickListModel.docEntry
        //             .toString()
        //             .toUpperCase()
        //             .contains(_query.text.toUpperCase()))) {
        //   return const SizedBox.shrink();
        // }

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
                                getPoppinsTextSpanHeading(text: 'Item Code'),
                                getPoppinsTextSpanDetails(
                                    text: dataModel?.itemCode?.toString() ?? ''),
                              ],
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                getPoppinsTextSpanHeading(
                                    text: 'Batch Number'),
                                getPoppinsTextSpanDetails(
                                    text: dataModel?.batchNum?.toString() ?? ''),
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
                                  getPoppinsTextSpanHeading(text: 'Quantity'),
                                  getPoppinsTextSpanDetails(
                                      text:
                                      dataModel?.quantity?.toString() ?? '0'),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  getPoppinsTextSpanHeading(
                                      text: 'SAP Quantity'),
                                  getPoppinsTextSpanDetails(
                                      text: dataModel?.sapQuantity?.toString() ??
                                          '0'),
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

  // Widget _statusFilterWidget() {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 18.0, top: 4),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           flex: 1,
  //           child: getInterText(
  //             text: 'Picklist Status',
  //             textAlign: TextAlign.left,
  //             color: const Color(0XFF0F3C4D),
  //             fontSize: 14,
  //             fontWeight: FontWeight.w500,
  //           ),
  //         ),
  //         Expanded(
  //             child: Padding(
  //               padding: const EdgeInsets.only(top: 8.0, left: 15, right: 15),
  //               child: DropdownButton<PickListStatusEnumForUser>(
  //                 value: pickListStatusEnum, // Currently selected value
  //                 onChanged: (newValue) {
  //                   if (newValue != null) {
  //                     setState(() {
  //                       pickListStatusEnum = newValue; // Update the selected value
  //                     });
  //                     setUserData();
  //                   }
  //                 },
  //                 items: PickListStatusEnumForUser.values
  //                     .map((PickListStatusEnumForUser value) {
  //                   return DropdownMenuItem<PickListStatusEnumForUser>(
  //                     value: value,
  //                     child:
  //                     Text(getEnumLabel(value)), // Display user-friendly label
  //                   );
  //                 }).toList(), // Converts enum values to dropdown items
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //             )),
  //       ],
  //     ),
  //   );
  // }

  // Widget _assignCountContainer() {
  //   return Align(
  //     alignment: Alignment.center,
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 15.0),
  //       child: getPoppinsText(
  //           text: 'You have ${pickList.length} Pick List assigned',
  //           decoration: TextDecoration.underline,
  //           color: Colors.red,
  //           fontWeight: FontWeight.bold,
  //           fontSize: 14),
  //     ),
  //   );
  // }

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
                  isLoading: false, btnText: 'Search', onPress: () {
                    setInventoryReport();
              }),
            ),
          )),
        ],
      ),
    );
  }
}
