import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:scanner/common/keys.dart';
import 'package:scanner/local_storage/local_storage.dart';
import 'package:scanner/models/user_model.dart';
import 'package:scanner/services/api_config.dart';
import 'package:scanner/services/api_exception.dart';
import 'package:scanner/translations/custom_locale.dart';

class AuthService {
  static Future<bool> isInternetAvailable() async {
    return true;
  }

  static Future<UserModel> login({
    required String Username,
    required String Password,
  }) async {
    var res = await http.post(Uri.parse('${ApiConfig.baseURL}logindetails/login'),
        headers: ApiConfig.header,
        body: jsonEncode({"Code": Username, "Password": Password}));

    Map responseMap = jsonDecode(res.body);
    if (!responseMap['IsError']) {
      return UserModel.fromJson(responseMap['Result']);
    } else {
      throw ApiException(
        responseMap['Error'] ?? 'Login failed',
        responseMap: Map<String, dynamic>.from(responseMap),
      );
    }
  }

  static void updateCurrentLangCode(String locale) async {
    LocalStorage.getInstance()
        ?.localStorage
        ?.setString(keyAppLocaleCode, locale);
    Get.updateLocale(CustomLocale.toLocale(locale));
  }
}
