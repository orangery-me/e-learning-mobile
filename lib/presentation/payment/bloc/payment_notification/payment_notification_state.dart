part of 'payment_notification_bloc.dart';

class PaymentNotificationState extends Equatable {
  final bool isConnected;
  final bool isConnecting;
  final String? errorMessage;
  final PaymentNotificationDto? lastNotification;

  const PaymentNotificationState({
    this.isConnected = false,
    this.isConnecting = false,
    this.errorMessage,
    this.lastNotification,
  });

  PaymentNotificationState copyWith({
    bool? isConnected,
    bool? isConnecting,
    String? errorMessage,
    PaymentNotificationDto? lastNotification,
    bool clearError = false,
    bool clearNotification = false,
  }) {
    return PaymentNotificationState(
      isConnected: isConnected ?? this.isConnected,
      isConnecting: isConnecting ?? this.isConnecting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      lastNotification: clearNotification
          ? null
          : (lastNotification ?? this.lastNotification),
    );
  }

  @override
  List<Object?> get props => [
        isConnected,
        isConnecting,
        errorMessage,
        lastNotification,
      ];
}
