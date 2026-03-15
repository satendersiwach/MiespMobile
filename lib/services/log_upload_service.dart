import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scanner/LogFile/log_file_functions.dart';
import 'package:scanner/local_storage/local_storage.dart';
import 'package:scanner/services/api_config.dart';

class LogUploadService {
  static Future<List<File>> _splitFile(String filePath, int chunkSize) async {
    List<File> files = [];
    File file = File(filePath);
    int fileSize = await file.length();

    int numChunks = (fileSize / chunkSize).ceil();

    RandomAccessFile raf = await file.open();

    for (int i = 0; i < numChunks; i++) {
      int startPosition = i * chunkSize;
      int endPosition = startPosition + chunkSize;
      if (endPosition > fileSize) {
        endPosition = fileSize;
      }
      int currentChunkSize = endPosition - startPosition;

      raf.setPositionSync(startPosition);
      List<int> chunkData = raf.readSync(currentChunkSize);

      File chunkFile = File('${filePath}${i + 1}');
      await chunkFile.writeAsBytes(chunkData);
      files.add(chunkFile);
    }

    await raf.close();
    return files;
  }

  static Future<bool> uploadLogFileToServer() async {
    final directory = await getApplicationDocumentsDirectory();
    String? filePath = LocalStorage.getString(key: logFileName);

    File imageFile = File(
      '${directory.path}/$filePath.txt',
    );
    bool fileExists = await imageFile.exists();
    if (!fileExists) {
      return false;
    }

    try {
      int chunkSize = 10 * 1024 * 1024; // 10MB in bytes
      List<File> logFiles = await _splitFile(imageFile.path, chunkSize);
      for (File imageFile in logFiles) {
        var stream =
            http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
        var length = await imageFile.length();

        String MobDocPAth = "LITPL_OAC1/UploadLogFile";
        var request = http.MultipartRequest(
            "POST", Uri.parse(ApiConfig.baseURL + MobDocPAth));

        var picture = http.MultipartFile('file', stream, length,
            filename: basename(imageFile.path));

        request.files.add(picture);

        request.headers['Authorization'] = ApiConfig.header['Authorization']!;
        request.headers['content-type'] = ApiConfig.header['content-type']!;
        var response = await request.send();

        var responseData = await response.stream.toBytes();

        var result = String.fromCharCodes(responseData);

        Map map = json.decode(result);
        if (map['dbPath'] != null && map['dbPath'] != "") {
          imageFile.delete();
          LocalStorage.setInt(key: 'LogId', value: 0);
          LocalStorage.setString(key: logFileName, value: '');

          return true;
        }
      }
      await imageFile.delete();
    } on Exception catch (e) {
      await writeToLogFile(
          text: 'Upload log file failed: $e',
          fileName: StackTrace.current.toString());
    }
    return false;
  }
}
