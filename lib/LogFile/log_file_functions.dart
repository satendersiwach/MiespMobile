import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scanner/common/get_formatted_date.dart';
import 'package:scanner/local_storage/local_storage.dart';
import 'package:scanner/models/customer_model.dart';
import 'package:scanner/services/service_manager.dart';
import 'package:scanner/theme/custom_snack_bar.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:whatsapp_share/whatsapp_share.dart';

String logFileName = 'FILE_NAME';

Future<void> writeToLogFile(
    {required String text,
    required String fileName,
    var db,
    String heading = 'Error'}) async {
  UserModel userModel = UserModel.getLoginCustomer();
  // DateTime? syncDate = getDataSyncDate();
  String companyName = 'MIESP';
  // if (syncDate == null) {
  //   OCINMetaDataModel? ocinMetaDataModel =
  //       OCINMetaDataModel.getToLocalStorage();
  //   companyName = ocinMetaDataModel?.CompanyName ?? '';
  // } else if (db == null) {
  //   await CompanyDetails.loadCompanyDetails();
  //   companyName = CompanyDetails.ocinModel?.CompanyName ?? '';
  // } else {
  //   final List<Map<String, Object?>> queryResult = await db.query('OCIN');
  //   List<OCINModel> l = queryResult.map((e) => OCINModel.fromJson(e)).toList();
  //   if (l.isNotEmpty) {
  //     CompanyDetails.ocinModel = l[0];
  //     companyName = l[0].CompanyName ?? '';
  //   }
  // }

  final directory = await getApplicationDocumentsDirectory();
  String? filePath = LocalStorage.getString(key: logFileName);
  if (filePath == null || filePath == '') {
    ///FIRST LOG
    ///CREATE LOG FILE
    companyName = companyName.split(' ')[0] ?? '';
    filePath = '${companyName}_${userModel.userCode}';
    LocalStorage.setString(key: logFileName, value: filePath);
  }
  File file = File(
    '${directory.path}/$filePath.txt',
  );

  int logId = LocalStorage.getInt(key: 'LogId') ?? 0;
  PackageInfo? packageInfo = await PackageInfo.fromPlatform();

  try {
    logId++;
    if (logId == 1) {
      text =
          '''Company Name --> "${companyName}"\nApp Version - ${packageInfo.version ?? ''}(${packageInfo.buildNumber ?? ''})\nURL : ${ServiceManager.baseURL}\nUser : ${userModel.userCode},${userModel.name}\n\n\nLog : $logId\n-------------------\nTime : ${getFormattedDateAndTimeForLog(DateTime.now())}\n$heading : $text\nStack Trace : $fileName\n\n''';
    } else {
      text =
          '''Log : $logId\n-------------------\nTime : ${getFormattedDateAndTimeForLog(DateTime.now())}\n$heading : $text\nStack Trace : $fileName\n\n''';
    }
    await file.writeAsString(text, mode: FileMode.append, flush: true);
    print('Text written to file successfully.');
    print(text);
    print(await file.exists());
    String fileContents = await file.readAsString();
    print(fileContents);
    await LocalStorage.setInt(key: 'LogId', value: logId);
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString());
    print('Error writing to file: $e');
  }
}

Future<String> readLogFile() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    String? filePath = LocalStorage.getString(key: logFileName);
    if (filePath == null || filePath == '') {
      return '';
    }
    File file = File(
      '${directory?.path}/$filePath.txt',
    );

    if (await file.exists()) {
      String fileContents = await file.readAsString();
      print(fileContents);
      return fileContents;
    } else {
      print('File not found.');
      return "File not found.";
    }
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString());
    return "Error reading file: $e";
  }
}
// Future<void> openLogFile() async {
//   try {
//     final directory = await getApplicationDocumentsDirectory();
//     File file = File('${directory?.path}/log.txt');
//
//     if (await file.exists()) {
//       OpenFile.open(file.path);
//     } else {
//       getErrorSnackBar('Can not open file');
//     }
//   } catch (e) {
//     getErrorSnackBar('Can not open file');
//   }
// }

Future<void> shareLogFile() async {
  final directory = await getApplicationDocumentsDirectory();
  String? filePath = LocalStorage.getString(key: logFileName);
  File file = File(
    '${directory.path}/$filePath.txt',
  );
  print(file.path);
  if(await file.exists())
    {
      print("File exist");
      Share.shareXFiles([XFile(file.path)], text: 'Hii, I am sharing log file');
    }
  else
    {
      print("File does not exist");
    }


  // Directory? downloadsDirectory = await DownloadsPath.downloadsDirectory();
  // // copy file to downloadsDirectory
  // String fileBasename = basename(file.path);
  // String pubPath = '${downloadsDirectory?.path}/$fileBasename';
  // await file.copy(pubPath);
  // FlutterShare.shareFile(
  //   title: 'share image',
  //   text: "share image",
  //   filePath: pubPath,
  // );

  // await FlutterShare.shareFile(
  //   title: appName,
  //   text: 'Log File',
  //   filePath: file.path,
  //   // fileType: '*.txt'
  // );
}

Future<void> shareFileOnWhatsApp() async {
  final directory = await getApplicationDocumentsDirectory();
  File file = File('${directory?.path}/log.txt');
  print(file.path);
  bool logFileExists = await file.exists();
  if (!logFileExists) {
    CustomSnackBar.errorSnackBar('You do not have any log');
    return;
  }
  // await WhatsappShare.shareFile(
  //   phone: '*',
  //   filePath: [file.path],
  // );
}
