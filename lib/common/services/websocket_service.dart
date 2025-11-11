import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:e_learning_mobile/common/constants/hive_keys.dart';
import 'package:e_learning_mobile/data/dtos/payment/payment_notification_dto.dart';
import 'package:e_learning_mobile/flavors.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

typedef PaymentNotificationCallback = void Function(
    PaymentNotificationDto notification);

@lazySingleton
class WebSocketService {
  WebSocketService(@Named(HiveKeys.authBox) this._authBox);

  final Box<dynamic> _authBox;
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  PaymentNotificationCallback? _onPaymentNotification;
  String? _userId;
  bool _isConnected = false;

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

      // Create WebSocket connection with authentication token in query parameter
      // Spring WebSocket interceptor can extract token from query or header
      final uri = Uri.parse(wsUrl).replace(
        queryParameters: {
          'token': accessToken,
        },
      );
      _channel = IOWebSocketChannel.connect(uri);

      _isConnected = true;

      // Listen to messages
      _subscription = _channel!.stream.listen(
        (message) {
          log('Received WebSocket message: $message');
          _handleMessage(message);
        },
        onError: (error) {
          log('WebSocket error: $error');
          _isConnected = false;
        },
        onDone: () {
          log('WebSocket connection closed');
          _isConnected = false;
        },
        cancelOnError: false,
      );

      // Send STOMP CONNECT frame
      _sendStompConnect();
    } catch (e) {
      log('Error connecting to WebSocket: $e');
      _isConnected = false;
    }
  }

  void _sendStompConnect() {
    if (_channel == null) return;

    final connectFrame = 'CONNECT\n'
        'accept-version:1.1,1.0\n'
        'heart-beat:10000,10000\n'
        '\n'
        '\x00';

    _channel!.sink.add(connectFrame);
    log('Sent STOMP CONNECT frame');

    // After connecting, subscribe to user queue
    Future.delayed(const Duration(milliseconds: 500), () {
      _subscribeToNotifications();
    });
  }

  void _subscribeToNotifications() {
    if (_channel == null || _userId == null) {
      log('Cannot subscribe: channel or userId is null');
      return;
    }

    try {
      // Subscribe to user-specific notifications
      // Spring WebSocket with user destination prefix will automatically route
      final destination = '/user/queue/notifications';
      final subscriptionId = 'sub-${DateTime.now().millisecondsSinceEpoch}';

      final subscribeFrame = 'SUBSCRIBE\n'
          'id:$subscriptionId\n'
          'destination:$destination\n'
          '\n'
          '\x00';

      _channel!.sink.add(subscribeFrame);
      log('Subscribed to: $destination with id: $subscriptionId');
    } catch (e) {
      log('Error subscribing to notifications: $e');
    }
  }

  void _handleMessage(dynamic message) {
    try {
      final messageStr = message.toString();

      // Parse STOMP message frame
      if (messageStr.startsWith('MESSAGE')) {
        final lines = messageStr.split('\n');
        String? body;
        bool inBody = false;
        final buffer = StringBuffer();

        for (var line in lines) {
          if (line.isEmpty && !inBody) {
            inBody = true;
            continue;
          }
          if (inBody && line != '\x00') {
            buffer.writeln(line);
          }
        }

        body = buffer.toString().trim();
        if (body.isEmpty) return;

        log('Parsed STOMP message body: $body');

        // Parse JSON notification
        final json = jsonDecode(body) as Map<String, dynamic>;
        final notification = PaymentNotificationDto.fromJson(json);
        log('Parsed notification: type=${notification.type}, orderCode=${notification.orderCode}');

        _onPaymentNotification?.call(notification);
      } else if (messageStr.startsWith('CONNECTED')) {
        log('STOMP connected successfully');
        _subscribeToNotifications();
      } else if (messageStr.startsWith('ERROR')) {
        log('STOMP error: $messageStr');
      }
    } catch (e) {
      log('Error handling WebSocket message: $e');
    }
  }

  void disconnect() {
    try {
      if (_channel != null) {
        // Send STOMP DISCONNECT frame
        final disconnectFrame = 'DISCONNECT\n'
            '\n'
            '\x00';
        _channel!.sink.add(disconnectFrame);
        _channel!.sink.close();
        _channel = null;
      }
      _subscription?.cancel();
      _subscription = null;
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
    wsUrl = '$wsUrl/ws-notifications/websocket';
    return wsUrl;
  }
}
