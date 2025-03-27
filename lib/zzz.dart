import 'package:flutter/material.dart';
import 'package:scanner/LogFile/log_file_functions.dart';
import 'package:scanner/services/service_manager.dart';
import 'package:scanner/ui/components/element_button.dart';

class ScannerTesting extends StatelessWidget {
  const ScannerTesting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MIESP Scanner")),
      body: Center(
        child: loadingButton(
            isLoading: false,
            btnText: 'Test Scanning',
            onPress: () {
              ServiceManager.scanQRCode(onSuccess: (String res) async {
                String text = '''
    Final Scanned result
    -----------------
    Result : $res
    ''';
                await writeToLogFile(
                    text: text,
                    heading: 'Value',
                    fileName: StackTrace.current.toString());
              });
            }),
        // child: ElevatedButton(
        //   onPressed: () {
        //     ServiceManager.scanQRCode(onSuccess: (String res) {});
        //   },
        //   child: getHeadingText(text: 'Test Scanning'),
        // ),
      ),
    );
  }
}
