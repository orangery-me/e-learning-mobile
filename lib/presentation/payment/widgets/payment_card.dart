import 'package:e_learning_mobile/common/extensions/context_extension.dart';
import 'package:e_learning_mobile/common/utils/format_util.dart';
import 'package:e_learning_mobile/data/dtos/order/order_response_dto.dart';
import 'package:e_learning_mobile/data/dtos/payment/payment_method.dart';
import 'package:e_learning_mobile/data/dtos/payment/payment_status.dart';
import 'package:flutter/material.dart';

class PaymentCard extends StatelessWidget {
  final OrderResponse order;

  const PaymentCard({super.key, required this.order});

  String _getPaymentMethodText(String? method) {
    if (method == null || method.isEmpty) return 'N/A';
    try {
      final paymentMethod = PaymentMethod.fromJson(method);
      switch (paymentMethod) {
        case PaymentMethod.payos:
          return 'PayOS';
        case PaymentMethod.vnpay:
          return 'VNPay';
        case PaymentMethod.momo:
          return 'MoMo';
        case PaymentMethod.zalopay:
          return 'ZaloPay';
        case PaymentMethod.bankTransfer:
          return 'Bank Transfer';
      }
    } catch (e) {
      return method;
    }
  }

  String _getPaymentStatusText(String? status) {
    if (status == null || status.isEmpty) return 'N/A';
    try {
      final paymentStatus = PaymentStatus.fromJson(status);
      switch (paymentStatus) {
        case PaymentStatus.pending:
          return 'Pending';
        case PaymentStatus.paid:
          return 'Paid';
        case PaymentStatus.failed:
          return 'Failed';
        case PaymentStatus.cancelled:
          return 'Cancelled';
        case PaymentStatus.refunded:
          return 'Refunded';
      }
    } catch (e) {
      return status;
    }
  }

  Color _getPaymentStatusColor(String? status) {
    if (status == null || status.isEmpty) return Colors.grey;
    try {
      final paymentStatus = PaymentStatus.fromJson(status);
      switch (paymentStatus) {
        case PaymentStatus.pending:
          return Colors.orange;
        case PaymentStatus.paid:
          return Colors.green;
        case PaymentStatus.failed:
          return Colors.red;
        case PaymentStatus.cancelled:
          return Colors.grey;
        case PaymentStatus.refunded:
          return Colors.blue;
      }
    } catch (e) {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final payment = order.payment;
    if (payment == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.palette.primaryColor.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: context.palette.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.payment,
                  color: context.palette.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Payment Information',
                style: context.textStyles.heading4.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _InfoRow(
            icon: Icons.credit_card,
            label: 'Payment Method',
            value: _getPaymentMethodText(payment.paymentMethod),
            context: context,
          ),
          const SizedBox(height: 16),
          _InfoRow(
            icon: Icons.info_outline,
            label: 'Status',
            value: _getPaymentStatusText(payment.status),
            context: context,
            valueColor: _getPaymentStatusColor(payment.status),
            showBadge: true,
          ),
          const SizedBox(height: 16),
          _InfoRow(
            icon: Icons.qr_code,
            label: 'Order Code',
            value: payment.orderCode,
            context: context,
          ),
          if (payment.paidAt != null) ...[
            const SizedBox(height: 16),
            _InfoRow(
              icon: Icons.check_circle,
              label: 'Paid At',
              value: FormatUtil.formatDateTime(payment.paidAt!),
              context: context,
              valueColor: Colors.green,
            ),
          ],
          if (payment.expiresAt != null && payment.status == 'pending') ...[
            const SizedBox(height: 16),
            _InfoRow(
              icon: Icons.access_time,
              label: 'Expires At',
              value: FormatUtil.formatDateTime(payment.expiresAt!),
              context: context,
              valueColor: Colors.orange,
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final BuildContext context;
  final Color? valueColor;
  final bool showBadge;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.context,
    this.valueColor,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: this.context.textStyles.metadata1.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 4),
              if (showBadge)
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: valueColor ?? Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        value,
                        style: this.context.textStyles.body2.copyWith(
                              color: valueColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                )
              else
                Text(
                  value,
                  style: this.context.textStyles.body2.copyWith(
                        color: valueColor ?? this.context.palette.normalText,
                        fontWeight: FontWeight.w600,
                      ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
