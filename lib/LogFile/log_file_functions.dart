import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scanner/common/get_formatted_date.dart';
import 'package:scanner/local_storage/local_storage.dart';
import 'package:scanner/models/customer_model.dart';
import 'package:scanner/services/api_config.dart';
import 'package:scanner/theme/custom_snack_bar.dart';
import 'package:share_plus/share_plus.dart';

String logFileName = 'FILE_NAME';

Future<void> writeToLogFile(
    {required String text,
    required String fileName,
    var db,
    String heading = 'Error'}) async {
  UserModel userModel = UserModel.getLoginCustomer();
  String companyName = 'MIESP';

  final directory = await getApplicationDocumentsDirectory();
  String? filePath = LocalStorage.getString(key: logFileName);
  if (filePath == null || filePath == '') {
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
          '''Company Name --> "${companyName}"\nApp Version - ${packageInfo.version ?? ''}(${packageInfo.buildNumber ?? ''})\nURL : ${ApiConfig.baseURL}\nUser : ${userModel.userCode},${userModel.name}\n\n\nLog : $logId\n-------------------\nTime : ${getFormattedDateAndTimeForLog(DateTime.now())}\n$heading : $text\nStack Trace : $fileName\n\n''';
    } else {
      text =
          '''Log : $logId\n-------------------\nTime : ${getFormattedDateAndTimeForLog(DateTime.now())}\n$heading : $text\nStack Trace : $fileName\n\n''';
    }
    await file.writeAsString(text, mode: FileMode.append, flush: true);
    await LocalStorage.setInt(key: 'LogId', value: logId);
  } catch (e) {
    debugPrint('Error writing to file: $e');
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
      '${directory.path}/$filePath.txt',
    );

    if (await file.exists()) {
      String fileContents = await file.readAsString();
      return fileContents;
    } else {
      return "File not found.";
    }
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString());
    return "Error reading file: $e";
  }
}

Future<void> shareLogFile() async {
  final directory = await getApplicationDocumentsDirectory();
  String? filePath = LocalStorage.getString(key: logFileName);
  File file = File(
    '${directory.path}/$filePath.txt',
  );
  if (await file.exists()) {
    Share.shareXFiles([XFile(file.path)], text: 'Hii, I am sharing log file');
  } else {
    debugPrint("Log file does not exist");
  }
}

Future<void> shareFileOnWhatsApp() async {
  final directory = await getApplicationDocumentsDirectory();
  File file = File('${directory.path}/log.txt');
  bool logFileExists = await file.exists();
  if (!logFileExists) {
    CustomSnackBar.errorSnackBar('You do not have any log');
    return;
  }
}
