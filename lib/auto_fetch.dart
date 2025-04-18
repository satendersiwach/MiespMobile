import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'services/service_manager.dart';

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
        print('Scanned result on Flutter side : $result');
        // _scannedData = "Scanned: $result";
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
              onPressed: () {
                ServiceManager.scanQRCode(onSuccess: (String scanResult) async {
                  if (!mounted) return;
                  print('Scanned result on Flutter side : $scanResult');
                  _scannedData="Manually Scanned: $scanResult";
                  }
                );
              },
              child: const Text('Scan from flutter software'),
            )
          ],
        ),
      ),
    );
  }
}
