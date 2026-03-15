import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:scanner/log_file/log_file_functions.dart';
import 'package:scanner/models/assign_pick_list_model.dart';
import 'package:scanner/models/user_model.dart';
import 'package:scanner/models/pick_list_item_detail_model.dart';
import 'package:scanner/models/pick_list_model.dart';
import 'package:scanner/models/update_pick_list_model.dart';
import 'package:scanner/services/api_config.dart';
import 'package:scanner/services/api_exception.dart';

class PickListService {
  static Future<List<PickListModel>> getPickListByStatus({
    required String status,
  }) async {
    String url = '${ApiConfig.baseURL}PickList/GetPicklistByStatus?status=$status';
    List<PickListModel> pickList = [];
    var res = await http.get(
      Uri.parse(url),
      headers: ApiConfig.header,
    );
    Map responseMap = jsonDecode(res.body);
    if (!responseMap['IsError']) {
      List open = responseMap['Result'];
      for (Map<String, dynamic> map in open) {
        pickList.add(PickListModel.fromJson(map));
      }
      return pickList;
    } else {
      throw ApiException(
        responseMap['Error'] ?? 'Failed to get pick list',
        responseMap: Map<String, dynamic>.from(responseMap),
      );
    }
  }

  static Future<List<PickListModel>> getPickListByUser({
    required String username,
    required String status,
  }) async {
    List<PickListModel> pickList = [];
    String url =
        '${ApiConfig.baseURL}PickList/GetPickListByUser?status=$status&user=$username';
    var res = await http.get(
      Uri.parse(url),
      headers: ApiConfig.header,
    );
    Map responseMap = jsonDecode(res.body);
    if (!responseMap['IsError']) {
      List open = responseMap['Result'];
      for (Map<String, dynamic> map in open) {
        pickList.add(PickListModel.fromJson(map));
      }
      return pickList;
    } else {
      throw ApiException(
        responseMap['Error'] ?? 'Failed to get pick list by user',
        responseMap: Map<String, dynamic>.from(responseMap),
      );
    }
  }

  static Future<List<PickListItemDetailModel>> getListingItems({
    required String status,
    required String search,
    required List<int> pickListId,
  }) async {
    List<PickListItemDetailModel> pickListItems = [];
    UserModel userModel = UserModel.getLoginCustomer();
    Map map = {
      "Status": status,
      "Search": search,
      "User": userModel.username,
      "PickList": pickListId
    };
    String url = '${ApiConfig.baseURL}picklist/GetListingItems';
    var res = await http.post(Uri.parse(url),
        headers: ApiConfig.header, body: jsonEncode(map));
    Map responseMap = jsonDecode(res.body);
    if (!responseMap['IsError']) {
      List open = responseMap['Result'];
      for (Map<String, dynamic> map in open) {
        pickListItems.add(PickListItemDetailModel.fromJson(map));
      }
      return pickListItems;
    } else {
      throw ApiException(
        responseMap['Error'] ?? 'Failed to get listing items',
        responseMap: Map<String, dynamic>.from(responseMap),
      );
    }
  }

  /// Note: uses `responseMap['Code'] == 0` instead of `!responseMap['IsError']`
  static Future<Map> updatePickList({
    required List<UpdatePickListModel> l,
  }) async {
    List<Map<String, dynamic>> list = [];
    for (UpdatePickListModel updatePickListModel in l) {
      list.add(updatePickListModel.toJson());
    }
    String url = '${ApiConfig.baseURL}picklist/UpdatePickList';
    String text = '''
    API call
    -----------------
    Calling Update PickList API with the following parameters
    Header : ${ApiConfig.header}
    Body :  ${jsonEncode(l)}
    URL : $url
    ''';
    await writeToLogFile(
        text: text,
        heading: 'Value',
        fileName: StackTrace.current.toString());
    var res = await http.post(Uri.parse(url),
        headers: ApiConfig.header, body: jsonEncode(l));
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
    if (responseMap['Code'] == 0) {
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
        responseMap['Error'] ?? 'Failed to update pick list',
        responseMap: Map<String, dynamic>.from(responseMap),
      );
    }
  }

  static Future<Map> removePickList({
    required List<String> l,
  }) async {
    String url = '${ApiConfig.baseURL}picklist/RemovePickList';
    String text = '''
    API call
    -----------------
    Calling Remove Pick List API with the following parameters
    Header : ${ApiConfig.header}
    Body :  ${jsonEncode(l)}
    URL : $url
    ''';
    await writeToLogFile(
        text: text,
        heading: 'Value',
        fileName: StackTrace.current.toString());
    var res = await http.post(Uri.parse(url),
        headers: ApiConfig.header, body: jsonEncode(l));
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
        responseMap['Error'] ?? 'Failed to remove pick list',
        responseMap: Map<String, dynamic>.from(responseMap),
      );
    }
  }

  static Future<Map> pickByBarcode({
    required String barcode,
    required String user,
  }) async {
    String url = '${ApiConfig.baseURL}picklist/PickByBarcode';
    Map<String, dynamic> body = {
      "barcode": barcode,
      "user": user,
    };
    String text = '''
    API call
    -----------------
    Calling Pick By Barcode API with the following parameters
    Header : ${ApiConfig.header}
    Body :  ${jsonEncode(body)}
    URL : $url
    ''';
    await writeToLogFile(
        text: text,
        heading: 'Value',
        fileName: StackTrace.current.toString());
    var res = await http.post(Uri.parse(url),
        headers: ApiConfig.header, body: jsonEncode(body));
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
        responseMap['Error'] ?? 'Failed to pick by barcode',
        responseMap: Map<String, dynamic>.from(responseMap),
      );
    }
  }

  static Future<Map> assignPickList({
    required List<AssignPickListModel> l,
  }) async {
    String url = '${ApiConfig.baseURL}picklist/AssignPickList';
    var res = await http.post(Uri.parse(url),
        headers: ApiConfig.header, body: jsonEncode(l));
    Map responseMap = jsonDecode(res.body);
    if (!responseMap['IsError']) {
      return responseMap;
    } else {
      throw ApiException(
        responseMap['Error'] ?? 'Failed to assign pick list',
        responseMap: Map<String, dynamic>.from(responseMap),
      );
    }
  }
}
