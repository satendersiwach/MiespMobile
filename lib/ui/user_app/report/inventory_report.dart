import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner/common/enums.dart';
import 'package:scanner/controllers/inventory_report_controller.dart';
import 'package:scanner/models/group_model.dart';
import 'package:scanner/models/inventory_report_model.dart';
import 'package:scanner/theme/custom_text_widgets.dart';
import 'package:scanner/theme/get_text_field.dart';
import 'package:scanner/ui/components/element_button.dart';

class InventoryReport extends StatefulWidget {
  const InventoryReport({super.key});

  @override
  State<InventoryReport> createState() => _InventoryReportState();
}

class _InventoryReportState extends State<InventoryReport> {
  final InventoryReportController _controller =
      Get.put(InventoryReportController());
  final TextEditingController _query = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    Get.delete<InventoryReportController>();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _controller.loadMoreData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inventory Report")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          _queryWidget(),
          const SizedBox(height: 5),
          SizedBox(
            height: 70,
            child: Row(
              children: [
                Expanded(child: _itemGroupFilterWidget()),
                const VerticalDivider(color: Colors.black, thickness: .5),
                Expanded(child: _statusFilterWidget()),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Obx(() {
            if (_controller.data.isNotEmpty) {
              return Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: 24.0, top: 8, bottom: 8),
                  child: getHeadingText(
                      text: 'Note : SAP Qty is in red',
                      fontSize: 11,
                      color: Colors.red),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
          Obx(() {
            if (_controller.isLoading.value && _controller.data.isEmpty) {
              return const Padding(
                padding: EdgeInsets.only(top: 70.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return Expanded(
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
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : const SizedBox());
                },
              ),
            );
          }),
        ],
      ),
    );
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
                        getPoppinsTextSpanHeading(text: 'Quantity'),
                        getPoppinsTextSpanDetails(
                            text: dataModel.quantity?.toString() ?? '0'),
                        getPoppinsTextSpanDetails(text: '/'),
                        getPoppinsTextSpanDetails(
                            text: dataModel.sapQuantity?.toString() ?? '0',
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
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
                          getPoppinsTextSpanHeading(text: 'Batch'),
                          getPoppinsTextSpanDetails(
                              text: dataModel.batchNum?.toString() ?? ''),
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

  Widget _statusFilterWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: getInterText(
              text: 'Filter',
              textAlign: TextAlign.left,
              color: const Color(0XFF0F3C4D),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Divider(thickness: .5, color: Colors.black),
          Expanded(
            flex: 2,
            child: Obx(() => DropdownButton<InventoryStatusEnum>(
                  value: _controller.selectedInventoryStatus.value,
                  borderRadius: BorderRadius.circular(10),
                  isExpanded: true,
                  onChanged: (newValue) {
                    if (newValue != null) {
                      _controller.updateStatusFilter(newValue);
                    }
                  },
                  items: InventoryStatusEnum.values
                      .map((value) => DropdownMenuItem(
                            value: value,
                            child: Text(getInventoryStatus(
                                pickListStatusEnum: value)),
                          ))
                      .toList(),
                )),
          ),
        ],
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
                onChanged: (val) {},
                suffixIcon: IconButton(
                    onPressed: () {
                      _query.clear();
                      _controller.search('');
                    },
                    icon: const Icon(Icons.clear)),
                labelFontSize: 14),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 2),
            child: SizedBox(
              height: 43,
              child: loadingButton(
                  isLoading: false,
                  btnText: 'Search',
                  onPress: () {
                    _controller.search(_query.text);
                  }),
            ),
          )),
        ],
      ),
    );
  }
}
