import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:e_learning_mobile/data/dtos/order/order_from_cart_request.dart';
import 'package:equatable/equatable.dart';
import 'package:e_learning_mobile/data/datasources/order/order_datasource.dart';
import 'package:e_learning_mobile/data/dtos/order/order_response_dto.dart';
import 'package:e_learning_mobile/data/dtos/paginated_orders.dart';
import 'package:injectable/injectable.dart';

part 'order_event.dart';
part 'order_state.dart';

@injectable
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderDatasource _orderDatasource;

  OrderBloc({required OrderDatasource orderDatasource})
      : _orderDatasource = orderDatasource,
        super(OrderInitial()) {
    on<LoadOrders>(_onLoadOrders);
    on<LoadOrdersByStatus>(_onLoadOrdersByStatus);
    on<LoadOrderDetail>(_onLoadOrderDetail);
    on<CreateOrder>(_onCreateOrder);
    on<CreateOrderFromCart>(_onCreateOrderFromCart);
    on<CancelOrder>(_onCancelOrder);
  }

  Future<void> _onLoadOrders(LoadOrders event, Emitter<OrderState> emit) async {
    try {
      final current = state;
      if (event.append && current is OrdersLoaded) {
        emit(current.copyWith(isAppending: true));
      } else {
        emit(OrderLoading());
      }

      final PaginatedOrders pageData =
          await _orderDatasource.getOrders(page: event.page, size: event.size);
      final merged = event.append && current is OrdersLoaded
          ? [...current.orders, ...pageData.content]
          : pageData.content;
      emit(OrdersLoaded(
        orders: merged,
        page: pageData.pageNumber,
        totalPages: pageData.totalPages,
        hasMore: pageData.pageNumber + 1 < pageData.totalPages,
        isAppending: false,
        statusFilter: null,
      ));
    } catch (e) {
      log('Error loading orders: $e');
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onLoadOrdersByStatus(
      LoadOrdersByStatus event, Emitter<OrderState> emit) async {
    try {
      final current = state;
      if (event.append && current is OrdersLoaded) {
        emit(current.copyWith(isAppending: true));
      } else {
        emit(OrderLoading());
      }

      final PaginatedOrders pageData = await _orderDatasource
          .getOrderByStatus(event.status, page: event.page, size: event.size);
      final merged = event.append && current is OrdersLoaded
          ? [...current.orders, ...pageData.content]
          : pageData.content;
      emit(OrdersLoaded(
        orders: merged,
        page: pageData.pageNumber,
        totalPages: pageData.totalPages,
        hasMore: pageData.pageNumber + 1 < pageData.totalPages,
        isAppending: false,
        statusFilter: event.status,
      ));
    } catch (e) {
      log('Error loading orders by status: $e');
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onLoadOrderDetail(
      LoadOrderDetail event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final order = await _orderDatasource.getOrderDetail(event.orderId);
      emit(OrderDetailLoaded(order));
    } catch (e) {
      log('Error loading order detail: $e');
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onCreateOrder(
      CreateOrder event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final order = await _orderDatasource.createOrder(event.orderData);
      emit(OrderActionSuccess(order));
    } catch (e) {
      log('Error creating order: $e');
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onCreateOrderFromCart(
      CreateOrderFromCart event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final order = await _orderDatasource.createOrderFromCart(event.request);
      emit(OrderActionSuccess(order));
    } catch (e) {
      log('Error creating order from cart: $e');
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onCancelOrder(
      CancelOrder event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final order = await _orderDatasource.cancelOrder(event.orderId);
      emit(OrderActionSuccess(order));
    } catch (e) {
      log('Error cancelling order: $e');
      emit(OrderError(e.toString()));
    }
  }
}
