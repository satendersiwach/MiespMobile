import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner/controllers/pick_list_controller.dart';
import 'package:scanner/common/enums.dart';
import 'package:scanner/models/pick_list_model.dart';
import 'package:scanner/theme/custom_colors.dart';
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
  final PickListController _controller = Get.put(PickListController());
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
    return screenWithAppBar(
      title: 'Pick List',
      drawer: const CustomDrawer(),
      body: Obx(() => _controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _controller.fetchPickList,
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
            )),
      bottomNavigationBar: Obx(() => _controller.hasSelection
          ? _viewItemsButton()
          : const SizedBox.shrink()),
    );
  }

  Widget _list() {
    return Obx(() => ListView.builder(
          controller: _scrollController,
          itemCount: _controller.displayedPickList.length + 1,
          itemBuilder: (context, index) {
            if (index == _controller.displayedPickList.length) {
              return _controller.isMoreLoading.value
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : const SizedBox.shrink();
            }

            PickListModel pickListModel = _controller.displayedPickList[index];

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

            return CheckboxListTile(
              value: pickListModel.isSelected,
              onChanged: (_) {
                final realIndex = _controller.displayedPickList.indexOf(pickListModel);
                _controller.toggleSelection(realIndex);
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: const EdgeInsets.only(left: 8),
              title: Container(
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
                                getPoppinsTextSpanHeading(text: 'Pick List id'),
                                getPoppinsTextSpanDetails(
                                    text: pickListModel.absEntry.toString()),
                              ])),
                              Text.rich(TextSpan(children: [
                                getPoppinsTextSpanHeading(text: 'SO Id'),
                                getPoppinsTextSpanDetails(
                                    text: pickListModel.docEntry.toString()),
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
                                  getPoppinsTextSpanHeading(text: 'Status'),
                                  getPoppinsTextSpanDetails(
                                      text: pickListModel.status == 'P'
                                          ? 'Picked'
                                          : 'Assigned'),
                                ])),
                                Text.rich(TextSpan(children: [
                                  getPoppinsTextSpanHeading(text: 'Total Items'),
                                  getPoppinsTextSpanDetails(
                                      text:
                                          pickListModel.totalItems.toString()),
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
          },
        ));
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
            child: Obx(() => DropdownButton<PickListStatusEnumForUser>(
                  value: _controller.pickListStatusEnum.value,
                  onChanged: (newValue) {
                    if (newValue != null) {
                      _controller.updateStatusFilter(newValue);
                    }
                  },
                  items: PickListStatusEnumForUser.values
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

  Widget _assignCountContainer() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Obx(() => getPoppinsText(
            text:
                'You have ${_controller.pickList.length} Pick List assigned',
            decoration: TextDecoration.underline,
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 14)),
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
            padding: const EdgeInsets.only(bottom: 8, top: 2),
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

  Widget _viewItemsButton() {
    final count = _controller.selectedPickListIds.length;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: appPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Get.to(() => PickListItemScreen(
                    pickListIds: _controller.selectedPickListIds,
                  ))?.then((_) => _controller.fetchPickList());
            },
            child: getPoppinsText(
              text: 'View Items ($count selected)',
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
