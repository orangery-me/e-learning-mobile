import 'package:e_learning_mobile/data/datasources/order/remote/order_remote_datasource.dart';
import 'package:e_learning_mobile/data/dtos/order/order_response_dto.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class OrderDatasource {
  final OrderRemoteDatasource remote;
  OrderDatasource({required this.remote});

  Future<List<OrderResponse>> getOrders() async {
    return await remote.getOrders(); // get: /orders
  }

  Future<OrderResponse> getOrderDetail(String orderId) async {
    return await remote.getOrderDetail(orderId); // get: /orders/{orderId}
  }

  Future<OrderResponse> createOrder(Map<String, dynamic> orderData) async {
    return await remote.createOrder(orderData); // post: /orders
  }

  Future<OrderResponse> cancelOrder(String orderId) async {
    return await remote.cancelOrder(orderId); // delete: /orders/{orderId}
  }

  Future<OrderResponse> createOrderFromCart() async {
    return await remote.createOrderFromCart(); // post: /orders/from-cart
  }

  Future<List<OrderResponse>> getOrderByStatus(String status) async {
    return await remote
        .getOrderByStatus(status); // get: /orders/status/{status}
  }
}
