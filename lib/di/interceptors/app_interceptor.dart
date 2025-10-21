import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e_learning_mobile/common/constants/endpoints.dart';
import 'package:e_learning_mobile/common/constants/hive_keys.dart';
import 'package:e_learning_mobile/common/helpers/jwt_decoder.helper.dart';
import 'package:e_learning_mobile/data/dtos/auth/refresh_token_dto.dart';
import 'package:e_learning_mobile/router/app_router.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

class AppInterceptor extends QueuedInterceptor {
  AppInterceptor({
    @Named(HiveKeys.authBox) required Box<dynamic> authBox,
    required Dio dio,
    required GlobalKey<NavigatorState> navigatorKey,
  })  : _authBox = authBox,
        _dio = dio,
        _navigatorKey = navigatorKey;

  final Box<dynamic> _authBox;
  final Dio _dio;
  final GlobalKey<NavigatorState> _navigatorKey;
  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    log('REQUEST[${options.method}] => PATH: ${options.path}');

    // Skip token check for refresh token endpoint
    if (options.path.contains('/refresh_tokens') || options.path.contains('/oauth/token')) {
      return super.onRequest(options, handler);
    }

    await _checkTokenExpired();

    final accessToken = _authBox.get(HiveKeys.accessToken) as String?;

    if (accessToken != null) {
      options.headers.addAll({
        HttpHeaders.authorizationHeader: 'Bearer $accessToken',
      });
    }

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    log(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
      name: 'Intercepter: onResponse',
    );

    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // HACK: handle logout, maybe

      return;
    }

    log(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path} => MESSAGE: ${err.message}',
      name: 'Intercepter: onError',
    );

    return handler.next(err);
  }

  Future<void> _checkTokenExpired() async {
    final accessToken = _authBox.get(HiveKeys.accessToken) as String?;

    if (accessToken != null && accessToken.isNotEmpty) {
      try {
        final remainingTime = JwtDecoderHelper.getRemainingTime(accessToken);

        if (remainingTime != null && remainingTime.inSeconds <= 3) {
          await _refreshToken();
        }
      } catch (e) {
        log('Token validation failed: $e');
        await _refreshToken();
      }
    }
  }

  Future<void> _refreshToken() async {
    final refreshToken = _authBox.get(HiveKeys.refreshToken) as String?;

    if (refreshToken == null || refreshToken.isEmpty) {
      _navigator.pushNamedAndRemoveUntil(AppRouter.login, (route) => false);
      return;
    }

    log('--[REFRESH TOKEN]--: $refreshToken');

    try {
      final response = await _dio.post(
        '${Endpoints.apiUrl}/refresh_tokens',
        data: {
          'refresh_token': refreshToken,
        },
      );

      final refreshTokenDTO = RefreshTokenDTO.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );

      await _authBox.putAll(refreshTokenDTO.toLocalJson());
    } catch (err) {
      log('Error refreshing token: $err');
      _navigator.pushNamedAndRemoveUntil(AppRouter.login, (route) => false);
      return;
    }
  }
}
