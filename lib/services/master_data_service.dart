import 'package:scanner/models/user_model.dart';
import 'package:scanner/models/group_model.dart';
import 'package:scanner/models/user_inventory_model.dart';
import 'package:scanner/services/api_client.dart';

class MasterDataService {
  static Future<List<GroupModel>> getItemGroups() async {
    final responseMap = await ApiClient.get('Inventory/GetItemGroups');
    return (responseMap['Result'] as List)
        .map((i) => GroupModel.fromJson(i))
        .toList();
  }

  static Future<List<UserModel>> getUserList() async {
    final responseMap = await ApiClient.get('master/getusers');
    return (responseMap['Result'] as List)
        .map((user) => UserModel.fromJson(user))
        .toList();
  }

  static Future<List<UserInventoryModel>> getUserInventoryList() async {
    UserModel customerModel = UserModel.getLoginCustomer();
    final responseMap = await ApiClient.get(
      'Inventory/GetInventoryByUser?user=${customerModel.userCode}',
    );
    return (responseMap['Result'] as List)
        .map((user) => UserInventoryModel.fromJson(user))
        .toList();
  }
}
