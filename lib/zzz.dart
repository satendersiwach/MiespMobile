import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class BarcodeScanner {
  static const platform = MethodChannel('com.example.temp/barcode_scanner');

  Future<String?> scanBarcode() async {
    try {
      final String? result = await platform.invokeMethod('scanBarcode');
      return result;
    } on PlatformException catch (e) {
      print("Failed to get barcode: '${e.message}'.");
      return null;
    }
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const platform = MethodChannel('com.example.temp/rfid');

  // Call onCreate from Flutter
  Future<void> callOnCreate() async {
    try {
      final result = await platform.invokeMethod('configureRFID');
      print("RFID_sample is configured $result");
    } catch (e) {
      print("Failed to configure RFID: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("MIESP Scanner")),
        body: Center(
          child: ElevatedButton(
            onPressed: callOnCreate,
            child: const Text("Configure RFID"),
          ),
        ),
      ),
    );
  }
}
