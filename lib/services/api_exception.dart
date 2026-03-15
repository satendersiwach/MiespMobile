class ApiException implements Exception {
  final String message;
  final Map<String, dynamic>? responseMap;
  ApiException(this.message, {this.responseMap});

  String? get validationError {
    final errors = responseMap?['ValidationErrors'];
    if (errors is List && errors.isNotEmpty) {
      return errors[0]['ErrorMessage']?.toString();
    }
    return null;
  }

  @override
  String toString() => message;
}
