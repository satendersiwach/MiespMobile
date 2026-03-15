import 'package:scanner/models/user_model.dart';
import 'package:scanner/models/inventory_report_model.dart';
import 'package:scanner/models/pending_item_model.dart';
import 'package:scanner/models/remove_inventory_model.dart';
import 'package:scanner/models/update_inventory_model.dart';
import 'package:scanner/services/api_client.dart';

class InventoryService {
  static Future<InventoryReportModel> getPaginatedInventoryReport({
    required int pageNum,
    required int pageSize,
    required String searchTerm,
    required int itemGroup,
    required String filter,
  }) async {
    final responseMap = await ApiClient.post(
      'Inventory/GetPaginatedInventoryReport',
      body: {
        "PageNum": pageNum,
        "PageSize": pageSize,
        "ItemGroup": itemGroup,
        "SearchTerm": searchTerm,
        "Filter": filter,
      },
    );
    return InventoryReportModel.fromJson(responseMap['Result']);
  }

  static Future<PendingItemModel> getItemsPendingForInventory({
    required int pageNum,
    required int pageSize,
    required int itemGroup,
  }) async {
    final responseMap = await ApiClient.post(
      'Inventory/GetItemsPendingForInventory',
      body: {
        "PageNum": pageNum,
        "PageSize": pageSize,
        "ItemGroupCod": itemGroup,
      },
    );
    return PendingItemModel.fromJson(responseMap['Result']);
  }

  static Future<Map> addInventoryCounting({
    required String batchNumber,
  }) async {
    UserModel customerModel = UserModel.getLoginCustomer();
    return await ApiClient.post(
      'Inventory/AddInventoryCounting',
      body: {"batchNumber": batchNumber, "user": customerModel.userCode},
    );
  }

  static Future<Map> updateInventoryCounting({
    required UpdateInventoryModel updateInventoryModel,
  }) async {
    return await ApiClient.post(
      'Inventory/UpdateInventoryCounting',
      body: updateInventoryModel.toJson(),
    );
  }

  static Future<Map> removeInventoryCounting({
    required RemoveInventoryModel removeInventoryModel,
  }) async {
    return await ApiClient.post(
      'Inventory/RemoveInventoryCounting',
      body: removeInventoryModel.toJson(),
    );
  }
}
