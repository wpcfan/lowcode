/// Environment variables and shared app constants.
abstract class Constants {
  static const String lowcodeBaseUrl = String.fromEnvironment(
    'LOWCODE_BASE_URL',
    defaultValue: 'http://localhost:8080/api/v1',
  );
}
