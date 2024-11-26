import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:scanner/local_storage/keys.dart';
import 'package:scanner/local_storage/local_storage.dart';
import 'package:scanner/models/customer_model.dart';
import 'package:scanner/models/item_details_model.dart';
import 'package:scanner/models/stock_count_request_model.dart';
import 'package:scanner/models/stock_counting_detail_model.dart';
import 'package:scanner/models/uom_model.dart';
import 'package:scanner/models/warehouse_model.dart';
import 'package:scanner/theme/custom_snack_bar.dart';
import 'package:scanner/translations/custom_locale.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceManager {

  static Future<bool> isInternetAvailable() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      CustomSnackBar.errorSnackBar('No Internet');
      return false;
    }
    return true;
  }
  static  scanQRCode({
    required Function(String) onSuccess,
  }) async {
    String scanResult = '';
    try {
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

    if (scanResult != '-1') {
      onSuccess(scanResult);
    }
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


  static String baseURL = 'http://172.16.0.205:8085/API/';
  static Map<String, String>? header = {
    'accept': '*/*',
    'Content-Type': 'application/json'
  };



  static launchCSV() async {
    try {
      File file=File('/storage/emulated/0/Download/report.csv');
      print(await file.exists());
      if (await canLaunchUrl(Uri.parse('/storage/emulated/0/Download/report.csv'))) {
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
    required Function onError,
  }) async {
    try {
      UserModel? customerModel;
      var res = await http.post(Uri.parse('${baseURL}login/verifyuser'),
          headers: header,
          body: jsonEncode({"Username": Username, "Password": Password}));
      print(res.body);
      if (res.statusCode == 200) {
        customerModel = UserModel.fromJson(jsonDecode(res.body));
        onSuccess(customerModel);
      } else {
        CustomSnackBar.errorSnackBar(res.body);
        onError();
      }
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
      if(res.body=='null')
      {
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
      if(res.body=='null')
      {
        onError();
        return;
      }
      stockCountingDetail = stockCountingDetailModelFromJson(res.body);
      onSuccess(stockCountingDetail);
    } else {
      onError();
    }
  }
}
