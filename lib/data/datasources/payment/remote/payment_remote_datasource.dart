import 'dart:developer';

import 'package:e_learning_mobile/common/constants/endpoints.dart';
import 'package:e_learning_mobile/common/helpers/dio_helper.dart';
import 'package:e_learning_mobile/data/dtos/payment/create_payment_request.dart';
import 'package:e_learning_mobile/data/dtos/payment/paginated_payments.dart';
import 'package:e_learning_mobile/data/dtos/payment/payment_response_dto.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class PaymentRemoteDatasource {
  PaymentRemoteDatasource({required DioHelper dioHelper})
      : _dioHelper = dioHelper;

  final DioHelper _dioHelper;

  Future<PaymentResponseDto> createPayment(CreatePaymentRequest request) async {
    log('Creating payment with data: ${request.toJson()}');
    final response = await _dioHelper.post(
      Endpoints.payments,
      data: request.toJson(),
    );
    log('Created payment response: ${response.data}');
    return PaymentResponseDto.fromJson(
        response.data['data'] as Map<String, dynamic>);
  }

  Future<PaymentResponseDto> getPaymentByOrderCode(String orderCode) async {
    final response = await _dioHelper.get(
      '${Endpoints.payments}/order-code/$orderCode',
    );
    log('Fetched payment by order code response: ${response.data}');
    return PaymentResponseDto.fromJson(
        response.data['data'] as Map<String, dynamic>);
  }

  Future<PaginatedPayments> getUserPayments(
      {int page = 0, int size = 10}) async {
    final response = await _dioHelper.get(
      Endpoints.payments,
      queryParameters: {'page': page, 'size': size},
    );
    log('Fetched user payments response: ${response.data}');
    return PaginatedPayments.fromResponseData(
        response.data['data'] as Map<String, dynamic>);
  }

  Future<PaymentResponseDto> cancelPayment(String orderCode) async {
    final response = await _dioHelper.delete(
      '${Endpoints.payments}/order-code/$orderCode',
    );
    log('Cancelled payment response: ${response.data}');
    return PaymentResponseDto.fromJson(
        response.data['data'] as Map<String, dynamic>);
  }
}
