import 'package:get/get.dart';
import 'package:scanner/models/group_model.dart';
import 'package:scanner/models/pending_item_model.dart';
import 'package:scanner/services/api_exception.dart';
import 'package:scanner/services/auth_service.dart';
import 'package:scanner/services/inventory_service.dart';
import 'package:scanner/services/master_data_service.dart';
import 'package:scanner/theme/custom_snack_bar.dart';

class PhysicalInventoryController extends GetxController {
  final itemGroupList = <GroupModel>[].obs;
  final data = <Datum>[].obs;
  final isLoading = false.obs;
  final isMoreLoading = false.obs;

  Rx<GroupModel?> selectedItemGroup = Rx<GroupModel?>(null);
  PendingItemModel? pendingItemModel;
  int currentPage = 1;

  @override
  void onInit() {
    super.onInit();
    _loadFilters();
  }

  Future<void> _loadFilters() async {
    final groups = await MasterDataService.getItemGroups();
    groups.removeWhere((g) => g.groupName == 'All');
    itemGroupList.assignAll(groups);
    if (groups.isNotEmpty) {
      selectedItemGroup.value = groups[0];
    }
    fetchInventory();
  }

  Future<void> fetchInventory() async {
    if (isLoading.value && currentPage > 1) return;

    if (currentPage == 1) {
      isLoading.value = true;
      pendingItemModel = null;
    }

    try {
      final result = await InventoryService.getItemsPendingForInventory(
        pageNum: currentPage,
        pageSize: 10,
        itemGroup: selectedItemGroup.value?.groupCode ?? 0,
      );
      pendingItemModel = result;
      data.addAll(result.data ?? []);
    } on ApiException {
      // silently handle
    } catch (e) {
      CustomSnackBar.errorSnackBar(e.toString());
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  void loadMoreData() {
    if (isMoreLoading.value) return;
    if (currentPage >= (pendingItemModel?.totalPages ?? 0)) return;
    isMoreLoading.value = true;
    currentPage++;
    fetchInventory();
  }

  void updateItemGroup(GroupModel group) {
    selectedItemGroup.value = group;
    currentPage = 1;
    data.clear();
    fetchInventory();
  }

  Future<void> addInventoryCounting(String barCode) async {
    if (await AuthService.isInternetAvailable()) {
      try {
        final responseMap =
            await InventoryService.addInventoryCounting(batchNumber: barCode);
        currentPage = 1;
        data.clear();
        fetchInventory();
        CustomSnackBar.successSnackBar(
            responseMap['Result'] ?? 'Inventory counting added successfully');
      } on ApiException catch (e) {
        currentPage = 1;
        data.clear();
        fetchInventory();
        CustomSnackBar.errorSnackBar(
            e.validationError ?? 'Something went wrong!');
      } catch (e) {
        CustomSnackBar.errorSnackBar(e.toString());
      }
    }
  }
}
