import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:scanner/LogFile/LogFileFunctions.dart';
import 'package:scanner/common/enums.dart';
import 'package:scanner/local_storage/keys.dart';
import 'package:scanner/local_storage/local_storage.dart';
import 'package:scanner/models/assign_pick_list_model.dart';
import 'package:scanner/models/customer_model.dart';
import 'package:scanner/models/item_details_model.dart';
import 'package:scanner/models/pick_list_item_detail_model.dart';
import 'package:scanner/models/pick_list_model.dart';
import 'package:scanner/models/remove_inventory_model.dart';
import 'package:scanner/models/stock_count_request_model.dart';
import 'package:scanner/models/stock_counting_detail_model.dart';
import 'package:scanner/models/uom_model.dart';
import 'package:scanner/models/update_inventory_model.dart';
import 'package:scanner/models/update_pick_list_model.dart';
import 'package:scanner/models/update_picking_qty_model.dart';
import 'package:scanner/models/user_inventory_model.dart';
import 'package:scanner/models/warehouse_model.dart';
import 'package:scanner/theme/custom_snack_bar.dart';
import 'package:scanner/translations/custom_locale.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceManager {
  static Codec<String, String> stringToBase64 = utf8.fuse(base64);
  static const platform = MethodChannel('com.example.temp/rfid');

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
    // var connectivityResult = await Connectivity().checkConnectivity();
    // if (connectivityResult == ConnectivityResult.none) {
    //   CustomSnackBar.errorSnackBar('No Internet');
    //   return false;
    // }
    return true;
  }

  // static scanQRCode({
  //   required Function(String) onSuccess,
  // })
  // async {
  //   String scanResult = '';
  //   try {
  //     // Get.to(() => BarcodeScannerSimple(
  //     //       barCodeScanResult: (String? res) {
  //     //         onSuccess(res ?? '');
  //     //       },
  //     //     ));
  //     // MobileScanner(
  //     //   onDetect: (BarcodeCapture barcodes) {
  //     //     barcodes.barcodes.firstOrNull;
  //     //   },
  //     //
  //     // );
  //     // scanResult = await FlutterBarcodeScanner.scanBarcode(
  //     //   '#ff6666', // Color for the background of the scan page
  //     //   'Cancel', // Text for the button that cancels the scan
  //     //   true, // Whether to show the flash icon
  //     //   ScanMode.QR, // The type of code to scan (QR Code or Barcode)
  //     // );
  //   } catch (e) {
  //     print('Error during scan: $e');
  //     CustomSnackBar.errorSnackBar('Error during scan: $e');
  //     return;
  //   }
  //
  //   // if (scanResult != '-1') {
  //   //   onSuccess(scanResult);
  //   // }
  // }

  static scanQRCode({
    required Function(String) onSuccess,
  }) async {
    String scanResult = '';
    try {
      var result = await platform.invokeMethod('configureRFID');
      print("RFID_sample is configured $result");

      if (result != null && result != '') {
        if (result.contains('\n')) {
          result = result.split('\n')[0];
        }

        if (result.contains(':')) {
          List l = result.split(":");
          if (l.length >= 2) {
            scanResult = l[1];
            onSuccess(scanResult);
            return;
          }
        } else {
          scanResult = result;
          onSuccess(scanResult);
          return;
        }
      }
      CustomSnackBar.errorSnackBar('Could not scan');
    } catch (e) {
      print("Failed to configure RFID: $e");
      CustomSnackBar.errorSnackBar('Error during scan: $e');
    }
  }

  static void updateCurrentLangCode(String locale) async {
    LocalStorage.getInstance()
        ?.localStorage
        ?.setString(keyAppLocaleCode, locale);
    Get.updateLocale(CustomLocale.toLocale(locale));
  }

  // static Future<bool> checkInternet() async {
  //   var connectivityResult = await Connectivity().checkConnectivity();
  //   if (connectivityResult == ConnectivityResult.none) {
  //     return false;
  //   }
  //   return true;
  // }

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

  static Future<List<UserInventoryModel>> getUserInventoryList() async {
    List<UserInventoryModel> userList = [];
    try {
      UserModel customerModel = UserModel.getLoginCustomer();
      var res = await http.get(
        Uri.parse('${baseURL}Inventory/GetInventoryByUser?user=${customerModel.userCode}'),
        headers: header,
      );
      print(res.body);
      Map responseMap = jsonDecode(res.body);
      if (!responseMap['IsError']) {
        List l = responseMap['Result'];

        for (var user in l) {
          userList.add(UserInventoryModel.fromJson(user));
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

  static Future<void> updatePickingQuantity({
    required List<UpdatePickingModel> l,
    required Function(Map) onSuccess,
    required Function(Map) onError,
  })
  async {
    //todo:
    try {
      List<Map<String, dynamic>> list = [];
      for (UpdatePickingModel updatePickListModel in l) {
        list.add(updatePickListModel.toJson());
      }
      var res = await http.post(
          Uri.parse('${baseURL}picklist/UpdatePickingQuantity'),
          headers: header,
          body: jsonEncode(l));
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

  static Future<void> removeInventoryCounting({
    required RemoveInventoryModel removeInventoryModel,
    required Function(Map) onSuccess,
    required Function(Map) onError,
  })
  async {
    try {
      // List<Map<String, dynamic>> list = [];
      // for (UpdatePickingModel updatePickListModel in l) {
      //   list.add(updatePickListModel.toJson());
      // }
      var res = await http.post(
          Uri.parse('${baseURL}Inventory/RemoveInventoryCounting'),
          headers: header,
          body: jsonEncode(removeInventoryModel.toJson()));
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

  static Future<List<File>> splitFile(String filePath, int chunkSize) async {
    List<File> files = [];
    File file = File(filePath);
    int fileSize = await file.length();

    // Calculate the number of chunks
    int numChunks = (fileSize / chunkSize).ceil();

    RandomAccessFile raf = await file.open();

    for (int i = 0; i < numChunks; i++) {
      // Set the start position
      int startPosition = i * chunkSize;
      // Calculate the remaining size
      int endPosition = startPosition + chunkSize;
      if (endPosition > fileSize) {
        endPosition = fileSize;
      }
      int currentChunkSize = endPosition - startPosition;

      // Read the chunk
      raf.setPositionSync(startPosition);
      List<int> chunkData = raf.readSync(currentChunkSize);

      // Write the chunk to a new file
      File chunkFile = File('${filePath}${i + 1}');
      await chunkFile.writeAsBytes(chunkData);
      files.add(chunkFile);
      print('Created: ${chunkFile.path}');
    }

    await raf.close();
    return files;
  }

  static Future<bool> uploadLogFileToServer() async {
    String path = "";
    final directory = await getApplicationDocumentsDirectory();
    String? filePath = LocalStorage.getString(key: logFileName);

    File imageFile = File(
      '${directory.path}/$filePath.txt',
    );
    print(await imageFile.exists());
    bool fileExists = await imageFile.exists();
    if (!fileExists) {
      return false;
    }

    try {
      int chunkSize = 10 * 1024 * 1024; // 10MB in bytes
      List<File> logFiles = await splitFile(imageFile.path, chunkSize);
      for (File imageFile in logFiles) {
        var stream =
        http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
        var length = await imageFile.length();

        String MobDocPAth = "LITPL_OAC1/UploadLogFile";
        var request =
        http.MultipartRequest("POST", Uri.parse(baseURL + MobDocPAth));

        var picture = http.MultipartFile('file', stream, length,
            filename: basename(imageFile.path));

        request.files.add(picture);

        credentials = "getCredentials()";
        String encoded = stringToBase64.encode(credentials );
        header = {
          'Authorization': 'Basic $encoded',
          "content-type": "application/json",
          "connection": "keep-alive"
        };
        request.headers['Authorization'] = header!['Authorization']!;
        request.headers['content-type'] = header!['content-type']!;
        var response = await request.send();

        var responseData = await response.stream.toBytes();

        var result = String.fromCharCodes(responseData);

        print(result);
        Map map = json.decode(result);
        if (map['dbPath'] != null && map['dbPath'] != "") {
          // var res=await http.post(Uri.parse(prefix + "LITPL_OAC1/DownloadFile",),
          // body: jsonEncode({
          //   'model':'Attachment\\Documents\\a3c13b7b-f950-4dec-b1a1-3ccebe19fb15181182899660113005625b5aa6a-7ea9-4172-8e86-bb3c64b9a963.jpg'
          // }));
          // print(res.body);
          imageFile.delete();
          LocalStorage.setInt(key: 'LogId', value: 0);
          LocalStorage.setString(key: logFileName, value: '');

          path = map['dbPath'];
          print(path);
          return true;
        }
      }
      await imageFile.delete();
    } on Exception catch (e) {}
    return false;
  }


  static Future<void> updateInventoryCounting({
    required UpdateInventoryModel updateInventoryModel,
    required Function(Map) onSuccess,
    required Function(Map) onError,
  })
  async {
    try {
      // List<Map<String, dynamic>> list = [];
      // for (UpdatePickingModel updatePickListModel in l) {
      //   list.add(updatePickListModel.toJson());
      // }
      var res = await http.post(
          Uri.parse('${baseURL}Inventory/UpdateInventoryCounting'),
          headers: header,
          body: jsonEncode(updateInventoryModel.toJson()));
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
      List<PickListItemDetailModel> pickListItems = [];
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
