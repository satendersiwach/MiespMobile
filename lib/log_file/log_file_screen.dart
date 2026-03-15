import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scanner/log_file/log_file_functions.dart';
import 'package:scanner/log_file/view_log_file.dart';
import 'package:scanner/local_storage/local_storage.dart';
import 'package:scanner/services/log_upload_service.dart';
import 'package:scanner/theme/custom_colors.dart';
import 'package:scanner/theme/custom_snack_bar.dart';

class LogFileScreen extends StatefulWidget {
  const LogFileScreen({super.key});

  @override
  State<LogFileScreen> createState() => _LogFileScreenState();
}

class _LogFileScreenState extends State<LogFileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appPrimary,
        title: const Text('Create Log'),
      ),
      body: Center(
        child: Column(
          children: [
            MaterialButton(
              onPressed: () {
                writeToLogFile(
                    text: "Hello, this text is written to a file!",
                    fileName: StackTrace.current.toString());
              },
              child: const Text('Create Log',
              style: TextStyle(
                fontSize: 20
              ),),
            ),
            MaterialButton(
              onPressed: () async {
                readLogFile();
              },
              child: const Text('Read Log File',
              style: TextStyle(
                fontSize: 20
              ),),
            ),
            MaterialButton(
              onPressed: () async {
                Get.to(()=>ViewLogFile());
              },
              child: const Text('View Log File',
              style: TextStyle(
                fontSize: 20
              ),),
            ),
            MaterialButton(
              onPressed: () async {
                shareLogFile();
              },
              child: const Text('Share Log File',
              style: TextStyle(
                fontSize: 20
              ),),
            ),
            MaterialButton(
              onPressed: () async {
                shareFileOnWhatsApp();
              },
              child: const Text('Share Log File on WhatsApp',
              style: TextStyle(
                fontSize: 20
              ),),
            ),
            MaterialButton(
              onPressed: () async {
                final directory = await getApplicationDocumentsDirectory();
                String? filePath = LocalStorage.getString(key: logFileName);
                if (filePath == null || filePath == '') {
                  CustomSnackBar.errorSnackBar('Log File does not exist');
                }
                File file = File(
                  '${directory?.path}/$filePath.txt',
                );

                if (await file.exists()) {
                  OpenFilex.open(file.path);
                } else {
                  CustomSnackBar.errorSnackBar('Log File does not exist');
                }
              },
              child: const Text('Open Log File Data on Screen',
              style: TextStyle(
                fontSize: 20
              ),),
            ),
            // MaterialButton(
            //   onPressed: () async {
            //     // await sendEmail2(onError: (String error) {
            //     //   CustomSnackBar.errorSnackBar(error);
            //     // }, onSuccess: () {
            //     //   getSuccessSnackBar('Email sent');
            //     // });
            //   },
            //   child: Text('Mail Log File'),
            // ),
            MaterialButton(
              onPressed: () async {
                await LogUploadService.uploadLogFileToServer();
              },
              child: const Text('Upload Log File',
              style: TextStyle(
                fontSize: 20
              ),),
            ),
          ],
        ),
      ),
    );
  }
}
