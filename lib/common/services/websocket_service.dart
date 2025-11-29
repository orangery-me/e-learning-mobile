import 'dart:convert';
import 'dart:developer';

import 'package:e_learning_mobile/common/constants/hive_keys.dart';
import 'package:e_learning_mobile/data/dtos/payment/payment_notification_dto.dart';
import 'package:e_learning_mobile/flavors.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

typedef PaymentNotificationCallback = void Function(
    PaymentNotificationDto notification);

@lazySingleton
class WebSocketService {
  WebSocketService(@Named(HiveKeys.authBox) this._authBox);

  final Box<dynamic> _authBox;
  StompClient? _stompClient;
  PaymentNotificationCallback? _onPaymentNotification;
  String? _userId;
  bool _isConnected = false;
  String? _subscriptionId;

  bool get isConnected => _isConnected;

  void connect(
      String userId, PaymentNotificationCallback onPaymentNotification) {
    _userId = userId;
    _onPaymentNotification = onPaymentNotification;

    if (_isConnected) {
      log('WebSocket already connected');
      return;
    }

    try {
      final accessToken = _authBox.get(HiveKeys.accessToken) as String?;
      if (accessToken == null) {
        log('No access token found, cannot connect to WebSocket');
        return;
      }

      // Get WebSocket URL from API base URL
      final wsUrl = _getWebSocketUrl();

      log('Connecting to WebSocket: $wsUrl for user: $userId');

      _stompClient = StompClient(
        config: StompConfig(
          url: wsUrl,
          stompConnectHeaders: {
            'Authorization': 'Bearer $accessToken',
          },
          onConnect: (frame) => _onStompConnected(frame, accessToken),
          onWebSocketError: (dynamic error) {
            log('WebSocket error: $error');
            _isConnected = false;
          },
          onStompError: (StompFrame frame) {
            log('STOMP error: ${frame.body}');
            _isConnected = false;
          },
          onDisconnect: (StompFrame frame) {
            log('WebSocket disconnected: ${frame.body}');
            _isConnected = false;
          },
          beforeConnect: () async {
            log('Preparing to connect to WebSocket...');
            await Future.delayed(const Duration(milliseconds: 100));
          },
          reconnectDelay: const Duration(milliseconds: 3000),
        ),
      );

      _stompClient!.activate();
    } catch (e) {
      log('Error connecting to WebSocket: $e');
      _isConnected = false;
    }
  }

  void _onStompConnected(StompFrame frame, String token) {
    log('STOMP connected successfully');
    _isConnected = true;
    _subscribeToNotifications(token);
  }

  void _subscribeToNotifications(String token) {
    if (_stompClient == null || _userId == null || !_isConnected) {
      log('Cannot subscribe: client, userId is null or not connected');
      return;
    }

    try {
      final destination = '/user/$_userId/queue/notifications';
      _subscriptionId = 'sub-${DateTime.now().millisecondsSinceEpoch}';

      _stompClient!.subscribe(
        destination: destination,
        callback: (StompFrame frame) {
          _handleNotification(frame);
        },
      );

      log('Subscribed to: $destination with id: $_subscriptionId');
    } catch (e) {
      log('Error subscribing to notifications: $e');
    }
  }

  void _handleNotification(StompFrame frame) {
    try {
      if (frame.body == null || frame.body!.isEmpty) {
        log('Received empty notification');
        return;
      }

      log('Received notification: ${frame.body}');

      // Parse JSON notification
      // final json = jsonDecode(frame.body!) as Map<String, dynamic>;
      final notification =
          PaymentNotificationDto.fromJson(jsonDecode(frame.body!));
      log('Parsed notification: type=${notification.type}'
          ', title=${notification.title}, message=${notification.message}');

      _onPaymentNotification?.call(notification);
    } catch (e) {
      log('Error handling notification: $e');
    }
  }

  void disconnect() {
    try {
      if (_stompClient != null) {
        // deactivate() will automatically unsubscribe from all destinations
        _stompClient!.deactivate();
        _stompClient = null;
      }

      _subscriptionId = null;
      _onPaymentNotification = null;
      _userId = null;
      _isConnected = false;
      log('WebSocket disconnected');
    } catch (e) {
      log('Error disconnecting WebSocket: $e');
    }
  }

  String _getWebSocketUrl() {
    final apiBaseUrl = AppFlavor.apiBaseUrl;
    // Convert http/https to ws/wss
    // Remove /v1 or /api/v1 if present as WebSocket endpoint is at root
    String baseUrl = apiBaseUrl.replaceAll('/api/v1', '').replaceAll('/v1', '');
    String wsUrl = baseUrl
        .replaceFirst('http://', 'ws://')
        .replaceFirst('https://', 'wss://');
    // For SockJS, we can try native WebSocket endpoint
    // Backend endpoint is /ws-notifications, SockJS adds /websocket for native WS
    wsUrl = '$wsUrl/ws-notifications';
    return wsUrl;
  }
}
