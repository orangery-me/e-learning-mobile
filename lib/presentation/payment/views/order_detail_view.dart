import 'dart:developer';

import 'package:e_learning_mobile/common/extensions/context_extension.dart';
import 'package:e_learning_mobile/common/utils/format_util.dart';
import 'package:e_learning_mobile/data/dtos/order/order_response_dto.dart';
import 'package:e_learning_mobile/data/dtos/payment/create_payment_request.dart';
import 'package:e_learning_mobile/di/di.dart';
import 'package:e_learning_mobile/presentation/auth/bloc/auth/auth_bloc.dart';
import 'package:e_learning_mobile/presentation/core/bloc/root_bloc.dart';
import 'package:e_learning_mobile/presentation/learn/bloc/enrollment/enrollment_bloc.dart';
import 'package:e_learning_mobile/presentation/payment/bloc/order/order_bloc.dart';
import 'package:e_learning_mobile/presentation/payment/bloc/payment/payment_bloc.dart';
import 'package:e_learning_mobile/presentation/payment/bloc/payment_notification/payment_notification_bloc.dart';
import 'package:e_learning_mobile/presentation/payment/widgets/payment_card.dart';
import 'package:e_learning_mobile/presentation/payment/widgets/qr_payment_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderDetailPage extends StatelessWidget {
  final OrderEvent?
      initialEvent; // e.g. CreateOrderFromCart() or LoadOrderDetail(id)
  final String? orderId;

  const OrderDetailPage({super.key, this.initialEvent, this.orderId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final bloc = getIt<OrderBloc>();
            final ev = initialEvent;
            if (ev != null) {
              bloc.add(ev);
            } else if (orderId != null) {
              bloc.add(LoadOrderDetail(orderId!));
            }
            return bloc;
          },
        ),
        BlocProvider(create: (_) => getIt<PaymentBloc>()),
        BlocProvider(create: (_) => getIt<EnrollmentBloc>()),
        BlocProvider(create: (_) => getIt<PaymentNotificationBloc>()),
      ],
      child: const OrderDetailView(),
    );
  }
}

class OrderDetailView extends StatelessWidget {
  const OrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Order Detail'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<OrderBloc, OrderState>(
            listener: (context, state) {
              if (state is OrderError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
          BlocListener<PaymentBloc, PaymentState>(
            listener: (context, state) {
              if (state is PaymentError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              } else if (state is PaymentActionSuccess) {
                // Show QR dialog when payment is created successfully
                final payment = state.payment;
                log('Payment created: $payment');
                if (payment.qrCode != null && payment.expiresAt != null) {
                  final paymentBloc = context.read<PaymentBloc>();
                  final orderBloc = context.read<OrderBloc>();
                  final enrollmentBloc = context.read<EnrollmentBloc>();
                  final paymentNotificationBloc =
                      context.read<PaymentNotificationBloc>();
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => MultiBlocProvider(
                      providers: [
                        BlocProvider.value(value: paymentBloc),
                        BlocProvider.value(value: orderBloc),
                        BlocProvider.value(value: enrollmentBloc),
                        BlocProvider.value(value: paymentNotificationBloc),
                      ],
                      child: QrPaymentDialogWrapper(
                        qrCode: payment.qrCode!,
                        checkoutUrl: payment.checkoutUrl!,
                        expiresAt: payment.expiresAt!,
                        orderCode: payment.orderCode,
                      ),
                    ),
                  );
                }
              }
            },
          ),
        ],
        child: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            if (state is OrderLoading || state is OrderInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is OrderError) {
              return _ErrorPane(
                message: state.message,
                onRetry: () => Navigator.of(context).maybePop(),
              );
            }

            if (state is OrderActionSuccess || state is OrderDetailLoaded) {
              final order = state is OrderActionSuccess
                  ? state.order
                  : (state as OrderDetailLoaded).order;
              return _OrderSummary(order: order);
            }

