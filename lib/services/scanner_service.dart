import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:scanner/LogFile/log_file_functions.dart';

class ScannerService {
  static const platform = MethodChannel('com.example.temp/rfid');

  /// Returns the scanned barcode string, or null if nothing was scanned.
  static Future<String?> scanQRCode() async {
    String text = '''
    Scanning
    -----------------
    Scan function is called
    ''';
    await writeToLogFile(
        text: text, heading: 'Value', fileName: StackTrace.current.toString());
    try {
      var result = await platform.invokeMethod('configureRFID');
      debugPrint("RFID_sample is configured $result");
      String logText = '''
    Scanned result
    -----------------
    Result : $result
    ''';
      await writeToLogFile(
          text: logText,
          heading: 'Value',
          fileName: StackTrace.current.toString());

      if (result != null && result != '') {
        if (result.contains('\n')) {
          result = result.split('\n')[0];
        }

        if (result.contains(':')) {
          List l = result.split(":");
          if (l.length >= 2) {
            return l[1];
          }
        } else {
          return result;
        }
      }
      String logText2 = '''
    Not Scanned
    -----------------
    User did not scan
    ''';
      await writeToLogFile(
          text: logText2,
          heading: 'Value',
          fileName: StackTrace.current.toString());
      return null;
    } catch (e) {
      debugPrint("Failed to configure RFID: $e");
      await writeToLogFile(
          text: e.toString(), fileName: StackTrace.current.toString());
      rethrow;
    }
  }
}
