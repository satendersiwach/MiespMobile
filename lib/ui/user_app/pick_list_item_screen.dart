import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scanner/controllers/pick_list_item_controller.dart';
import 'package:scanner/services/scanner_event_service.dart';
import 'package:scanner/common/enums.dart';
import 'package:scanner/models/pick_list_item_detail_model.dart';
import 'package:scanner/services/scanner_service.dart';
import 'package:scanner/theme/custom_colors.dart';
import 'package:scanner/theme/custom_snack_bar.dart';
import 'package:scanner/theme/custom_text_widgets.dart';
import 'package:scanner/theme/elements_screen.dart';
import 'package:scanner/theme/get_text_field.dart';
import 'package:scanner/ui/components/element_button.dart';

class PickListItemScreen extends StatefulWidget {
  final List<int> pickListIds;
  final PickListStatusEnum initialStatus;

  const PickListItemScreen({
    super.key,
    required this.pickListIds,
    this.initialStatus = PickListStatusEnum.notPicked,
  });

  @override
  State<PickListItemScreen> createState() => _PickListItemScreenState();
}

class _PickListItemScreenState extends State<PickListItemScreen> {
  late final PickListItemController _controller;
  final TextEditingController query = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = Get.put(PickListItemController(
      pickListIds: widget.pickListIds,
    ));
    _controller.pickListStatusEnum.value = widget.initialStatus;
    _controller.fetchItems();
    ScannerEventService().pushHandler(_handleBarcode);
  }

  void _handleBarcode(String barcode) {
    _controller.pickByBarcode(barcode);
  }

  @override
  void dispose() {
    ScannerEventService().removeHandler(_handleBarcode);
    _scrollController.dispose();
    query.dispose();
    Get.delete<PickListItemController>();
    super.dispose();
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
                  _controller.updateQuery(val);
                },
                suffixIcon: IconButton(
                    onPressed: () {
                      query.clear();
                      _controller.updateQuery('');
                      _controller.fetchItems();
                    },
                    icon: const Icon(Icons.clear)),
                labelFontSize: 14),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 2),
            child: SizedBox(
              height: 43,
              child: FittedBox(
                child: loadingButton(
                    isLoading: false,
                    btnText: 'Search',
                    onPress: () {
                      _controller.fetchItems();
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
            child: Obx(() => DropdownButton<PickListStatusEnum>(
                  value: _controller.pickListStatusEnum.value,
                  onChanged: (newValue) {
                    if (newValue != null) {
                      _controller.updateStatusFilter(newValue);
                    }
                  },
                  items: PickListStatusEnum.values
                      .map((value) => DropdownMenuItem(
                            value: value,
                            child: Text(getEnumLabel(value)),
                          ))
                      .toList(),
                  borderRadius: BorderRadius.circular(10),
                )),
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return screenWithAppBar(
        title: 'Pick list items',
        body: Obx(() => _controller.isLoading.value
            ? const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Center(child: CircularProgressIndicator()),
              )
            : SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    const SizedBox(height: 25),
                    _queryWidget(),
                    const SizedBox(height: 10),
                    _statusFilterWidget(),
                    const SizedBox(height: 4),
                    _list(),
                  ],
                ),
              )));
  }

  Widget _list() {
    return Obx(() {
      final items = _controller.pickListItems;
      return Column(
        children: [
          getHeadingText(
              text:
                  'You have total of (${items.length}) ${items.length == 1 ? 'item' : 'items'}'),
          ListView.separated(
            itemCount: items.length,
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (index >= items.length) return Container();

              PickListItemDetailModel pickListModel = items[index];
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
                        Text.rich(TextSpan(children: [
                          getPoppinsTextSpanHeading(text: 'Item Name'),
                          getPoppinsTextSpanDetails(text: pickListModel.itemName),
                        ])),
                        Text.rich(TextSpan(children: [
                          getPoppinsTextSpanHeading(text: 'Dist Number'),
                          getPoppinsTextSpanDetails(
                              text: pickListModel.distNumber.toString()),
                        ])),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(TextSpan(children: [
                                  getPoppinsTextSpanHeading(text: 'Item Code'),
                                  getPoppinsTextSpanDetails(
                                      text: pickListModel.itemCode.toString()),
                                ])),
                                Text.rich(TextSpan(children: [
                                  getPoppinsTextSpanHeading(text: 'Doc Entry'),
                                  getPoppinsTextSpanDetails(
                                      text: pickListModel.docEntry.toString()),
                                ])),
                                Text.rich(TextSpan(children: [
                                  getPoppinsTextSpanHeading(text: 'Abs Entry'),
                                  getPoppinsTextSpanDetails(
                                      text: pickListModel.absEntry.toString()),
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
                                    getPoppinsTextSpanHeading(text: 'Rel Qtty'),
                                    getPoppinsTextSpanDetails(
                                        text: pickListModel.relQtty.toString()),
                                  ])),
                                  Text.rich(TextSpan(children: [
                                    getPoppinsTextSpanHeading(text: 'Whs Code'),
                                    getPoppinsTextSpanDetails(
                                        text: pickListModel.whsCode.toString()),
                                  ])),
                                  Text.rich(TextSpan(children: [
                                    getPoppinsTextSpanHeading(text: 'Picked'),
                                    getPoppinsTextSpanDetails(
                                        text: pickListModel.picked),
                                  ])),
                                ],
                              ),
                            )),
                          ],
                        ),
                        if (pickListModel.picked == 'N') ...[
                          const SizedBox(height: 10),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: Divider(thickness: 1, color: Colors.grey),
                          ),
                          _buttonContainer(),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              if (index >= items.length) return Container();
              return const Divider(thickness: 1.5, color: Colors.grey);
            },
          ),
        ],
      );
    });
  }

  Widget _buttonContainer() {
    return SizedBox(
      height: 30,
      child: InkWell(
        onTap: () async {
          try {
            final scanResult = await ScannerService.scanQRCode();
            if (!mounted) return;
            if (scanResult != null) {
              _controller.pickByBarcode(scanResult);
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
            Icon(MdiIcons.barcode, color: appPrimary),
            const SizedBox(width: 10),
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
