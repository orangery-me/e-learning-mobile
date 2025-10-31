part of 'order_bloc.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class LoadOrders extends OrderEvent {
  const LoadOrders();
}

class LoadOrdersByStatus extends OrderEvent {
  final String status; // use lowercase string consistent with API

  const LoadOrdersByStatus(this.status);

  @override
  List<Object> get props => [status];
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
  const CreateOrderFromCart();
}

class CancelOrder extends OrderEvent {
  final String orderId;

  const CancelOrder(this.orderId);

  @override
  List<Object> get props => [orderId];
}
