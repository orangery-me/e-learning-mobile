part of 'order_bloc.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class LoadOrders extends OrderEvent {
  final int page;
  final int size;
  final bool append;

  const LoadOrders({this.page = 0, this.size = 10, this.append = false});

  @override
  List<Object> get props => [page, size, append];
}

class LoadOrdersByStatus extends OrderEvent {
  final String status; // use lowercase string consistent with API
  final int page;
  final int size;
  final bool append;

  const LoadOrdersByStatus(this.status, {this.page = 0, this.size = 10, this.append = false});

  @override
  List<Object> get props => [status, page, size, append];
}

class LoadOrderDetail extends OrderEvent {
  final String orderId;

  const LoadOrderDetail(this.orderId);

  @override
  List<Object> get props => [orderId];
}

class CreateOrder extends OrderEvent {
  final Map<String, dynamic> orderData;

  const CreateOrder(this.orderData);

  @override
  List<Object> get props => [orderData];
}

class CreateOrderFromCart extends OrderEvent {
  final OrderFromCartRequest request;

  CreateOrderFromCart({OrderFromCartRequest? request})
      : request = request ?? OrderFromCartRequest(clearCartAfterOrder: true);
}

class CancelOrder extends OrderEvent {
  final String orderId;

  const CancelOrder(this.orderId);

  @override
  List<Object> get props => [orderId];
}
