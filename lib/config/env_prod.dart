import 'package:envied/envied.dart';

part 'env_prod.g.dart';

@Envied(path: '.env.prod')
abstract class EnvProd {
  @EnviedField(varName: 'API_KEY', obfuscate: true)
  static final String apiKey = _EnvProd.apiKey;
}