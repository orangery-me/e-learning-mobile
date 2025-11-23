part of 'progress_bloc.dart';

sealed class ProgressEvent extends Equatable {
  const ProgressEvent();

  @override
  List<Object> get props => [];
}

class LoadCurrentProgress extends ProgressEvent {
  final String enrollmentId;

  const LoadCurrentProgress(this.enrollmentId);

  @override
  List<Object> get props => [enrollmentId];
}

class UpdateProgress extends ProgressEvent {
  final String enrollmentId;
  final int progress;

  const UpdateProgress(this.enrollmentId, this.progress);

  @override
  List<Object> get props => [enrollmentId, progress];
}
