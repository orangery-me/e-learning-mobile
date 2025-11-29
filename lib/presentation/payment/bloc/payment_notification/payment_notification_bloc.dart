import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:e_learning_mobile/common/services/websocket_service.dart';
import 'package:e_learning_mobile/data/dtos/payment/payment_notification_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'payment_notification_event.dart';
part 'payment_notification_state.dart';

@injectable
class PaymentNotificationBloc
    extends Bloc<PaymentNotificationEvent, PaymentNotificationState> {
  final WebSocketService _webSocketService;

  PaymentNotificationBloc({required WebSocketService webSocketService})
      : _webSocketService = webSocketService,
        super(const PaymentNotificationState()) {
    on<ConnectPaymentNotification>(_onConnect);
    on<DisconnectPaymentNotification>(_onDisconnect);
    on<PaymentNotificationReceived>(_onNotificationReceived);
  }

  Future<void> _onConnect(
    ConnectPaymentNotification event,
    Emitter<PaymentNotificationState> emit,
  ) async {
    if (state.isConnected) {
      log('WebSocket already connected');
      return;
    }

    emit(state.copyWith(isConnecting: true, errorMessage: null));

    try {
      _webSocketService.connect(
        event.userId,
        (notification) {
          // Only handle notifications for the current order
          if (notification.type == 'PAYMENT_SUCCESS') {
            add(PaymentNotificationReceived(notification));
          }
        },
      );

      emit(state.copyWith(
        isConnected: true,
        isConnecting: false,
      ));
    } catch (e) {
      log('Error connecting WebSocket: $e');
      emit(state.copyWith(
        isConnected: false,
        isConnecting: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onDisconnect(
    DisconnectPaymentNotification event,
    Emitter<PaymentNotificationState> emit,
  ) {
    try {
      _webSocketService.disconnect();
      emit(state.copyWith(
        isConnected: false,
        isConnecting: false,
        clearNotification: true,
      ));
    } catch (e) {
      log('Error disconnecting WebSocket: $e');
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  void _onNotificationReceived(
    PaymentNotificationReceived event,
    Emitter<PaymentNotificationState> emit,
  ) {
    log('Payment notification received: type=${event.notification.type}');
    emit(state.copyWith(
      lastNotification: event.notification,
      clearError: true,
    ));
  }
}
