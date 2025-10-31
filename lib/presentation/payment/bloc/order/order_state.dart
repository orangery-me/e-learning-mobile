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
  final int page;
  final int totalPages;
  final bool hasMore;
  final bool isAppending;
  final String? statusFilter; // null means all

  const OrdersLoaded({
    required this.orders,
    required this.page,
    required this.totalPages,
    required this.hasMore,
    this.isAppending = false,
    this.statusFilter,
  });

  OrdersLoaded copyWith({
    List<OrderResponse>? orders,
    int? page,
    int? totalPages,
    bool? hasMore,
    bool? isAppending,
    String? statusFilter,
  }) => OrdersLoaded(
        orders: orders ?? this.orders,
        page: page ?? this.page,
        totalPages: totalPages ?? this.totalPages,
        hasMore: hasMore ?? this.hasMore,
        isAppending: isAppending ?? this.isAppending,
        statusFilter: statusFilter ?? this.statusFilter,
      );

  @override
  List<Object> get props => [orders, page, totalPages, hasMore, isAppending, statusFilter ?? ''];
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
