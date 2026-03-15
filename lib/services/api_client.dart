import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:scanner/log_file/log_file_functions.dart';
import 'package:scanner/services/api_config.dart';
import 'package:scanner/services/api_exception.dart';

/// Centralized HTTP client that handles common concerns:
/// - Attaching auth headers
/// - JSON encoding/decoding
/// - Standard error checking (IsError / Code patterns)
/// - Optional request/response logging
class ApiClient {
  /// Performs a GET request and returns the decoded 'Result' from the response.
  static Future<dynamic> get(
    String path, {
    bool log = false,
  }) async {
    final url = '${ApiConfig.baseURL}$path';

    if (log) await _logRequest('GET', url);

    final res = await http.get(Uri.parse(url), headers: ApiConfig.header);

    if (log) await _logResponse(url, res.body);

    return _handleResponse(res);
  }

  /// Performs a POST request with a JSON body and returns the decoded 'Result'.
  static Future<dynamic> post(
    String path, {
    Object? body,
    bool log = false,
    bool useCodeCheck = false,
  }) async {
    final url = '${ApiConfig.baseURL}$path';
    final encodedBody = body != null ? jsonEncode(body) : null;

    if (log) await _logRequest('POST', url, body: encodedBody);

    final res = await http.post(
      Uri.parse(url),
      headers: ApiConfig.header,
      body: encodedBody,
    );

    if (log) await _logResponse(url, res.body);

    return _handleResponse(res, useCodeCheck: useCodeCheck);
  }

  /// Decodes the response and checks for API-level errors.
  /// Returns the full responseMap so callers can access 'Result' or other fields.
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

  static Future<void> _logRequest(String method, String url,
      {String? body}) async {
    final text = '''
    API call
    -----------------
    $method $url
    Header : ${ApiConfig.header}
    ${body != null ? 'Body :  $body' : ''}
    ''';
    await writeToLogFile(
        text: text, heading: 'Value', fileName: StackTrace.current.toString());
  }

  static Future<void> _logResponse(String url, String body) async {
    final text = '''
    API response for: $url
    -------------------------------------------------------------------------------------
    Response : $body
    ''';
    await writeToLogFile(
        text: text, heading: 'Value', fileName: StackTrace.current.toString());
  }
}
