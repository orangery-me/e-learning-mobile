import 'package:e_learning_mobile/data/datasources/order/remote/order_remote_datasource.dart';
import 'package:e_learning_mobile/data/dtos/order/order_from_cart_request.dart';
import 'package:e_learning_mobile/data/dtos/order/order_response_dto.dart';
import 'package:e_learning_mobile/data/dtos/order/paginated_orders.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class OrderDatasource {
  final OrderRemoteDatasource remote;
  OrderDatasource({required this.remote});

  Future<PaginatedOrders> getOrders({int page = 0, int size = 10}) async {
    return await remote.getOrders(page: page, size: size); // get: /orders
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

  Future<OrderResponse> createOrderFromCart(OrderFromCartRequest request) async {
    return await remote.createOrderFromCart(request); // post: /orders/from-cart
  }

  Future<PaginatedOrders> getOrderByStatus(String status,
      {int page = 0, int size = 10}) async {
    return await remote.getOrderByStatus(status, page: page, size: size);
  }
}
