part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

/// Event to load/refresh cart
class LoadCart extends CartEvent {
  const LoadCart();

  @override
  List<Object> get props => [];
}

/// Event to add item to cart
class AddItemToCart extends CartEvent {
  final String courseId;
  final double price;

  const AddItemToCart({
    required this.courseId,
    required this.price,
  });

  @override
  List<Object> get props => [courseId, price];
}

/// Event to remove item from cart
class RemoveItemFromCart extends CartEvent {
  final String courseId;

  const RemoveItemFromCart(this.courseId);

  @override
  List<Object> get props => [courseId];
}

/// Event to clear entire cart
class ClearCart extends CartEvent {
  const ClearCart();

  @override
  List<Object> get props => [];
}
