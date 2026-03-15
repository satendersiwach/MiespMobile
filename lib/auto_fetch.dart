import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:scanner/services/scanner_service.dart';
import 'package:scanner/theme/custom_snack_bar.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const EventChannel _eventChannel = EventChannel('scannerStream');
  String _scannedData = 'Waiting for scan...';

  @override
  void initState() {
    super.initState();
    _eventChannel.receiveBroadcastStream().listen((result) {
      setState(() {
        if (result != null && result != '') {
          if (result.contains('\n')) {
            result = result.split('\n')[0];
          }

          if (result.contains(':')) {
            List l = result.split(":");
            if (l.length >= 2) {
              _scannedData = l[1];
              return;
            }
          } else {
            _scannedData = result;
            return;
          }
        }
      });
    }, onError: (error) {
      setState(() {
        _scannedData = "Error: $error";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Scanner Receiver')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_scannedData, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: () async {
                try {
                  final scanResult = await ScannerService.scanQRCode();
                  if (!mounted) return;
                  if (scanResult != null) {
                    setState(() {
                      _scannedData = "Manually Scanned: $scanResult";
                    });
                  } else {
                    CustomSnackBar.errorSnackBar('Could not scan');
                  }
                } catch (e) {
                  CustomSnackBar.errorSnackBar('Error during scan: $e');
                }
              },
              child: const Text('Scan from flutter software'),
            )
          ],
        ),
      ),
    );
  }
}
