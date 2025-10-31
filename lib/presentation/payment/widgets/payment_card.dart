import 'package:e_learning_mobile/data/dtos/order/order_response_dto.dart';
import 'package:flutter/material.dart';

class PaymentCard extends StatelessWidget {
  final OrderResponse order;

  const PaymentCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final payment = order.payment;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          _KVRow(
              'Method',
              ((payment?.paymentMethod ?? '').isNotEmpty)
                  ? (payment?.paymentMethod ?? '')
                  : 'N/A'),
          const SizedBox(height: 6),
          _KVRow(
              'Status',
              ((payment?.status ?? '').isNotEmpty)
                  ? (payment?.status ?? '')
                  : 'N/A'),
          const SizedBox(height: 6),
          _KVRow(
              'Order Code',
              ((payment?.orderCode ?? '').isNotEmpty)
                  ? (payment?.orderCode ?? '')
                  : 'N/A'),
          const SizedBox(height: 6),
          _KVRow(
              'Checkout URL',
              ((payment?.checkoutUrl ?? '').isNotEmpty)
                  ? (payment?.checkoutUrl ?? '')
                  : 'N/A',
              isMonospace: true),
        ],
      ),
    );
  }
}

class _KVRow extends StatelessWidget {
  final String k;
  final String v;
  final bool isMonospace;

  const _KVRow(this.k, this.v, {this.isMonospace = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            k,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            v,
            style: TextStyle(
              fontSize: 14,
              fontFamily: isMonospace ? 'monospace' : null,
            ),
          ),
        ),
      ],
    );
  }
}
