import 'package:e_learning_mobile/data/datasources/review/remote/review_remote_datasource.dart';
import 'package:e_learning_mobile/data/dtos/review/review_request_dto.dart';
import 'package:e_learning_mobile/data/dtos/review/review_response_dto.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ReviewDatasource {
  final ReviewRemoteDatasource _remote;

  ReviewDatasource({required ReviewRemoteDatasource remote}) : _remote = remote;

  Future<List<ReviewResponseDto>> getAllReviews(String courseId) =>
      _remote.getAllReviews(courseId);

  Future<ReviewResponseDto> createReview(
          String courseId, ReviewRequestDto dto) =>
      _remote.createReview(courseId, dto);

  Future<ReviewResponseDto> getReviewById(String reviewId) =>
      _remote.getReviewById(reviewId);

  Future<void> deleteReview(String reviewId) => _remote.deleteReview(reviewId);
}
