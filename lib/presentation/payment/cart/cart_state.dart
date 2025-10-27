part of 'cart_bloc.dart';

sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

/// Initial state - cart hasn't been loaded yet
final class CartInitial extends CartState {
  const CartInitial();

  @override
  List<Object> get props => [];
}

/// Loading state - cart operations in progress
final class CartLoading extends CartState {
  const CartLoading();

  @override
  List<Object> get props => [];
}

/// Success state - cart loaded with data
final class CartLoaded extends CartState {
  final GetCardResponseDto cart;

  const CartLoaded(this.cart);

  @override
  List<Object?> get props => [cart];
}

/// Error state - cart operation failed
final class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object> get props => [message];
}

/// Empty cart state
final class CartEmpty extends CartState {
  const CartEmpty();

  @override
  List<Object> get props => [];
}
