import 'package:e_learning_mobile/common/constants/endpoints.dart';
import 'package:e_learning_mobile/common/helpers/dio_helper.dart';
import 'package:e_learning_mobile/data/dtos/order/order_response_dto.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class OrderRemoteDatasource {
  OrderRemoteDatasource({required DioHelper dioHelper})
      : _dioHelper = dioHelper;

  final DioHelper _dioHelper;

  Future<List<OrderResponse>> getOrders() async {
    final response = await _dioHelper.get(Endpoints.orders);
    return (response.data['data'] as List)
        .map((e) => OrderResponse.fromJson(e))
        .toList();
  }

  Future<List<OrderResponse>> getOrderByStatus(String status) async {
    final response = await _dioHelper.get('${Endpoints.orders}/status/$status');
    return (response.data['data'] as List)
        .map((e) => OrderResponse.fromJson(e))
        .toList();
  }

  Future<OrderResponse> getOrderDetail(String orderId) async {
    final response = await _dioHelper.get('${Endpoints.orders}/$orderId');
    return OrderResponse.fromJson(response.data['data']);
  }

  Future<OrderResponse> createOrder(Map<String, dynamic> orderData) async {
    final response = await _dioHelper.post(Endpoints.orders, data: orderData);
    return OrderResponse.fromJson(response.data['data']);
  }

  Future<OrderResponse> createOrderFromCart() async {
    final response = await _dioHelper.post('${Endpoints.orders}/from-cart');
    return OrderResponse.fromJson(response.data['data']);
  }

  Future<OrderResponse> cancelOrder(String orderId) async {
    final response = await _dioHelper.delete('${Endpoints.orders}/$orderId');
    return OrderResponse.fromJson(response.data['data']);
  }
}
