/// App configuration that reads from --dart-define environment variables.
///
/// Usage at build time:
/// ```
/// flutter run \
///   --dart-define=API_BASE_URL=http://192.168.10.42:8084/api/ \
///   --dart-define=API_CREDENTIALS=11205952:60-dayfreetrial
/// ```
class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://192.168.10.42:8084/api/',
  );

  static const String apiCredentials = String.fromEnvironment(
    'API_CREDENTIALS',
    defaultValue: '11205952:60-dayfreetrial',
  );
}
