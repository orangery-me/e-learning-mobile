import 'dart:developer';

import 'package:e_learning_mobile/common/constants/endpoints.dart';
import 'package:e_learning_mobile/common/helpers/dio_helper.dart';
import 'package:e_learning_mobile/data/dtos/order/order_from_cart_request.dart';
import 'package:e_learning_mobile/data/dtos/order/order_response_dto.dart';
import 'package:e_learning_mobile/data/dtos/paginated_orders.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class OrderRemoteDatasource {
  OrderRemoteDatasource({required DioHelper dioHelper})
      : _dioHelper = dioHelper;

  final DioHelper _dioHelper;

  Future<PaginatedOrders> getOrders({int page = 0, int size = 10}) async {
    final response = await _dioHelper.get(
      Endpoints.orders,
      queryParameters: {'page': page, 'size': size},
    );
    log('Fetched orders response: ${response.data}');
    return PaginatedOrders.fromResponseData(
        response.data['data'] as Map<String, dynamic>);
  }

  Future<PaginatedOrders> getOrderByStatus(String status,
      {int page = 0, int size = 10}) async {
    final response = await _dioHelper
        .get('${Endpoints.orders}/status/$status', queryParameters: {
      'page': page,
      'size': size,
    });
    final data = response.data['data'];
    if (data is Map<String, dynamic> && data.containsKey('content')) {
      return PaginatedOrders.fromResponseData(data);
    }
    // Fallback for non-paginated response
    final list = (data as List)
        .map((e) => OrderResponse.fromJson(e as Map<String, dynamic>))
        .toList();
    return PaginatedOrders(
      content: list,
      pageNumber: page,
      pageSize: size,
      totalPages: 1,
      totalElements: list.length,
      last: true,
      first: true,
      numberOfElements: list.length,
      empty: list.isEmpty,
    );
  }

  Future<OrderResponse> getOrderDetail(String orderId) async {
    final response = await _dioHelper.get('${Endpoints.orders}/$orderId');
    log('Fetched order detail response: ${response.data}');
    return OrderResponse.fromJson(response.data['data']);
  }

  Future<OrderResponse> createOrder(Map<String, dynamic> orderData) async {
    final response = await _dioHelper.post(Endpoints.orders, data: orderData);
    return OrderResponse.fromJson(response.data['data']);
  }

  Future<OrderResponse> createOrderFromCart(
      OrderFromCartRequest request) async {
    log('Creating order from cart with data: ${request.toJson()}');
    final response = await _dioHelper.post('${Endpoints.orders}/from-cart',
        data: request.toJson());
    return OrderResponse.fromJson(response.data['data']);
  }

  Future<OrderResponse> cancelOrder(String orderId) async {
    final response = await _dioHelper.delete('${Endpoints.orders}/$orderId');
    return OrderResponse.fromJson(response.data['data']);
  }
}
