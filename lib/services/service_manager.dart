import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scanner/LogFile/log_file_functions.dart';
import 'package:scanner/common/enums.dart';
import 'package:scanner/local_storage/keys.dart';
import 'package:scanner/local_storage/local_storage.dart';
import 'package:scanner/models/assign_pick_list_model.dart';
import 'package:scanner/models/customer_model.dart';
import 'package:scanner/models/inventory_report_model.dart';
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
  // static String removeSpecialCharacters(String input) {
  //   String cleanedString = input.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
  //   print(cleanedString);
  //   return cleanedString;
  // }

  static scanQRCode({
    required Function(String) onSuccess,
  }) async {
    String text = '''
    Scanning
    -----------------
    Scan function is called
    ''';
    await writeToLogFile(
        text: text, heading: 'Value', fileName: StackTrace.current.toString());
    String scanResult = '';
    try {
      var result = await platform.invokeMethod('configureRFID');
      print("RFID_sample is configured $result");
      String text = '''
    Scanned result
    -----------------
    Result : $result
    ''';
      await writeToLogFile(
          text: text,
          heading: 'Value',
          fileName: StackTrace.current.toString());

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
      String text2 = '''
    Not Scanned
    -----------------
    User did not scan
    ''';
      await writeToLogFile(
          text: text2,
          heading: 'Value',
          fileName: StackTrace.current.toString());
    } catch (e) {
      print("Failed to configure RFID: $e");

      await writeToLogFile(
          text: e.toString(), fileName: StackTrace.current.toString());
      CustomSnackBar.errorSnackBar('Error during scan: $e');
    }
  }

  static void updateCurrentLangCode(String locale) async {
    LocalStorage.getInstance()
        ?.localStorage
        ?.setString(keyAppLocaleCode, locale);
    Get.updateLocale(CustomLocale.toLocale(locale));
  }

  static launchInBrowser(Uri? uri) async {
    try {
      if (await canLaunchUrl(uri ?? Uri.parse(''))) {
        await launchUrl(uri ?? Uri.parse(''));
      } else {}
    } catch (e) {
      await writeToLogFile(
          text: e.toString(), fileName: StackTrace.current.toString());
      CustomSnackBar.errorSnackBar(e.toString());
    }
  }

  static getPaginatedInventoryReport({
    required int pageNum,
    required int pageSize,
    required String searchTerm,
    required String filter,
    required Function(InventoryReportModel) onSuccess,
    required Function(Map) onError,
  }) async {
    var res = await http.post(
        Uri.parse('${baseURL}Inventory/GetPaginatedInventoryReport'),
        headers: header,
        body: jsonEncode({
          "PageNum": pageNum,
          "PageSize": pageSize,
          "SearchTerm": searchTerm,
          "Filter": filter
        }));
    print(res.body);
    Map responseMap = jsonDecode(res.body);
    if (!responseMap['IsError']) {
      InventoryReportModel inventoryReportModel =
      InventoryReportModel.fromJson(jsonDecode(res.body)['Result']);

      //     String resText = '''
      // Calling success function
      // -------------------------
      // Response : ${customerModel.toJson()}
      // ''';
      //     await writeToLogFile(
      //         text: resText,
      //         heading: 'Value',
      //         fileName: StackTrace.current.toString());
      onSuccess(inventoryReportModel);
    } else {
      //     String resText = '''
      // Calling error function
      // -------------------------
      // Response : $responseMap
      // ''';
      //     await writeToLogFile(
      //         text: resText,
      //         heading: 'Value',
      //         fileName: StackTrace.current.toString());
      onError(responseMap);
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
      //   String text = '''
      // API call
      // -----------------
      // Calling Login API with the following parameters
      // Username : $Username
      // Password : $Password
      // Header : $header
      // Body :  ${{"Code": Username, "Password": Password}}
      // URL : ${baseURL}logindetails/login
      // ''';
      //   await writeToLogFile(
      //       text: text,
      //       heading: 'Value',
      //       fileName: StackTrace.current.toString());
      var res = await http.post(Uri.parse('${baseURL}logindetails/login'),
          headers: header,
          body: jsonEncode({"Code": Username, "Password": Password}));

      //   String resText = '''
      // API call response for URL : ${baseURL}logindetails/login
      // -------------------------------------------------------------------------------------
      // Response : ${res.body}
      // ''';
      //   await writeToLogFile(
      //       text: resText,
      //       heading: 'Value',
      //       fileName: StackTrace.current.toString());
      print(res.body);
      Map responseMap = jsonDecode(res.body);
      if (!responseMap['IsError']) {
        customerModel = UserModel.fromJson(jsonDecode(res.body)['Result']);

        //     String resText = '''
        // Calling success function
        // -------------------------
        // Response : ${customerModel.toJson()}
        // ''';
        //     await writeToLogFile(
        //         text: resText,
        //         heading: 'Value',
        //         fileName: StackTrace.current.toString());
        onSuccess(customerModel);
      } else {
        //     String resText = '''
        // Calling error function
        // -------------------------
        // Response : $responseMap
        // ''';
        //     await writeToLogFile(
        //         text: resText,
        //         heading: 'Value',
        //         fileName: StackTrace.current.toString());
        onError(responseMap);
      }
    } catch (e) {
      CustomSnackBar.errorSnackBar(e.toString());
      // await writeToLogFile(
      //     text: e.toString(), fileName: StackTrace.current.toString());
    }
  }

  static Future<List<UserModel>> getUserList() async {
    List<UserModel> userList = [];
    try {
      //   String text = '''
      // API call
      // -----------------
      // Calling Get User API
      // Header : $header
      // URL : ${baseURL}master/getusers
      // ''';
      //   await writeToLogFile(
      //       text: text,
      //       heading: 'Value',
      //       fileName: StackTrace.current.toString());

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
      await writeToLogFile(
          text: e.toString(), fileName: StackTrace.current.toString());
      CustomSnackBar.errorSnackBar(e.toString());
    }
    // String resText = '''
    // Returning User list
    // -------------------------
    // Length =  : ${userList.length}
    // ''';
    // await writeToLogFile(
    //     text: resText,
    //     heading: 'Value',
    //     fileName: StackTrace.current.toString());
    return userList;
  }

  static Future<List<UserInventoryModel>> getUserInventoryList() async {
    List<UserInventoryModel> userInventoryList = [];
    try {
      UserModel customerModel = UserModel.getLoginCustomer();
      String url =
          '${baseURL}Inventory/GetInventoryByUser?user=${customerModel.userCode}';

      //   String text = '''
      // API call
      // -----------------
      // Calling Get Inventory By User API with the following parameters
      // Header : $header
      // URL : $url
      // ''';
      //   await writeToLogFile(
      //       text: text,
      //       heading: 'Value',
      //       fileName: StackTrace.current.toString());

      var res = await http.get(
        Uri.parse(url),
        headers: header,
      );
      print(res.body);
      //   String resText = '''
      // API call response for URL : ${baseURL}Inventory/GetInventoryByUser?user=${customerModel.userCode}
      // -------------------------------------------------------------------------------------
      // Response : ${res.body}
      // ''';
      //   await writeToLogFile(
      //       text: resText,
      //       heading: 'Value',
      //       fileName: StackTrace.current.toString());
      Map responseMap = jsonDecode(res.body);
      if (!responseMap['IsError']) {
        List l = responseMap['Result'];

        for (var user in l) {
          userInventoryList.add(UserInventoryModel.fromJson(user));
        }
      }
    } catch (e) {
      await writeToLogFile(
          text: e.toString(), fileName: StackTrace.current.toString());
      CustomSnackBar.errorSnackBar(e.toString());
    }

    // String resText = '''
    // Returning User Inventory list
    // -------------------------
    // Length =  : ${userInventoryList.length}
    // ''';
    // await writeToLogFile(
    //     text: resText,
    //     heading: 'Value',
    //     fileName: StackTrace.current.toString());
    return userInventoryList;
  }

  static Future<void> getPickListByStatus({
    required String status,
    required Function(List<PickListModel>) onSuccess,
    required Function(Map) onError,
  }) async {
    try {
      String url = '${baseURL}PickList/GetPicklistByStatus?status=$status';
      List<PickListModel> pickList = [];
      //   String text = '''
      // API call
      // -----------------
      // Calling Get Picklist By Status with the following parameters
      // Header : $header
      // URL : $url
      // ''';
      //   await writeToLogFile(
      //       text: text,
      //       heading: 'Value',
      //       fileName: StackTrace.current.toString());
      var res = await http.get(
        Uri.parse(url),
        headers: header,
      );
      print(res.body);
      //   String resText = '''
      // API call response for URL : $url
      // -------------------------------------------------------------------------------------
      // Response : ${res.body}
      // ''';
      //   await writeToLogFile(
      //       text: resText,
      //       heading: 'Value',
      //       fileName: StackTrace.current.toString());
      Map responseMap = jsonDecode(res.body);
      if (!responseMap['IsError']) {
        List open = responseMap['Result'];
        for (Map<String, dynamic> map in open) {
          pickList.add(PickListModel.fromJson(map));
        }
        //     String resText = '''
        // Calling success function
        // -------------------------
        // Pick List length : ${pickList.length}
        // ''';
        //     await writeToLogFile(
        //         text: resText,
        //         heading: 'Value',
        //         fileName: StackTrace.current.toString());

        onSuccess(pickList);
      } else {
        //     String resText = '''
        // Calling error function
        // -------------------------
        // Response : $responseMap
        // ''';
        //     await writeToLogFile(
        //         text: resText,
        //         heading: 'Value',
        //         fileName: StackTrace.current.toString());
        onError(responseMap);
      }
    } catch (e) {
      await writeToLogFile(
          text: e.toString(), fileName: StackTrace.current.toString());
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
      String url =
          '${baseURL}PickList/GetPickListByUser?status=$status&user=$username';
      //   String text = '''
      // API call
      // -----------------
      // Get Pick List By User with the following parameters
      // Header : $header
      // URL : $url
      // ''';
      //   await writeToLogFile(
      //       text: text,
      //       heading: 'Value',
      //       fileName: StackTrace.current.toString());
      var res = await http.get(
        Uri.parse(url),
        headers: header,
      );
      print(res.body);
      //   String resText = '''
      // API call response for URL : $url
      // -------------------------------------------------------------------------------------
      // Response : ${res.body}
      // ''';
      //   await writeToLogFile(
      //       text: resText,
      //       heading: 'Value',
      //       fileName: StackTrace.current.toString());
      Map responseMap = jsonDecode(res.body);
      if (!responseMap['IsError']) {
        List open = responseMap['Result'];
        for (Map<String, dynamic> map in open) {
          pickList.add(PickListModel.fromJson(map));
        }

        //     String resText = '''
        // Calling success function
        // -------------------------
        // Pick List length : ${pickList.length}
        // ''';
        //     await writeToLogFile(
        //         text: resText,
        //         heading: 'Value',
        //         fileName: StackTrace.current.toString());
        onSuccess(pickList);
      } else {
        //     String resText = '''
        // Calling error function
        // -------------------------
        // Response : $responseMap
        // ''';
        //     await writeToLogFile(
        //         text: resText,
        //         heading: 'Value',
        //         fileName: StackTrace.current.toString());
        onError(responseMap);
      }
    } catch (e) {
      await writeToLogFile(
          text: e.toString(), fileName: StackTrace.current.toString());
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
      String url = '${baseURL}picklist/UpdatePickList';
      String text = '''
    API call
    -----------------
    Calling Update PickList API with the following parameters
    Header : $header
    Body :  ${jsonEncode(l)}
    URL : $url
    ''';
      await writeToLogFile(
          text: text,
          heading: 'Value',
          fileName: StackTrace.current.toString());
      var res =
          await http.post(Uri.parse(url), headers: header, body: jsonEncode(l));
      print(res.body);
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
        onSuccess(responseMap);
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
        onError(responseMap);
      }
    } catch (e) {
      await writeToLogFile(
          text: e.toString(), fileName: StackTrace.current.toString());
      CustomSnackBar.errorSnackBar(e.toString());
    }
  }

  static Future<void> updatePickingQuantity({
    required List<UpdatePickingModel> l,
    required Function(Map) onSuccess,
    required Function(Map) onError,
  }) async {
    try {
      List<Map<String, dynamic>> list = [];
      for (UpdatePickingModel updatePickListModel in l) {
        list.add(updatePickListModel.toJson());
      }
      String url = '${baseURL}picklist/UpdatePickingQuantity';
      String text = '''
    API call
    -----------------
    Calling Update Picking Quantity API with the following parameters
    Header : $header
    Body :  ${jsonEncode(l)}
    URL : $url
    ''';
      await writeToLogFile(
          text: text,
          heading: 'Value',
          fileName: StackTrace.current.toString());
      var res =
          await http.post(Uri.parse(url), headers: header, body: jsonEncode(l));
      print(res.body);
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

        onSuccess(responseMap);
      } else {
        onError(responseMap);
        String resText = '''
    Calling error function
    -------------------------
    Response : $responseMap
    ''';
        await writeToLogFile(
            text: resText,
            heading: 'Value',
            fileName: StackTrace.current.toString());
      }
    } catch (e) {
      await writeToLogFile(
          text: e.toString(), fileName: StackTrace.current.toString());
      CustomSnackBar.errorSnackBar(e.toString());
    }
  }

  static Future<void> removeInventoryCounting({
    required RemoveInventoryModel removeInventoryModel,
    required Function(Map) onSuccess,
    required Function(Map) onError,
  }) async {
    try {
      // List<Map<String, dynamic>> list = [];
      // for (UpdatePickingModel updatePickListModel in l) {
      //   list.add(updatePickListModel.toJson());
      // }
      String url = '${baseURL}Inventory/RemoveInventoryCounting';
      String text = '''
    API call
    -----------------
    Calling Remove Inventory Counting API with the following parameters
    Header : $header
    Body :  ${jsonEncode(removeInventoryModel.toJson())}
    URL : $url
    ''';
      await writeToLogFile(
          text: text,
          heading: 'Value',
          fileName: StackTrace.current.toString());
      var res = await http.post(Uri.parse(url),
          headers: header, body: jsonEncode(removeInventoryModel.toJson()));
      String resText = '''
    API call response for URL : $url
    -------------------------------------------------------------------------------------
    Response : ${res.body}
    ''';
      await writeToLogFile(
          text: resText,
          heading: 'Value',
          fileName: StackTrace.current.toString());
      print(res.body);
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
        onSuccess(responseMap);
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
        onError(responseMap);
      }
      // if (res.statusCode == 200) {
      // } else {
      // }
    } catch (e) {
      await writeToLogFile(
          text: e.toString(), fileName: StackTrace.current.toString());
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
        String encoded = stringToBase64.encode(credentials);
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
  }) async {
    try {
      // List<Map<String, dynamic>> list = [];
      // for (UpdatePickingModel updatePickListModel in l) {
      //   list.add(updatePickListModel.toJson());
      // }
      String url = '${baseURL}Inventory/UpdateInventoryCounting';

      String text = '''
    API call
    -----------------
    Calling Update Inventory Counting API with the following parameters
    Header : $header
    Body :  ${jsonEncode(updateInventoryModel.toJson())}
    URL : $url
    ''';
      await writeToLogFile(
          text: text,
          heading: 'Value',
          fileName: StackTrace.current.toString());

      var res = await http.post(Uri.parse(url),
          headers: header, body: jsonEncode(updateInventoryModel.toJson()));
      String resText = '''
    API call response for URL : $url
    -------------------------------------------------------------------------------------
    Response : ${res.body}
    ''';
      await writeToLogFile(
          text: resText,
          heading: 'Value',
          fileName: StackTrace.current.toString());
      print(res.body);
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
        onSuccess(responseMap);
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
        onError(responseMap);
      }
    } catch (e) {
      await writeToLogFile(
          text: e.toString(), fileName: StackTrace.current.toString());
      CustomSnackBar.errorSnackBar(e.toString());
    }
  }

  static Future<void> assignPickList({
    required List<AssignPickListModel> l,
    required Function(Map) onSuccess,
    required Function(Map) onError,
  }) async {
    try {
      String url = '${baseURL}picklist/AssignPickList';
      //   String text = '''
      // API call
      // -----------------
      // Calling Assign Pick List API with the following parameters
      // Header : $header
      // Body :  ${jsonEncode(l)}
      // URL : $url
      // ''';
      //   await writeToLogFile(
      //       text: text,
      //       heading: 'Value',
      //       fileName: StackTrace.current.toString());
      var res =
          await http.post(Uri.parse(url), headers: header, body: jsonEncode(l));
      //   String resText = '''
      // API call response for URL : $url
      // -------------------------------------------------------------------------------------
      // Response : ${res.body}
      // ''';
      //   await writeToLogFile(
      //       text: resText,
      //       heading: 'Value',
      //       fileName: StackTrace.current.toString());
      print(res.body);
      Map responseMap = jsonDecode(res.body);
      if (!responseMap['IsError']) {
        //     String resText = '''
        // Calling success function
        // -------------------------
        // Response : $responseMap
        // ''';
        //     await writeToLogFile(
        //         text: resText,
        //         heading: 'Value',
        //         fileName: StackTrace.current.toString());
        onSuccess(responseMap);
      } else {
        //     String resText = '''
        // Calling error function
        // -------------------------
        // Response : $responseMap
        // ''';
        //     await writeToLogFile(
        //         text: resText,
        //         heading: 'Value',
        //         fileName: StackTrace.current.toString());
        onError(responseMap);
      }
      // if (res.statusCode == 200) {
      // } else {
      // }
    } catch (e) {
      await writeToLogFile(
          text: e.toString(), fileName: StackTrace.current.toString());
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
      Map map = {
        "Status": status,
        "Search": search,
        "User": userModel.username,
        "PickList": pickListId
      };
      String url = '${baseURL}picklist/GetListingItems';
      //   String text = '''
      // API call
      // -----------------
      // Calling Get Listing Items API with the following parameters
      // Header : $header
      // Body :  ${jsonEncode(map)}
      // URL : $url
      // ''';
      //   await writeToLogFile(
      //       text: text,
      //       heading: 'Value',
      //       fileName: StackTrace.current.toString());
      var res = await http.post(Uri.parse(url),
          headers: header, body: jsonEncode(map));
      //   String resText = '''
      // API call response for URL : $url
      // -------------------------------------------------------------------------------------
      // Response : ${res.body}
      // ''';
      //   await writeToLogFile(
      //       text: resText,
      //       heading: 'Value',
      //       fileName: StackTrace.current.toString());
      print(res.body);
      Map responseMap = jsonDecode(res.body);
      if (!responseMap['IsError']) {
        List open = responseMap['Result'];
        for (Map<String, dynamic> map in open) {
          pickListItems.add(PickListItemDetailModel.fromJson(map));
        }
        //     String resText = '''
        // Calling success function
        // -------------------------
        // Response : $responseMap
        // Length : ${pickListItems.length}
        // ''';
        //     await writeToLogFile(
        //         text: resText,
        //         heading: 'Value',
        //         fileName: StackTrace.current.toString());
        onSuccess(pickListItems);
      } else {
        //     String resText = '''
        // Calling error function
        // -------------------------
        // Response : $responseMap
        // ''';
        //     await writeToLogFile(
        //         text: resText,
        //         heading: 'Value',
        //         fileName: StackTrace.current.toString());
        onError(responseMap);
      }
    } catch (e) {
      await writeToLogFile(
          text: e.toString(), fileName: StackTrace.current.toString());
      CustomSnackBar.errorSnackBar(e.toString());
    }
  }

  static Future<void> removePickList({
    required List<String> l,
    required Function(Map) onSuccess,
    required Function(Map) onError,
  }) async {
    try {
      String url = '${baseURL}picklist/RemovePickList';
      String text = '''
    API call
    -----------------
    Calling Remove Pick List API with the following parameters
    Header : $header
    Body :  ${jsonEncode(l)}
    URL : $url
    ''';
      await writeToLogFile(
          text: text,
          heading: 'Value',
          fileName: StackTrace.current.toString());
      var res =
          await http.post(Uri.parse(url), headers: header, body: jsonEncode(l));
      String resText = '''
    API call response for URL : $url
    -------------------------------------------------------------------------------------
    Response : ${res.body}
    ''';
      await writeToLogFile(
          text: resText,
          heading: 'Value',
          fileName: StackTrace.current.toString());
      print(res.body);
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
        onSuccess(responseMap);
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
        onError(responseMap);
      }
    } catch (e) {
      await writeToLogFile(
          text: e.toString(), fileName: StackTrace.current.toString());
      CustomSnackBar.errorSnackBar(e.toString());
    }
  }

  static Future<void> getWarehouseList({
    required Function(List<WarehouseModel>) onSuccess,
    required Function onError,
  }) async {
    List<WarehouseModel>? warehouseList = [];
    String url = '${baseURL}Items/GetWarehouseList';
    var res = await http.get(
      Uri.parse(url),
      headers: header,
    );
    // String resText = '''
    // API call response for URL : $url
    // -------------------------------------------------------------------------------------
    // Response : ${res.body}
    // ''';
    // await writeToLogFile(
    //     text: resText,
    //     heading: 'Value',
    //     fileName: StackTrace.current.toString());
    print(res.body);
    if (res.statusCode == 200) {
      warehouseList = warehouseModelFromJson(res.body);
      //   String resText = '''
      // Calling success function
      // -------------------------
      // Length : ${warehouseList.length}
      // ''';
      //   await writeToLogFile(
      //       text: resText,
      //       heading: 'Value',
      //       fileName: StackTrace.current.toString());
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
    String url = '${baseURL}Items/GetUOM';
    // String text = '''
    // API call
    // -----------------
    // Calling Get UOM API with the following parameters
    // Header : $header
    // URL : $url
    // ''';
    // await writeToLogFile(
    //     text: text, heading: 'Value', fileName: StackTrace.current.toString());
    var res = await http.get(
      Uri.parse(url),
      headers: header,
    );
    // String resText = '''
    // API call response for URL : $url
    // -------------------------------------------------------------------------------------
    // Response : ${res.body}
    // ''';
    // await writeToLogFile(
    //     text: resText,
    //     heading: 'Value',
    //     fileName: StackTrace.current.toString());
    print(res.body);
    if (res.statusCode == 200) {
      uomList = uomModelFromJson(res.body);
      //   String resText = '''
      // Calling success function
      // -------------------------
      // Response : ${uomList.length}
      // ''';
      //   await writeToLogFile(
      //       text: resText,
      //       heading: 'Value',
      //       fileName: StackTrace.current.toString());
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
    String url = '${baseURL}Items/SaveStockCounting';
    String text = '''
    API call
    -----------------
    Calling Save Stock Counting API with the following parameters
    Header : $header
    Body :  ${jsonEncode(requestList)}
    URL : $url
    ''';
    await writeToLogFile(
        text: text, heading: 'Value', fileName: StackTrace.current.toString());
    var res = await http.post(
      Uri.parse(url),
      headers: header,
      body: jsonEncode(requestList),
    );
    String resText = '''
    API call response for URL : $url
    -------------------------------------------------------------------------------------
    Response : ${res.body}
    ''';
    await writeToLogFile(
        text: resText,
        heading: 'Value',
        fileName: StackTrace.current.toString());
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
    String url = '${baseURL}Items/GetItemDetail';
    Map map = {
      "Barcode": barCode,
      "UserId": customerModel.userId ?? 0,
      "WarehouseCode": warehouseModel?.warehouseCode ?? ''
    };

    // String text = '''
    // API call
    // -----------------
    // Calling Get Item Detail API with the following parameters
    // Header : $header
    // Body :  ${jsonEncode(map)}
    // URL : $url
    // ''';
    // await writeToLogFile(
    //     text: text, heading: 'Value', fileName: StackTrace.current.toString());
    var res = await http.post(
      Uri.parse(url),
      body: jsonEncode(map),
      headers: header,
    );
    // String resText = '''
    // API call response for URL : $url
    // -------------------------------------------------------------------------------------
    // Response : ${res.body}
    // ''';
    // await writeToLogFile(
    //     text: resText,
    //     heading: 'Value',
    //     fileName: StackTrace.current.toString());
    print(res.body);
    if (res.statusCode == 200) {
      if (res.body == 'null') {
        onError();
        return;
      }
      warehouseList = itemDetailModelFromJson(res.body);
      //   String resText = '''
      // Calling success function
      // -------------------------
      // Response data : ${warehouseList.toJson()}
      // ''';
      //   await writeToLogFile(
      //       text: resText,
      //       heading: 'Value',
      //       fileName: StackTrace.current.toString());
      onSuccess(warehouseList);
    } else {
      //   String resText = '''
      // Calling error function
      // -------------------------
      // ''';
      //   await writeToLogFile(
      //       text: resText,
      //       heading: 'Value',
      //       fileName: StackTrace.current.toString());
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
    String url = '${baseURL}Items/GetStockCountingDetail';
    Map map = {
      "Barcode": barCode,
      "UserId": customerModel.userId ?? 0,
      "WarehouseCode": warehouseModel?.warehouseCode ?? ''
    };
    // String text = '''
    // API call
    // -----------------
    // Calling Get Stock Counting Detail API with the following parameters
    // Header : $header
    // Body :  ${jsonEncode(map)}
    // URL : $url
    // ''';
    // await writeToLogFile(
    //     text: text, heading: 'Value', fileName: StackTrace.current.toString());
    var res = await http.post(
      Uri.parse(url),
      body: jsonEncode(map),
      headers: header,
    );
    // String resText = '''
    // API call response for URL : $url
    // -------------------------------------------------------------------------------------
    // Response : ${res.body}
    // ''';
    // await writeToLogFile(
    //     text: resText,
    //     heading: 'Value',
    //     fileName: StackTrace.current.toString());
    print(res.body);
    if (res.statusCode == 200) {
      if (res.body == 'null') {
        onError();
        return;
      }
      stockCountingDetail = stockCountingDetailModelFromJson(res.body);

      //   String resText = '''
      // Calling success function
      // -------------------------
      // Response : ${stockCountingDetail.toJson()}
      // ''';
      //   await writeToLogFile(
      //       text: resText,
      //       heading: 'Value',
      //       fileName: StackTrace.current.toString());
      onSuccess(stockCountingDetail);
    } else {
      //   String resText = '''
      // Calling error function
      // -------------------------
      // ''';
      //   await writeToLogFile(
      //       text: resText,
      //       heading: 'Value',
      //       fileName: StackTrace.current.toString());

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
