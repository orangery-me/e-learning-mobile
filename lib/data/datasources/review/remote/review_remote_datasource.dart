import 'package:e_learning_mobile/common/constants/endpoints.dart';
import 'package:e_learning_mobile/common/helpers/dio_helper.dart';
import 'package:e_learning_mobile/data/dtos/review/review_request_dto.dart';
import 'package:e_learning_mobile/data/dtos/review/review_response_dto.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ReviewRemoteDatasource {
  final DioHelper _dioHelper;

  ReviewRemoteDatasource({required DioHelper dioHelper})
      : _dioHelper = dioHelper;

  Future<List<ReviewResponseDto>> getAllReviews(String courseId) async {
    final response = await _dioHelper.get(
      '${Endpoints.courses}/$courseId/reviews',
    );

    final List<dynamic> reviewsJson = response.data['data'] ?? response.data;
    return reviewsJson.map((json) => ReviewResponseDto.fromJson(json)).toList();
  }

  Future<ReviewResponseDto> createReview(
    String courseId,
    ReviewRequestDto dto,
  ) async {
    final response = await _dioHelper.post(
      '${Endpoints.courses}/$courseId/reviews',
      data: dto.toJson(),
    );

    return ReviewResponseDto.fromJson(response.data['data'] ?? response.data);
  }

  Future<ReviewResponseDto> getReviewById(String reviewId) async {
    final response = await _dioHelper.get('${Endpoints.reviews}/$reviewId');

    return ReviewResponseDto.fromJson(response.data['data'] ?? response.data);
  }

  Future<void> deleteReview(String reviewId) async {
    await _dioHelper.delete('${Endpoints.reviews}/$reviewId');
  }
}
