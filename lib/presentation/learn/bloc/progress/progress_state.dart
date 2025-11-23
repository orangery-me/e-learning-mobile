part of 'progress_bloc.dart';

sealed class ProgressState {}

class ProgressInitial extends ProgressState {}

class ProgressLoading extends ProgressState {}

class ProgressLoaded extends ProgressState {
  final ProgressDto? progress;
  ProgressLoaded(this.progress);
}

class ProgressError extends ProgressState {
  final String message;
  ProgressError(this.message);
}
