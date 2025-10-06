import 'package:e_learning_mobile/common/helpers/dio_helper.dart';
import 'package:e_learning_mobile/di/providers/dio_provider.dart';
import 'package:injectable/injectable.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  DioHelper provideDioHelper(DioProvider dioProvider) {
    return DioHelper(dio: dioProvider.getDio());
  }
}
