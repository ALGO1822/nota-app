enum Environment { dev, prod }

class AppConfig {
  final String appTitle;
  final String apiKey;
  final Environment environment;

  static late AppConfig instance;

  AppConfig({
    required this.appTitle,
    required this.apiKey,
    required this.environment,
  });

  bool get isDev => environment == Environment.dev;
  bool get isProd => environment == Environment.prod;
}