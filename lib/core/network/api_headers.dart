/// HTTP header names and common header values, centralized so they aren't
/// re-typed as string literals across the interceptors and Dio setup.
abstract class ApiHeaders {
  const ApiHeaders._();

  // Header names.
  static const String authorization = 'Authorization';
  static const String acceptLanguage = 'Accept-Language';
  static const String contentType = 'Content-Type';
  static const String accept = 'accept';

  // Header values.
  static const String bearer = 'Bearer';
  static const String applicationJson = 'application/json';
}
