import 'package:get/get.dart';
import 'package:scanner/common/enums.dart';
import 'package:scanner/models/pick_list_model.dart';
import 'package:scanner/services/api_exception.dart';
import 'package:scanner/services/pick_list_service.dart';
import 'package:scanner/theme/custom_snack_bar.dart';

class SuperAdminController extends GetxController {
  final pickList = <PickListModel>[].obs;
  final isLoading = false.obs;
  final pickListStatusEnum = PickListStatusEnumForAdmin.open.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    pickList.clear();
    try {
      final result = await PickListService.getPickListByStatus(
        status: getPickListStatusFromEnum(
            pickListStatusEnum: pickListStatusEnum.value),
      );
      pickList.assignAll(result);
    } on ApiException {
      // silently handle
    } catch (e) {
      CustomSnackBar.errorSnackBar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void updateStatusFilter(PickListStatusEnumForAdmin status) {
    pickListStatusEnum.value = status;
    fetchData();
  }

  bool atLeastOneSelected() {
    return pickList.any((p) => p.isSelected);
  }

  List<PickListModel> get selectedPickLists =>
      pickList.where((p) => p.isSelected).toList();

  Future<void> removeSelectedPickLists() async {
    final selected = pickList
        .where((p) => p.isSelected)
        .map((p) => p.docEntry.toString())
        .toList();
    try {
      final responseMap = await PickListService.removePickList(l: selected);
      fetchData();
      CustomSnackBar.successSnackBar(responseMap['Result']);
    } on ApiException catch (e) {
      CustomSnackBar.errorSnackBar(e.validationError ?? e.message);
    } catch (e) {
      CustomSnackBar.errorSnackBar(e.toString());
    }
  }

  Future<void> removeSinglePickList(PickListModel pickListModel) async {
    try {
      final responseMap = await PickListService.removePickList(
          l: [pickListModel.absEntry.toString()]);
      fetchData();
      CustomSnackBar.successSnackBar(responseMap['Result']);
    } on ApiException catch (e) {
      CustomSnackBar.errorSnackBar(e.validationError ?? e.message);
    } catch (e) {
      CustomSnackBar.errorSnackBar(e.toString());
    }
  }

  void toggleSelection(int index) {
    pickList[index].isSelected = !pickList[index].isSelected;
    pickList.refresh();
  }
}
