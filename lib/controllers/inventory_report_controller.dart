import 'package:get/get.dart';
import 'package:scanner/common/enums.dart';
import 'package:scanner/models/group_model.dart';
import 'package:scanner/models/inventory_report_model.dart';
import 'package:scanner/services/api_exception.dart';
import 'package:scanner/services/inventory_service.dart';
import 'package:scanner/services/master_data_service.dart';

class InventoryReportController extends GetxController {
  final data = <Datum>[].obs;
  final itemGroupList = <GroupModel>[].obs;
  final isLoading = false.obs;
  final isMoreLoading = false.obs;
  final queryText = ''.obs;
  final selectedInventoryStatus = InventoryStatusEnum.all.obs;

  Rx<GroupModel?> selectedItemGroup = Rx<GroupModel?>(null);
  InventoryReportModel? inventoryReport;

  int itemsPerPage = 10;
  int currentPage = 1;

  @override
  void onInit() {
    super.onInit();
    _loadFilters();
  }

  Future<void> _loadFilters() async {
    final groups = await MasterDataService.getItemGroups();
    itemGroupList.assignAll(groups);
    if (groups.isNotEmpty) {
      selectedItemGroup.value = groups[0];
    }
    fetchReport();
  }

  Future<void> fetchReport() async {
    if (isLoading.value && currentPage > 1) return;

    if (currentPage == 1) {
      isLoading.value = true;
      inventoryReport = null;
    }

    try {
      final report = await InventoryService.getPaginatedInventoryReport(
        filter: getInventoryStatus(
            pickListStatusEnum: selectedInventoryStatus.value),
        pageNum: currentPage,
        searchTerm: queryText.value,
        pageSize: itemsPerPage,
        itemGroup: selectedItemGroup.value?.groupCode ?? 0,
      );
      inventoryReport = report;
      data.addAll(report.data ?? []);
    } on ApiException {
      // silently handle
    } catch (e) {
      // silently handle
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  void loadMoreData() {
    if (isMoreLoading.value) return;
    if (currentPage >= (inventoryReport?.totalPages ?? 0)) return;
    isMoreLoading.value = true;
    currentPage++;
    fetchReport();
  }

  void updateItemGroup(GroupModel group) {
    selectedItemGroup.value = group;
    _resetAndFetch();
  }

  void updateStatusFilter(InventoryStatusEnum status) {
    selectedInventoryStatus.value = status;
    _resetAndFetch();
  }

  void search(String query) {
    queryText.value = query;
    _resetAndFetch();
  }

  void _resetAndFetch() {
    currentPage = 1;
    data.clear();
    fetchReport();
  }
}
