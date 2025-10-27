import 'package:e_learning_mobile/data/datasources/cart/remote/cart_remote_datasource.dart';
import 'package:e_learning_mobile/data/dtos/cart/add_item_to_cart_request_dto.dart';
import 'package:e_learning_mobile/data/dtos/cart/get_cart_response_dto.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CartDatasource {
  final CartRemoteDatasource _remote;

  CartDatasource({required CartRemoteDatasource remote}) : _remote = remote;

  /// Get current user's cart
  Future<GetCardResponseDto> getCart() => _remote.getCart();

  /// Add item to cart
  Future<GetCardResponseDto> addItemToCart(AddItemToCartRequestDto dto) =>
      _remote.addItemToCart(dto);

  /// Clear entire cart
  Future<void> clearCart() => _remote.clearCart();

  /// Remove specific item from cart by courseId
  Future<void> removeItemFromCart(String courseId) =>
      _remote.removeItemFromCart(courseId);
}
