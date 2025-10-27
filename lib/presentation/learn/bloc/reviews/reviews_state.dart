part of 'reviews_bloc.dart';

final class ReviewsState extends Equatable {
  final List<ReviewResponseDto> reviews;
  final bool isLoading;
  final String? errorMessage;

  const ReviewsState({
    this.reviews = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        reviews,
        isLoading,
        errorMessage,
      ];

  ReviewsState copyWith({
    List<ReviewResponseDto>? reviews,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ReviewsState(
      reviews: reviews ?? this.reviews,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
