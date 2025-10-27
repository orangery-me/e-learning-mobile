part of 'reviews_bloc.dart';

sealed class ReviewsEvent extends Equatable {
  const ReviewsEvent();

  @override
  List<Object> get props => [];
}

class LoadReviewsByCourseId extends ReviewsEvent {
  final String courseId;

  const LoadReviewsByCourseId(this.courseId);

  @override
  List<Object> get props => [courseId];
}

class CreateReview extends ReviewsEvent {
  final String courseId;
  final ReviewRequestDto reviewRequest;

  const CreateReview(this.courseId, this.reviewRequest);

  @override
  List<Object> get props => [courseId, reviewRequest];
}

class DeleteReview extends ReviewsEvent {
  final String reviewId;

  const DeleteReview(this.reviewId);

  @override
  List<Object> get props => [reviewId];
}
