import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:scanner/services/api_config.dart';
import 'package:scanner/services/api_exception.dart';

/// Centralized HTTP client that handles common concerns:
/// - Attaching auth headers
/// - JSON encoding/decoding
/// - Standard error checking (IsError / Code patterns)
class ApiClient {
  /// Performs a GET request and returns the decoded response map.
  static Future<Map<String, dynamic>> get(String path) async {
    final url = '${ApiConfig.baseURL}$path';
    final res = await http.get(Uri.parse(url), headers: ApiConfig.header);
    return _handleResponse(res);
  }

  /// Performs a POST request with a JSON body and returns the decoded response map.
  static Future<Map<String, dynamic>> post(
    String path, {
    Object? body,
    bool useCodeCheck = false,
  }) async {
    final url = '${ApiConfig.baseURL}$path';
    final res = await http.post(
      Uri.parse(url),
      headers: ApiConfig.header,
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(res, useCodeCheck: useCodeCheck);
  }

  static Map<String, dynamic> _handleResponse(
    http.Response res, {
    bool useCodeCheck = false,
  }) {
    final Map<String, dynamic> responseMap =
        Map<String, dynamic>.from(jsonDecode(res.body));

    final bool isSuccess = useCodeCheck
        ? responseMap['Code'] == 0
        : responseMap['IsError'] == false;

    if (!isSuccess) {
      throw ApiException(
        responseMap['Error']?.toString() ?? 'Request failed',
        responseMap: responseMap,
      );
    }

    return responseMap;
  }
}
