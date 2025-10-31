part of 'order_bloc.dart';

sealed class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

final class OrderInitial extends OrderState {}

final class OrderLoading extends OrderState {}

final class OrdersLoaded extends OrderState {
  final List<OrderResponse> orders;
  const OrdersLoaded(this.orders);

  @override
  List<Object> get props => [orders];
}

final class OrderDetailLoaded extends OrderState {
  final OrderResponse order;
  const OrderDetailLoaded(this.order);

  @override
  List<Object> get props => [order];
}

final class OrderActionSuccess extends OrderState {
  final OrderResponse order;
  const OrderActionSuccess(this.order);

  @override
  List<Object> get props => [order];
}

final class OrderError extends OrderState {
  final String message;
  const OrderError(this.message);

  @override
  List<Object> get props => [message];
}
