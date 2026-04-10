import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ScannerService {
  static const platform = MethodChannel('com.example.temp/rfid');

  /// Returns the scanned barcode string, or null if nothing was scanned.
  static Future<String?> scanQRCode() async {
    try {
      var result = await platform.invokeMethod('configureRFID');
      debugPrint("RFID_sample is configured $result");

      if (result != null && result != '') {
        result = result.trim();
        if (result.contains('\n')) {
          result = result.split('\n')[0].trim();
        }

        if (result.contains(':')) {
          List l = result.split(":");
          if (l.length >= 3) {
            // Format: "symbology:data:length" — extract only the data part
            return l.sublist(1, l.length - 1).join(':').trim();
          } else if (l.length == 2) {
            return l[1].trim();
          }
        } else {
          return result;
        }
      }
      return null;
    } catch (e) {
      debugPrint("Failed to configure RFID: $e");
      rethrow;
    }
  }
}