            if (state is OrdersLoaded) {
              // Fallback: no specific order, show empty
              return const Center(child: Text('No order selected'));
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class _ErrorPane extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorPane({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 12),
            Text(
              'Failed to load order',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  final OrderResponse order;

  const _OrderSummary({required this.order});

  Widget listItems() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: order.items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final it = order.items[index];
        final finalPrice = (it.unitPrice ?? 0) - it.discountAmount;
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  it.courseImage ?? '',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[600],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Course Title
                    Text(
                      it.courseTitle ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Course ID
                    Text(
                      'ID: ${it.courseId}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Final Price
                    Text(
                      'Price: ${FormatUtil.formatNumberAsCurrency(
                        finalPrice,
                        symbol: '₫',
                      )}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: context.palette.buttonBackground,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // can pay when pending; payment info may be null before initiating payment

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            border: Border(
              bottom: BorderSide(color: Colors.grey[200]!),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.receipt_long,
                  color: context.palette.buttonBackground, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${order.orderNumber}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Total: ${FormatUtil.formatNumberAsCurrency(order.finalAmount, symbol: '₫')}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Items',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),

              listItems(),

              if (order.payment != null) ...[
                const SizedBox(height: 16),
                PaymentCard(order: order),
              ],

              // push other content to bottom
              Expanded(child: Container()),

              if (order.discountAmount > 0) ...[
                const SizedBox(height: 8),
                _SummaryRow(
                  label: 'Discount',
                  value:
                      '-${FormatUtil.formatNumberAsCurrency(order.discountAmount, symbol: '₫')}',
                  valueStyle: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              _SummaryRow(
                label: 'Total',
                value: FormatUtil.formatNumberAsCurrency(order.finalAmount,
                    symbol: '₫'),
                labelStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                valueStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: context.palette.buttonBackground,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Colors.grey[200]!),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: (order.status.name.toLowerCase() == 'pending')
              ? BlocBuilder<PaymentBloc, PaymentState>(
                  builder: (context, paymentState) {
                    final isLoading = paymentState is PaymentLoading;
                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                context.read<PaymentBloc>().add(
                                      CreatePayment(
                                        CreatePaymentRequest(
                                          orderId: order.id,
                                        ),
                                      ),
                                    );
                              },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: context.palette.buttonBackground,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    context.palette.buttonText,
                                  ),
                                ),
                              )
                            : Text(
                                'Confirm Payment',
                                style: context.textStyles.heading4.copyWith(
                                  color: context.palette.buttonText,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    );
                  },
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle ?? TextStyle(color: Colors.grey[600])),
        Text(
          value,
          style: valueStyle ?? const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class QrPaymentDialogWrapper extends StatefulWidget {
  final String qrCode;
  final String checkoutUrl;
  final DateTime expiresAt;
  final String orderCode;

  const QrPaymentDialogWrapper({
    super.key,
    required this.qrCode,
    required this.checkoutUrl,
    required this.expiresAt,
    required this.orderCode,
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

    // Get userId from AuthBloc and connect WebSocket
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      if (authState.user != null) {
        _userId = authState.user!.id;
        context.read<PaymentNotificationBloc>().add(
              ConnectPaymentNotification(
                userId: _userId!,
                orderCode: widget.orderCode,
              ),
            );
      }
    });
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
      enrollmentBloc.add(LoadEnrollmentsByUserId(_userId!));
    }

    // Navigate to home (index 0)
    final rootBloc = context.read<RootBloc>();
    rootBloc.add(const RootBottomTabChange(newIndex: 0));

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
          listener: (context, state) {
            if (state.lastNotification != null) {
              final notification = state.lastNotification!;
              log('Handling payment notification: type=${notification.type}, status=${notification.paymentStatus}');

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
        qrCode: widget.qrCode,
        checkoutUrl: widget.checkoutUrl,
        expiresAt: widget.expiresAt,
        onExpired: () {
          setState(() {
            _isExpired = true;
          });
          // Cancel payment when QR expired
          context.read<PaymentBloc>().add(CancelPayment(widget.orderCode));
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
