import 'package:e_learning_mobile/data/dtos/payment/payment_response_dto.dart';
import 'package:e_learning_mobile/di/di.dart';
import 'package:e_learning_mobile/presentation/auth/bloc/auth/auth_bloc.dart';
import 'package:e_learning_mobile/presentation/core/bloc/root_bloc.dart';
import 'package:e_learning_mobile/presentation/learn/bloc/enrollment/enrollment_bloc.dart';
import 'package:e_learning_mobile/presentation/payment/bloc/order/order_bloc.dart';
import 'package:e_learning_mobile/presentation/payment/bloc/payment/payment_bloc.dart';
import 'package:e_learning_mobile/presentation/payment/bloc/payment_notification/payment_notification_bloc.dart';
import 'package:e_learning_mobile/presentation/payment/widgets/qr_payment_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QrPaymentDialogWrapper extends StatefulWidget {
  final PaymentResponseDto payment;

  const QrPaymentDialogWrapper({
    super.key,
    required this.payment,
  });

  @override
  State<QrPaymentDialogWrapper> createState() => _QrPaymentDialogWrapperState();
}

class _QrPaymentDialogWrapperState extends State<QrPaymentDialogWrapper> {
  bool _isExpired = false;
  String? _userId;

  @override
  void initState() {
    super.initState();

    // Cache userId for reload enrollment after payment success
    final authState = context.read<AuthBloc>().state;
    if (authState.user != null) {
      _userId = authState.user!.id;
    }
  }

  @override
  void dispose() {
    // Disconnect WebSocket when dialog is closed
    context.read<PaymentNotificationBloc>().add(
          const DisconnectPaymentNotification(),
        );
    super.dispose();
  }

  void _handlePaymentSuccess() {
    if (!mounted) return;

    // Show success toast
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bạn đã mua khóa học thành công! Học ngay'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );

    // Reload enrollments to show new courses in My Learning
    final enrollmentBloc = context.read<EnrollmentBloc>();
    if (_userId != null) {
      // Reload local bloc (dialog scope)
      enrollmentBloc.add(LoadEnrollmentsByUserId(_userId!));
      // Trigger global EnrollmentBloc (home page) via DI to refresh My Learning
      try {
        getIt<EnrollmentBloc>().add(LoadEnrollmentsByUserId(_userId!));
      } catch (_) {
        // ignore if not registered
      }
    }

    // Navigate to Tab My Learning (index 0). 
    RootBloc? rootBloc;
    try {
      rootBloc = context.read<RootBloc>();
    } catch (_) {
      rootBloc = getIt<RootBloc>();
    }
    rootBloc.add(const RootBottomTabChange(newIndex: 1));

    // Close all routes back to root (exit order detail page)
    Navigator.of(context).popUntil((route) => route.isFirst);

    // Also reload order to reflect updated status
    final orderBloc = context.read<OrderBloc>();
    final orderState = orderBloc.state;
    if (orderState is OrderDetailLoaded) {
      orderBloc.add(LoadOrderDetail(orderState.order.id));
    }
  }

  void _handlePaymentFailed() {
    if (!mounted) return;

    // Show failed toast
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Thanh toán thất bại. Vui lòng thử lại sau'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );

    // Reload order to reflect updated status
    final orderBloc = context.read<OrderBloc>();
    final orderState = orderBloc.state;
    if (orderState is OrderDetailLoaded) {
      orderBloc.add(LoadOrderDetail(orderState.order.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PaymentBloc, PaymentState>(
          listener: (context, state) {
            if (state is PaymentActionSuccess && _isExpired) {
              // Payment was cancelled due to expiration, reload order to reflect status change
              final orderBloc = context.read<OrderBloc>();
              final orderState = orderBloc.state;
              if (orderState is OrderDetailLoaded) {
                // Reload order detail to get updated status
                orderBloc.add(LoadOrderDetail(orderState.order.id));
              }
              // Close dialog after cancel is complete
              if (mounted) {
                Navigator.of(context).pop();
              }
            }
          },
        ),
        BlocListener<PaymentNotificationBloc, PaymentNotificationState>(
          listenWhen: (previous, current) =>
              previous.lastNotification != current.lastNotification,
          listener: (context, state) {
            if (state.lastNotification != null) {
              final notification = state.lastNotification!;

              // Close dialog first
              if (mounted) {
                Navigator.of(context).pop();
              }

              // Handle based on notification type
              if (notification.type == 'PAYMENT_SUCCESS') {
                _handlePaymentSuccess();
              } else if (notification.type == 'PAYMENT_FAILED') {
                _handlePaymentFailed();
              }
            }

            // Handle connection errors
            if (state.errorMessage != null && mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('WebSocket error: ${state.errorMessage}'),
                  backgroundColor: Colors.orange,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          },
        ),
      ],
      child: QrPaymentDialog(
        payment: widget.payment,
        onExpired: () {
          setState(() {
            _isExpired = true;
          });
          // Cancel payment when QR expired
          context
              .read<PaymentBloc>()
              .add(CancelPayment(widget.payment.orderCode));
          // Disconnect WebSocket when expired
          context.read<PaymentNotificationBloc>().add(
                const DisconnectPaymentNotification(),
              );
        },
        onCancel: () {
          // Disconnect WebSocket when user cancels
          context.read<PaymentNotificationBloc>().add(
                const DisconnectPaymentNotification(),
              );
        },
      ),
    );
  }
}
