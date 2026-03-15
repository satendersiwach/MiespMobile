import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:scanner/models/customer_model.dart';
import 'package:scanner/models/group_model.dart';
import 'package:scanner/models/user_inventory_model.dart';
import 'package:scanner/services/api_config.dart';

class MasterDataService {
  static Future<List<GroupModel>> getItemGroups() async {
    List<GroupModel> l = [];
    var res = await http.get(
      Uri.parse('${ApiConfig.baseURL}Inventory/GetItemGroups'),
      headers: ApiConfig.header,
    );
    Map responseMap = jsonDecode(res.body);
    if (!responseMap['IsError']) {
      for (Map<String, dynamic> i in responseMap['Result']) {
        l.add(GroupModel.fromJson(i));
      }
    }
    return l;
  }

  static Future<List<UserModel>> getUserList() async {
    List<UserModel> userList = [];
    var res = await http.get(
      Uri.parse('${ApiConfig.baseURL}master/getusers'),
      headers: ApiConfig.header,
    );
    Map responseMap = jsonDecode(res.body);
    if (!responseMap['IsError']) {
      List l = responseMap['Result'];
      for (var user in l) {
        userList.add(UserModel.fromJson(user));
      }
    }
    return userList;
  }

  static Future<List<UserInventoryModel>> getUserInventoryList() async {
    List<UserInventoryModel> userInventoryList = [];
    UserModel customerModel = UserModel.getLoginCustomer();
    String url =
        '${ApiConfig.baseURL}Inventory/GetInventoryByUser?user=${customerModel.userCode}';

    var res = await http.get(
      Uri.parse(url),
      headers: ApiConfig.header,
    );
    Map responseMap = jsonDecode(res.body);
    if (!responseMap['IsError']) {
      List l = responseMap['Result'];
      for (var user in l) {
        userInventoryList.add(UserInventoryModel.fromJson(user));
      }
    }
    return userInventoryList;
  }
}
