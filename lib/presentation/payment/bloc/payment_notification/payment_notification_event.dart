part of 'payment_notification_bloc.dart';

sealed class PaymentNotificationEvent extends Equatable {
  const PaymentNotificationEvent();

  @override
  List<Object> get props => [];
}

class ConnectPaymentNotification extends PaymentNotificationEvent {
  final String userId;
  final String orderCode;

  const ConnectPaymentNotification({
    required this.userId,
    required this.orderCode,
  });

  @override
  List<Object> get props => [userId, orderCode];
}

class DisconnectPaymentNotification extends PaymentNotificationEvent {
  const DisconnectPaymentNotification();
}

class PaymentNotificationReceived extends PaymentNotificationEvent {
  final PaymentNotificationDto notification;

  const PaymentNotificationReceived(this.notification);

  @override
  List<Object> get props => [notification];
}
