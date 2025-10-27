import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:e_learning_mobile/data/datasources/review/review_datasource.dart';
import 'package:e_learning_mobile/data/dtos/review/review_request_dto.dart';
import 'package:e_learning_mobile/data/dtos/review/review_response_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'reviews_event.dart';
part 'reviews_state.dart';

@injectable
class ReviewsBloc extends Bloc<ReviewsEvent, ReviewsState> {
  final ReviewDatasource datasource;

  ReviewsBloc({required this.datasource}) : super(ReviewsState()) {
    on<LoadReviewsByCourseId>(
        (event, emit) => loadReviewsByCourseId(event, emit));
    on<CreateReview>((event, emit) => createReview(event, emit));
    on<DeleteReview>((event, emit) => deleteReview(event, emit));
  }

  Future<void> loadReviewsByCourseId(
      LoadReviewsByCourseId event, Emitter<ReviewsState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final reviews = await datasource.getAllReviews(event.courseId);
      emit(state.copyWith(reviews: reviews, isLoading: false));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> createReview(
      CreateReview event, Emitter<ReviewsState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final newReview = await datasource.createReview(
        event.courseId,
        event.reviewRequest,
      );

      // Add the new review to the list
      final updatedReviews = [newReview, ...state.reviews];
      emit(state.copyWith(
        reviews: updatedReviews,
        isLoading: false,
      ));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> deleteReview(
      DeleteReview event, Emitter<ReviewsState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      await datasource.deleteReview(event.reviewId);

      // Remove the review from the list
      final updatedReviews =
          state.reviews.where((r) => r.reviewId != event.reviewId).toList();
      emit(state.copyWith(
        reviews: updatedReviews,
        isLoading: false,
      ));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
