import 'package:e_learning_mobile/data/datasources/payment/remote/payment_remote_datasource.dart';
import 'package:e_learning_mobile/data/dtos/payment/create_payment_request.dart';
import 'package:e_learning_mobile/data/dtos/payment/paginated_payments.dart';
import 'package:e_learning_mobile/data/dtos/payment/payment_response_dto.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class PaymentDatasource {
  final PaymentRemoteDatasource remote;
  PaymentDatasource({required this.remote});

  Future<PaymentResponseDto> createPayment(CreatePaymentRequest request) async {
    return await remote.createPayment(request); // post: /payments
  }

  Future<PaymentResponseDto> getPaymentByOrderCode(String orderCode) async {
    return await remote.getPaymentByOrderCode(
        orderCode); // get: /payments/order-code/{orderCode}
  }

  Future<PaginatedPayments> getUserPayments(
      {int page = 0, int size = 10}) async {
    return await remote.getUserPayments(
        page: page, size: size); // get: /payments
  }

  Future<PaymentResponseDto> cancelPayment(String orderCode) async {
    return await remote
        .cancelPayment(orderCode); // delete: /payments/order-code/{orderCode}
  }
}
