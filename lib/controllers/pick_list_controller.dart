import 'package:get/get.dart';
import 'package:scanner/common/enums.dart';
import 'package:scanner/models/user_model.dart';
import 'package:scanner/models/pick_list_model.dart';
import 'package:scanner/services/api_exception.dart';
import 'package:scanner/services/pick_list_service.dart';

class PickListController extends GetxController {
  final pickList = <PickListModel>[].obs;
  final displayedPickList = <PickListModel>[].obs;
  final isLoading = false.obs;
  final isMoreLoading = false.obs;
  final query = ''.obs;

  final pickListStatusEnum = PickListStatusEnumForUser.notPicked.obs;

  int itemsPerPage = 20;
  int currentPage = 0;

  @override
  void onInit() {
    super.onInit();
    fetchPickList();
  }

  Future<void> fetchPickList() async {
    isLoading.value = true;
    pickList.clear();
    displayedPickList.clear();
    currentPage = 0;

    UserModel userModel = UserModel.getLoginCustomer();
    try {
      final result = await PickListService.getPickListByUser(
        username: userModel.username ?? "",
        status: getPickListStatusFromEnum(
            pickListStatusEnum: pickListStatusEnum.value),
      );
      pickList.assignAll(result);
      loadMoreData();
    } on ApiException {
      // silently handle
    } catch (e) {
      // silently handle
    } finally {
      isLoading.value = false;
    }
  }

  void loadMoreData() {
    if (isMoreLoading.value || (currentPage * itemsPerPage) >= pickList.length) {
      return;
    }
    isMoreLoading.value = true;

    Future.delayed(const Duration(seconds: 1), () {
      int start = currentPage * itemsPerPage;
      int end = (start + itemsPerPage).clamp(0, pickList.length);
      displayedPickList.addAll(pickList.sublist(start, end));
      currentPage++;
      isMoreLoading.value = false;
    });
  }

  void updateStatusFilter(PickListStatusEnumForUser status) {
    pickListStatusEnum.value = status;
    fetchPickList();
  }

  void toggleSelection(int index) {
    displayedPickList[index].isSelected = !displayedPickList[index].isSelected;
    displayedPickList.refresh();
    pickList.refresh();
  }

  List<int> get selectedPickListIds =>
      pickList.where((p) => p.isSelected).map((p) => p.absEntry).toList();

  bool get hasSelection => pickList.any((p) => p.isSelected);

}
