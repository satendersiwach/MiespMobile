import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:scanner/common/enums.dart';
import 'package:scanner/local_storage/keys.dart';
import 'package:scanner/local_storage/local_storage.dart';
import 'package:scanner/models/assign_pick_list_model.dart';
import 'package:scanner/models/customer_model.dart';
import 'package:scanner/models/item_details_model.dart';
import 'package:scanner/models/pick_list_item_detail_model.dart';
import 'package:scanner/models/pick_list_model.dart';
import 'package:scanner/models/stock_count_request_model.dart';
import 'package:scanner/models/stock_counting_detail_model.dart';
import 'package:scanner/models/uom_model.dart';
import 'package:scanner/models/update_pick_list_model.dart';
import 'package:scanner/models/warehouse_model.dart';
import 'package:scanner/theme/custom_snack_bar.dart';
import 'package:scanner/translations/custom_locale.dart';
import 'package:scanner/zzz.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceManager {
  static Codec<String, String> stringToBase64 = utf8.fuse(base64);

  // static String baseURL = 'http://satusingh-001-site1.mtempurl.com/api/';
  static String baseURL = 'http://192.168.10.42:8084/api/';
  static String credentials = '11205952:60-dayfreetrial';
  static String encoded = stringToBase64.encode(credentials);

  static Map<String, String>? header = {
    'Authorization': 'Basic $encoded',
    "content-type": "application/json",
    "connection": "keep-alive"
  };

  static Future<bool> isInternetAvailable() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      CustomSnackBar.errorSnackBar('No Internet');
      return false;
    }
    return true;
  }

  static scanQRCode({
    required Function(String) onSuccess,
  }) async {
    String scanResult = '';
    try {
      Get.to(() => BarcodeScannerSimple(
            barCodeScanResult: (String? res) {
              onSuccess(res ?? '');
            },
          ));
      // MobileScanner(
      //   onDetect: (BarcodeCapture barcodes) {
      //     barcodes.barcodes.firstOrNull;
      //   },
      //
      // );
      // scanResult = await FlutterBarcodeScanner.scanBarcode(
      //   '#ff6666', // Color for the background of the scan page
      //   'Cancel', // Text for the button that cancels the scan
      //   true, // Whether to show the flash icon
      //   ScanMode.QR, // The type of code to scan (QR Code or Barcode)
      // );
    } catch (e) {
      print('Error during scan: $e');
      CustomSnackBar.errorSnackBar('Error during scan: $e');
      return;
    }

    // if (scanResult != '-1') {
    //   onSuccess(scanResult);
    // }
  }

  static void updateCurrentLangCode(String locale) async {
    LocalStorage.getInstance()
        ?.localStorage
        ?.setString(keyAppLocaleCode, locale);
    Get.updateLocale(CustomLocale.toLocale(locale));
  }

  static Future<bool> checkInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    return true;
  }

  static launchInBrowser(Uri? uri) async {
    try {
      if (await canLaunchUrl(uri ?? Uri.parse(''))) {
        await launchUrl(uri ?? Uri.parse(''));
      } else {}
    } catch (e) {
      CustomSnackBar.errorSnackBar(e.toString());
    }
  }

  static launchCSV() async {
    try {
      File file = File('/storage/emulated/0/Download/report.csv');
      print(await file.exists());
      if (await canLaunchUrl(
          Uri.parse('/storage/emulated/0/Download/report.csv'))) {
        await launchUrl(Uri.parse('/storage/emulated/0/Download/report.csv'));
      } else {
        print('Cant launch');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<void> login({
    required String Username,
    required String Password,
    required Function(UserModel) onSuccess,
    required Function(Map) onError,
  }) async {
    try {
      UserModel? customerModel;
      var res = await http.post(Uri.parse('${baseURL}logindetails/login'),
          headers: header,
          body: jsonEncode({"Code": Username, "Password": Password}));
      print(res.body);
      Map responseMap = jsonDecode(res.body);
      if (!responseMap['IsError']) {
        customerModel = UserModel.fromJson(jsonDecode(res.body)['Result']);
        onSuccess(customerModel);
      } else {
        onError(responseMap);
      }
      // if (res.statusCode == 200) {
      // } else {
      // }
    } catch (e) {
      CustomSnackBar.errorSnackBar(e.toString());
    }
  }

  static Future<List<UserModel>> getUserList() async {
    List<UserModel> userList = [];
    try {
      var res = await http.get(
        Uri.parse('${baseURL}master/getusers'),
        headers: header,
      );
      print(res.body);
      Map responseMap = jsonDecode(res.body);
      if (!responseMap['IsError']) {
        List l = responseMap['Result'];

        for (var user in l) {
          userList.add(UserModel.fromJson(user));
        }
      }
    } catch (e) {
      CustomSnackBar.errorSnackBar(e.toString());
    }
    return userList;
  }

  static Future<void> getPickListByStatus({
    required String status,
    required Function(List<PickListModel>) onSuccess,
    required Function(Map) onError,
  }) async {
    try {
      List<PickListModel> pickList = [];
      var res = await http.get(
        Uri.parse('${baseURL}PickList/GetPicklistByStatus?status=$status'),
        headers: header,
      );
      print(res.body);
      Map responseMap = jsonDecode(res.body);
      if (!responseMap['IsError']) {
        List open = responseMap['Result'];
        for (Map<String, dynamic> map in open) {
          pickList.add(PickListModel.fromJson(map));
        }
        onSuccess(pickList);
      } else {
        onError(responseMap);
      }
      // if (res.statusCode == 200) {
      // } else {
      // }
    } catch (e) {
      CustomSnackBar.errorSnackBar(e.toString());
    }
  }

  static Future<void> getPickListByUser({
    required String username,
    required String status,
    required Function(List<PickListModel>) onSuccess,
    required Function(Map) onError,
  }) async {
    try {
      List<PickListModel> pickList = [];
      var res = await http.get(
        Uri.parse(
            '${baseURL}PickList/GetPickListByUser?status=$status&user=$username'),
        headers: header,
      );
      print(res.body);
      Map responseMap = jsonDecode(res.body);
      if (!responseMap['IsError']) {
        List open = responseMap['Result'];
        for (Map<String, dynamic> map in open) {
          pickList.add(PickListModel.fromJson(map));
        }
        onSuccess(pickList);
      } else {
        onError(responseMap);
      }
      // if (res.statusCode == 200) {
      // } else {
      // }
    } catch (e) {
      CustomSnackBar.errorSnackBar(e.toString());
    }
  }

  static Future<void> updatePickList({
    required List<UpdatePickListModel> l,
    required Function(Map) onSuccess,
    required Function(Map) onError,
  }) async {
    try {
      List<Map<String, dynamic>> list = [];
      for (UpdatePickListModel updatePickListModel in l) {
        list.add(updatePickListModel.toJson());
      }
      var res = await http.post(Uri.parse('${baseURL}picklist/UpdatePickList'),
          headers: header, body: jsonEncode(l));
      print(res.body);
      Map responseMap = jsonDecode(res.body);
      if (responseMap['Code'] == 0) {
        onSuccess(responseMap);
      } else {
        onError(responseMap);
      }
      // if (res.statusCode == 200) {
      // } else {
      // }
    } catch (e) {
      CustomSnackBar.errorSnackBar(e.toString());
    }
  }

  static Future<void> assignPickList({
    required List<AssignPickListModel> l,
    required Function(Map) onSuccess,
    required Function(Map) onError,
  }) async {
    try {
      var res = await http.post(Uri.parse('${baseURL}picklist/AssignPickList'),
          headers: header, body: jsonEncode(l));
      print(res.body);
      Map responseMap = jsonDecode(res.body);
      if (!responseMap['IsError']) {
        onSuccess(responseMap);
      } else {
        onError(responseMap);
      }
      // if (res.statusCode == 200) {
      // } else {
      // }
    } catch (e) {
      CustomSnackBar.errorSnackBar(e.toString());
    }
  }

  static Future<void> getListingItems({
    required String status,
    required String search,
    required List<int> pickListId,
    required Function(List<PickListItemDetailModel>) onSuccess,
    required Function(Map) onError,
  }) async {
    try {
      List<PickListItemDetailModel> pickListItems=[];
      UserModel userModel = UserModel.getLoginCustomer();
      var res = await http.post(Uri.parse('${baseURL}picklist/GetListingItems'),
          headers: header,
          body: jsonEncode({
            "Status": status,
            "Search": search,
            "User": userModel.username,
            "PickList": pickListId
          }));
      print(res.body);
      Map responseMap = jsonDecode(res.body);
      if (!responseMap['IsError']) {
        List open = responseMap['Result'];
        for (Map<String, dynamic> map in open) {
          pickListItems.add(PickListItemDetailModel.fromJson(map));
        }
        onSuccess(pickListItems);
      } else {
        onError(responseMap);
      }
      // if (res.statusCode == 200) {
      // } else {
      // }
    } catch (e) {
      CustomSnackBar.errorSnackBar(e.toString());
    }
  }

  static Future<void> removePickList({
    required List<String> l,
    required Function(Map) onSuccess,
    required Function(Map) onError,
  }) async {
    try {
      var res = await http.post(Uri.parse('${baseURL}picklist/RemovePickList'),
          headers: header, body: jsonEncode(l));
      print(res.body);
      Map responseMap = jsonDecode(res.body);
      if (!responseMap['IsError']) {
        onSuccess(responseMap);
      } else {
        onError(responseMap);
      }
      // if (res.statusCode == 200) {
      // } else {
      // }
    } catch (e) {
      CustomSnackBar.errorSnackBar(e.toString());
    }
  }

  static Future<void> getWarehouseList({
    required Function(List<WarehouseModel>) onSuccess,
    required Function onError,
  }) async {
    List<WarehouseModel>? warehouseList = [];
    ;
    var res = await http.get(
      Uri.parse('${baseURL}Items/GetWarehouseList'),
      headers: header,
    );
    print(res.body);
    if (res.statusCode == 200) {
      warehouseList = warehouseModelFromJson(res.body);
      onSuccess(warehouseList);
    } else {
      onError();
    }
  }

  static Future<void> getUOMList({
    required Function(List<UomModel>) onSuccess,
    required Function onError,
  }) async {
    List<UomModel>? uomList = [];
    var res = await http.get(
      Uri.parse('${baseURL}Items/GetUOM'),
      headers: header,
    );
    print(res.body);
    if (res.statusCode == 200) {
      uomList = uomModelFromJson(res.body);
      onSuccess(uomList);
    } else {
      onError();
    }
  }

  static Future<void> saveStockCounting({
    required List<StockCountRequestModel> requestList,
    required Function onSuccess,
    required Function(String error) onError,
  }) async {
    var res = await http.post(
      Uri.parse('${baseURL}Items/SaveStockCounting'),
      headers: header,
      body: jsonEncode(requestList),
    );
    print(res.body);
    if (res.statusCode == 200) {
      onSuccess();
    } else {
      onError(res.body);
    }
  }

  static Future<void> getItemDetails({
    required String barCode,
    required Function(ItemDetailModel) onSuccess,
    required Function onError,
  }) async {
    ItemDetailModel? warehouseList;
    UserModel customerModel = UserModel.getLoginCustomer();
    WarehouseModel? warehouseModel = WarehouseModel.getSelectedWarehouse();

    var res = await http.post(
      Uri.parse('${baseURL}Items/GetItemDetail'),
      body: jsonEncode({
        "Barcode": barCode,
        "UserId": customerModel.userId ?? 0,
        "WarehouseCode": warehouseModel?.warehouseCode ?? ''
      }),
      headers: header,
    );
    print(res.body);
    if (res.statusCode == 200) {
      if (res.body == 'null') {
        onError();
        return;
      }
      warehouseList = itemDetailModelFromJson(res.body);
      onSuccess(warehouseList);
    } else {
      onError();
    }
  }

  static Future<void> getStockCountingDetail({
    required String barCode,
    required Function(StockCountingDetailModel) onSuccess,
    required Function onError,
  }) async {
    StockCountingDetailModel? stockCountingDetail;
    UserModel customerModel = UserModel.getLoginCustomer();
    WarehouseModel? warehouseModel = WarehouseModel.getSelectedWarehouse();

    var res = await http.post(
      Uri.parse('${baseURL}Items/GetStockCountingDetail'),
      body: jsonEncode({
        "Barcode": barCode,
        "UserId": customerModel.userId ?? 0,
        "WarehouseCode": warehouseModel?.warehouseCode ?? ''
      }),
      headers: header,
    );
    print(res.body);
    if (res.statusCode == 200) {
      if (res.body == 'null') {
        onError();
        return;
      }
      stockCountingDetail = stockCountingDetailModelFromJson(res.body);
      onSuccess(stockCountingDetail);
    } else {
      onError();
    }
  }

  static String getPickListStatusFromEnum({required var pickListStatusEnum}) {
    if (pickListStatusEnum == PickListStatusEnumForAdmin.assigned ||
        pickListStatusEnum == PickListStatusEnumForUser.notPicked) {
      return 'A';
    }
    if (pickListStatusEnum == PickListStatusEnumForAdmin.closed) {
      return 'C';
    }
    if (pickListStatusEnum == PickListStatusEnumForAdmin.open) {
      return 'O';
    }
    if (pickListStatusEnum == PickListStatusEnumForUser.picked) {
      return 'P';
    }
    if (pickListStatusEnum == PickListStatusEnumForAdmin.all ||
        pickListStatusEnum == PickListStatusEnumForUser.all) {
      return 'All';
    } else {
      return '';
    }
  }
}
