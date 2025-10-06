// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:e_learning_mobile/common/helpers/dio_helper.dart' as _i896;
import 'package:e_learning_mobile/data/datasources/user/local/user_datasource.dart'
    as _i591;
import 'package:e_learning_mobile/data/datasources/user/remote/user_datasource.dart'
    as _i812;
import 'package:e_learning_mobile/data/datasources/user/user_datasource.dart'
    as _i1056;
import 'package:e_learning_mobile/data/repositories/user_repository.dart'
    as _i979;
import 'package:e_learning_mobile/di/modules/local_module.dart' as _i414;
import 'package:e_learning_mobile/di/modules/network_module.dart' as _i220;
import 'package:e_learning_mobile/di/providers/dio_provider.dart' as _i958;
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive/hive.dart' as _i979;
import 'package:hive_flutter/hive_flutter.dart' as _i986;
import 'package:injectable/injectable.dart' as _i526;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i174.GetIt> initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final localModule = _$LocalModule();
  final networkModule = _$NetworkModule();
  await gh.singletonAsync<_i986.Box<dynamic>>(
    () => localModule.authBox,
    instanceName: 'auth_box',
    preResolve: true,
  );
  gh.lazySingleton<_i958.DioProvider>(
    () => _i958.DioProvider(gh<_i979.Box<dynamic>>(instanceName: 'auth_box')),
  );
  gh.lazySingleton<_i591.UserLocalDataSource>(
    () => _i591.UserLocalDataSource(
      authBox: gh<_i979.Box<dynamic>>(instanceName: 'auth_box'),
    ),
  );
  gh.lazySingleton<_i896.DioHelper>(
    () => networkModule.provideDioHelper(gh<_i958.DioProvider>()),
  );
  gh.lazySingleton<_i812.UserRemoteDataSource>(
    () => _i812.UserRemoteDataSource(dioHelper: gh<_i896.DioHelper>()),
  );
  gh.lazySingleton<_i1056.UserDataSource>(
    () => _i1056.UserDataSource(
      remoteDataSource: gh<_i812.UserRemoteDataSource>(),
      localDataSource: gh<_i591.UserLocalDataSource>(),
    ),
  );
  gh.lazySingleton<_i979.UserRepository>(
    () => _i979.UserRepository(dataSource: gh<_i1056.UserDataSource>()),
  );
  return getIt;
}

class _$LocalModule extends _i414.LocalModule {}

class _$NetworkModule extends _i220.NetworkModule {}
