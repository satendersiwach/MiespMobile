import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:scanner/LogFile/log_file_functions.dart';
import 'package:scanner/models/customer_model.dart';
import 'package:scanner/models/inventory_report_model.dart';
import 'package:scanner/models/pending_item_model.dart';
import 'package:scanner/models/remove_inventory_model.dart';
import 'package:scanner/models/update_inventory_model.dart';
import 'package:scanner/services/api_config.dart';
import 'package:scanner/services/api_exception.dart';

class InventoryService {
  static Future<InventoryReportModel> getPaginatedInventoryReport({
    required int pageNum,
    required int pageSize,
    required String searchTerm,
    required int itemGroup,
    required String filter,
  }) async {
    Map map = {
      "PageNum": pageNum,
      "PageSize": pageSize,
      "ItemGroup": itemGroup,
      "SearchTerm": searchTerm,
      "Filter": filter
    };
    var res = await http.post(
        Uri.parse('${ApiConfig.baseURL}Inventory/GetPaginatedInventoryReport'),
        headers: ApiConfig.header,
        body: jsonEncode(map));
    Map responseMap = jsonDecode(res.body);
    if (!responseMap['IsError']) {
      return InventoryReportModel.fromJson(responseMap['Result']);
    } else {
      throw ApiException(
        responseMap['Error'] ?? 'Failed to get inventory report',
        responseMap: Map<String, dynamic>.from(responseMap),
      );
    }
  }

  static Future<PendingItemModel> getItemsPendingForInventory({
    required int pageNum,
    required int pageSize,
    required int itemGroup,
  }) async {
    Map map = {
      "PageNum": pageNum,
      "PageSize": pageSize,
      "ItemGroupCod": itemGroup
    };
    var res = await http.post(
        Uri.parse('${ApiConfig.baseURL}Inventory/GetItemsPendingForInventory'),
        headers: ApiConfig.header,
        body: jsonEncode(map));
    Map responseMap = jsonDecode(res.body);
    if (!responseMap['IsError']) {
      return PendingItemModel.fromJson(responseMap['Result']);
    } else {
      throw ApiException(
        responseMap['Error'] ?? 'Failed to get pending items',
        responseMap: Map<String, dynamic>.from(responseMap),
      );
    }
  }

  static Future<Map> addInventoryCounting({
    required String batchNumber,
  }) async {
    UserModel customerModel = UserModel.getLoginCustomer();
    String text = '''
      API call
      -----------------
      Calling AddInventoryCounting API with the following parameters
      Username : ${customerModel.username}
      Header : ${ApiConfig.header}
      Body :  ${{"batchNumber": batchNumber, "user": customerModel.userCode}}
      URL : ${ApiConfig.baseURL}Inventory/AddInventoryCounting
      ''';
    await writeToLogFile(
        text: text,
        heading: 'Value',
        fileName: StackTrace.current.toString());
    var res = await http.post(
        Uri.parse('${ApiConfig.baseURL}Inventory/AddInventoryCounting'),
        headers: ApiConfig.header,
        body: jsonEncode(
            {"batchNumber": batchNumber, "user": customerModel.userCode}));

    String resText = '''
      API call response for URL : ${ApiConfig.baseURL}Inventory/AddInventoryCounting
      -------------------------------------------------------------------------------------
      Response : ${res.body}
      ''';
    await writeToLogFile(
        text: resText,
        heading: 'Value',
        fileName: StackTrace.current.toString());
    Map responseMap = jsonDecode(res.body);
    if (!responseMap['IsError']) {
      return responseMap;
    } else {
      throw ApiException(
        responseMap['Error'] ?? 'Failed to add inventory counting',
        responseMap: Map<String, dynamic>.from(responseMap),
      );
    }
  }

  static Future<Map> updateInventoryCounting({
    required UpdateInventoryModel updateInventoryModel,
  }) async {
    String url = '${ApiConfig.baseURL}Inventory/UpdateInventoryCounting';

    String text = '''
    API call
    -----------------
    Calling Update Inventory Counting API with the following parameters
    Header : ${ApiConfig.header}
    Body :  ${jsonEncode(updateInventoryModel.toJson())}
    URL : $url
    ''';
    await writeToLogFile(
        text: text,
        heading: 'Value',
        fileName: StackTrace.current.toString());

    var res = await http.post(Uri.parse(url),
        headers: ApiConfig.header,
        body: jsonEncode(updateInventoryModel.toJson()));
    String resText = '''
    API call response for URL : $url
    -------------------------------------------------------------------------------------
    Response : ${res.body}
    ''';
    await writeToLogFile(
        text: resText,
        heading: 'Value',
        fileName: StackTrace.current.toString());
    Map responseMap = jsonDecode(res.body);
    if (!responseMap['IsError']) {
      String resText = '''
    Calling success function
    -------------------------
    Response : $responseMap
    ''';
      await writeToLogFile(
          text: resText,
          heading: 'Value',
          fileName: StackTrace.current.toString());
      return responseMap;
    } else {
      String resText = '''
    Calling error function
    -------------------------
    Response : $responseMap
    ''';
      await writeToLogFile(
          text: resText,
          heading: 'Value',
          fileName: StackTrace.current.toString());
      throw ApiException(
        responseMap['Error'] ?? 'Failed to update inventory counting',
        responseMap: Map<String, dynamic>.from(responseMap),
      );
    }
  }

  static Future<Map> removeInventoryCounting({
    required RemoveInventoryModel removeInventoryModel,
  }) async {
    String url = '${ApiConfig.baseURL}Inventory/RemoveInventoryCounting';
    String text = '''
    API call
    -----------------
    Calling Remove Inventory Counting API with the following parameters
    Header : ${ApiConfig.header}
    Body :  ${jsonEncode(removeInventoryModel.toJson())}
    URL : $url
    ''';
    await writeToLogFile(
        text: text,
        heading: 'Value',
        fileName: StackTrace.current.toString());
    var res = await http.post(Uri.parse(url),
        headers: ApiConfig.header,
        body: jsonEncode(removeInventoryModel.toJson()));
    String resText = '''
    API call response for URL : $url
    -------------------------------------------------------------------------------------
    Response : ${res.body}
    ''';
    await writeToLogFile(
        text: resText,
        heading: 'Value',
        fileName: StackTrace.current.toString());
    Map responseMap = jsonDecode(res.body);
    if (!responseMap['IsError']) {
      String resText = '''
    Calling success function
    -------------------------
    Response : $responseMap
    ''';
      await writeToLogFile(
          text: resText,
          heading: 'Value',
          fileName: StackTrace.current.toString());
      return responseMap;
    } else {
      String resText = '''
    Calling error function
    -------------------------
    Response : $responseMap
    ''';
      await writeToLogFile(
          text: resText,
          heading: 'Value',
          fileName: StackTrace.current.toString());
      throw ApiException(
        responseMap['Error'] ?? 'Failed to remove inventory counting',
        responseMap: Map<String, dynamic>.from(responseMap),
      );
    }
  }
}
