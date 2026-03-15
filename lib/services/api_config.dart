import 'dart:convert';

import 'package:scanner/common/app_config.dart';

class ApiConfig {
  static String baseURL = AppConfig.apiBaseUrl;
  static final String _credentials = AppConfig.apiCredentials;
  static String encoded = utf8.fuse(base64).encode(_credentials);
  static Map<String, String> header = {
    'Authorization': 'Basic $encoded',
    "content-type": "application/json",
    "connection": "keep-alive"
  };
}
