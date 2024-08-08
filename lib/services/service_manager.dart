import 'package:scanner/local_storage/keys.dart';
import 'package:scanner/local_storage/local_storage.dart';
import 'package:scanner/theme/custom_snack_bar.dart';
import 'package:scanner/translations/custom_locale.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import 'package:url_launcher/url_launcher.dart';

class ServiceManager {
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
