import 'dart:developer';

import 'package:e_learning_mobile/common/extensions/context_extension.dart';
import 'package:e_learning_mobile/common/utils/dialog_util.dart';
import 'package:e_learning_mobile/common/utils/format_util.dart';
import 'package:e_learning_mobile/data/dtos/order/order_response_dto.dart';
import 'package:e_learning_mobile/data/dtos/order/order_status.dart';
import 'package:e_learning_mobile/data/dtos/payment/create_payment_request.dart';
import 'package:e_learning_mobile/di/di.dart';
import 'package:e_learning_mobile/presentation/auth/bloc/auth/auth_bloc.dart';
import 'package:e_learning_mobile/presentation/learn/bloc/enrollment/enrollment_bloc.dart';
import 'package:e_learning_mobile/presentation/payment/bloc/order/order_bloc.dart';
import 'package:e_learning_mobile/presentation/payment/bloc/payment/payment_bloc.dart';
import 'package:e_learning_mobile/presentation/payment/bloc/payment_notification/payment_notification_bloc.dart';
import 'package:e_learning_mobile/presentation/payment/widgets/payment_card.dart';
import 'package:e_learning_mobile/presentation/payment/widgets/qr_payment_dialig_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderDetailPage extends StatelessWidget {
  final OrderEvent? initialEvent;
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

class OrderDetailView extends StatefulWidget {
  const OrderDetailView({super.key});

  @override
  State<OrderDetailView> createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends State<OrderDetailView> {
  String? _userId;

  @override
  void initState() {
    final authState = context.read<AuthBloc>().state;
    if (authState.user != null) {
      _userId = authState.user!.id;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.scaffoldBackground,
      appBar: AppBar(
        title: Text(
          'Order Detail',
          style: context.textStyles.heading4,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: context.palette.scaffoldBackground,
        foregroundColor: context.palette.normalText,
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
                if (_userId != null && payment.orderCode.isNotEmpty) {
                  context.read<PaymentNotificationBloc>().add(
                        ConnectPaymentNotification(
                          userId: _userId!,
                          orderCode: payment.orderCode,
                        ),
                      );
                }
                if (payment.qrCode != null && payment.expiresAt != null) {
                  final paymentBloc = context.read<PaymentBloc>();
                  final orderBloc = context.read<OrderBloc>();
                  final enrollmentBloc = context.read<EnrollmentBloc>();
                  final paymentNotificationBloc =
                      context.read<PaymentNotificationBloc>();
                  DialogUtil.showCustomDialog(
                    context,
                    title: 'Payment QR Code',
                    barrierDismissible: false,
                    confirmButtonText: 'Close',
                    confirmAction: () {
                      paymentNotificationBloc
                          .add(const DisconnectPaymentNotification());
                    },
                    child: MultiBlocProvider(
                      providers: [
                        BlocProvider.value(value: paymentBloc),
                        BlocProvider.value(value: orderBloc),
                        BlocProvider.value(value: enrollmentBloc),
                        BlocProvider.value(value: paymentNotificationBloc),
                      ],
                      child: QrPaymentDialogWrapper(
                        payment: payment,
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
              style: context.textStyles.heading4,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: context.textStyles.body2.copyWith(
                color: Colors.grey[600],
              ),
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

  Widget listItems(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: order.items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final it = order.items[index];
        final finalPrice = (it.unitPrice ?? 0) - it.discountAmount;
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.palette.textFieldBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.withOpacity(0.1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
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
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[400],
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
                      style: context.textStyles.body1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Final Price
                    Text(
                      FormatUtil.formatNumberAsCurrency(
                        finalPrice,
                        symbol: '₫',
                      ),
                      style: context.textStyles.heading4.copyWith(
                        color: context.palette.primaryColor,
                        fontWeight: FontWeight.bold,
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

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.paid:
        return 'Paid';
      case OrderStatus.failed:
        return 'Failed';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.refunded:
        return 'Refunded';
      case OrderStatus.delivered:
        return 'Delivered';
    }
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.paid:
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.failed:
        return Colors.red;
      case OrderStatus.cancelled:
        return Colors.grey;
      case OrderStatus.refunded:
        return Colors.blue;
    }
  }

  String _getButtonText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Confirm Payment';
      case OrderStatus.cancelled:
      case OrderStatus.failed:
        return 'Thanh toán lại';
      default:
        return '';
    }
  }

  bool _shouldShowButton(OrderStatus status) {
    return status == OrderStatus.pending ||
        status == OrderStatus.cancelled ||
        status == OrderStatus.failed;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Order Header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              // gradient: LinearGradient(
              //   colors: [
              //     context.palette.primaryColor,
              //     context.palette.primaryColor.withOpacity(0.8),
              //   ],
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              // ),
              // boxShadow: [
              //   BoxShadow(
              //     color: context.palette.primaryColor.withOpacity(0.3),
              //     blurRadius: 12,
              //     offset: const Offset(0, 4),
              //   ),
              // ],
              ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.receipt_long,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${order.orderNumber}',
                          style: context.textStyles.heading4.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          FormatUtil.formatNumberAsCurrency(
                            order.finalAmount,
                            symbol: '₫',
                          ),
                          style: context.textStyles.heading4,
                        ),
                      ],
                    ),
                  ),
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _getStatusColor(order.status),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _getStatusText(order.status),
                          style: context.textStyles.metadata1.copyWith(
                            color: _getStatusColor(order.status),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (order.createdAt != null) ...[
                const SizedBox(height: 12),
                Divider(color: Colors.white.withOpacity(0.2)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Created: ${FormatUtil.formatDateTime(order.createdAt!)}',
                      style: context.textStyles.metadata1.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),

        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Items Section
              Text(
                'Items',
                style: context.textStyles.heading4.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              listItems(context),

              // Payment Info Section
              if (order.payment != null) ...[
                const SizedBox(height: 24),
                PaymentCard(order: order),
              ],

              // Summary Section
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.palette.textFieldBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  children: [
                    if (order.discountAmount > 0) ...[
                      _SummaryRow(
                        label: 'Subtotal',
                        value: FormatUtil.formatNumberAsCurrency(
                          order.totalAmount,
                          symbol: '₫',
                        ),
                      ),
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
                      const SizedBox(height: 12),
                      Divider(color: Colors.grey.withOpacity(0.2)),
                      const SizedBox(height: 12),
                    ],
                    _SummaryRow(
                      label: 'Total',
                      value: FormatUtil.formatNumberAsCurrency(
                        order.finalAmount,
                        symbol: '₫',
                      ),
                      labelStyle: context.textStyles.heading4.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      valueStyle: context.textStyles.heading3.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.palette.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Action Button
        if (_shouldShowButton(order.status))
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.withOpacity(0.1)),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: BlocBuilder<PaymentBloc, PaymentState>(
              builder: (context, paymentState) {
                final isLoading = paymentState is PaymentLoading;
                return SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    key: const ValueKey('payment_action_button'),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.palette.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
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
                            _getButtonText(order.status),
                            style: context.textStyles.buttonLabel.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                );
              },
            ),
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
        Text(
          label,
          style: labelStyle ??
              context.textStyles.body2.copyWith(
                color: Colors.grey[600],
              ),
        ),
        Text(
          value,
          style: valueStyle ??
              context.textStyles.body1.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
