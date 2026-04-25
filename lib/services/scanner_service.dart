import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:scanner/services/scanner_event_service.dart';

class ScannerService {
  static const platform = MethodChannel('com.example.temp/rfid');

  /// Returns the scanned barcode string, or null if nothing was scanned.
  static Future<String?> scanQRCode() async {
    try {
      final raw = await platform.invokeMethod('configureRFID');
      debugPrint("RFID_sample is configured $raw");

      if (raw != null && raw != '') {
        final barcode = parseBarcode(raw.toString());
        debugPrint('[ScannerService] raw=$raw parsed="$barcode"');
        return barcode.isEmpty ? null : barcode;
      }
      return null;
    } catch (e) {
      debugPrint("Failed to configure RFID: $e");
      rethrow;
    }
  }
}
