import 'package:scanner/models/assign_pick_list_model.dart';
import 'package:scanner/models/user_model.dart';
import 'package:scanner/models/pick_list_item_detail_model.dart';
import 'package:scanner/models/pick_list_model.dart';
import 'package:scanner/services/api_client.dart';

class PickListService {
  static Future<List<PickListModel>> getPickListByStatus({
    required String status,
  }) async {
    final responseMap = await ApiClient.get(
      'PickList/GetPicklistByStatus?status=$status',
    );
    return (responseMap['Result'] as List)
        .map((map) => PickListModel.fromJson(map))
        .toList();
  }

  static Future<List<PickListModel>> getPickListByUser({
    required String username,
    required String status,
  }) async {
    final responseMap = await ApiClient.get(
      'PickList/GetPickListByUser?status=$status&user=$username',
    );
    return (responseMap['Result'] as List)
        .map((map) => PickListModel.fromJson(map))
        .toList();
  }

  static Future<List<PickListItemDetailModel>> getListingItems({
    required String status,
    required String search,
    required List<int> pickListId,
  }) async {
    UserModel userModel = UserModel.getLoginCustomer();
    final responseMap = await ApiClient.post(
      'picklist/GetListingItems',
      body: {
        "Status": status,
        "Search": search,
        "User": userModel.username,
        "PickList": pickListId,
      },
    );
    return (responseMap['Result'] as List)
        .map((map) => PickListItemDetailModel.fromJson(map))
        .toList();
  }

  static Future<Map> removePickList({
    required List<String> l,
  }) async {
    return await ApiClient.post(
      'picklist/RemovePickList',
      body: l,
    );
  }

  static Future<Map> updatePickingQuantity({
    required int pickListId,
    required int soId,
    required String itemCode,
    required String user,
    required double pickQty,
    required String batchNumber,
  }) async {
    return await ApiClient.post(
      'picklist/UpdatePickingQuantity',
      body: {
        "PickListId": pickListId,
        "SOId": soId,
        "ItemCode": itemCode,
        "User": user,
        "PickQty": pickQty,
        "BatchNumber": batchNumber,
      },
    );
  }

  static Future<Map> assignPickList({
    required List<AssignPickListModel> l,
  }) async {
    return await ApiClient.post(
      'picklist/AssignPickList',
      body: l,
    );
  }
}
