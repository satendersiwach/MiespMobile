import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:scanner/local_storage/keys.dart';
import 'package:scanner/local_storage/local_storage.dart';
import 'package:scanner/theme/custom_colors.dart';
import 'package:scanner/theme/custom_snack_bar.dart';
import 'package:scanner/theme/custom_text_widgets.dart';
import 'package:scanner/translations/custom_locale.dart';
import 'package:scanner/ui/login_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceManager {
  static Future<bool> isInternetAvailable() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      CustomSnackBar.errorSnackBar('No Internet');
      return false;
    }
    return true;
  }

  static scanQRCode({
    required Function(String) onSuccess,
  }) async {
    String scanResult = '';
    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // Color for the background of the scan page
        'Cancel', // Text for the button that cancels the scan
        true, // Whether to show the flash icon
        ScanMode.QR, // The type of code to scan (QR Code or Barcode)
      );
    } catch (e) {
      print('Error during scan: $e');
      CustomSnackBar.errorSnackBar('Error during scan: $e');
      return;
    }

    if (scanResult != '-1') {
      onSuccess(scanResult);
    }
  }

  static showLogoutDialog() {
    showDialog(
      barrierDismissible: false,
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: getHeadingText(text: "Logout", fontSize: 15),
          content: SizedBox(
            height: Get.height / 35,
            width: Get.width / 1.5,
            child: getHeadingText(
                text: 'Are you sure you want to logout?',
                fontWeight: FontWeight.w500),
          ),
          actions: [
            MaterialButton(
              // OPTIONAL BUTTON
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              color: submitButtonColor,
              child: getHeadingText(text: 'No', color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            MaterialButton(
              // OPTIONAL BUTTON
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              color: Colors.red,
              child: getHeadingText(text: 'Yes', color: Colors.white),
              onPressed: () async {
                LocalStorage.logout();
                Get.offAll(() => const LoginPage());
              },
            ),
          ],
        );
      },
    );
  }

  static void updateCurrentLangCode(String locale) async {
    LocalStorage.getInstance()
        ?.localStorage
        ?.setString(keyAppLocaleCode, locale);
    Get.updateLocale(CustomLocale.toLocale(locale));
  }

  static Future<bool> checkInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    return true;
  }

  static launchInBrowser(Uri? uri) async {
    try {
      if (await canLaunchUrl(uri ?? Uri.parse(''))) {
        await launchUrl(uri ?? Uri.parse(''));
      } else {}
    } catch (e) {
      CustomSnackBar.errorSnackBar(e.toString());
    }
  }
}
