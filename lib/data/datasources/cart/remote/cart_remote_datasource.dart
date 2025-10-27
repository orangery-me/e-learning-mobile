import 'dart:developer';

import 'package:e_learning_mobile/common/constants/endpoints.dart';
import 'package:e_learning_mobile/common/helpers/dio_helper.dart';
import 'package:e_learning_mobile/data/dtos/cart/add_item_to_cart_request_dto.dart';
import 'package:e_learning_mobile/data/dtos/cart/get_cart_response_dto.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CartRemoteDatasource {
  final DioHelper _dioHelper;

  CartRemoteDatasource({required DioHelper dioHelper}) : _dioHelper = dioHelper;

  /// Get current user's cart
  Future<GetCardResponseDto> getCart() async {
    try {
      final response = await _dioHelper.get(Endpoints.cart);
      log('Get cart response: ${response.data}');
      return GetCardResponseDto.fromJson(
          response.data['data'] ?? response.data);
    } catch (e) {
      log('Error getting cart: $e');
      rethrow;
    }
  }

  /// Add item to cart
  /// POST: /api/v1/cart/add
  Future<GetCardResponseDto> addItemToCart(AddItemToCartRequestDto dto) async {
    try {
      log('Adding item to cart: ${dto.toJson()}');
      final response = await _dioHelper.post(
        '${Endpoints.cart}/add',
        data: dto.toJson(),
      );
      log('Add item to cart response: ${response.data}');
      return GetCardResponseDto.fromJson(
          response.data['data'] ?? response.data);
    } catch (e) {
      log('Error adding item to cart: $e');
      rethrow;
    }
  }

  /// Remove item from cart by courseId
  /// DELETE: /api/v1/cart/items/{courseId}
  Future<void> removeItemFromCart(String courseId) async {
    try {
      log('Removing item from cart: courseId=$courseId');
      await _dioHelper.delete('${Endpoints.cart}/items/$courseId');
      log('Item removed from cart successfully');
    } catch (e) {
      log('Error removing item from cart: $e');
      rethrow;
    }
  }

  /// Clear entire cart
  /// DELETE: /api/v1/cart/clear
  Future<void> clearCart() async {
    try {
      log('Clearing cart');
      await _dioHelper.delete('${Endpoints.cart}/clear');
      log('Cart cleared successfully');
    } catch (e) {
      log('Error clearing cart: $e');
      rethrow;
    }
  }
}
