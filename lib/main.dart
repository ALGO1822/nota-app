import 'package:nota_app/config/env_prod.dart';
import 'package:nota_app/startup.dart';

import 'config/app_config.dart';

void main() {
  AppConfig.instance = AppConfig(
    appTitle: 'Nota',
    apiKey: EnvProd.apiKey,
    environment: Environment.prod,
  );

  startupApp();
}