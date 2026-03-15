import 'package:get/get.dart';
import 'package:scanner/common/keys.dart';
import 'package:scanner/local_storage/local_storage.dart';
import 'package:scanner/models/user_model.dart';
import 'package:scanner/services/api_client.dart';
import 'package:scanner/translations/custom_locale.dart';

class AuthService {
  static Future<bool> isInternetAvailable() async {
    return true;
  }

  static Future<UserModel> login({
    required String Username,
    required String Password,
  }) async {
    final responseMap = await ApiClient.post(
      'logindetails/login',
      body: {"Code": Username, "Password": Password},
    );
    return UserModel.fromJson(responseMap['Result']);
  }

  static void updateCurrentLangCode(String locale) async {
    LocalStorage.getInstance()
        ?.localStorage
        ?.setString(keyAppLocaleCode, locale);
    Get.updateLocale(CustomLocale.toLocale(locale));
  }
}
