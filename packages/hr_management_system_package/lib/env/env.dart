import 'package:envied/envied.dart';

part 'env.g.dart';

enum EnvironmentType { dev, prod }

EnvironmentType currentEnvironment = EnvironmentType.dev;

@Envied(path: '.env.dev')
abstract class EnvDev {
  @EnviedField(varName: 'BASE_URL')
  static const String baseUrl = _EnvDev.baseUrl;
}

@Envied(path: '.env.prod')
abstract class EnvProd {
  @EnviedField(varName: 'BASE_URL')
  static const String baseUrl = _EnvProd.baseUrl;
}

class Env {
  static String get baseUrl {
    switch (currentEnvironment) {
      case EnvironmentType.prod:
        return EnvProd.baseUrl;
      case EnvironmentType.dev:
        return EnvDev.baseUrl;
    }
  }
}
