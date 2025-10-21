import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e_learning_mobile/common/constants/hive_keys.dart';
import 'package:e_learning_mobile/di/interceptors/app_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DioProvider {
  DioProvider(@Named(HiveKeys.authBox) this._authBox, this._nagivatorKey);
  final Box<dynamic> _authBox;
  final GlobalKey<NavigatorState> _nagivatorKey;

  Dio? _dio;
  Dio getDio() => _dio ?? _createDio();

  Dio _createDio() {
    final interceptorDio = Dio();
    final refreshTokenDio = Dio();

    final appInterceptor = AppInterceptor(
      authBox: _authBox,
      dio: refreshTokenDio,
      navigatorKey: _nagivatorKey
    );
    final interceptors = <Interceptor>[appInterceptor];

    return interceptorDio
      ..options.headers = {
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      }
      ..options.connectTimeout = const Duration(seconds: 15)
      ..options.receiveTimeout = const Duration(seconds: 15)
      ..options.sendTimeout = const Duration(seconds: 15)
      ..interceptors.addAll(interceptors);
  }
}
