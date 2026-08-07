import 'package:nota_app/config/env_dev.dart';
import 'package:nota_app/startup.dart';

import 'config/app_config.dart';

void main() {
  AppConfig.instance = AppConfig(
    appTitle: '[DEV] Nota App',
    apiKey: EnvDev.apiKey,
    environment: Environment.dev,
  );

  startupApp();
}