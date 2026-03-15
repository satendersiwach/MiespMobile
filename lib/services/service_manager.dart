import 'package:scanner/services/api_config.dart';

export 'api_config.dart';
export 'api_exception.dart';
export 'auth_service.dart';
export 'pick_list_service.dart';
export 'inventory_service.dart';
export 'master_data_service.dart';
export 'scanner_service.dart';
export 'log_upload_service.dart';

/// Backward-compatible aliases so existing code using
/// `ServiceManager.baseURL` / `ServiceManager.header` still works.
class ServiceManager {
  static String get baseURL => ApiConfig.baseURL;
  static set baseURL(String v) => ApiConfig.baseURL = v;

  static String get encoded => ApiConfig.encoded;

  static Map<String, String> get header => ApiConfig.header;
  static set header(Map<String, String> v) => ApiConfig.header = v;
}
