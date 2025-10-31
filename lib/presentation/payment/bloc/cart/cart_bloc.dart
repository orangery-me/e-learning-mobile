import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:e_learning_mobile/data/datasources/cart/cart_datasource.dart';
import 'package:e_learning_mobile/data/dtos/cart/add_item_to_cart_request_dto.dart';
import 'package:e_learning_mobile/data/dtos/cart/get_cart_response_dto.dart';
import 'package:injectable/injectable.dart';

part 'cart_event.dart';
part 'cart_state.dart';

@injectable
class CartBloc extends Bloc<CartEvent, CartState> {
  final CartDatasource _cartDatasource;

  CartBloc({required CartDatasource cartDatasource})
      : _cartDatasource = cartDatasource,
        super(const CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddItemToCart>(_onAddItemToCart);
    on<RemoveItemFromCart>(_onRemoveItemFromCart);
    on<ClearCart>(_onClearCart);
  }

  /// Load cart from API
  Future<void> _onLoadCart(
    LoadCart event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoading());

    try {
      final cart = await _cartDatasource.getCart();

      if (cart.isEmpty) {
        emit(const CartEmpty());
      } else {
        emit(CartLoaded(cart));
      }
    } catch (e) {
      log('Error loading cart: $e');
      emit(CartError(e.toString()));
    }
  }

  /// Add item to cart
  Future<void> _onAddItemToCart(
    AddItemToCart event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoading());

    try {
      final dto = AddItemToCartRequestDto(
        courseId: event.courseId,
        addedPrice: event.price,
      );

      final cart = await _cartDatasource.addItemToCart(dto);
      emit(CartLoaded(cart));

      log('Item added to cart successfully');
    } catch (e) {
      log('Error adding item to cart: $e');
      emit(CartError(e.toString()));
    }
  }

  /// Remove item from cart
  Future<void> _onRemoveItemFromCart(
    RemoveItemFromCart event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoading());

    try {
      await _cartDatasource.removeItemFromCart(event.courseId);

      // Reload cart after removal
      final cart = await _cartDatasource.getCart();

      if (cart.isEmpty) {
        emit(const CartEmpty());
      } else {
        emit(CartLoaded(cart));
      }

      log('Item removed from cart successfully');
    } catch (e) {
      log('Error removing item from cart: $e');
      emit(CartError(e.toString()));
    }
  }

  /// Clear entire cart
  Future<void> _onClearCart(
    ClearCart event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoading());

    try {
      await _cartDatasource.clearCart();
      emit(const CartEmpty());

      log('Cart cleared successfully');
    } catch (e) {
      log('Error clearing cart: $e');
      emit(CartError(e.toString()));
    }
  }
}
