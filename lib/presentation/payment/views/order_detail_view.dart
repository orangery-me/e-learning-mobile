import 'package:e_learning_mobile/common/extensions/context_extension.dart';
import 'package:e_learning_mobile/common/utils/format_util.dart';
import 'package:e_learning_mobile/data/dtos/order/order_response_dto.dart';
import 'package:e_learning_mobile/di/di.dart';
import 'package:e_learning_mobile/presentation/payment/bloc/order/order_bloc.dart';
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
    return BlocProvider(
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
      body: BlocConsumer<OrderBloc, OrderState>(
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
              _SummaryRow(
                label: 'Subtotal',
                value: FormatUtil.formatNumberAsCurrency(order.totalAmount,
                    symbol: '₫'),
              ),
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
              const SizedBox(height: 16),
              const Text(
                'Items',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: order.items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final it = order.items[index];
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
                        Icon(Icons.menu_book,
                            color: context.palette.buttonBackground),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Course ID: ${it.courseId}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Unit price: ${it.unitPrice == null ? 'N/A' : FormatUtil.formatNumberAsCurrency(it.unitPrice!, symbol: '₫')}',
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                  Text(
                                    it.discountAmount > 0
                                        ? '-${FormatUtil.formatNumberAsCurrency(it.discountAmount, symbol: '₫')}'
                                        : '',
                                    style: TextStyle(
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              if (order.payment != null) ...[
                const SizedBox(height: 16),
                PaymentCard(order: order),
              ],
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
              ? ElevatedButton(
                  onPressed: () async {
                    // After API call later, replace the below demo values
                    final mockQr =
                        '00020101021238590010A000000727012900069704180115V3CAS56019992280208QRIBFTTA530370454065500005802VN62...';
                    final mockExpiresAt =
                        DateTime.now().add(const Duration(minutes: 10));
                    // ignore: use_build_context_synchronously
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => QrPaymentDialog(
                        qrCode: mockQr,
                        expiresAt: mockExpiresAt,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.palette.buttonBackground,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Pay Now',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
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
